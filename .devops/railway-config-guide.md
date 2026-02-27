# Railway Configuration Guide

Services créés automatiquement via API. Configuration finale à faire via Dashboard.

---

## ✅ Services Créés

### Staging (vivelapero-staging)
**Dashboard:** https://railway.app/project/7d85fbb5-4693-459a-bb97-27b4b02d1375

- ✅ **PostgreSQL** (ID: cd6ccef6-0e22-4bc3-a2d9-d4d6717c22ad)
- ✅ **Redis** (ID: e681352f-a63b-4828-b76f-4824291aaa64)
- ✅ **Backend** (ID: fcf1530f-2558-4390-8255-1159b4285eb1)

### Production (vivelapero-production)
**Dashboard:** https://railway.app/project/ccde0103-65c6-4537-a8db-051bb0b96abb

- ✅ **PostgreSQL** (ID: a89b78c2-030a-4d1d-a151-2830e514e246)
- ✅ **Redis** (ID: d2f18857-bb2c-43c8-be19-91b9661219f3)
- ✅ **Backend** (ID: 4543113d-28f2-4912-9823-13ec56642f37)

---

## 📝 Configuration Required

### 1. Backend Service Settings

Pour **Staging** et **Production**, configurer le service Backend :

**Settings → General :**
- ✅ Root Directory : `backend`
- ✅ Build Command : `npm install && npm run build`
- ✅ Start Command : `npm run start`
- ✅ Watch Paths : `backend/**`

**Settings → Networking :**
- ✅ Port : `3000` (auto-detected)
- **Production only** : Custom Domain → `api.vivelapero.fr`

---

### 2. Environment Variables

#### Staging Backend

**Settings → Variables :**

```bash
NODE_ENV=staging
PORT=3000

# Génération secrets (exécuter localement) :
JWT_SECRET=$(openssl rand -base64 32)
COOKIE_SECRET=$(openssl rand -base64 32)

# References Railway (automatique si services dans même projet)
DATABASE_URL=${{Postgres.DATABASE_URL}}
REDIS_URL=${{Redis.REDIS_URL}}

# Medusa config
MEDUSA_ADMIN_ONBOARDING_TYPE=default

# CORS (ajuster selon URLs Vercel preview)
STORE_CORS=https://vivelapero-storefront-git-main-nivenn-io.vercel.app,https://aperosexy-storefront-git-main-nivenn-io.vercel.app
ADMIN_CORS=https://vivelapero-storefront-git-main-nivenn-io.vercel.app,https://aperosexy-storefront-git-main-nivenn-io.vercel.app
```

#### Production Backend

**Settings → Variables :**

```bash
NODE_ENV=production
PORT=3000

# Génération secrets (DIFFÉRENTS de staging !)
JWT_SECRET=$(openssl rand -base64 32)
COOKIE_SECRET=$(openssl rand -base64 32)

# References Railway
DATABASE_URL=${{Postgres.DATABASE_URL}}
REDIS_URL=${{Redis.REDIS_URL}}

# Medusa config
MEDUSA_ADMIN_ONBOARDING_TYPE=default

# CORS (domaines production)
STORE_CORS=https://vivelapero.fr,https://aperosexy.fr
ADMIN_CORS=https://vivelapero.fr,https://aperosexy.fr
```

---

### 3. PostgreSQL Configuration

Les deux environnements (staging + prod) :

**Settings → Variables :**

Railway auto-configure PostgreSQL, mais vérifier :
- ✅ `POSTGRES_USER` : postgres
- ✅ `POSTGRES_PASSWORD` : (auto-généré)
- ✅ `POSTGRES_DB` : railway

**Connection string** automatiquement exposé via `${{Postgres.DATABASE_URL}}`

---

### 4. Redis Configuration

Les deux environnements (staging + prod) :

**Settings → Variables :**

Aucune config nécessaire. Railway expose automatiquement :
- ✅ `REDIS_URL` : redis://default:...@...railway.app:PORT

