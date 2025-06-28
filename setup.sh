echo "🔧 Setting up DevOps Project"
echo "=========================="

echo "📁 Creating directory structure..."
mkdir -p backend
mkdir -p frontend  
mkdir -p prometheus
mkdir -p grafana/provisioning/datasources
mkdir -p scripts
mkdir -p docs/incident-logs
mkdir -p ansible
mkdir -p scan-results

echo "🔐 Setting script permissions..."
chmod +x scripts/*.sh

if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running!"
    echo "Please start Docker Desktop and run this script again."
    exit 1
fi

echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Run: ./scripts/start.sh"
echo "2. Open: http://localhost:3000"
echo ""
echo "Happy DevOps learning! 🚀"