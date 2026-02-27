# Railway - Fix PostgreSQL & Redis

Les services PostgreSQL et Redis créés via API étaient incorrects (Docker custom au lieu de plugins managés).

**Status :** Services incorrects supprimés ✅

**Action requise :** Créer les plugins managés via Dashboard (2 min par environnement)

---

## ✅ Staging Environment

**Dashboard :** https://railway.app/project/7d85fbb5-4693-459a-bb97-27b4b02d1375

### Étapes :

1. **Ajouter PostgreSQL**
   - Click **"New"** → **"Database"** → **"Add PostgreSQL"**
   - ✅ Aucune config nécessaire (Railway auto-configure tout)
   - ✅ Variable `DATABASE_URL` exposée automatiquement

2. **Ajouter Redis**
   - Click **"New"** → **"Database"** → **"Add Redis"**
   - ✅ Aucune config nécessaire
   - ✅ Variable `REDIS_URL` exposée automatiquement

3. **Vérifier Backend service**
   - Le service Backend existe déjà (ID: `fcf1530f-2558-4390-8255-1159b4285eb1`)
   - Configurer comme dans `.devops/railway-config-guide.md`

---

## ✅ Production Environment

**Dashboard :** https://railway.app/project/ccde0103-65c6-4537-a8db-051bb0b96abb

### Étapes :

1. **Ajouter PostgreSQL**
   - Click **"New"** → **"Database"** → **"Add PostgreSQL"**
   - ✅ Auto-configuré

2. **Ajouter Redis**
   - Click **"New"** → **"Database"** → **"Add Redis"**
   - ✅ Auto-configuré

3. **Vérifier Backend service**
   - Le service Backend existe déjà (ID: `4543113d-28f2-4912-9823-13ec56642f37`)
   - Configurer comme dans `.devops/railway-config-guide.md`

---

## 🔗 Variables Automatiques

Une fois les plugins créés, Railway expose automatiquement :

```bash
# PostgreSQL
DATABASE_URL=postgresql://postgres:xxxxx@postgres.railway.internal:5432/railway
PGHOST=postgres.railway.internal
PGPORT=5432
PGUSER=postgres
PGPASSWORD=xxxxx
PGDATABASE=railway

# Redis
REDIS_URL=redis://default:xxxxx@redis.railway.internal:6379
REDIS_HOST=redis.railway.internal
REDIS_PORT=6379
REDIS_PASSWORD=xxxxx
```

**Dans le Backend service**, référence-les avec :
```bash
DATABASE_URL=${{Postgres.DATABASE_URL}}
REDIS_URL=${{Redis.REDIS_URL}}
```

---

## ⏱️ Temps Total

- Staging : 2 clics (PostgreSQL + Redis)
- Production : 2 clics (PostgreSQL + Redis)
- **Total : ~1 minute**

---

## ✅ Après Création

Une fois les plugins créés, continuer avec :
1. Configuration Backend service (`.devops/railway-config-guide.md`)
2. GitHub Secrets (`.github/SECRETS-CHECKLIST.md`)
3. Test deployment

---

**Created :** 2026-02-27  
**Reason :** API GraphQL Railway pour plugins managés non documentée publiquement  
**Solution :** Dashboard (plus rapide et sûr)
