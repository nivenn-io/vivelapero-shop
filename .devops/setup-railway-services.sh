#!/bin/bash
set -e

echo "🚂 Railway Services Setup"
echo "========================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Project IDs
STAGING_ID="7d85fbb5-4693-459a-bb97-27b4b02d1375"
PROD_ID="ccde0103-65c6-4537-a8db-051bb0b96abb"

echo "Projects créés :"
echo "  - Staging: $STAGING_ID"
echo "  - Production: $PROD_ID"
echo ""

echo -e "${BLUE}📋 Prochaines étapes (via Railway Dashboard) :${NC}"
echo ""

echo -e "${GREEN}1️⃣  Staging (vivelapero-staging)${NC}"
echo "   https://railway.app/project/$STAGING_ID"
echo ""
echo "   Ajouter 3 services :"
echo "   ┌─ PostgreSQL"
echo "   │  └─ Version: 16"
echo "   ├─ Redis"
echo "   │  └─ Version: 7"
echo "   └─ Backend (GitHub)"
echo "      ├─ Repo: nivenn-io/vivelapero-shop"
echo "      ├─ Branch: main"
echo "      ├─ Root directory: backend"
echo "      ├─ Build command: npm install && npm run build"
echo "      └─ Start command: npm run start"
echo ""

echo -e "${GREEN}2️⃣  Production (vivelapero-production)${NC}"
echo "   https://railway.app/project/$PROD_ID"
echo ""
echo "   Idem staging + domaine custom :"
echo "   ┌─ PostgreSQL (version 16)"
echo "   ├─ Redis (version 7)"
echo "   └─ Backend (GitHub)"
echo "      ├─ ... (idem staging)"
echo "      └─ Custom domain: api.vivelapero.fr"
echo ""

echo -e "${BLUE}📝 Environment Variables (à ajouter dans chaque Backend)${NC}"
echo ""
echo "Staging :"
cat << 'EOF'
NODE_ENV=staging
PORT=3000
JWT_SECRET=$(openssl rand -base64 32)
COOKIE_SECRET=$(openssl rand -base64 32)
DATABASE_URL=${{Postgres.DATABASE_URL}}
REDIS_URL=${{Redis.REDIS_URL}}
MEDUSA_ADMIN_ONBOARDING_TYPE=default
STORE_CORS=https://vivelapero.vercel.app,https://aperosexy.vercel.app
ADMIN_CORS=https://vivelapero.vercel.app,https://aperosexy.vercel.app
EOF
echo ""

echo "Production :"
cat << 'EOF'
NODE_ENV=production
PORT=3000
JWT_SECRET=$(openssl rand -base64 32)
COOKIE_SECRET=$(openssl rand -base64 32)
DATABASE_URL=${{Postgres.DATABASE_URL}}
REDIS_URL=${{Redis.REDIS_URL}}
MEDUSA_ADMIN_ONBOARDING_TYPE=default
STORE_CORS=https://vivelapero.fr,https://aperosexy.fr
ADMIN_CORS=https://vivelapero.fr,https://aperosexy.fr
EOF
echo ""

echo -e "${GREEN}✅ Une fois les services créés :${NC}"
echo "   1. Noter les URLs des backends Railway"
echo "   2. Configurer GitHub Secrets (voir .github/SECRETS-CHECKLIST.md)"
echo "   3. Push vers main → déploiement auto staging"
echo ""
