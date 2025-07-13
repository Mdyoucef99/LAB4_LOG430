#!/bin/bash

echo "=== Tests de charge avec différentes configurations d'instances ==="
echo ""

# Fonction pour tester une configuration
test_configuration() {
    local instances=$1
    local strategy=$2
    local test_name="test_${instances}_instances_${strategy}"
    
    echo " Test: $instances instances avec stratégie $strategy"
    echo "=================================================="
    
    # Copier la configuration NGINX appropriée
    cp monitoring/nginx/${strategy}.conf monitoring/nginx/nginx.conf
    
    # Redémarrer NGINX
    docker-compose restart nginx
    sleep 5
    
    # Attendre que tous les services soient prêts
    echo " Attente que les services soient prêts..."
    sleep 10
    
    # Lancer le test de charge
    echo " Lancement du test de charge..."
    k6 run \
        --env BASE_URL=http://localhost \
        --env ENDPOINT=/api/v1/stores/1/stock \
        --out json=results/${test_name}.json \
        load-tests/load-balancer-test.js
    
    echo " Test terminé pour $instances instances ($strategy)"
    echo ""
}

# Créer le dossier de résultats
mkdir -p results

# Tests avec différentes configurations
echo " Configuration 1: 1 instance (Round Robin)"
test_configuration 1 "round-robin"

echo " Configuration 2: 2 instances (Round Robin)"
test_configuration 2 "round-robin"

echo " Configuration 3: 3 instances (Round Robin)"
test_configuration 3 "round-robin"

echo " Configuration 4: 4 instances (Round Robin)"
test_configuration 4 "round-robin"

echo " Configuration 5: 4 instances (Least Connections)"
test_configuration 4 "least-connections"

echo " Configuration 6: 4 instances (IP Hash)"
test_configuration 4 "ip-hash"

echo " Tous les tests sont terminés !"
echo " Résultats disponibles dans le dossier 'results/'" 