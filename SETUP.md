# Setup - Railway Infrastructure

## ✅ Configured Automatically

- **Railway project:** vivelapero (`3d0d2ef7-a811-4a94-859e-8582e5782c4a`)
- **Environments:** production + staging  
- **Service Backend:** Created + 7/9 variables configured per environment

**Dashboard:** https://railway.app/project/3d0d2ef7-a811-4a94-859e-8582e5782c4a

---

## 🔧 Manual Actions (2 min)

### 1. Add Databases (30 sec)

Click **"New"** → **"Database"** → **"Add PostgreSQL"**  
Click **"New"** → **"Database"** → **"Add Redis"**

### 2. Configure Backend Build (90 sec)

Click **Backend** → **Settings** → **Source**

Set:
- **Root Directory:** `backend`
- **Build Command:** `npm install && npm run build`
- **Start Command:** `npm run start`

Click **Update**

### 3. Add DB Variables (30 sec)

**Settings** → **Variables**

**Staging:**
```
DATABASE_URL=${{Postgres.DATABASE_URL}}
REDIS_URL=${{Redis.REDIS_URL}}
```

**Production:** Same

---

## Next: Phase 1 Backend Medusa Init

After Railway setup complete, init Medusa backend code.
