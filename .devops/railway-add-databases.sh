#!/bin/bash
set -e

# Configuration
PROJECT_ID="3d0d2ef7-a811-4a94-859e-8582e5782c4a"
TOKEN="916990d4-6f79-40ec-9e56-1a68a3bb4a43"

echo "🚂 Railway - Ajout PostgreSQL et Redis"
echo "======================================="
echo ""

echo "⚠️  Les plugins managés (PostgreSQL, Redis) doivent être créés via Dashboard Railway."
echo ""
echo "📍 Dashboard projet : https://railway.app/project/$PROJECT_ID"
echo ""

echo "Instructions :"
echo ""
echo "1️⃣  Click 'New' → 'Database' → 'Add PostgreSQL'"
echo "2️⃣  Click 'New' → 'Database' → 'Add Redis'"
echo ""
echo "✅ Railway auto-configure les databases dans TOUS les environnements (staging + production)"
echo ""
echo "Les variables seront disponibles automatiquement :"
echo "  - DATABASE_URL"
echo "  - REDIS_URL"
echo ""
echo "Temps estimé : 30 secondes"
echo ""
