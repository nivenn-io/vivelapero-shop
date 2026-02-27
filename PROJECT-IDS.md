# Project IDs & Links

Tous les identifiants et liens pour le projet vivelapero-shop.

**Créé le :** 2026-02-27

---

## GitHub

**Repository :** https://github.com/nivenn-io/vivelapero-shop

**Derniers commits :**
- [2e58ed4](https://github.com/nivenn-io/vivelapero-shop/commit/2e58ed4) - docs: add DevOps setup completion reports and quick start guide
- [05f0960](https://github.com/nivenn-io/vivelapero-shop/commit/05f0960) - ci: add Railway + Docker Compose + GitHub Actions deployment
- [1cec524](https://github.com/nivenn-io/vivelapero-shop/commit/1cec524) - chore: initial monorepo structure with documentation

**GitHub Actions :** https://github.com/nivenn-io/vivelapero-shop/actions

**Settings → Secrets :** https://github.com/nivenn-io/vivelapero-shop/settings/secrets/actions

---

## Vercel

**Organisation :** nivenn-io  
**Org ID :** `team_dk4x9caXgp5qX7cdIf16Bja4`

### Storefront Vivelapero

**Nom :** vivelapero-storefront  
**Project ID :** `prj_UAgAfZwPJ6dBRfPm9aNufAcNoqWF`  
**Dashboard :** https://vercel.com/nivenn-io/vivelapero-storefront  
**Domaine principal :** vivelapero.fr  
**Redirect :** vive-lapero.fr → vivelapero.fr

### Storefront Apero Sexy

**Nom :** aperosexy-storefront  
**Project ID :** `prj_aV45MqmrxUfqLZF2FboEAwjEvn9w`  
**Dashboard :** https://vercel.com/nivenn-io/aperosexy-storefront  
**Domaine principal :** aperosexy.fr  
**Redirect :** apero-sexy.fr → aperosexy.fr

---

## Railway

### Staging Environment

**Nom :** vivelapero-staging  
**Project ID :** `7d85fbb5-4693-459a-bb97-27b4b02d1375`  
**Dashboard :** https://railway.app/project/7d85fbb5-4693-459a-bb97-27b4b02d1375

**Services créés ✅ :**
- PostgreSQL 16 (ID: `87de2c4a-2131-4b3f-b84d-0ddc1f5b8b1f`)
- Redis 7 (ID: `c2894e5f-c6a5-4c6a-9077-6d1e183123f3`)
- Backend (ID: `fcf1530f-2558-4390-8255-1159b4285eb1`) — ⏳ À configurer

**Configuration Backend :** `.devops/RAILWAY-BACKEND-CONFIG.md`

### Production Environment

**Nom :** vivelapero-production  
**Project ID :** `ccde0103-65c6-4537-a8db-051bb0b96abb`  
**Dashboard :** https://railway.app/project/ccde0103-65c6-4537-a8db-051bb0b96abb

**Services créés ✅ :**
- PostgreSQL 16 (ID: `4bcd575b-d93b-484a-add5-7c8ea84331c8`)
- Redis 7 (ID: `a0107eea-63a4-40bc-8a21-4bb3f8560448`)
- Backend (ID: `4543113d-28f2-4912-9823-13ec56642f37`) — ⏳ À configurer

**Domaine custom :** api.vivelapero.fr

**Configuration Backend :** `.devops/RAILWAY-BACKEND-CONFIG.md`

---

## GitHub Secrets à configurer

**Emplacement :** https://github.com/nivenn-io/vivelapero-shop/settings/secrets/actions

```bash
# Railway
RAILWAY_TOKEN=<stored in /data/.config/railway/config.json>

# Vercel (récupérer via commandes ci-dessous)
VERCEL_TOKEN=$(cat /data/.config/vercel/token)
VERCEL_ORG_ID=team_dk4x9caXgp5qX7cdIf16Bja4
VERCEL_PROJECT_ID_VIVELAPERO=prj_UAgAfZwPJ6dBRfPm9aNufAcNoqWF
VERCEL_PROJECT_ID_APEROSEXY=prj_aV45MqmrxUfqLZF2FboEAwjEvn9w
```

**Voir détails :** `.github/SECRETS-CHECKLIST.md`

---

## Credentials Locaux

Stockés dans `/data/.config/` :

```
/data/.config/
├── gh/hosts.yml              # GitHub CLI
├── vercel/token              # Vercel CLI
└── railway/config.json       # Railway CLI
```

---

## Next Steps

1. ✅ Projets créés (GitHub, Vercel x2, Railway x2)
2. ⏳ Ajouter services Railway (PostgreSQL + Redis + Backend) via Dashboard
3. ⏳ Configurer GitHub Secrets
4. ⏳ Configurer domaines Vercel (vivelapero.fr, aperosexy.fr)
5. ⏳ Configurer domaine Railway prod (api.vivelapero.fr)
6. ⏳ Tester CI/CD (push main → auto-deploy staging)

**Guide complet :** `README-DEPLOY.md`  
**Setup rapide :** `QUICK-START.md`  
**Script Railway :** `.devops/setup-railway-services.sh`

---

**Status :** Phase 0 DevOps complete ✅  
**Prochaine phase :** Phase 1 - Backend Medusa init
