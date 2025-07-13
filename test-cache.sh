#!/bin/bash

echo "=== Test de performance avec cache Redis ==="

# Démarrer les services
echo "1. Démarrage des services..."
docker-compose up -d db redis api1 prometheus grafana

# Attendre que les services soient prêts
echo "2. Attente du démarrage des services..."
sleep 30

# Test sans cache (première requête)
echo "3. Test sans cache (première requête)..."
curl -w "Temps: %{time_total}s\n" -o /dev/null -s http://localhost:8080/api/v1/stores/1/stock

# Test avec cache (requêtes suivantes)
echo "4. Test avec cache (requêtes suivantes)..."
for i in {1..5}; do
    echo "Requête $i:"
    curl -w "Temps: %{time_total}s\n" -o /dev/null -s http://localhost:8080/api/v1/stores/1/stock
done

# Test de charge avec k6
echo "5. Test de charge avec k6..."
k6 run load-tests/load-balancer-test.js

echo "=== Test terminé ===" 