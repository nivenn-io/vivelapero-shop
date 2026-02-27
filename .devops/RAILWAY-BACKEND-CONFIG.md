# Railway Backend Configuration

Databases créées ✅ Maintenant configurer les services Backend.

**Temps estimé :** 5 minutes par environnement

---

## ✅ Services Détectés

### Staging (vivelapero-staging)
**Dashboard :** https://railway.app/project/7d85fbb5-4693-459a-bb97-27b4b02d1375

- PostgreSQL ✅ (ID: `87de2c4a-2131-4b3f-b84d-0ddc1f5b8b1f`)
- Redis ✅ (ID: `c2894e5f-c6a5-4c6a-9077-6d1e183123f3`)
- Backend ⏳ (ID: `fcf1530f-2558-4390-8255-1159b4285eb1`) — À configurer

### Production (vivelapero-production)
**Dashboard :** https://railway.app/project/ccde0103-65c6-4537-a8db-051bb0b96abb

- PostgreSQL ✅ (ID: `4bcd575b-d93b-484a-add5-7c8ea84331c8`)
- Redis ✅ (ID: `a0107eea-63a4-40bc-8a21-4bb3f8560448`)
- Backend ⏳ (ID: `4543113d-28f2-4912-9823-13ec56642f37`) — À configurer

---

## 📝 Configuration Backend Staging

**Dashboard :** https://railway.app/project/7d85fbb5-4693-459a-bb97-27b4b02d1375

### 1. Settings → General

Click sur le service **"Backend"** → **Settings** :

**Source :**
- ✅ Repository : nivenn-io/vivelapero-shop (déjà configuré)
- ✅ Branch : main (déjà configuré)
- **Root Directory :** `backend` ⚠️ **À AJOUTER**
- **Watch Paths :** `backend/**` (optionnel)

**Build :**
- **Build Command :** `npm install && npm run build` ⚠️ **À AJOUTER**
- **Start Command :** `npm run start` ⚠️ **À AJOUTER**

**Deploy :**
- Auto-deploy : ✅ ON (déjà configuré normalement)

**Cliquer "Update" après chaque modification.**

### 2. Variables d'environnement

**Settings → Variables** :

Ajouter ces variables (click **"New Variable"** pour chacune) :

```bash
NODE_ENV=staging
PORT=3000
```

**Secrets à générer** (exécuter localement puis copier) :
```bash
# Sur ta machine ou VPS
JWT_SECRET=$(openssl rand -base64 32)
COOKIE_SECRET=$(openssl rand -base64 32)

# Copier les résultats dans Railway
```

**References Railway** (copier exactement comme ça) :
```bash
DATABASE_URL=${{Postgres.DATABASE_URL}}
REDIS_URL=${{Redis.REDIS_URL}}
```

**Medusa config :**
```bash
MEDUSA_ADMIN_ONBOARDING_TYPE=default
```

**CORS** (adapter les URLs Vercel si besoin) :
```bash
STORE_CORS=https://vivelapero-storefront.vercel.app,https://aperosexy-storefront.vercel.app
ADMIN_CORS=https://vivelapero-storefront.vercel.app,https://aperosexy-storefront.vercel.app
```

**Total variables Staging Backend : 9**

### 3. Networking

**Settings → Networking** :

- ✅ Port : `3000` (auto-détecté normalement)
- Public networking : ✅ ON
- Domain : Railway va générer `backend-production-xxx.up.railway.app`

**Pas de custom domain pour staging** (optionnel)

---

## 📝 Configuration Backend Production

**Dashboard :** https://railway.app/project/ccde0103-65c6-4537-a8db-051bb0b96abb

### 1. Settings → General

Idem staging :

- **Root Directory :** `backend`
- **Build Command :** `npm install && npm run build`
- **Start Command :** `npm run start`
- Auto-deploy : ⚠️ **OFF** (deploy manuel pour production)

### 2. Variables d'environnement

**Idem staging MAIS avec des secrets DIFFÉRENTS :**

```bash
NODE_ENV=production
PORT=3000
```

**Secrets DIFFÉRENTS de staging :**
```bash
# Générer de NOUVEAUX secrets pour production
JWT_SECRET=$(openssl rand -base64 32)  # Nouveau !
COOKIE_SECRET=$(openssl rand -base64 32)  # Nouveau !
```

**References Railway :**
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

**Total variables Production Backend : 9**

### 3. Networking + Custom Domain

**Settings → Networking** :

- Port : `3000`
- Public networking : ✅ ON

**Custom Domain :**
1. Click **"Generate Domain"** (Railway auto-domain)
2. Click **"Add Custom Domain"**
3. Entrer : `api.vivelapero.fr`
4. Railway affiche un **CNAME** :
   ```
   api.vivelapero.fr → <service-id>.up.railway.app
   ```
