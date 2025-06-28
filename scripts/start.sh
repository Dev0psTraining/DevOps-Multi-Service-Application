set -e

echo "🚀 Starting DevOps Multi-Service Application"
echo "=========================================="

if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker is not running!"
    echo "Please start Docker and try again."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Error: docker-compose is not installed!"
    exit 1
fi

echo "📁 Creating directories..."
mkdir -p grafana/provisioning/datasources

echo "🔨 Building containers..."
docker-compose build

echo "🏃 Starting services..."
docker-compose up -d

echo "⏳ Waiting for services to start..."
sleep 10

echo "🔍 Checking service health..."
echo ""

check_service() {
    local name=$1
    local url=$2
    if curl -s -f -o /dev/null "$url"; then
        echo "✅ $name is running"
    else
        echo "❌ $name is not responding"
    fi
}

check_service "Backend API" "http://localhost:5001/health"
check_service "Frontend" "http://localhost:3000"
check_service "Prometheus" "http://localhost:9090/-/healthy"
check_service "Grafana" "http://localhost:3001/api/health"

echo ""
echo "🎉 Application is ready!"
echo "========================"
echo "📊 Frontend Dashboard: http://localhost:3000"
echo "🔧 Backend API Health: http://localhost:5001/health"
echo "📈 Prometheus: http://localhost:9090"
echo "📊 Grafana: http://localhost:3001 (admin/admin)"
echo ""
echo "Run 'docker-compose logs -f' to see logs"
echo "Run 'docker-compose down' to stop all services"