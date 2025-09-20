#!/bin/bash

# QYX Explorer Deployment Script
# This script helps deploy the QYX Explorer in various environments

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
FLAVOR="${FLAVOR:-qyx-mainnet}"
DEPLOYMENT_TYPE="${DEPLOYMENT_TYPE:-docker}"
DOMAIN="${DOMAIN:-localhost}"
API_URL="${API_URL:-http://localhost:8332/}"

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_dependencies() {
    log_info "Checking dependencies..."
    
    if ! command -v node &> /dev/null; then
        log_error "Node.js is not installed. Please install Node.js 16 or later."
        exit 1
    fi
    
    if ! command -v npm &> /dev/null; then
        log_error "npm is not installed. Please install npm."
        exit 1
    fi
    
    if [[ "$DEPLOYMENT_TYPE" == "docker" ]] && ! command -v docker &> /dev/null; then
        log_error "Docker is not installed. Please install Docker."
        exit 1
    fi
    
    if [[ "$DEPLOYMENT_TYPE" == "k8s" ]] && ! command -v kubectl &> /dev/null; then
        log_error "kubectl is not installed. Please install kubectl."
        exit 1
    fi
    
    log_success "All dependencies are available."
}

install_npm_dependencies() {
    log_info "Installing npm dependencies..."
    npm install
    log_success "npm dependencies installed."
}

build_flavor() {
    log_info "Building flavor: $FLAVOR"
    
    if [[ ! -d "flavors/$FLAVOR" ]]; then
        log_error "Flavor directory flavors/$FLAVOR does not exist."
        log_info "Available flavors:"
        ls -1 flavors/
        exit 1
    fi
    
    export CANONICAL_URL="https://$DOMAIN"
    export API_URL="$API_URL"
    
    PATH="$PWD/node_modules/.bin:$PATH" ./build.sh "$FLAVOR"
    log_success "Flavor $FLAVOR built successfully."
}

deploy_local() {
    log_info "Starting local development server..."
    export API_URL="$API_URL"
    export CANONICAL_URL="http://localhost:5000"
    npm run dev-server
}

deploy_docker() {
    log_info "Building Docker image..."
    docker build -t qyx-explorer -f contrib/Dockerfile .
    log_success "Docker image built successfully."
    
    log_info "Starting Docker container..."
    docker run -d \
        --name qyx-explorer \
        -p 80:80 \
        -p 50001:50001 \
        -v qyx_data:/data \
        -e CANONICAL_URL="https://$DOMAIN" \
        -e API_URL="$API_URL" \
        qyx-explorer \
        bash -c "/srv/explorer/run.sh $FLAVOR explorer"
    
    log_success "Docker container started."
    log_info "Explorer available at: http://localhost"
    log_info "Electrum server at: localhost:50001"
}

deploy_docker_compose() {
    log_info "Deploying with Docker Compose..."
    
    if [[ ! -f docker-compose.qyx.yml ]]; then
        log_error "docker-compose.qyx.yml not found."
        exit 1
    fi
    
    # Set environment variables
    export CANONICAL_URL="https://$DOMAIN"
    export API_URL="$API_URL"
    export FLAVOR="$FLAVOR"
    
    docker-compose -f docker-compose.qyx.yml up -d
    log_success "Services started with Docker Compose."
    log_info "Explorer available at: http://localhost"
}

deploy_kubernetes() {
    log_info "Deploying to Kubernetes..."
    
    if [[ ! -f kubernetes-deployment.yaml ]]; then
        log_error "kubernetes-deployment.yaml not found."
        exit 1
    fi
    
    # Replace variables in Kubernetes config
    sed -e "s|DOMAIN_PLACEHOLDER|$DOMAIN|g" \
        -e "s|API_URL_PLACEHOLDER|$API_URL|g" \
        -e "s|FLAVOR_PLACEHOLDER|$FLAVOR|g" \
        kubernetes-deployment.yaml | kubectl apply -f -
    
    log_success "Deployed to Kubernetes."
    log_info "Check deployment status with: kubectl get pods"
}

