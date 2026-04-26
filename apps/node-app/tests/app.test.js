const request = require('supertest');
const app = require('../src/app');

describe('GET /', () => {
  it('should return Hello World message', async () => {
    const res = await request(app).get('/');
    expect(res.statusCode).toEqual(200);
    expect(res.body.message).toBe('Hello World from Docker + GitHub Actions!');
  });
});

describe('GET /api', () => {
  it('should return API info', async () => {
    const res = await request(app).get('/api');
    expect(res.statusCode).toEqual(200);
    expect(res.body.api).toBe('v1');
  });
});

describe('GET /status', () => {
  it('should return status OK', async () => {
    const res = await request(app).get('/status');
    expect(res.statusCode).toEqual(200);
    expect(res.body.status).toBe('OK');
  });
});