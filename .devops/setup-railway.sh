#!/bin/bash
set -e

echo "🚂 Railway Setup Script for Vive l'Apéro Shop"
echo "=============================================="
echo ""

# Check Railway CLI
if ! command -v railway &> /dev/null; then
  echo "❌ Railway CLI not found."
  echo ""
  echo "Install it with:"
  echo "   npm install -g @railway/cli"
  echo ""
  exit 1
fi

# Check authentication
echo "🔐 Checking Railway authentication..."
if ! railway whoami &> /dev/null; then
  echo "❌ Not authenticated with Railway."
  echo ""
  echo "Authenticate with:"
  echo "   railway login"
  echo ""
  echo "Or set RAILWAY_TOKEN environment variable (for CI/CD):"
  echo "   export RAILWAY_TOKEN=your_token_here"
  echo ""
  exit 1
fi

echo "✅ Authenticated as: $(railway whoami)"
echo ""

# Ask for environment
echo "Which environment do you want to setup?"
echo "  1) Staging"
echo "  2) Production"
read -p "Enter choice (1 or 2): " choice

case $choice in
  1)
    ENV="staging"
    ;;
  2)
    ENV="production"
    ;;
  *)
    echo "❌ Invalid choice"
    exit 1
    ;;
esac

echo ""
echo "🎯 Setting up $ENV environment..."
echo ""

# Generate secrets
JWT_SECRET=$(openssl rand -base64 64)
COOKIE_SECRET=$(openssl rand -base64 64)
ADMIN_PASSWORD=$(openssl rand -base64 32)

echo "🔑 Generated secrets for $ENV"
echo ""

# Link to project (manual step - user must do this first)
echo "📋 Before continuing, make sure you have:"
echo "   1. Created a Railway project for $ENV"
echo "   2. Added PostgreSQL and Redis services"
echo "   3. Linked this repo: railway link"
echo ""
read -p "Have you completed these steps? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "❌ Please complete Railway project setup first."
  echo ""
  echo "Steps:"
  echo "   1. Go to https://railway.app"
  echo "   2. Create new project: 'vivelapero-$ENV'"
  echo "   3. Add PostgreSQL service"
  echo "   4. Add Redis service"
  echo "   5. Add this repo as service"
  echo "   6. Run: railway link"
  echo ""
  exit 1
fi

# Set environment variables
echo "⚙️  Setting environment variables..."

railway variables set NODE_ENV=$([[ "$ENV" == "production" ]] && echo "production" || echo "staging")
railway variables set JWT_SECRET="$JWT_SECRET"
railway variables set COOKIE_SECRET="$COOKIE_SECRET"
railway variables set MEDUSA_ADMIN_ONBOARDING_TYPE="default"
railway variables set STORE_CORS="https://vivelapero.fr,https://aperosexy.fr"
railway variables set ADMIN_CORS="https://api.vivelapero.fr"

echo "✅ Environment variables set!"
echo ""

# Display next steps
echo "📋 Next steps:"
echo ""
echo "1. Verify services are running:"
echo "   railway status"
echo ""
echo "2. Check logs:"
echo "   railway logs"
echo ""
echo "3. Add custom domain (if production):"
echo "   - Go to Railway dashboard"
echo "   - Select backend service"
echo "   - Add domain: api.vivelapero.fr"
echo ""
echo "4. Configure GitHub secrets for CI/CD:"
echo "   RAILWAY_TOKEN=$RAILWAY_TOKEN"
echo ""
echo "5. Run migrations:"
echo "   railway run npm run migrate"
echo ""
echo "✅ Setup complete!"
