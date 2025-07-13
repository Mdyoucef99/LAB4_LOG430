#!/bin/bash

echo "=== Test de performance avec cache Redis ==="

# Démarrer les services
echo "1. Démarrage des services..."
docker-compose up -d db redis api1 prometheus grafana

# Attendre que les services soient prêts
echo "2. Attente du démarrage des services..."
sleep 30

# Test des endpoints avec cache
echo "3. Test des endpoints avec cache..."

echo "Stock consultation (magasin 1):"
for i in {1..3}; do
    echo "Requête $i:"
    curl -w "Temps: %{time_total}s\n" -o /dev/null -s http://localhost:8080/api/v1/stores/1/stock
done

echo ""
echo "Reports generation:"
for i in {1..3}; do
    echo "Requête $i:"
    curl -w "Temps: %{time_total}s\n" -o /dev/null -s http://localhost:8080/api/v1/reports/sales
done

echo ""
echo "Product consultation (produit 1):"
for i in {1..3}; do
    echo "Requête $i:"
    curl -w "Temps: %{time_total}s\n" -o /dev/null -s http://localhost:8080/api/v1/products/1
done

echo ""
echo "Product consultation (produit 2):"
for i in {1..3}; do
    echo "Requête $i:"
    curl -w "Temps: %{time_total}s\n" -o /dev/null -s http://localhost:8080/api/v1/products/2
done

echo ""
echo "Product consultation (produit 3):"
for i in {1..3}; do
    echo "Requête $i:"
    curl -w "Temps: %{time_total}s\n" -o /dev/null -s http://localhost:8080/api/v1/products/3
done

# Test de charge avec k6
echo ""
echo "4. Test de charge avec k6..."
k6 run load-tests/load-balancer-test.js

echo "=== Test terminé ==="
echo "Consultez le dashboard: http://localhost:3000" 