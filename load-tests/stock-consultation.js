import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '2m', target: 10 },
    { duration: '5m', target: 10 },
    { duration: '2m', target: 0 },
  ],
  thresholds: {
    http_req_duration: ['p(95)<2000'],
    http_req_failed: ['rate<0.1'],
  },
};

export default function () {
  const storeIds = [1, 2, 3, 4, 5];
  const randomStoreId = storeIds[Math.floor(Math.random() * storeIds.length)];
  
  const response = http.get(`http://localhost:8080/api/v1/stores/${randomStoreId}/stock`);
  
  check(response, {
    'status is 200': (r) => r.status === 200,
    'response time < 2000ms': (r) => r.timings.duration < 2000,
  });
  
  sleep(1);
}