deploy_static() {
    log_info "Deploying static files..."
    
    if [[ ! -d dist ]]; then
        log_error "No dist directory found. Run build first."
        exit 1
    fi
    
    # Nginx configuration
    if command -v nginx &> /dev/null; then
        log_info "Copying files to /var/www/html..."
        sudo cp -r dist/* /var/www/html/
        
        log_info "Configuring Nginx..."
        sudo tee /etc/nginx/sites-available/qyx-explorer > /dev/null << EOF
server {
    listen 80;
    server_name $DOMAIN;
    root /var/www/html;
    index index.html;

    # Gzip compression
    gzip on;
    gzip_types text/plain text/css application/javascript application/json;

    # API proxy
    location /api/ {
        proxy_pass $API_URL;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    # SPA routing
    location / {
        try_files \$uri \$uri/ /index.html;
    }

    # Static assets caching
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF
        
        sudo ln -sf /etc/nginx/sites-available/qyx-explorer /etc/nginx/sites-enabled/
        sudo nginx -t && sudo systemctl reload nginx
        log_success "Nginx configured and reloaded."
    else
        log_warning "Nginx not found. Static files copied to dist/. Serve with your preferred web server."
    fi
    
    log_success "Static deployment completed."
}

show_usage() {
    echo "QYX Explorer Deployment Script"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -t, --type TYPE        Deployment type: local, docker, docker-compose, k8s, static"
    echo "  -f, --flavor FLAVOR    Flavor to deploy (default: qyx-mainnet)"
    echo "  -d, --domain DOMAIN    Domain name (default: localhost)"
    echo "  -a, --api-url URL      API URL (default: http://localhost:8332/)"
    echo "  -h, --help             Show this help message"
    echo ""
    echo "Environment Variables:"
    echo "  DEPLOYMENT_TYPE        Same as --type"
    echo "  FLAVOR                 Same as --flavor"
    echo "  DOMAIN                 Same as --domain"
    echo "  API_URL                Same as --api-url"
    echo ""
    echo "Examples:"
    echo "  $0 --type local                                    # Local development"
    echo "  $0 --type docker --domain explorer.example.com    # Docker production"
    echo "  $0 --type docker-compose --flavor qyx-testnet     # Docker Compose testnet"
    echo "  $0 --type k8s --domain explorer.quantumyield.com  # Kubernetes deployment"
    echo "  $0 --type static --domain myexplorer.com          # Static files deployment"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--type)
            DEPLOYMENT_TYPE="$2"
            shift 2
            ;;
        -f|--flavor)
            FLAVOR="$2"
            shift 2
            ;;
        -d|--domain)
            DOMAIN="$2"
            shift 2
            ;;
        -a|--api-url)
            API_URL="$2"
            shift 2
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Main deployment logic
main() {
    log_info "Starting QYX Explorer deployment..."
    log_info "Deployment type: $DEPLOYMENT_TYPE"
    log_info "Flavor: $FLAVOR"
    log_info "Domain: $DOMAIN"
    log_info "API URL: $API_URL"
    
    check_dependencies
    
    case "$DEPLOYMENT_TYPE" in
        local)
            install_npm_dependencies
            build_flavor
            deploy_local
            ;;
        docker)
            install_npm_dependencies
            deploy_docker
            ;;
        docker-compose)
            install_npm_dependencies
            deploy_docker_compose
            ;;
        k8s|kubernetes)
            install_npm_dependencies
            deploy_kubernetes
            ;;
        static)
            install_npm_dependencies
            build_flavor
            deploy_static
            ;;
        *)
            log_error "Invalid deployment type: $DEPLOYMENT_TYPE"
            log_info "Valid types: local, docker, docker-compose, k8s, static"
            exit 1
            ;;
    esac
    
    log_success "Deployment completed successfully!"
    
    # Show access information
    case "$DEPLOYMENT_TYPE" in
        local)
            echo ""
            log_info "🌐 Explorer: http://localhost:5000"
            ;;
        docker|docker-compose)
            echo ""
            log_info "🌐 Explorer: http://localhost (or http://$DOMAIN)"
            log_info "⚡ Electrum: localhost:50001"
            ;;
        static)
            echo ""
            log_info "🌐 Explorer: http://$DOMAIN"
            ;;
        k8s)
            echo ""
            log_info "🌐 Explorer: https://$DOMAIN (after DNS/ingress setup)"
            log_info "📊 Status: kubectl get pods"
            ;;
    esac
}

# Run main function
main