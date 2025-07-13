#!/bin/bash

echo "=== Test du Load Balancer NGINX ==="
echo ""

# Test du health check NGINX
echo "1. Test du health check NGINX:"
curl -s http://localhost/health
echo ""
echo ""

# Test de l'API via NGINX - Stock d'un magasin
echo "2. Test de l'API via NGINX (stock magasin 1):"
curl -s http://localhost/api/v1/stores/1/stock | jq '.[0:2]'  # Affiche seulement les 2 premiers stocks
echo ""
echo ""

# Test direct de l'API (pour comparaison)
echo "3. Test direct de l'API (port 8080):"
curl -s http://localhost:8080/api/v1/stores/1/stock | jq '.[0:2]'
echo ""
echo ""

# Test d'un autre magasin
echo "4. Test stock magasin 2 via NGINX:"
curl -s http://localhost/api/v1/stores/2/stock | jq '.[0:2]'
echo ""
echo ""

# Test de l'actuator health via NGINX
echo "5. Test actuator health via NGINX:"
curl -s http://localhost/actuator/health | jq .
echo ""
echo ""

echo "=== Test terminé ==="