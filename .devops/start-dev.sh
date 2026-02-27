#!/bin/bash
set -e

echo "🚀 Starting Vive l'Apéro development environment..."

# Check if .env exists, if not create from example
if [ ! -f .env ]; then
  echo "⚠️  No .env file found. Creating from .env.example..."
  if [ -f .env.example ]; then
    cp .env.example .env
    echo "✅ .env created. Please update with your credentials."
  else
    echo "❌ No .env.example found. Creating minimal .env..."
    cat > .env << EOF
# Database
POSTGRES_PASSWORD=$(openssl rand -base64 32)

# Medusa
JWT_SECRET=$(openssl rand -base64 32)
COOKIE_SECRET=$(openssl rand -base64 32)
EOF
    echo "✅ Minimal .env created with random secrets."
  fi
fi

# Start Docker Compose
echo "🐳 Starting Docker Compose services..."
docker-compose up -d

# Wait for services to be healthy
echo "⏳ Waiting for services to be ready..."
sleep 5

# Check health
echo "🏥 Checking service health..."
docker-compose ps

# Show logs
echo ""
echo "📋 Service URLs:"
echo "   - Medusa API: http://localhost:9000"
echo "   - Medusa Admin: http://localhost:7001"
echo "   - PostgreSQL: localhost:5432"
echo "   - Redis: localhost:6379"
echo ""
echo "📝 To view logs: docker-compose logs -f [service]"
echo "📝 To stop: ./devops/stop-dev.sh"
echo ""
echo "✅ Development environment started!"
