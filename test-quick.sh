#!/bin/bash

echo "🧪 Test rapide du système de monitoring"

# 1. Vérifier que les services sont démarrés
echo "1. Vérification des services..."
services=("api:8080" "prometheus:9090" "grafana:3000")

for service in "${services[@]}"; do
    host=$(echo $service | cut -d: -f1)
    port=$(echo $service | cut -d: -f2)
    
    if curl -s http://localhost:$port > /dev/null 2>&1; then
        echo "   ✅ $host:$port - OK"
    else
        echo "   ❌ $host:$port - Non accessible"
    fi
done

# 2. Tester l'endpoint Prometheus
echo ""
echo "2. Test de l'endpoint Prometheus..."
if curl -s http://localhost:8080/actuator/prometheus | grep -q "http_server_requests_seconds"; then
    echo "   ✅ Métriques Prometheus disponibles"
else
    echo "   ❌ Métriques Prometheus non trouvées"
fi

# 3. Test simple de charge
echo ""
echo "3. Test de charge simple (30 secondes)..."
k6 run --duration 30s --vus 5 stock-consultation.js

echo ""
echo "�� Test terminé! Consultez Grafana pour voir les métriques." 