5. **Aller chez ton registrar DNS** (OVH/Cloudflare/autre)
6. Ajouter le CNAME :
   ```
   Type: CNAME
   Name: api
   Target: <service-id>.up.railway.app
   TTL: 3600
   ```
7. Attendre propagation DNS (5-60 min)
8. ✅ Railway auto-configure SSL (Let's Encrypt)

---

## 🧪 Test de Configuration

### 1. Vérifier que les services running

**Staging :**
- PostgreSQL : Status "Running" ✅
- Redis : Status "Running" ✅
- Backend : Status "Building..." puis "Running" ✅

**Production :**
- Idem (Backend peut être "Waiting" si auto-deploy OFF)

### 2. Vérifier les logs Backend

**Backend service → Deployments → Latest → Logs**

Chercher :
```
✅ "Server is ready on port 3000"
✅ "Database connection established"
✅ pas d'erreur "DATABASE_URL not found"
✅ pas d'erreur "REDIS_URL not found"
```

### 3. Tester l'API

**Staging Backend URL** (noter l'URL Railway générée) :
```bash
curl https://backend-production-xxx.up.railway.app/health
# Expected: {"status":"ok"}
```

**Production (après DNS propagation) :**
```bash
curl https://api.vivelapero.fr/health
# Expected: {"status":"ok"}
```

---

## ✅ Checklist Complète

### Staging Backend
- [ ] Root Directory : `backend`
- [ ] Build Command : `npm install && npm run build`
- [ ] Start Command : `npm run start`
- [ ] Variables : NODE_ENV, PORT, JWT_SECRET, COOKIE_SECRET
- [ ] Variables : DATABASE_URL, REDIS_URL
- [ ] Variables : MEDUSA_ADMIN_ONBOARDING_TYPE
- [ ] Variables : STORE_CORS, ADMIN_CORS
- [ ] Auto-deploy : ON
- [ ] Service running ✅
- [ ] API responds to /health

### Production Backend
- [ ] Root Directory : `backend`
- [ ] Build Command : `npm install && npm run build`
- [ ] Start Command : `npm run start`
- [ ] Variables : NODE_ENV=production, PORT
- [ ] Variables : JWT_SECRET (DIFFÉRENT staging), COOKIE_SECRET (DIFFÉRENT staging)
- [ ] Variables : DATABASE_URL, REDIS_URL
- [ ] Variables : MEDUSA_ADMIN_ONBOARDING_TYPE
- [ ] Variables : STORE_CORS, ADMIN_CORS (domaines production)
- [ ] Auto-deploy : OFF
- [ ] Custom Domain : api.vivelapero.fr configuré
- [ ] DNS CNAME ajouté
- [ ] SSL actif (Let's Encrypt)
- [ ] Service running ✅
- [ ] API responds to https://api.vivelapero.fr/health

---

## 🔧 Troubleshooting

### Backend ne build pas

**Erreur :** `Cannot find package.json`
- ✅ Vérifier **Root Directory** = `backend` (pas `/backend`, pas `backend/`)

**Erreur :** `npm: command not found`
- Railway détecte auto Node.js via package.json dans root directory
- Vérifier que `backend/package.json` existe dans le repo GitHub

### DATABASE_URL not found

**Erreur dans logs :** `DATABASE_URL is not defined`
- ✅ Vérifier variable : `DATABASE_URL=${{Postgres.DATABASE_URL}}`
- ✅ Vérifier que PostgreSQL service running
- ✅ Vérifier nom exact du service : "Postgres" (case-sensitive)

### CORS errors

**Erreur browser :** `CORS policy: No 'Access-Control-Allow-Origin'`
- ✅ Vérifier `STORE_CORS` inclut l'URL Vercel exacte
- Format : `https://domain1.com,https://domain2.com` (pas d'espace)
- ✅ Redéployer backend après changement CORS

### Custom domain ne fonctionne pas

**SSL error ou domain not found**
- ✅ Vérifier DNS propagation : `dig api.vivelapero.fr`
- ✅ Attendre jusqu'à 60 min pour propagation DNS
- ✅ Vérifier CNAME pointe vers Railway URL exacte
- Railway auto-configure SSL après DNS OK

---

## 📊 URLs Finales

Une fois tout configuré :

**Staging :**
- Backend API : `https://backend-production-xxx.up.railway.app`
- PostgreSQL : Internal (via `${{Postgres.DATABASE_URL}}`)
- Redis : Internal (via `${{Redis.REDIS_URL}}`)

**Production :**
- Backend API : `https://api.vivelapero.fr`
- PostgreSQL : Internal
- Redis : Internal

---

**Created :** 2026-02-27  
**Next :** GitHub Secrets configuration → `.github/SECRETS-CHECKLIST.md`
