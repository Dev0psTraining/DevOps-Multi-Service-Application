const express = require('express');
const cors = require('cors');
const prometheus = require('prom-client');

const app = express();
const port = process.env.PORT || 5000;
 
const register = new prometheus.Registry();
prometheus.collectDefaultMetrics({ register });

const httpRequestCounter = new prometheus.Counter({
  name: 'http_requests_total',
  help: 'Total HTTP requests',
  labelNames: ['method', 'route', 'status'],
  registers: [register]
});

const httpRequestDuration = new prometheus.Histogram({
  name: 'http_request_duration_seconds',
  help: 'HTTP request latencies in seconds',
  labelNames: ['method', 'route'],
  registers: [register]
}); 

app.use(cors());
app.use(express.json());
 
app.use((req, res, next) => {
  const start = Date.now();
  
  res.on('finish', () => {
    const duration = (Date.now() - start) / 1000;
    
    httpRequestCounter.inc({
      method: req.method,
      route: req.path,
      status: res.statusCode
    });
    
    httpRequestDuration.observe({
      method: req.method,
      route: req.path
    }, duration);
  });
  
  next();
});
 
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    service: 'backend-api',
    environment: process.env.NODE_ENV || 'development'
  });
});

app.get('/api/stats', (req, res) => {
  res.json({
    visits: Math.floor(Math.random() * 1000) + 100,
    users: Math.floor(Math.random() * 100) + 10,
    cpu: parseFloat((Math.random() * 100).toFixed(2)),
    memory: parseFloat((Math.random() * 100).toFixed(2)),
    responseTime: Math.floor(Math.random() * 100) + 20
  });
});

app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
});

app.listen(port, () => {
  console.log(`Backend API running on port ${port}`);
  console.log(`Health check: http://localhost:${port}/health`);
  console.log(`Metrics: http://localhost:${port}/metrics`);
});