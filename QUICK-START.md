# ⚡ Quick Start Guide

**Get up and running in 5 minutes!**

---

## 🚀 Step 1: Push the DevOps Config

```bash
# Fix GitHub auth (add workflow scope)
gh auth refresh -s workflow

# Verify scopes
gh auth status
# Should include: 'workflow'

# Push the commit
cd /data/dev/vivelapero-shop
git push origin main
```

**✅ Result:** Infrastructure code pushed to GitHub

---

## 🔐 Step 2: Configure GitHub Secrets

Go to: https://github.com/nivenn-io/vivelapero-shop/settings/secrets/actions

**Add 5 secrets** (copy-paste from `.github/SECRETS-CHECKLIST.md`):

1. `RAILWAY_TOKEN` ✅ (already have: b4ca20df-a461-4fe6-aea6-d7945e04b2a7)
2. `VERCEL_TOKEN` (get from `~/.config/vercel/token`)
3. `VERCEL_ORG_ID` (run `vercel teams ls`)
4. `VERCEL_PROJECT_ID_VIVELAPERO` (after creating Vercel project)
5. `VERCEL_PROJECT_ID_APEROSEXY` (after creating Vercel project)

**Commands to get tokens:**
```bash
# Vercel token
cat ~/.config/vercel/token

# Vercel org ID
vercel teams ls
```

---

## 💻 Step 3: Test Local Development

```bash
cd /data/dev/vivelapero-shop

# Start local stack (PostgreSQL + Redis + Medusa)
./.devops/start-dev.sh

# Wait ~10 seconds, then check
docker-compose ps

# Access services:
# - API: http://localhost:9000
# - Admin: http://localhost:7001
```

**✅ Result:** Local dev environment running

---

## 🚂 Step 4: Setup Railway (Staging)

```bash
# Interactive setup
./.devops/setup-railway.sh
# Choose: 1) Staging

# OR manual:
# 1. Go to https://railway.app/new
# 2. Create project "vivelapero-staging"
# 3. Add PostgreSQL service
# 4. Add Redis service
# 5. Add GitHub repo service (link to nivenn-io/vivelapero-shop)
# 6. Set environment variables (see README-DEPLOY.md section "Railway Setup")
```

**Key environment variables to set:**
```bash
NODE_ENV=staging
JWT_SECRET=$(openssl rand -base64 64)
COOKIE_SECRET=$(openssl rand -base64 64)
DATABASE_URL=${{Postgres.DATABASE_URL}}  # Auto-filled
REDIS_URL=${{Redis.REDIS_URL}}           # Auto-filled
STORE_CORS=https://vivelapero.fr,https://aperosexy.fr
ADMIN_CORS=https://api.vivelapero.fr
```

**✅ Result:** Staging environment ready on Railway

---

## 🚂 Step 5: Setup Railway (Production)

Same as Step 4, but:
- Project name: `vivelapero-production`
- Environment: production
- Add custom domain: `api.vivelapero.fr`

**DNS Configuration:**
```
CNAME api.vivelapero.fr → [railway-provided-url].railway.app
```

**✅ Result:** Production environment ready on Railway

---

## ▲ Step 6: Setup Vercel Projects

### Vive l'Apéro Storefront

```bash
cd storefront-vivelapero

# Create project
vercel
# - Project name: vivelapero-storefront
# - Add to team

# Note the project ID
cat .vercel/project.json | jq -r '.projectId'
# → Add to GitHub secret: VERCEL_PROJECT_ID_VIVELAPERO

# Configure environment variables in Vercel dashboard:
# NEXT_PUBLIC_MEDUSA_BACKEND_URL=https://api.vivelapero.fr
# NEXT_PUBLIC_SALES_CHANNEL=vivelapero

# Add domains:
# - vivelapero.fr (production)
# - vive-lapero.fr (redirect)
```

### Apero Sexy Storefront

```bash
cd storefront-aperosexy

# Create project
vercel
# - Project name: aperosexy-storefront

# Note the project ID
cat .vercel/project.json | jq -r '.projectId'
# → Add to GitHub secret: VERCEL_PROJECT_ID_APEROSEXY

# Configure environment variables:
# NEXT_PUBLIC_MEDUSA_BACKEND_URL=https://api.vivelapero.fr
# NEXT_PUBLIC_SALES_CHANNEL=aperosexy

# Add domains:
# - aperosexy.fr (production)
# - apero-sexy.fr (redirect)
```

**✅ Result:** Both storefronts deployed on Vercel

---

## ✅ Step 7: Test CI/CD

```bash
# Make a small change
cd /data/dev/vivelapero-shop
echo "# Test" >> backend/README.md
git add backend/README.md
git commit -m "test: trigger CI/CD"
git push origin main

# Check GitHub Actions
# Go to: https://github.com/nivenn-io/vivelapero-shop/actions
# Should see:
# - ✅ Backend CI (tests)
# - ✅ Deploy to Railway Staging
# - ✅ Deploy Storefronts to Vercel (if storefront files changed)
```

**✅ Result:** CI/CD working!

---

## 🎉 Done!

You now have:

- ✅ Local development environment (Docker Compose)
- ✅ Staging environment (Railway auto-deploy on push to main)
- ✅ Production environment (Railway manual deploy)
- ✅ 2 storefronts on Vercel (auto-deploy on push to main)
- ✅ CI/CD with GitHub Actions
- ✅ Complete documentation (README-DEPLOY.md)

---

## 📚 What to Read Next

1. **Full deployment guide:** [README-DEPLOY.md](./README-DEPLOY.md)
2. **GitHub secrets setup:** [.github/SECRETS-CHECKLIST.md](./.github/SECRETS-CHECKLIST.md)
3. **DevOps setup details:** [DEVOPS-SETUP-COMPLETE.md](./DEVOPS-SETUP-COMPLETE.md)

---

## 🛠️ Useful Commands

```bash
# Local dev
./.devops/start-dev.sh        # Start
./.devops/stop-dev.sh         # Stop
./.devops/reset-db.sh         # Reset database
docker-compose logs -f        # View logs

# Railway
railway status                # Check status
railway logs -f               # View logs
railway run <command>         # Run command in Railway

# Vercel
vercel                        # Deploy preview
vercel --prod                 # Deploy production
vercel logs <project> -f      # View logs

# Backup
./.devops/backup-db.sh        # Backup Railway production DB
```

---

**Need help?** See [README-DEPLOY.md](./README-DEPLOY.md) → Troubleshooting section.
