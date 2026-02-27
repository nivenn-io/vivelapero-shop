# Railway Setup Final - Multi-Environnements

Configuration complète du projet Railway vivelapero (staging + production).

---

## ✅ Créé Automatiquement

**Projet :** vivelapero  
**ID :** `3d0d2ef7-a811-4a94-859e-8582e5782c4a`  
**Dashboard :** https://railway.app/project/3d0d2ef7-a811-4a94-859e-8582e5782c4a

**Environnements :**
- ✅ Production (ID: `b191a02d-b5f2-4989-81a2-0276de29c9ce`)
- ✅ Staging (ID: `d4dc732a-4f73-4496-845e-075c8a4188ed`)

**Service :**
- ✅ Backend (ID: `6017c981-7c60-4d44-b099-ead04976e38c`)

---

## 📋 Configuration Requise (10 min)

### 1️⃣ Ajouter les Databases (30 sec)

**Dashboard :** https://railway.app/project/3d0d2ef7-a811-4a94-859e-8582e5782c4a

1. Click **"New"** → **"Database"** → **"Add PostgreSQL"**
2. Click **"New"** → **"Database"** → **"Add Redis"**

✅ Railway crée automatiquement les databases dans **les 2 environnements** (staging + production)

---

### 2️⃣ Configurer le Service Backend

#### Settings → General

**Source :**
- Repository : `nivenn-io/vivelapero-shop` ✅ (déjà configuré)
- Branch : `main` ✅ (déjà configuré)
- **Root Directory :** `backend` ⚠️ **À AJOUTER**
- Watch Paths : `backend/**` (optionnel)

**Build :**
- **Build Command :** `npm install && npm run build` ⚠️ **À AJOUTER**
- **Start Command :** `npm run start` ⚠️ **À AJOUTER**

**Deploy :**
- Environment : **Production et Staging** (Railway déploie dans les 2)
- Auto-deploy staging : ✅ ON
- Auto-deploy production : ⚠️ **OFF** (deploy manuel pour prod)

#### Variables d'Environnement

**⚠️ Important :** Railway permet de définir des variables **par environnement**.

**Switch d'environnement :** En haut à droite, selector "production" / "staging"

---

#### Variables STAGING

**Settings → Variables → Switch to "staging"**

**Variables communes :**
```bash
NODE_ENV=staging
PORT=3000
```

**Secrets (générer localement puis copier) :**
```bash
# Exécuter sur ta machine :
JWT_SECRET=$(openssl rand -base64 32)
COOKIE_SECRET=$(openssl rand -base64 32)

# Copier les résultats dans Railway
```

**References databases (copier exactement) :**
```bash
DATABASE_URL=${{Postgres.DATABASE_URL}}
REDIS_URL=${{Redis.REDIS_URL}}
```

**Medusa config :**
```bash
MEDUSA_ADMIN_ONBOARDING_TYPE=default
```

**CORS staging (adapter URLs Vercel après création storefronts) :**
```bash
STORE_CORS=https://vivelapero-storefront-git-staging.vercel.app,https://aperosexy-storefront-git-staging.vercel.app
ADMIN_CORS=https://vivelapero-storefront-git-staging.vercel.app,https://aperosexy-storefront-git-staging.vercel.app
```

**Total : 9 variables pour staging**

---

#### Variables PRODUCTION

**Settings → Variables → Switch to "production"**

**Variables communes :**
```bash
NODE_ENV=production
PORT=3000
```

**Secrets DIFFÉRENTS de staging :**
```bash
# Générer de NOUVEAUX secrets pour production (différents !)
JWT_SECRET=$(openssl rand -base64 32)  # Nouveau !
COOKIE_SECRET=$(openssl rand -base64 32)  # Nouveau !
```

**References databases :**
```bash
DATABASE_URL=${{Postgres.DATABASE_URL}}
REDIS_URL=${{Redis.REDIS_URL}}
```

**Medusa config :**
```bash
MEDUSA_ADMIN_ONBOARDING_TYPE=default
```

