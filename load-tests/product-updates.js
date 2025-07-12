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
  // Lines 15-22: High-frequency product updates
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

