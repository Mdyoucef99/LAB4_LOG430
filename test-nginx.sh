#!/bin/bash

echo "=== Test du Load Balancer NGINX ==="
echo ""

# Test du health check NGINX
echo "1. Test du health check NGINX:"
curl -s http://localhost/health
echo ""
echo ""

# Test de l'API via NGINX
echo "2. Test de l'API via NGINX:"
curl -s http://localhost/api/stores | jq '.[0:2]'  # Affiche seulement les 2 premiers magasins
echo ""
echo ""

# Test direct de l'API (pour comparaison)
echo "3. Test direct de l'API (port 8080):"
curl -s http://localhost:8080/api/stores | jq '.[0:2]'
echo ""
echo ""

echo "=== Test terminé ==="