#!/bin/bash
set -e

echo "⚠️  WARNING: This will delete all database data!"
read -p "Are you sure? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "❌ Aborted."
  exit 1
fi

echo "🗑️  Stopping services..."
docker-compose down

echo "🗑️  Removing database volume..."
docker volume rm vivelapero-shop_postgres_data 2>/dev/null || true

echo "🚀 Starting services..."
docker-compose up -d postgres redis

echo "⏳ Waiting for PostgreSQL to be ready..."
sleep 5

echo "🌱 Running Medusa migrations and seed..."
docker-compose up -d medusa
docker-compose exec medusa npm run migrate
docker-compose exec medusa npm run seed || echo "⚠️  No seed script found (optional)"

echo "✅ Database reset complete!"
