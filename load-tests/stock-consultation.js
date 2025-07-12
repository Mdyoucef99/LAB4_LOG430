import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '2m', target: 10 }, // Montée en charge
    { duration: '5m', target: 10 }, // Charge constante
    { duration: '2m', target: 0 },  // Décharge
  ],
  thresholds: {
    http_req_duration: ['p(95)<2000'], // 95% des requêtes < 2s
    http_req_failed: ['rate<0.1'],     // Taux d'erreur < 10%
  },
};

export default function () {
  // Consultation des stocks de plusieurs magasins
  const storeIds = [1, 2, 3, 4, 5];
  const randomStoreId = storeIds[Math.floor(Math.random() * storeIds.length)];
  
  const response = http.get(`http://localhost:8080/api/v1/stores/${randomStoreId}/stock`);
  
  check(response, {
    'status is 200': (r) => r.status === 200,
    'response time < 2000ms': (r) => r.timings.duration < 2000,
  });
  
  sleep(1);
}
```

```javascript:load-tests/reports-generation.js
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '1m', target: 5 },
    { duration: '3m', target: 5 },
    { duration: '1m', target: 0 },
  ],
  thresholds: {
    http_req_duration: ['p(95)<5000'], // Rapports plus lents
    http_req_failed: ['rate<0.1'],
  },
};

export default function () {
  // Génération de rapports consolidés
  const response = http.get('http://localhost:8080/api/v1/reports/sales');
  
  check(response, {
    'status is 200': (r) => r.status === 200,
    'response time < 5000ms': (r) => r.timings.duration < 5000,
  });
  
  sleep(2);
}
```

```javascript:load-tests/product-updates.js
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '1m', target: 20 },
    { duration: '3m', target: 20 },
    { duration: '1m', target: 0 },
  ],
  thresholds: {
    http_req_duration: ['p(95)<1000'],
    http_req_failed: ['rate<0.1'],
  },
};

export default function () {
  // Mise à jour de produits à forte fréquence
  const productId = Math.floor(Math.random() * 100) + 1;
  const payload = JSON.stringify({
    nom: `Produit ${productId} - Updated`,
    prix: Math.random() * 100
  });
  
  const response = http.put(`http://localhost:8080/api/v1/products/${productId}`, payload, {
    headers: { 'Content-Type': 'application/json' },
  });
  
  check(response, {
    'status is 200': (r) => r.status === 200,
    'response time < 1000ms': (r) => r.timings.duration < 1000,
  });
  
  sleep(0.5);
}
```

### 8. Script de test de stress

```javascript:load-tests/stress-test.js
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '2m', target: 10 },
    { duration: '2m', target: 50 },
    { duration: '2m', target: 100 },
    { duration: '2m', target: 200 },
    { duration: '2m', target: 0 },
  ],
  thresholds: {
    http_req_duration: ['p(95)<3000'],
    http_req_failed: ['rate<0.2'],
  },
};

export default function () {
  const urls = [
    'http://localhost:8080/api/v1/stores/1/stock',
    'http://localhost:8080/api/v1/products/1',
    'http://localhost:8080/api/v1/reports/sales',
  ];
  
  const randomUrl = urls[Math.floor(Math.random() * urls.length)];
  const response = http.get(randomUrl);
  
  check(response, {
    'status is 200': (r) => r.status === 200,
  });
  
  sleep(0.1);
}
```

### 9. Script de lancement des tests

```bash:load-tests/run-tests.sh
#!/bin/bash

echo "🚀 Démarrage des tests de charge..."

echo "📊 Test 1: Consultation des stocks"
k6 run stock-consultation.js

echo " Test 2: Génération de rapports"
k6 run reports-generation.js

echo "🔄 Test 3: Mise à jour de produits"
k6 run product-updates.js

echo "💥 Test 4: Test de stress"
k6 run stress-test.js

echo "✅ Tests terminés!"
```

### 10. Amélioration du logging

Créons une configuration de logging plus structurée :

```properties:src/main/resources/application.properties
# Actuator configuration
management.endpoints.web.exposure.include=health,info,metrics,prometheus
management.endpoint.health.enabled=true
management.endpoint.health.show-details=always
management.endpoint.prometheus.enabled=true

# Logging configuration
logging.level.root=INFO
logging.level.org.springframework.boot.actuator=DEBUG
logging.level.com.lab4=DEBUG
logging.pattern.console=%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n
logging.pattern.file=%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n

# Performance monitoring
management.metrics.tags.application=lab4-api
management.metrics.export.prometheus.enabled=true
```

### 11. Instructions d'utilisation

Créons un README pour expliquer comment utiliser cette solution :

```markdown:LOAD_TESTING_README.md
# Tests de Charge et Observabilité - LAB4

##  Démarrage rapide

### 1. Lancer l'infrastructure complète
```bash
docker-compose up -d
```

### 2. Vérifier les services
- API: http://localhost:8080
- Grafana: http://localhost:3000 (admin/admin)
- Prometheus: http://localhost:9090

### 3. Lancer les tests de charge
```bash
cd load-tests
chmod +x run-tests.sh
./run-tests.sh
```

## 📊 Métriques observées

### Latence
- Temps de réponse moyen
- Percentiles 95e et 99e
- Métrique: `http_server_requests_seconds`

### Trafic
- Requêtes par seconde
- Métrique: `http_server_requests_seconds_count`

### Erreurs
- Taux de réponses HTTP 4xx/5xx
- Métrique: `http_server_requests_seconds_count{status=~"4..|5.."}`

### Saturation
- Utilisation CPU et mémoire JVM
- Métriques: `jvm_memory_used_bytes`, `process_cpu_usage`

## 🔍 Analyse des goulets d'étranglement

1. **Base de données**: Vérifier les requêtes lentes
2. **Pool de connexions**: Surveiller l'utilisation
3. **Mémoire JVM**: Détecter les fuites
4. **CPU**: Identifier les opérations coûteuses

##  Améliorations suggérées

1. **Index de base de données** sur les colonnes fréquemment consultées
2. **Cache Redis** pour les données statiques
3. **Optimisation des requêtes SQL**
4. **Connection pooling** optimisé
```

## Résumé de la solution

Cette implémentation simple et claire vous fournit :

1. **✅ Observabilité complète** avec Prometheus + Grafana
2. **✅ Tests de charge** avec k6 (simple et efficace)
3. **✅ Métriques Spring Boot** automatiques
4. **✅ Logging structuré**
5. **✅ Dashboards prêts à l'emploi**
6. **✅ Scripts de test automatisés**

Pour démarrer, il suffit de :
1. Mettre à jour le `pom.xml` avec la dépendance Prometheus
2. Remplacer le `docker-compose.yml`
3. Créer les dossiers `monitoring/` et `load-tests/`
4. Lancer `docker-compose up -d`
5. Exécuter les tests avec `./load-tests/run-tests.sh`

Cette solution respecte votre préférence pour des implémentations minimales et simples tout en couvrant tous les aspects demandés dans la tâche. 