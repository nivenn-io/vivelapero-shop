#!/bin/bash
set -e

# Backup Railway production database
# Requires Railway CLI authenticated and project linked

BACKUP_DIR="./backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/vivelapero_prod_${TIMESTAMP}.sql"

echo "💾 Backing up Railway production database..."

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Check if Railway CLI is available
if ! command -v railway &> /dev/null; then
  echo "❌ Railway CLI not found. Install it first:"
  echo "   npm install -g @railway/cli"
  exit 1
fi

# Get database URL from Railway
echo "🔍 Fetching database credentials from Railway..."
DATABASE_URL=$(railway variables --json | jq -r '.DATABASE_URL')

if [ -z "$DATABASE_URL" ] || [ "$DATABASE_URL" == "null" ]; then
  echo "❌ Could not fetch DATABASE_URL from Railway."
  echo "   Make sure you're linked to the correct project:"
  echo "   railway link"
  exit 1
fi

# Extract connection details
DB_HOST=$(echo "$DATABASE_URL" | sed -E 's/.*@([^:]+):.*/\1/')
DB_PORT=$(echo "$DATABASE_URL" | sed -E 's/.*:([0-9]+)\/.*/\1/')
DB_NAME=$(echo "$DATABASE_URL" | sed -E 's/.*\/([^?]+).*/\1/')
DB_USER=$(echo "$DATABASE_URL" | sed -E 's/.*:\/\/([^:]+):.*/\1/')
DB_PASS=$(echo "$DATABASE_URL" | sed -E 's/.*:\/\/[^:]+:([^@]+)@.*/\1/')

# Perform backup
echo "📦 Creating backup: $BACKUP_FILE"
PGPASSWORD="$DB_PASS" pg_dump \
  -h "$DB_HOST" \
  -p "$DB_PORT" \
  -U "$DB_USER" \
  -d "$DB_NAME" \
  -F c \
  -f "$BACKUP_FILE"

# Compress backup
echo "🗜️  Compressing backup..."
gzip "$BACKUP_FILE"

echo "✅ Backup created: ${BACKUP_FILE}.gz"
echo ""
echo "💡 To restore:"
echo "   gunzip ${BACKUP_FILE}.gz"
echo "   PGPASSWORD=\$DB_PASS pg_restore -h \$DB_HOST -p \$DB_PORT -U \$DB_USER -d \$DB_NAME -c $BACKUP_FILE"
