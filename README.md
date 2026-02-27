# Vive l'Apéro Shop

E-commerce multi-storefront platform powered by Medusa.js

## Architecture

**Monorepo structure:**
- `backend/` — Medusa.js backend
- `storefront-vivelapero/` — Next.js storefront for vivelapero.fr
- `storefront-aperosexy/` — Next.js storefront for aperosexy.fr
- `shared/` — Shared code (types, components, utils)
- `docs/` — Documentation & ADR

## Storefronts

| Brand | Domain | Sales Channel | Blog |
|-------|--------|---------------|------|
| Vive l'Apéro | vivelapero.fr | vivelapero | ✅ |
| Apero Sexy | aperosexy.fr | aperosexy | ✅ |

**Redirects:**
- vive-lapero.fr → vivelapero.fr
- apero-sexy.fr → aperosexy.fr

## Tech Stack

**Backend:**
- Medusa.js (e-commerce engine)
- PostgreSQL (database)
- Redis (cache & jobs)
- Docker (containerization)

**Frontend:**
- Next.js 14+ (App Router)
- TailwindCSS (styling)
- TypeScript (type safety)
- MDX (blog content)

**Services:**
- Stripe (payment)
- Brevo (email & SMS)
- Replicate (image generation)
- Vercel (frontend hosting)

## Future Storefronts

This project serves as a **reusable template** for future e-commerce projects:
- `leschtitesboites.fr` — Migration from Shopify
- `atelierobe.fr` — New storefront

Setup time for new storefront: **~1 day** (branding + config)

## Development

### Prerequisites
- Node.js 20+
- Docker & Docker Compose
- GitHub CLI (`gh`)
- Vercel CLI

### Setup

```bash
# Install dependencies
npm install

# Start local development
docker-compose up -d  # PostgreSQL + Redis
cd backend && npm run dev

# Storefronts
cd storefront-vivelapero && npm run dev
cd storefront-aperosexy && npm run dev
```

## Documentation

- [Architecture Decisions](docs/DECISIONS.md)
- [New Storefront Setup](docs/NEW_STOREFRONT.md)
- [Shopify Migration Guide](docs/SHOPIFY_MIGRATION.md)

## Status

🚧 **Phase 0** — Infrastructure & DevOps setup in progress

---

**Made with ❤️ in France**
