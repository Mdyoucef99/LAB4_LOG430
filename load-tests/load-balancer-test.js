import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate } from 'k6/metrics';

// Métriques personnalisées
const errorRate = new Rate('errors');

// Configuration du test
export const options = {
  stages: [
    { duration: '30s', target: 10 },  // Montée en charge
    { duration: '1m', target: 10 },   // Charge constante
    { duration: '30s', target: 0 },   // Descente
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'], // 95% des requêtes < 500ms
    errors: ['rate<0.1'],             // Taux d'erreur < 10%
  },
};

// Variables d'environnement
const BASE_URL = __ENV.BASE_URL || 'http://localhost';
const ENDPOINT = __ENV.ENDPOINT || '/api/v1/stores/1/stock';

export default function () {
  // Test de l'endpoint via load balancer
  const response = http.get(`${BASE_URL}${ENDPOINT}`);
  
  // Vérifications
  const success = check(response, {
    'status is 200': (r) => r.status === 200,
    'response time < 500ms': (r) => r.timings.duration < 500,
    'has data': (r) => r.json().length > 0,
  });

  // Enregistrer les erreurs
  errorRate.add(!success);
  
  // Pause entre les requêtes
  sleep(1);
}

// Hook de fin de test
export function handleSummary(data) {
  return {
    'load-balancer-results.json': JSON.stringify(data, null, 2),
  };
} 