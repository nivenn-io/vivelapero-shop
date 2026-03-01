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

**Project:** vivelapero (`7b6af845-8414-4ea8-9eed-abc77d29fb7a`)  
**Dashboard:** https://railway.app/project/7b6af845-8414-4ea8-9eed-abc77d29fb7a

**Environments:**
- Production (`1d773368-076f-4406-b6fa-836c4a677131`) → api.vivelapero.fr
- Staging (`d6a6bd97-c30a-4372-a673-5efedcfd1bf1`)

**Services:**
- Backend ✅ (`6e8d1d1c-4818-443b-aa1e-334b2d8ec890`) — Variables 7/9 configured
- PostgreSQL ⏳ — Add via Dashboard
- Redis ⏳ — Add via Dashboard

**Setup:** See `SETUP.md` (2 min remaining manual steps)

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