**CORS production (domaines finaux) :**
```bash
STORE_CORS=https://vivelapero.fr,https://aperosexy.fr
ADMIN_CORS=https://vivelapero.fr,https://aperosexy.fr
```

**Total : 9 variables pour production**

---

### 3️⃣ Networking & Custom Domain

#### Staging

**Settings → Networking → Switch to "staging"**
- Port : `3000` (auto-détecté)
- Public networking : ✅ ON
- Domain : Railway génère `backend-staging-xxx.up.railway.app`

**Pas de custom domain pour staging**

#### Production

**Settings → Networking → Switch to "production"**
- Port : `3000`
- Public networking : ✅ ON

**Custom Domain :**
1. Click **"Add Custom Domain"**
2. Entrer : `api.vivelapero.fr`
3. Railway affiche un CNAME :
   ```
   api.vivelapero.fr → backend-production-xxx.up.railway.app
   ```
4. **Aller chez ton registrar DNS**
5. Ajouter le CNAME :
   ```
   Type: CNAME
   Name: api
   Target: backend-production-xxx.up.railway.app
   TTL: 3600
   ```
6. Attendre propagation DNS (5-60 min)
7. ✅ Railway auto-configure SSL

---

## 🚀 Déploiement

### Staging (Auto-deploy)

**Trigger :** Push sur `main` → deploy auto staging

```bash
git push origin main
# → Railway build + deploy staging automatiquement
```

**Vérifier :**
- Railway Dashboard → Backend service → Switch "staging" → Deployments

### Production (Manuel)

**Option A : Via Railway Dashboard**
1. Backend service → Switch "production"
2. Deployments → Latest successful staging build
3. Click **"Redeploy to Production"**

**Option B : Via Git Tag**
```bash
git tag v1.0.0
git push origin v1.0.0
# → Déclenche workflow GitHub Actions → deploy production
```

---

## 🧪 Test

### Staging

```bash
# Récupérer URL staging depuis Railway Dashboard
curl https://backend-staging-xxx.up.railway.app/health
# Expected: {"status":"ok"}
```

### Production (après DNS)

```bash
curl https://api.vivelapero.fr/health
# Expected: {"status":"ok"}
```

---

## ✅ Checklist Finale

**Infrastructure :**
- [ ] Projet Railway créé ✅
- [ ] Environnements staging + production ✅
- [ ] Service Backend créé ✅
- [ ] PostgreSQL ajouté (via Dashboard)
- [ ] Redis ajouté (via Dashboard)

**Configuration Backend :**
- [ ] Root Directory : `backend`
- [ ] Build : `npm install && npm run build`
- [ ] Start : `npm run start`
- [ ] Auto-deploy staging : ON
- [ ] Auto-deploy production : OFF

**Variables Staging :**
- [ ] NODE_ENV=staging, PORT=3000
- [ ] JWT_SECRET, COOKIE_SECRET (générés)
- [ ] DATABASE_URL, REDIS_URL (references)
- [ ] MEDUSA_ADMIN_ONBOARDING_TYPE
- [ ] STORE_CORS, ADMIN_CORS

**Variables Production :**
- [ ] NODE_ENV=production, PORT=3000
- [ ] JWT_SECRET, COOKIE_SECRET (DIFFÉRENTS staging)
- [ ] DATABASE_URL, REDIS_URL (references)
- [ ] MEDUSA_ADMIN_ONBOARDING_TYPE
- [ ] STORE_CORS, ADMIN_CORS (domaines production)

**Networking Production :**
- [ ] Custom Domain : api.vivelapero.fr
- [ ] DNS CNAME configuré
- [ ] SSL actif

**Tests :**
- [ ] Staging API responds /health
- [ ] Production API responds /health (après DNS)

---

## 📊 URLs Finales

**Staging :**
- Backend : `https://backend-staging-xxx.up.railway.app`
- Admin : `https://backend-staging-xxx.up.railway.app/app`

**Production :**
- Backend : `https://api.vivelapero.fr`
- Admin : `https://api.vivelapero.fr/app`

---

**Created :** 2026-02-27  
**Structure :** 1 projet Railway, 2 environnements, 3 services chacun  
**Next :** Phase 1 - Backend Medusa init
