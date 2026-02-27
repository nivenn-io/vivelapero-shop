# 🚀 Deployment Guide - Vive l'Apéro Shop

Complete guide for deploying the Vive l'Apéro multi-storefront e-commerce platform.

## 📋 Table of Contents

- [Architecture Overview](#architecture-overview)
- [Prerequisites](#prerequisites)
- [Local Development](#local-development)
- [Railway Setup](#railway-setup)
- [Vercel Setup](#vercel-setup)
- [GitHub Secrets](#github-secrets)
- [CI/CD Workflows](#cicd-workflows)
- [Manual Deployment](#manual-deployment)
- [Rollback Procedure](#rollback-procedure)
- [Monitoring](#monitoring)
- [Troubleshooting](#troubleshooting)

---

## 🏗️ Architecture Overview

### Services

**Backend (Railway):**
- Medusa.js API (Node.js)
- PostgreSQL 16 (managed database)
- Redis 7 (managed cache)
- Custom domain: `api.vivelapero.fr`

**Storefronts (Vercel):**
- Vive l'Apéro: `vivelapero.fr` (+ redirect `vive-lapero.fr`)
- Apero Sexy: `aperosexy.fr` (+ redirect `apero-sexy.fr`)

### Environments

| Environment | Backend | Storefronts | Auto-deploy |
|-------------|---------|-------------|-------------|
| **Development** | Docker Compose (local) | localhost:3000-3001 | Manual |
| **Staging** | Railway | Vercel Preview | ✅ Auto (on push to `main`) |
| **Production** | Railway | Vercel Production | Manual (tag or workflow dispatch) |

---

## ✅ Prerequisites

### Required Tools

```bash
# Node.js 20+
node --version  # v20.x.x

# Docker & Docker Compose
docker --version
docker-compose --version

# GitHub CLI
gh --version

# Railway CLI
npm install -g @railway/cli
railway --version

# Vercel CLI
npm install -g vercel
vercel --version
```

### Credentials Checklist

Before starting, ensure you have:

- ✅ GitHub account with repo access
- ✅ Railway account ([railway.app](https://railway.app))
- ✅ Vercel account ([vercel.com](https://vercel.com)) - **Pro plan required for multi-project**
- ✅ Stripe account (payment processing)
- ✅ Brevo account (email/SMS)
- ✅ Domain access (DNS configuration)

---

## 💻 Local Development

### 1. Clone & Setup

```bash
# Clone repository
git clone https://github.com/nivenn-io/vivelapero-shop.git
cd vivelapero-shop

# Create .env file
cp .env.example .env

# Edit .env with your local credentials
# (Auto-generated secrets on first start if not exists)
```

### 2. Start Development Environment

```bash
# Start all services (PostgreSQL + Redis + Medusa)
./.devops/start-dev.sh
```

**Service URLs:**
- Medusa API: http://localhost:9000
- Medusa Admin: http://localhost:7001
- PostgreSQL: localhost:5432
- Redis: localhost:6379

### 3. Stop Development Environment

```bash
# Stop services (keeps data)
./.devops/stop-dev.sh

# Stop and remove all data
docker-compose down -v
```

### 4. Reset Database

```bash
# ⚠️  WARNING: Deletes all local data
./.devops/reset-db.sh
```

### 5. Run Storefronts

```bash
# Terminal 1: Vive l'Apéro storefront
cd storefront-vivelapero
npm install
npm run dev
# → http://localhost:3000

# Terminal 2: Apero Sexy storefront
cd storefront-aperosexy
npm install
npm run dev
# → http://localhost:3001
```

---

## 🚂 Railway Setup

### 1. Create Railway Projects

Create **two separate projects** (staging + production):

#### Staging Project

```bash
# 1. Go to https://railway.app/new
# 2. Click "New Project"
# 3. Name: "vivelapero-staging"
# 4. Click "Add Service" → "PostgreSQL"
# 5. Click "Add Service" → "Redis"
# 6. Click "Add Service" → "GitHub Repo" → Select this repo
# 7. Set environment to "staging"
```

#### Production Project

```bash
# Repeat same steps with name "vivelapero-production"
# Set environment to "production"
```

### 2. Link Projects Locally

```bash
# Link to staging
railway link --project vivelapero-staging --environment staging

# Link to production (from separate terminal/directory)
railway link --project vivelapero-production --environment production
```

### 3. Configure Environment Variables

#### Required Variables (Both Staging & Production)

Go to Railway dashboard → Project → Variables:

```bash
# Node Environment
NODE_ENV=production  # or "staging" for staging

# Secrets (generate unique values for each environment)
JWT_SECRET=<generated-secret-64-chars>
COOKIE_SECRET=<generated-secret-64-chars>

# Database & Redis (auto-populated by Railway services)
DATABASE_URL=${{Postgres.DATABASE_URL}}
REDIS_URL=${{Redis.REDIS_URL}}

# CORS (adjust domains for staging/production)
STORE_CORS=https://vivelapero.fr,https://aperosexy.fr
ADMIN_CORS=https://api.vivelapero.fr

# Medusa
MEDUSA_ADMIN_ONBOARDING_TYPE=default

# Stripe (production keys for prod, test keys for staging)
STRIPE_API_KEY=sk_live_... # or sk_test_... for staging
STRIPE_WEBHOOK_SECRET=whsec_...

# Brevo
BREVO_API_KEY=xkeysib-...
BREVO_SENDER_EMAIL=noreply@vivelapero.fr

# Optional: Object Storage (if using S3/Minio)
# S3_BUCKET=vivelapero-uploads
# S3_REGION=eu-west-1
# S3_ACCESS_KEY_ID=...
# S3_SECRET_ACCESS_KEY=...
```

### 4. Generate Secrets

```bash
# Generate JWT_SECRET (64 characters)
openssl rand -base64 64

# Generate COOKIE_SECRET (64 characters)
openssl rand -base64 64

# Generate admin password
openssl rand -base64 32
```

### 5. Configure Custom Domain (Production Only)

1. Go to Railway dashboard → Production project → Backend service
2. Click "Settings" → "Domains"
3. Click "Add Domain" → "Custom Domain"
4. Enter: `api.vivelapero.fr`
5. Railway will provide DNS records:
   - `CNAME api.vivelapero.fr → xxx.railway.app`
6. Add this CNAME record to your DNS provider
7. Wait for DNS propagation (~5-60 minutes)
8. Railway will auto-provision SSL certificate

### 6. Run Migrations

```bash
# Staging
railway run npm run migrate --project vivelapero-staging --environment staging

# Production
railway run npm run migrate --project vivelapero-production --environment production
```

### 7. Automated Setup Script

```bash
# Interactive setup script
./.devops/setup-railway.sh

# Follow prompts to setup staging or production
```

---

## ▲ Vercel Setup

### 1. Create Vercel Projects

#### Project 1: Vive l'Apéro Storefront

```bash
cd storefront-vivelapero
vercel

# Follow prompts:
# - Set up and deploy? Yes
# - Which scope? Your team
# - Link to existing project? No
# - Project name? vivelapero-storefront
# - Directory? ./
# - Override settings? No
```

#### Project 2: Apero Sexy Storefront

```bash
cd storefront-aperosexy
vercel

# Follow prompts:
# - Set up and deploy? Yes
# - Which scope? Your team
# - Link to existing project? No
# - Project name? aperosexy-storefront
# - Directory? ./
# - Override settings? No
```

### 2. Configure Environment Variables

For **each project**, go to Vercel dashboard → Project → Settings → Environment Variables:

```bash
# Medusa Backend URL
NEXT_PUBLIC_MEDUSA_BACKEND_URL=https://api.vivelapero.fr

# Sales Channel (different for each storefront!)
# vivelapero-storefront:
NEXT_PUBLIC_SALES_CHANNEL=vivelapero

# aperosexy-storefront:
NEXT_PUBLIC_SALES_CHANNEL=aperosexy

# Optional: Analytics
NEXT_PUBLIC_GA_ID=G-XXXXXXXXXX
```

### 3. Configure Custom Domains

#### Vive l'Apéro Storefront

1. Vercel dashboard → vivelapero-storefront → Settings → Domains
2. Add domains:
   - `vivelapero.fr` (production)
   - `vive-lapero.fr` (redirect to vivelapero.fr)
3. Configure DNS:
   - `A vivelapero.fr → 76.76.21.21`
   - `CNAME www.vivelapero.fr → cname.vercel-dns.com`
   - `CNAME vive-lapero.fr → cname.vercel-dns.com`
4. Enable "Redirect to Primary Domain" for `vive-lapero.fr`

#### Apero Sexy Storefront

1. Vercel dashboard → aperosexy-storefront → Settings → Domains
2. Add domains:
   - `aperosexy.fr` (production)
   - `apero-sexy.fr` (redirect to aperosexy.fr)
3. Configure DNS (same as above)

### 4. Get Project IDs

```bash
# Vive l'Apéro
cd storefront-vivelapero
vercel project ls
# Note the project ID

# Apero Sexy
cd storefront-aperosexy
vercel project ls
# Note the project ID

# Or get from Vercel dashboard:
# Project → Settings → General → Project ID
```

---

## 🔐 GitHub Secrets

Configure these secrets in GitHub repository settings:

**Settings → Secrets and variables → Actions → New repository secret**

### Required Secrets

```bash
# Railway
RAILWAY_TOKEN=b4ca20df-a461-4fe6-aea6-d7945e04b2a7
# Get from: railway.app/account/tokens

# Vercel
VERCEL_TOKEN=xxxxxxxxxxxxx
# Get from: vercel.com/account/tokens

VERCEL_ORG_ID=team_xxxxxxxxxxxxx
# Get from: vercel.com/[team]/settings

VERCEL_PROJECT_ID_VIVELAPERO=prj_xxxxxxxxxxxxx
# Get from: vivelapero-storefront project settings

VERCEL_PROJECT_ID_APEROSEXY=prj_xxxxxxxxxxxxx
# Get from: aperosexy-storefront project settings
```

### How to Get Tokens

#### Railway Token

```bash
# Method 1: CLI
railway whoami
cat ~/.railway/config.json

# Method 2: Dashboard
# 1. Go to railway.app/account/tokens
# 2. Click "Create Token"
# 3. Name: "GitHub Actions"
# 4. Copy token
```

#### Vercel Token

```bash
# Method 1: CLI
cat ~/.config/vercel/token

# Method 2: Dashboard
# 1. Go to vercel.com/account/tokens
# 2. Click "Create Token"
# 3. Scope: Full Account
# 4. Expiration: No Expiration (or 1 year)
# 5. Copy token
```

#### Vercel Org ID

```bash
# CLI
vercel teams ls

# Dashboard
# Go to vercel.com/[team]/settings → General → Team ID
```

#### Vercel Project IDs

```bash
# CLI (from project directory)
cd storefront-vivelapero
vercel project ls
# or
cat .vercel/project.json

# Dashboard
# Go to project → Settings → General → Project ID
```

---

## 🤖 CI/CD Workflows

### Workflow Triggers

| Workflow | Trigger | Environment |
|----------|---------|-------------|
| **backend-ci.yml** | Push to `backend/**` | Tests only |
| **deploy-railway-staging.yml** | Push to `main` → `backend/**` | Staging |
| **deploy-railway-prod.yml** | Manual (workflow dispatch) or tag `v*.*.*` | Production |
| **deploy-vercel-storefronts.yml** | Push to `main` → `storefront-*/**` | Production |

### Staging Deployment (Auto)

```bash
# Merge to main → auto-deploys to staging
git checkout main
git pull
git merge feat/my-feature
git push
# ✅ GitHub Actions will deploy to Railway staging + Vercel preview
```

### Production Deployment (Manual)

#### Method 1: Workflow Dispatch

```bash
# 1. Go to GitHub → Actions → "Deploy to Railway Production"
# 2. Click "Run workflow"
# 3. Type "deploy" to confirm
# 4. Click "Run workflow"
```

#### Method 2: Git Tag

```bash
# Create and push a version tag
git tag v1.0.0
git push origin v1.0.0
# ✅ Triggers production deployment
```

### Monitor Deployment

```bash
# GitHub Actions
# Go to: github.com/[user]/[repo]/actions

# Railway Logs
railway logs --project vivelapero-production --environment production

# Vercel Logs
vercel logs vivelapero-storefront
```

---

## 🛠️ Manual Deployment

If CI/CD fails, deploy manually:

### Railway (Backend)

```bash
# Staging
railway link --project vivelapero-staging --environment staging
railway up

# Production
railway link --project vivelapero-production --environment production
railway up

# Run migrations
railway run npm run migrate
```

### Vercel (Storefronts)

```bash
# Vive l'Apéro
cd storefront-vivelapero
vercel --prod

# Apero Sexy
cd storefront-aperosexy
vercel --prod
```

---

## ⏮️ Rollback Procedure

### Rollback Backend (Railway)

#### Option 1: Redeploy Previous Deployment

```bash
# 1. Go to Railway dashboard → Production project → Backend service
# 2. Click "Deployments" tab
# 3. Find last working deployment
# 4. Click "..." → "Redeploy"
```

#### Option 2: Rollback Git & Redeploy

```bash
# Find last working commit
git log --oneline

# Revert to that commit
git revert <commit-hash>
git push

# Or hard reset (⚠️  dangerous)
git reset --hard <commit-hash>
git push --force

# Railway will auto-deploy on push
```

#### Option 3: Restore Database Backup

```bash
# 1. Stop current deployment
railway service stop --project vivelapero-production

# 2. Restore database
gunzip ./backups/vivelapero_prod_YYYYMMDD_HHMMSS.sql.gz
railway run pg_restore -c -d $DATABASE_URL ./backups/vivelapero_prod_YYYYMMDD_HHMMSS.sql

# 3. Restart service
railway service start --project vivelapero-production
```

### Rollback Storefronts (Vercel)

```bash
# 1. Go to Vercel dashboard → Project → Deployments
# 2. Find last working deployment
# 3. Click "..." → "Promote to Production"
```

---

## 📊 Monitoring

### Health Checks

```bash
# Backend
curl https://api.vivelapero.fr/health
# Expected: {"status":"ok"}

# Storefronts
curl -I https://vivelapero.fr
curl -I https://aperosexy.fr
# Expected: HTTP/2 200
```

### Logs

```bash
# Railway
railway logs --project vivelapero-production --environment production -f

# Vercel
vercel logs vivelapero-storefront --follow
vercel logs aperosexy-storefront --follow
```

### Monitoring URLs

- **Railway Dashboard:** https://railway.app
- **Vercel Dashboard:** https://vercel.com
- **GitHub Actions:** https://github.com/nivenn-io/vivelapero-shop/actions

### Database Backup

```bash
# Manual backup
./.devops/backup-db.sh

# Automated backup (Railway)
# Railway provides automatic daily backups for PostgreSQL
# Access via: Railway dashboard → PostgreSQL service → Backups
```

---

## 🐛 Troubleshooting

### Issue: Docker Compose fails to start

```bash
# Check if ports are already in use
lsof -i :5432  # PostgreSQL
lsof -i :6379  # Redis
lsof -i :9000  # Medusa

# Stop conflicting services
docker-compose down
# or
docker stop $(docker ps -aq)

# Clean up
docker-compose down -v
docker system prune -a
```

### Issue: Railway deployment fails

```bash
# Check build logs
railway logs --project vivelapero-production --environment production

# Common issues:
# 1. Missing environment variables → Check Railway dashboard → Variables
# 2. Database migration failed → Run manually: railway run npm run migrate
# 3. Port conflict → Ensure Dockerfile exposes port 9000
```

### Issue: Vercel deployment fails

```bash
# Check build logs
vercel logs vivelapero-storefront

# Common issues:
# 1. Missing env vars → Check Vercel dashboard → Settings → Environment Variables
# 2. Build timeout → Increase timeout in Vercel settings
# 3. Incorrect backend URL → Verify NEXT_PUBLIC_MEDUSA_BACKEND_URL
```

### Issue: Domain not resolving

```bash
# Check DNS propagation
dig api.vivelapero.fr
nslookup api.vivelapero.fr

# Wait for propagation (up to 48h, usually 5-60 minutes)
# Verify DNS records in your domain registrar
```

### Issue: Database connection failed

```bash
# Verify DATABASE_URL format
# Correct: postgresql://user:password@host:port/database

# Test connection (Railway)
railway run psql $DATABASE_URL -c "SELECT 1;"

# Check PostgreSQL logs
railway logs --project vivelapero-production --service postgres
```

### Issue: CORS errors in storefronts

```bash
# Verify backend STORE_CORS variable includes storefront domain
# Railway → Backend → Variables → STORE_CORS

# Should include:
# STORE_CORS=https://vivelapero.fr,https://aperosexy.fr
```

---

## 📞 Support

### Useful Commands

```bash
# Railway
railway status                    # Check deployment status
railway logs -f                   # Follow logs
railway variables                 # List environment variables
railway run <command>             # Run command in production

# Vercel
vercel                            # Deploy to preview
vercel --prod                     # Deploy to production
vercel logs <project> --follow    # Follow logs
vercel env ls                     # List environment variables

# Docker
docker-compose ps                 # Check running services
docker-compose logs -f [service]  # Follow logs
docker-compose exec [service] sh  # Shell into container
```

### Resources

- **Railway Docs:** https://docs.railway.app
- **Vercel Docs:** https://vercel.com/docs
- **Medusa Docs:** https://docs.medusajs.com
- **Next.js Docs:** https://nextjs.org/docs

---

## ✅ Deployment Checklist

### Pre-Deployment

- [ ] All tests passing locally
- [ ] Environment variables configured (Railway + Vercel)
- [ ] GitHub secrets configured
- [ ] DNS records configured
- [ ] SSL certificates active
- [ ] Database backup created (production)

### Post-Deployment

- [ ] Health checks passing
- [ ] Storefronts accessible
- [ ] Admin panel accessible
- [ ] Database migrations applied
- [ ] Logs checked (no errors)
- [ ] Monitoring active

---

**Made with ❤️ by Nivenn.io**

Last updated: 2026-02-27
