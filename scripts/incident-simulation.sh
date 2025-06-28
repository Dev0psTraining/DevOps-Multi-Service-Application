set -e

echo "🚨 DevOps Incident Simulation Tool"
echo "================================="


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'


mkdir -p docs/incident-logs


LOG_FILE="docs/incident-logs/incident-$(date +%Y%m%d-%H%M%S).log"


log_event() {
    local message=$1
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $message" | tee -a "$LOG_FILE"
}


simulate_container_failure() {
    local service=$1
    
    echo -e "\n${RED}🔥 Simulating $service container failure${NC}"
    log_event "INCIDENT START: Simulating $service container failure"
    

    local container_name="devops-$service"
    

    echo "Current status:"
    docker ps | grep $container_name || echo "Container not found"
    

    echo -e "${YELLOW}Killing container...${NC}"
    docker kill $container_name 2>/dev/null || echo "Container already stopped"
    log_event "Container $container_name killed"
    

    echo -e "${BLUE}Waiting 30 seconds to observe recovery...${NC}"
    for i in {1..6}; do
        sleep 5
        echo -n "."
    done
    echo ""
    

    if docker ps | grep -q $container_name; then
        echo -e "${GREEN}✅ Container recovered automatically!${NC}"
        log_event "Container $container_name recovered automatically"
    else
        echo -e "${RED}❌ Container did not recover${NC}"
        log_event "Container $container_name failed to recover"
        

        echo "Starting manual recovery..."
        docker-compose up -d $service
        log_event "Manual recovery initiated for $service"
    fi
    

    echo -e "\nFinal status:"
    docker ps | grep $container_name
}


while true; do
    echo -e "\n${BLUE}Select incident to simulate:${NC}"
    echo "1) Backend container failure"
    echo "2) Frontend container failure"
    echo "3) High CPU load simulation"
    echo "4) View incident logs"
    echo "5) Exit"
    
    read -p "Enter choice (1-5): " choice
    
    case $choice in
        1)
            simulate_container_failure "backend"
            ;;
        2)
            simulate_container_failure "frontend"
            ;;
        3)
            echo -e "\n${YELLOW}📈 Simulating high CPU load...${NC}"
            log_event "High CPU load simulation started"
            

            docker exec devops-backend sh -c "timeout 30s sh -c 'while true; do echo calculating...; done'" &
            
            echo "CPU load applied for 30 seconds..."
            echo "Check metrics at: http://localhost:9090"
            
            sleep 30
            log_event "High CPU load simulation completed"
            echo -e "${GREEN}✅ CPU load test completed${NC}"
            ;;
        4)
            echo -e "\n${BLUE}Recent incident logs:${NC}"
            ls -la docs/incident-logs/ 2>/dev/null || echo "No logs found"
            ;;
        5)
            echo "Exiting..."
            log_event "Incident simulation session ended"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice${NC}"
            ;;
    esac
done