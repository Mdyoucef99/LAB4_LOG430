import http from 'k6/http';
import { check, sleep } from 'k6';

export const stressOptions = {
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