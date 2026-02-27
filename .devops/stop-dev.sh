#!/bin/bash
set -e

echo "🛑 Stopping Vive l'Apéro development environment..."

docker-compose down

echo "✅ Development environment stopped."
echo ""
echo "💡 To remove volumes (⚠️  this will delete all data):"
echo "   docker-compose down -v"