---

## 🚀 Deployment Triggers

### Staging
**Settings → Deploys → GitHub Triggers :**
- ✅ Branch : `main`
- ✅ Auto-deploy : ON
- ✅ Root directory : `backend`

### Production
**Settings → Deploys → GitHub Triggers :**
- ⚠️ Auto-deploy : OFF (deploy manuel ou via tag)
- ✅ Branch : `main`
- ✅ Root directory : `backend`

**Deploy production :**
```bash
# Option A : Tag Git
git tag v1.0.0
git push origin v1.0.0

# Option B : Railway Dashboard
# → Deploys → Deploy → Select commit
```

---

## 🔗 Custom Domain (Production only)

**Backend service → Settings → Networking → Custom Domain :**

1. Add domain : `api.vivelapero.fr`
2. Railway affiche un CNAME :
   ```
   api.vivelapero.fr → <service-id>.up.railway.app
   ```
3. Ajouter le CNAME chez ton registrar (OVH/Cloudflare/autre)
4. Attendre propagation DNS (5-60 min)
5. ✅ Railway auto-configure SSL (Let's Encrypt)

---

## ✅ Checklist Configuration

### Staging
- [ ] Backend → Root directory : `backend`
- [ ] Backend → Build command : `npm install && npm run build`
- [ ] Backend → Start command : `npm run start`
- [ ] Backend → Variables : NODE_ENV, JWT_SECRET, COOKIE_SECRET, DATABASE_URL, REDIS_URL, CORS
- [ ] PostgreSQL → Running (aucune config)
- [ ] Redis → Running (aucune config)
- [ ] GitHub trigger : Branch `main`, auto-deploy ON

### Production
- [ ] Backend → Root directory : `backend`
- [ ] Backend → Build command : `npm install && npm run build`
- [ ] Backend → Start command : `npm run start`
- [ ] Backend → Variables : NODE_ENV, JWT_SECRET, COOKIE_SECRET, DATABASE_URL, REDIS_URL, CORS
- [ ] Backend → Custom domain : `api.vivelapero.fr`
- [ ] PostgreSQL → Running
- [ ] Redis → Running
- [ ] GitHub trigger : Branch `main`, auto-deploy OFF
- [ ] DNS CNAME configuré

---

## 🧪 Test Deployment

### 1. Vérifier services running

**Staging :**
```bash
curl https://<staging-backend-url>.up.railway.app/health
# Expected: {"status":"ok"}
```

**Production :**
```bash
curl https://api.vivelapero.fr/health
# Expected: {"status":"ok"}
```

### 2. Vérifier database connection

```bash
# Logs Railway → Backend service
# Chercher : "Database connected successfully"
```

### 3. Tester API Medusa

```bash
curl https://api.vivelapero.fr/store/products
# Expected: {"products":[],"count":0,...}
```

---

## 🔧 Troubleshooting

### Backend ne démarre pas
- Vérifier logs : Railway Dashboard → Backend → Logs
- Vérifier variables : DATABASE_URL et REDIS_URL bien référencés
- Vérifier build : `npm run build` success

### Database connection failed
- Vérifier PostgreSQL service running
- Vérifier `DATABASE_URL` format : `postgresql://user:pass@host:port/db`

### CORS errors
- Vérifier `STORE_CORS` et `ADMIN_CORS` incluent bien les URLs Vercel
- Format : `https://domain1.com,https://domain2.com` (pas d'espace)

---

## 📊 Monitoring

**Railway Dashboard :**
- **Metrics** : CPU, RAM, Network
- **Logs** : Real-time + historical
- **Deployments** : Status, duration, commit

**URLs à bookmarker :**
- Staging : https://railway.app/project/7d85fbb5-4693-459a-bb97-27b4b02d1375
- Production : https://railway.app/project/ccde0103-65c6-4537-a8db-051bb0b96abb

---

**Created :** 2026-02-27  
**Status :** Services created ✅ | Config pending ⏳
