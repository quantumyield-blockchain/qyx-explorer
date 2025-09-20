# QYX Explorer Deployment Guide

This guide provides comprehensive instructions for deploying the QYX Explorer in various environments, from local development to production setups.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Start with Docker](#quick-start-with-docker)
- [Local Development Setup](#local-development-setup)
- [Production Deployment](#production-deployment)
- [Environment Configuration](#environment-configuration)
- [Platform-Specific Guides](#platform-specific-guides)
- [Monitoring and Maintenance](#monitoring-and-maintenance)
- [Troubleshooting](#troubleshooting)

## Prerequisites

### System Requirements

- **CPU**: 2+ cores (4+ recommended for production)
- **RAM**: 4GB minimum (8GB+ recommended for production)
- **Storage**: 100GB+ available space (blockchain data grows over time)
- **Network**: Stable internet connection

### Software Dependencies

- **Docker** (recommended) or **Node.js 16+**
- **Git**
- Access to a QYX blockchain node (bitcoind/quantumyieldd)
- **Nginx** (for production deployments)

## Quick Start with Docker

### 1. Clone the Repository

```bash
git clone https://github.com/quantumyield-blockchain/qyx-explorer.git
cd qyx-explorer
```

### 2. Build the Docker Image

```bash
docker build -t qyx-explorer -f contrib/Dockerfile .
```

### 3. Run with Docker Compose

```bash
# Copy and customize the docker-compose file
cp contrib/docker-compose.yml docker-compose.yml

# Edit docker-compose.yml to use QYX configuration
# Then start the services
docker-compose up -d
```

### 4. Access the Explorer

- **Web Interface**: http://localhost:8080
- **API**: http://localhost:8080/api
- **Electrum Server**: localhost:50001

## Local Development Setup

### 1. Install Dependencies

```bash
npm install
```

### 2. Configure Environment

```bash
# Set your blockchain node API URL
export API_URL=http://localhost:8332/  # Your QYX node RPC endpoint

# Optional: Set other configuration options
export SITE_TITLE="QYX Explorer - Dev"
export BASE_HREF="/"
```

### 3. Start Development Server

```bash
npm run dev-server
```

The development server will be available at http://localhost:5000

### 4. Build for Production

```bash
# Build with QYX flavor
./build.sh qyx-mainnet

# The built files will be in the 'dist' directory
```

## Production Deployment

### Option 1: Docker Deployment

#### Using Docker Run

```bash
# For QYX Mainnet
docker run -d \
  --name qyx-explorer \
  -p 80:80 \
  -p 50001:50001 \
  -v qyx_data:/data \
  -v qyx_logs:/var/log \
  -e CANONICAL_URL=https://explorer.yourdomain.com \
  qyx-explorer \
  bash -c "/srv/explorer/run.sh qyx-mainnet explorer"

# For QYX Testnet
docker run -d \
  --name qyx-explorer-testnet \
  -p 8080:80 \
  -p 50002:50001 \
  -v qyx_testnet_data:/data \
  qyx-explorer \
  bash -c "/srv/explorer/run.sh qyx-testnet explorer"
```

#### Using Docker Compose

Create a `docker-compose.yml` file:

```yaml
version: '3.8'

services:
  qyx-explorer:
    build:
      context: .
      dockerfile: contrib/Dockerfile
    ports:
      - "80:80"
      - "50001:50001"
    volumes:
      - qyx_data:/data
      - qyx_logs:/var/log
    environment:
      - CANONICAL_URL=https://explorer.yourdomain.com
      - SITE_TITLE=QYX Explorer
    command: >
      bash -c "/srv/explorer/run.sh qyx-mainnet explorer"
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/api/blocks/tip/height"]
      interval: 30s
      timeout: 10s
      retries: 3

volumes:
  qyx_data:
  qyx_logs:
```

### Option 2: Traditional Server Deployment

#### 1. Build the Application

```bash
# Build for production
NODE_ENV=production ./build.sh qyx-mainnet

# Copy built files to web server directory
sudo cp -r dist/* /var/www/html/
```

#### 2. Configure Nginx

Create `/etc/nginx/sites-available/qyx-explorer`:

```nginx
server {
    listen 80;
    server_name explorer.yourdomain.com;
    root /var/www/html;
    index index.html;

    # Gzip compression
    gzip on;
    gzip_types text/plain text/css application/javascript application/json;

    # API proxy to blockchain node
    location /api/ {
        proxy_pass http://localhost:8332/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Electrum WebSocket proxy
    location /ws {
        proxy_pass http://localhost:50001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }

    # Single Page Application routing
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Static assets caching
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

#### 3. Enable and Start Services

```bash
# Enable Nginx site
sudo ln -s /etc/nginx/sites-available/qyx-explorer /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx

# Start your QYX blockchain node (if not already running)
# quantumyieldd -daemon -conf=/path/to/qyx.conf
```

## Environment Configuration

### Essential Environment Variables

```bash
# Core Configuration
export SITE_TITLE="QYX Explorer"
export API_URL="http://localhost:8332/"  # Your QYX node URL
export BASE_HREF="/"
export CANONICAL_URL="https://explorer.yourdomain.com"

# Branding
export SITE_DESC="QYX Blockchain Explorer"
export SITE_FOOTER="© 2025 QuantumYield Blockchain"
export NATIVE_ASSET_LABEL="QYX"

# Features
export NOSCRIPT_REDIR=1
export NAVBAR_HTML=1
```

### Advanced Configuration

```bash
# Performance
export NO_PRECACHE=0              # Enable address precaching
export NO_ADDRESS_SEARCH=0        # Enable address search
export ENABLE_LIGHTMODE=0         # Disable for full features

# Security
export CORS_ALLOW="https://yourdomain.com"
export ONION_URL="http://youroniondomain.onion"

# Monitoring
export DEBUG=verbose              # Enable verbose logging
```

## Platform-Specific Guides

### AWS EC2 Deployment

1. **Launch EC2 Instance**
   - AMI: Ubuntu 22.04 LTS
   - Instance Type: t3.medium or larger
   - Security Groups: Allow ports 80, 443, 22

2. **Install Dependencies**
   ```bash
   sudo apt update
   sudo apt install docker.io docker-compose nginx certbot
   sudo systemctl enable docker
   ```

3. **Deploy Application**
   ```bash
   git clone https://github.com/quantumyield-blockchain/qyx-explorer.git
   cd qyx-explorer
   docker-compose up -d
   ```

4. **Setup SSL with Let's Encrypt**
   ```bash
   sudo certbot --nginx -d explorer.yourdomain.com
   ```

### Google Cloud Platform

1. **Create Compute Engine Instance**
   ```bash
   gcloud compute instances create qyx-explorer \
     --image-family=ubuntu-2204-lts \
     --image-project=ubuntu-os-cloud \
     --machine-type=e2-medium \
     --tags=http-server,https-server
   ```

2. **Follow the general Docker deployment steps above**

### DigitalOcean Droplet

1. **Create Droplet**
   - Choose Ubuntu 22.04
   - Size: 2GB RAM / 2 CPUs minimum
   - Add your SSH key

2. **Use the Docker deployment method**

### Self-Hosted/VPS

Follow the traditional server deployment method above, ensuring:
- Firewall allows ports 80, 443
- Regular backups of blockchain data
- Monitoring setup

## Monitoring and Maintenance

### Health Checks

```bash
# Check if explorer is responding
curl -f http://localhost/api/blocks/tip/height

# Check blockchain sync status
curl http://localhost/api/blocks/tip/height
```

### Log Monitoring

```bash
# Docker logs
docker logs qyx-explorer -f

# System logs (if using systemd)
sudo journalctl -u qyx-explorer -f
```

### Backup Strategy

```bash
# Backup blockchain data
docker run --rm -v qyx_data:/data -v $(pwd):/backup ubuntu \
  tar czf /backup/qyx-data-$(date +%Y%m%d).tar.gz /data

# Backup configuration
cp -r flavors/qyx-mainnet /backup/qyx-config-$(date +%Y%m%d)
```

### Updates

```bash
# Pull latest code
git pull origin main

# Rebuild and restart
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

## Troubleshooting

### Common Issues

1. **Explorer not loading**
   ```bash
   # Check if container is running
   docker ps
   
   # Check logs
   docker logs qyx-explorer
   ```

2. **API not responding**
   ```bash
   # Verify blockchain node is accessible
   curl -u rpcuser:rpcpass http://localhost:8332/
   ```

3. **Build failures**
   ```bash
   # Clear npm cache
   npm cache clean --force
   
   # Remove node_modules and reinstall
   rm -rf node_modules client/node_modules prerender-server/node_modules
   npm install
   ```

4. **High memory usage**
   ```bash
   # Enable light mode
   export ENABLE_LIGHTMODE=1
   ```

### Performance Optimization

1. **Enable caching**
   - Use Redis for API response caching
   - Configure Nginx proxy cache

2. **Database optimization**
   - Ensure adequate disk space
   - Monitor disk I/O performance

3. **Network optimization**
   - Use CDN for static assets
   - Enable gzip compression

### Getting Help

- **GitHub Issues**: https://github.com/quantumyield-blockchain/qyx-explorer/issues
- **Documentation**: Check the [WHITELABELING.md](WHITELABELING.md) guide
- **Community**: Join the QuantumYield Discord/Telegram channels

## Security Considerations

1. **Use HTTPS in production**
2. **Keep system and dependencies updated**
3. **Configure proper firewall rules**
4. **Regular security audits**
5. **Backup encryption for sensitive data**

---

For whitelabeling and customization instructions, see [WHITELABELING.md](WHITELABELING.md).