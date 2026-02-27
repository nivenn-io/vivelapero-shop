# Architecture Decision Records (ADR)

This file documents all major architectural and technical decisions made during the project.

## Format

Each decision follows this structure:
```
## ADR-XXX: Title
Date: YYYY-MM-DD
Status: Accepted | Proposed | Deprecated
Decision: What we decided
Rationale: Why we decided this
Alternatives: What else we considered
Consequences: Impact of this decision
```

---

## ADR-001: Monorepo Structure
**Date:** 2026-02-27  
**Status:** Accepted  
**Decision:** Use monorepo with multiple storefronts sharing a common Medusa backend

**Rationale:**
- Single backend with sales channels for brand separation
- Code sharing (types, components, utils) reduces duplication
- Atomic deployments (backend changes propagate to all storefronts)
- Easier maintenance and scaling

**Alternatives Considered:**
- Separate repos per storefront → Rejected: too much duplication, sync issues
- Multi-repo with shared packages → Rejected: added complexity without benefits

**Consequences:**
- All storefronts must follow same tech stack (Next.js)
- Deployment orchestration more complex (multiple Vercel projects)
- But: faster feature development, consistent UX patterns

---

## ADR-002: Email Provider - Brevo
**Date:** 2026-02-27  
**Status:** Accepted  
**Decision:** Use Brevo (ex-Sendinblue) for all email communications

**Rationale:**
- Marketing automation built-in (essential for e-commerce)
- SMS included (shipping notifications)
- Generous free tier (9k emails/month)
- CRM features reduce tool sprawl
- French support

**Alternatives Considered:**
- Resend → Rejected: transactional only, no marketing automation
- SendGrid → Rejected: dated UI, worse DX
- Amazon SES → Rejected: complex setup, no marketing features

**Consequences:**
- Templates in HTML/Handlebars (not React)
- But: full marketing automation out of the box

---

## ADR-003: Blog Strategy - MDX
**Date:** 2026-02-27  
**Status:** Accepted  
**Decision:** Use MDX (Markdown + JSX) for blog content on both storefronts

**Rationale:**
- Lightweight, no CMS overhead
- Git-versionable content
- React components in markdown (interactive examples)
- Fast builds (static generation)
- Content sharing between storefronts possible

**Alternatives Considered:**
- Sanity/Strapi → Rejected: overkill for simple blog
- Notion API → Rejected: coupling to external service
- WordPress → Rejected: separate stack, maintenance burden

**Consequences:**
- Content editing requires Git knowledge (or UI layer later)
- But: full control, no CMS costs, excellent DX

---

## ADR-004: Payment Provider - Stripe
**Date:** 2026-02-27  
**Status:** Accepted  
**Decision:** Stripe for payment processing

**Rationale:**
- Official Medusa plugin with excellent support
- Best-in-class developer experience
- Comprehensive dashboard for business operations
- Supports future features (subscriptions, invoicing)
- Excellent fraud protection

**Alternatives Considered:**
- PayPal → Rejected: worse UX, higher fees
- Adyen → Rejected: overkill for SMB

**Consequences:**
- Stripe fees apply (~2.9% + 0.30€)
- But: best UX for customers, easiest integration

---

## ADR-005: Frontend Hosting - Vercel
**Date:** 2026-02-27  
**Status:** Accepted  
**Decision:** Host both storefronts on Vercel

**Rationale:**
- Zero-config Next.js deployment
- Preview deployments for every PR
- Edge functions for personalization features
- Excellent DX with Git integration
- Already have Pro account

**Alternatives Considered:**
- Netlify → Rejected: less Next.js optimization
- Railway → Rejected: better for backend than frontend
- Self-hosted → Rejected: maintenance overhead

**Consequences:**
- Two separate Vercel projects to manage
- But: instant deployments, great performance

---

## ADR-006: Backend Hosting Strategy
**Date:** 2026-02-27  
**Status:** Accepted  
**Decision:** VPS Hostinger (dev) → MedusaCloud (production, later)

**Rationale:**
- Dev on existing VPS infrastructure (Docker)
- Production on MedusaCloud when revenue justifies (~$20/mois)
- Avoid infrastructure reconfiguration

**Alternatives Considered:**
- Railway → Option kept for future evaluation
- Self-hosted prod → Rejected: scaling complexity

**Consequences:**
- Manual Docker management in dev
- Migration work when moving to prod
- But: low initial costs, flexibility

---

## ADR-007: Reusability Architecture
**Date:** 2026-02-27  
**Status:** Accepted  
**Decision:** Design for storefront reusability from day one

**Rationale:**
- Future migration: leschtitesboites.fr (Shopify → Medusa)
- Future storefront: atelierobe.fr
- Goal: new storefront in ~1 day (branding + config)

**Approach:**
- Shared template: `shared/templates/storefront-base/`
- Documented setup process
- Migration guides
- ADR documentation

**Consequences:**
- Slightly more upfront abstraction work
- But: massive time savings for future storefronts

---

## Next Decisions

_To be documented as project evolves_

- Image storage strategy (local dev vs S3 vs CDN)
- Analytics provider
- Search functionality (Meilisearch? Algolia?)
- Internationalization strategy
- Mobile app consideration
