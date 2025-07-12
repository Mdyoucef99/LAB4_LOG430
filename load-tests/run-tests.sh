#!/bin/bash

echo "🚀 Démarrage des tests de charge pour LAB4..."

# Vérifier que k6 est installé
if ! command -v k6 &> /dev/null; then
    echo "❌ k6 n'est pas installé. Veuillez l'installer depuis https://k6.io/docs/getting-started/installation/"
    exit 1
fi

# Vérifier que l'API est accessible
echo "�� Vérification de l'API..."
if ! curl -s http://localhost:8080/actuator/health > /dev/null; then
    echo "❌ L'API n'est pas accessible sur http://localhost:8080"
    echo "   Assurez-vous que docker-compose up -d a été lancé"
    exit 1
fi

echo "✅ API accessible"

echo ""
echo "📊 Test 1: Consultation des stocks (2 minutes)"
k6 run stock-consultation.js

echo ""
echo "�� Test 2: Génération de rapports (5 minutes)"
k6 run reports-generation.js

echo ""
echo "🔄 Test 3: Mise à jour de produits (5 minutes)"
k6 run product-updates.js

echo ""
echo "💥 Test 4: Test de stress (10 minutes)"
k6 run stress-test.js

echo ""
echo "✅ Tous les tests sont terminés!"
echo ""
echo "📊 Consultez les métriques sur:"
echo "   - Grafana: http://localhost:3000 (admin/admin)"
echo "   - Prometheus: http://localhost:9090"
echo "   - API Health: http://localhost:8080/actuator/health" 