set -e

echo "🔍 DevOps Security Scanner"
echo "========================="

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' 

if ! command -v trivy &> /dev/null; then
    echo -e "${YELLOW}Trivy not found. Installing...${NC}"
    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
fi

mkdir -p scan-results

scan_image() {
    local image=$1
    local name=$2
    
    echo -e "\n${YELLOW}Scanning $name...${NC}"
    
    trivy image --severity HIGH,CRITICAL \
                --format table \
                --output "scan-results/${name}-scan.txt" \
                "$image"
    
    local critical=$(trivy image --severity CRITICAL --format json "$image" 2>/dev/null | grep -c '"Severity": "CRITICAL"' || true)
    local high=$(trivy image --severity HIGH --format json "$image" 2>/dev/null | grep -c '"Severity": "HIGH"' || true)
    
    echo -e "Results for $name:"
    echo -e "  Critical: ${RED}$critical${NC}"
    echo -e "  High: ${YELLOW}$high${NC}"
    
    if [ $critical -gt 0 ]; then
        echo -e "  ${RED}⚠️  Critical vulnerabilities found!${NC}"
    else
        echo -e "  ${GREEN}✅ No critical vulnerabilities${NC}"
    fi
}

echo "Building images..."
docker-compose build


scan_image "devops-project_backend:latest" "backend"
scan_image "devops-project_frontend:latest" "frontend"

echo -e "\n${GREEN}✅ Security scan completed!${NC}"
echo "Detailed reports saved in: scan-results/"