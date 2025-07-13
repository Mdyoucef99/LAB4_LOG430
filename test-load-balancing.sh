#!/bin/bash

echo "=== Test de distribution du Load Balancer ==="
echo ""

# Test de base du load balancer
echo "1. Test du health check NGINX:"
curl -s http://localhost/health
echo ""
echo ""

# Test de distribution des requêtes
echo "2. Test de distribution (10 requêtes):"
echo "======================================"
for i in {1..10}; do
    echo "Requête $i:"
    # Récupérer l'instance qui répond (via les headers ou logs)
    response=$(curl -s -w "HTTP_CODE:%{http_code}\nTIME:%{time_total}\n" http://localhost/api/v1/stores/1/stock -o /dev/null)
    echo "$response"
    sleep 0.5
done
echo ""

# Test de performance rapide
echo "3. Test de performance (5 secondes):"
echo "===================================="
echo "Début du test: $(date)"
timeout 5s bash -c 'while true; do curl -s http://localhost/api/v1/stores/1/stock > /dev/null; done' &
echo "Fin du test: $(date)"
echo ""

# Vérifier les instances individuelles
echo "4. Vérification des instances individuelles:"
echo "============================================"
echo "Instance 1 (port 8080):"
curl -s http://localhost:8080/api/v1/stores/1/stock | jq '.[0:1]' | head -5
echo ""

echo "Instance 2 (port 8081):"
curl -s http://localhost:8081/api/v1/stores/1/stock | jq '.[0:1]' | head -5
echo ""

echo "Instance 3 (port 8082):"
curl -s http://localhost:8082/api/v1/stores/1/stock | jq '.[0:1]' | head -5
echo ""

echo "Instance 4 (port 8083):"
curl -s http://localhost:8083/api/v1/stores/1/stock | jq '.[0:1]' | head -5
echo ""

echo "=== Test terminé ==="
echo ""
echo "💡 Pour voir la distribution en temps réel, va sur:"
echo "   Grafana: http://localhost:3000 (admin/admin)"
echo "   Dashboard: Load Balancer - Performance Comparison" 