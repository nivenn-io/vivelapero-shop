# Shopify to Medusa Migration Guide

This guide documents the process for migrating an existing Shopify store to the Medusa platform.

**Target:** leschtitesboites.fr (initial migration)

**Estimated time:** 2-3 days (depending on product count & customizations)

---

## Pre-Migration Checklist

- [ ] Full Shopify data export completed
- [ ] Backup of theme files (liquid templates)
- [ ] List of installed Shopify apps & their functions
- [ ] Current analytics baseline (for comparison post-migration)
- [ ] Email list exported (customers)
- [ ] DNS access for domain transfer
- [ ] Downtime window scheduled (if needed)

---

## Phase 1: Data Export from Shopify

### 1.1 Export Products

**Via Shopify Admin:**
1. Products → Export
2. Format: CSV
3. Export: All products
4. Save as: `shopify-products-export.csv`

**Includes:**
- Product title, description, vendor
- Variants (SKU, price, inventory)
- Images URLs
- SEO meta (title, description)
- Tags, collections

### 1.2 Export Customers (Optional)

**Via Shopify Admin:**
1. Customers → Export
2. Format: CSV
3. Save as: `shopify-customers-export.csv`

**Note:** Passwords cannot be migrated (Shopify hashes them). Customers will need to reset passwords.

### 1.3 Export Orders (Historical Data)

**Via Shopify Admin:**
1. Orders → Export
2. Date range: All time
3. Save as: `shopify-orders-export.csv`

**Use case:** Analytics, customer history reference (not imported into Medusa, just for records)

### 1.4 Download Images

```bash
# Script to download all product images from Shopify CDN
# (Create script based on exported product CSV image URLs)

# Example:
mkdir -p shopify-images
cd shopify-images

while IFS=',' read -r url filename; do
  curl -O "$url"
done < ../image-urls.txt
```

---

## Phase 2: Data Transformation

### 2.1 Convert Products CSV to Medusa Format

**Shopify CSV structure:**
```csv
Handle,Title,Body (HTML),Vendor,Type,Tags,Published,Option1 Name,Option1 Value,Variant SKU,Variant Price,Variant Inventory Qty,Image Src
```

**Medusa seed format (JSON):**
```json
{
  "products": [
    {
      "title": "Product Name",
      "description": "Product description",
      "handle": "product-slug",
      "status": "published",
      "variants": [
        {
          "title": "Variant Name",
          "sku": "SKU-123",
          "prices": [{ "amount": 4990, "currency_code": "eur" }],
          "inventory_quantity": 10
        }
      ],
      "images": ["https://url-to-image.jpg"]
    }
  ]
}
```

**Conversion script:**
```javascript
// scripts/shopify-to-medusa.js
const fs = require('fs');
const csv = require('csv-parser');

const products = {};

fs.createReadStream('shopify-products-export.csv')
  .pipe(csv())
  .on('data', (row) => {
    const handle = row.Handle;
    
    if (!products[handle]) {
      products[handle] = {
        title: row.Title,
        description: row['Body (HTML)'],
        handle: handle,
        status: row.Published === 'TRUE' ? 'published' : 'draft',
        variants: [],
        images: []
      };
    }
    
    // Add variant
    if (row['Variant SKU']) {
      products[handle].variants.push({
        title: row['Option1 Value'] || 'Default',
        sku: row['Variant SKU'],
        prices: [{ 
          amount: Math.round(parseFloat(row['Variant Price']) * 100), 
          currency_code: 'eur' 
        }],
        inventory_quantity: parseInt(row['Variant Inventory Qty']) || 0
      });
    }
    
    // Add image
    if (row['Image Src']) {
      products[handle].images.push(row['Image Src']);
    }
  })
  .on('end', () => {
    fs.writeFileSync(
      'medusa-products.json',
      JSON.stringify({ products: Object.values(products) }, null, 2)
    );
    console.log('✅ Conversion complete: medusa-products.json');
  });
```

Run:
```bash
npm install csv-parser
node scripts/shopify-to-medusa.js
```

### 2.2 Image Migration

**Option A: Reuse Shopify CDN URLs**
- Fastest, no download needed
- Risk: Shopify may expire URLs after account closure

**Option B: Self-host**
```bash
# Upload to Medusa backend storage
# (Configure S3 or local storage first)

# Script to upload images via Medusa API
node scripts/upload-images.js
```

---

## Phase 3: Medusa Setup

### 3.1 Create Sales Channel

```bash
cd backend

# Via Medusa admin or API
curl -X POST http://localhost:9000/admin/sales-channels \
  -H "Authorization: Bearer YOUR_ADMIN_TOKEN" \
  -d '{"name": "leschtitesboites", "description": "Les Chtites Boîtes storefront"}'
```

### 3.2 Seed Products

```bash
# Import converted products
cd backend
medusa seed -f ../medusa-products.json
```

Or manual import via Medusa admin UI (for smaller catalogs).

### 3.3 Configure Collections/Categories

Recreate Shopify collections as Medusa collections:
1. Medusa Admin → Products → Collections
2. Create new collection
3. Assign products

---

## Phase 4: Storefront Setup

Follow [NEW_STOREFRONT.md](./NEW_STOREFRONT.md) guide with these specifics:

**Sales channel:** `leschtitesboites`  
**Domain:** `leschtitesboites.fr`

**Custom pages to migrate:**
- About page (copy content from Shopify)
- FAQ (if exists)
- Custom Shopify pages → Next.js pages

---

## Phase 5: URL Redirects

**Critical:** Preserve SEO by redirecting old Shopify URLs to new Medusa URLs.

### Shopify URL Structure
```
https://leschtitesboites.fr/products/product-handle
https://leschtitesboites.fr/collections/collection-handle
```

### Medusa URL Structure
```
https://leschtitesboites.fr/products/product-handle  ✅ Same
https://leschtitesboites.fr/collections/collection-handle  ✅ Same
```

**Good news:** If handles are preserved, URLs should match!

**Implement in Next.js:**
```javascript
// next.config.js
module.exports = {
  async redirects() {
    return [
      // Shopify cart → Medusa cart
      {
        source: '/cart',
        destination: '/cart',
        permanent: true
      },
      // Add any custom redirects here
    ];
  },
}
```

**Submit updated sitemap to Google Search Console:**
```bash
# Generate sitemap
npm run build
# sitemap.xml generated in /public
```

---

## Phase 6: Customer Migration (Optional)

### Email-only migration
```javascript
// Import customer emails to Medusa
// Note: Customers will need to set new passwords

const customers = []; // Load from shopify-customers-export.csv

customers.forEach(customer => {
  fetch('http://localhost:9000/admin/customers', {
    method: 'POST',
    headers: {
      'Authorization': 'Bearer YOUR_ADMIN_TOKEN',
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      email: customer.email,
      first_name: customer.first_name,
      last_name: customer.last_name
    })
  });
});
```

**Notify customers:**
Send email via Brevo:
> "We've upgraded our store! Please reset your password to continue: [link]"

---

## Phase 7: DNS Switchover

### Pre-switchover checklist
- [ ] All products imported & verified
- [ ] Test orders completed successfully
- [ ] Stripe live mode configured
- [ ] Emails sending correctly
- [ ] Analytics tracking installed

### DNS Update
**Current (Shopify):**
```
A record: @ → Shopify IP
CNAME: www → shops.myshopify.com
```

**New (Vercel):**
```
A record: @ → 76.76.21.21 (Vercel)
CNAME: www → cname.vercel-dns.com
```

**Propagation time:** 1-24 hours

**Pro tip:** Lower TTL to 300 seconds (5 min) before switchover for faster propagation.

---

## Phase 8: Post-Migration

### Immediate (Day 1)
- [ ] Monitor errors (Sentry/Vercel logs)
- [ ] Test checkout flow every hour
- [ ] Check email delivery
- [ ] Watch analytics for traffic drop

### Week 1
- [ ] Compare sales to previous week (Shopify baseline)
- [ ] Monitor Google Search Console for crawl errors
- [ ] Check PageSpeed score (should improve vs Shopify)
- [ ] Collect customer feedback

### Month 1
- [ ] SEO rankings comparison
- [ ] Conversion rate analysis
- [ ] Identify missing features (if any)
- [ ] Plan improvements

---

## Rollback Plan (If Needed)

**If critical issues arise:**

1. **Revert DNS** to Shopify (5-60 min propagation)
2. **Keep Shopify account active** for 30 days post-migration
3. **Pause Medusa deployments** until issue resolved

**When to rollback:**
- Payment processing completely broken
- Catastrophic data loss
- Site completely down for >1 hour

**When NOT to rollback:**
- Minor UI bugs (fix forward)
- Isolated checkout issues (fix quickly)
- Slowness (optimize)

---

## Tools & Scripts

### Required NPM Packages
```bash
npm install csv-parser
npm install @medusajs/medusa
```

### Helpful Scripts
```bash
# Product conversion
node scripts/shopify-to-medusa.js

# Image download
bash scripts/download-shopify-images.sh

# Customer import
node scripts/import-customers.js

# Verify product count
node scripts/verify-import.js
```

---

## Cost Comparison

| Item | Shopify | Medusa |
|------|---------|--------|
| Platform | $29-299/mo | $0 (self-hosted) or $20/mo (MedusaCloud) |
| Transaction fees | 0.5-2% | 0% |
| Apps | ~$50-200/mo | $0 (most features built-in) |
| **Total** | ~$100-500/mo | ~$20-50/mo |

**Potential savings:** $500-$5,000/year

---

## FAQ

**Q: Can I keep Shopify & Medusa running in parallel?**  
A: Yes, for testing. But don't sync inventory (manage separately until full cutover).

**Q: What about Shopify apps I use?**  
A: Most features are built into Medusa or available via plugins. List your apps and we'll find equivalents.

**Q: Will my SEO tank?**  
A: No, if URLs are preserved and you submit updated sitemap. May even improve (faster load times).

**Q: How long does migration take?**  
A: 2-3 days for basic store. Add 1 week for complex customizations.

---

## Next Steps

1. **Export data from Shopify** (Phase 1)
2. **Run conversion script** (Phase 2)
3. **Test import on dev Medusa instance** (Phase 3)
4. **Set up storefront** (Phase 4)
5. **Schedule migration date** (coordinate with Vincent)

---

**When ready to migrate leschtitesboites.fr, return to this guide and execute step-by-step.**
