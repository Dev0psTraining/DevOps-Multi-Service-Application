DevOps Multi-Service Application

A comprehensive DevOps project demonstrating containerization, orchestration, monitoring, and security practices.

 🎯 Project Overview

This project implements a multi-service application with:
- Backend API: Node.js service with health endpoints and metrics
- Frontend Dashboard: Real-time monitoring interface
- Prometheus: Metrics collection and storage
- Grafana: Advanced visualization and alerting
- Security Scanning: Automated vulnerability detection with Trivy
- Incident Management: Simulation tools and post-mortem procedures

 🚀 Quick Start

 Prerequisites
- Docker Desktop installed and running
- Docker Compose v2.0+
- 4GB RAM minimum
- 10GB free disk space

 Installation

1. Clone the repository
   bash
   git clone <repository-url>
   cd devops-project
   

2. Make scripts executable
   bash
   chmod +x scripts/*.sh
   

3. Start all services
   bash
   ./scripts/start.sh
   

4. Access the services
   - 📊 Dashboard: http://localhost:3000
   - 🔧 API Health: http://localhost:5001/health
   - 📈 Prometheus: http://localhost:9090
   - 📊 Grafana: http://localhost:3001 (admin/admin)

 📁 Project Structure


devops-project/
├── backend/               Node.js API service
│   ├── app.js            Main application
│   ├── package.json      Dependencies
│   └── Dockerfile        Container definition
├── frontend/             Web dashboard
│   ├── index.html       Dashboard UI
│   ├── nginx.conf       Web server config
│   └── Dockerfile       Container definition
├── prometheus/           Monitoring configuration
│   └── prometheus.yml   Scrape configurations
├── grafana/             Visualization setup
│   └── provisioning/    Auto-provisioning
├── scripts/             Automation scripts
│   ├── start.sh         Quick start
│   ├── security-scan.sh  Vulnerability scanning
│   └── incident-simulation.sh  Failure testing
├── docs/                Documentation
├── docker-compose.yml   Service orchestration
├── .env                Environment variables
└── README.md           This file


 🛠️ Technical Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| Backend | Node.js + Express | API and metrics endpoint |
| Frontend | HTML/JS + Nginx | Monitoring dashboard |
| Metrics | Prometheus | Time-series data collection |
| Visualization | Grafana | Dashboards and alerts |
| Containerization | Docker | Service isolation |
| Orchestration | Docker Compose | Multi-container management |
| Security | Trivy | Vulnerability scanning |

 📊 Monitoring Setup

 Prometheus Metrics
The backend exposes metrics at /metrics:
- http_requests_total - Total HTTP requests by method, route, status
- http_request_duration_seconds - Request latency histogram
- Default Node.js metrics (CPU, memory, etc.)

 Grafana Dashboards
1. Access Grafana at http://localhost:3001
2. Login with admin/admin
3. Navigate to Dashboards → Browse
4. Import custom dashboard or create your own

 Adding Custom Metrics
javascript
// Example in backend/app.js
const customMetric = new prometheus.Counter({
  name: 'custom_metric_total',
  help: 'Description of metric'
});


 🔒 Security Implementation

 Container Security
- All containers run as non-root users
- Minimal base images (Alpine Linux)
- Health checks for automatic recovery
- Resource limits to prevent DoS

 Vulnerability Scanning
bash
 Run security scan
./scripts/security-scan.sh

 Results saved in scan-results/


 Best Practices
- Environment variables for configuration
- No hardcoded secrets
- Regular security updates
- Network isolation between services

 🚨 Incident Management

 Simulation Tool
bash
 Run incident simulation
./scripts/incident-simulation.sh

 Available scenarios:
 1. Backend container failure
 2. Frontend container failure
 3. High CPU load


 Post-Mortem Process
1. Incident occurs (real or simulated)
2. Document in docs/incident-logs/
3. Fill out post-mortem template
4. Implement improvements

 🔧 Common Operations

 View Logs
bash
 All services
docker-compose logs -f

 Specific service
docker-compose logs -f backend


 Restart Services
bash
 All services
docker-compose restart

 Single service
docker-compose restart backend


 Stop Everything
bash
docker-compose down

 Remove volumes too
docker-compose down -v


 Update Services
bash
 Rebuild and restart
docker-compose up -d --build


 📈 Performance Optimization

- Caching: Nginx caches static assets
- Compression: Gzip enabled for responses
- Health Checks: Automatic container recovery
- Resource Limits: Prevent resource exhaustion

 🐛 Troubleshooting

 Backend Not Responding
1. Check logs: docker-compose logs backend
2. Verify port 5001 is accessible
3. Restart service: docker-compose restart backend

 Prometheus Not Scraping
1. Check targets: http://localhost:9090/targets
2. Verify network: docker network ls
3. Check configuration: prometheus/prometheus.yml

 Port Conflicts
- If port 5001 is in use, edit docker-compose.yml
- macOS users: Port 5000 is used by AirPlay Receiver

 🎓 Learning Resources

- [Docker Documentation](https://docs.docker.com/)
- [Prometheus Best Practices](https://prometheus.io/docs/practices/)
- [Grafana Tutorials](https://grafana.com/tutorials/)
- [Node.js Monitoring Guide](https://nodejs.org/en/docs/guides/)

 📝 Assignment Checklist

- [x] Multi-container application (2+ services)
- [x] Docker Compose orchestration
- [x] Prometheus monitoring
- [x] Grafana visualization
- [x] Trivy security scanning
- [x] Incident simulation
- [x] Post-mortem template
- [x] Environment management
- [x] Git version control
- [x] Comprehensive documentation