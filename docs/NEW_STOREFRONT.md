# New Storefront Setup Guide

This guide documents the process for adding a new storefront to the Vive l'Apéro Shop platform.

**Estimated time:** ~1 day (branding + configuration)

---

## Prerequisites

- Access to this monorepo
- Vercel account with proper permissions
- Domain purchased and DNS access
- Branding assets ready (logo, colors, fonts)

---

## Step-by-Step Process

### 1. Backend: Create Sales Channel

```bash
cd backend

# Start Medusa admin
npm run dev

# In Medusa admin (http://localhost:9000/app):
# Settings → Sales Channels → Create new
# Name: your-brand
# Description: Sales channel for your-brand.com
```

Or via Medusa API:
```bash
curl -X POST http://localhost:9000/admin/sales-channels \
  -H "Authorization: Bearer YOUR_ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "yourbrand",
    "description": "Sales channel for yourbrand.com"
  }'
```

### 2. Copy Storefront Template

```bash
# From monorepo root
cp -r shared/templates/storefront-base storefront-yourbrand

cd storefront-yourbrand
```

### 3. Configure Storefront

**Update package.json:**
```json
{
  "name": "storefront-yourbrand",
  "version": "0.1.0",
  "description": "Your Brand storefront",
  ...
}
```

**Update `.env.local`:**
```bash
NEXT_PUBLIC_MEDUSA_BACKEND_URL=http://localhost:9000
NEXT_PUBLIC_SALES_CHANNEL=yourbrand
NEXT_PUBLIC_SITE_URL=https://yourbrand.com
```

### 4. Branding Customization

**Logo:**
```bash
# Add logo files
storefront-yourbrand/public/
  ├── logo.svg          # Main logo
  ├── logo-white.svg    # Dark mode variant
  └── favicon.ico
```

**Colors (TailwindCSS):**
```javascript
// storefront-yourbrand/tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#...',
          100: '#...',
          // ... your brand colors
          900: '#...',
        },
        secondary: { /* ... */ },
      },
    },
  },
}
```

**Typography:**
```javascript
// storefront-yourbrand/tailwind.config.js
theme: {
  extend: {
    fontFamily: {
      sans: ['Your Sans Font', 'system-ui'],
      heading: ['Your Heading Font', 'system-ui'],
    },
  },
}
```

### 5. Content Customization

**Homepage:**
```bash
# Edit hero, featured products, etc.
storefront-yourbrand/app/page.tsx
```

**About/Legal pages:**
```bash
storefront-yourbrand/app/
  ├── about/page.tsx
  ├── legal/page.tsx
  └── ...
```

**Blog (if enabled):**
```bash
storefront-yourbrand/content/blog/
  └── your-first-post.mdx
```

### 6. GitHub & Version Control

```bash
# Add to Git
git add storefront-yourbrand/
git commit -m "feat: add yourbrand storefront"
git push origin main
```

### 7. Vercel Deployment

**Option A: Vercel CLI**
```bash
cd storefront-yourbrand
vercel link

# Follow prompts:
# - Create new project: yes
# - Project name: yourbrand-storefront
# - Framework: Next.js
# - Root directory: storefront-yourbrand
```

**Option B: Vercel Dashboard**
1. Go to vercel.com/new
2. Import from GitHub: nivenn-io/vivelapero-shop
3. Framework: Next.js
4. Root Directory: `storefront-yourbrand`
5. Project name: `yourbrand-storefront`

**Environment Variables (Vercel):**
```bash
NEXT_PUBLIC_MEDUSA_BACKEND_URL=https://api.yourbrand.com
NEXT_PUBLIC_SALES_CHANNEL=yourbrand
NEXT_PUBLIC_SITE_URL=https://yourbrand.com
MEDUSA_ADMIN_TOKEN=your_admin_token
STRIPE_PUBLISHABLE_KEY=pk_live_...
```

### 8. Domain Configuration

**Add domain in Vercel:**
1. Project Settings → Domains
2. Add: `yourbrand.com`
3. Add redirect: `www.yourbrand.com` → `yourbrand.com`

**DNS Configuration:**
```
Type: A
Name: @
Value: 76.76.21.21 (Vercel IP)

Type: CNAME
Name: www
Value: cname.vercel-dns.com
```

### 9. Backend Sales Channel Assignment

Assign products to the new sales channel via Medusa admin:
1. Products → Select product
2. Scroll to "Sales Channels"
3. Check `yourbrand`
4. Save

Or bulk assign via API script (create as needed).

### 10. Testing Checklist

- [ ] Homepage loads with correct branding
- [ ] Product listing shows correct items (sales channel filter)
- [ ] Add to cart works
- [ ] Checkout flow complete (test mode)
- [ ] Order confirmation email received
- [ ] Blog loads (if enabled)
- [ ] Mobile responsive
- [ ] Favicon displays correctly
- [ ] SEO meta tags correct

---

## Post-Launch

### Analytics
Add Google Analytics / Plausible / etc:
```javascript
// storefront-yourbrand/app/layout.tsx
// Add analytics script
```

### Monitoring
- Add to UptimeRobot or similar
- Configure Sentry for error tracking
- Set up Vercel alerts

### Marketing
- Submit sitemap to Google Search Console
- Configure social media meta tags
- Set up conversion tracking (Stripe webhook → analytics)

---

## Troubleshooting

**Products not showing:**
- Check sales channel assignment in Medusa admin
- Verify `NEXT_PUBLIC_SALES_CHANNEL` env var

**Styles not loading:**
- Run `npm run build` locally to check for Tailwind errors
- Clear `.next` cache

**Vercel build fails:**
- Check environment variables are set
- Review build logs for missing dependencies

---

## Time Breakdown

| Task | Est. Time |
|------|-----------|
| Backend sales channel | 5 min |
| Copy & configure storefront | 30 min |
| Branding (logo, colors, fonts) | 2-3 hours |
| Content customization | 2-3 hours |
| Vercel deployment | 30 min |
| Domain configuration | 15 min |
| Product assignment | 30 min |
| Testing | 1 hour |
| **Total** | **~8 hours (1 day)** |

*Assumes branding assets are ready. Add 1-2 days if starting from scratch.*
