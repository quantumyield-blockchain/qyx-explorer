# QYX Explorer Quick Start Guide

Get your QYX blockchain explorer up and running in minutes!

## 🚀 Super Quick Start (Docker)

```bash
# 1. Clone the repository
git clone https://github.com/quantumyield-blockchain/qyx-explorer.git
cd qyx-explorer

# 2. Deploy with one command
./deploy.sh --type docker --domain explorer.yourdomain.com

# 3. Access your explorer
# 🌐 Web Interface: http://localhost
# ⚡ Electrum Server: localhost:50001
```

## 📋 Prerequisites

- **Docker** (for containerized deployment)
- **Node.js 16+** (for local development)
- **QYX blockchain node** (running and synced)

## 🎯 Deployment Options

### 1. Docker (Recommended)
```bash
./deploy.sh --type docker --flavor qyx-mainnet
```

### 2. Docker Compose (Production)
```bash
./deploy.sh --type docker-compose --domain explorer.quantumyield.com
```

### 3. Kubernetes (Scale)
```bash
./deploy.sh --type k8s --domain explorer.quantumyield.com
```

### 4. Local Development
```bash
./deploy.sh --type local --api-url http://your-qyx-node:8332/
```

### 5. Static Files (Traditional Hosting)
```bash
./deploy.sh --type static --domain yourdomain.com
```

## 🎨 Customization

### Quick Branding
Edit `flavors/qyx-mainnet/config.env`:
```bash
export SITE_TITLE='Your Brand Explorer'
export SITE_FOOTER='© 2025 Your Company'
export NATIVE_ASSET_LABEL=YBT
```

### Custom Styling
Edit `flavors/qyx-mainnet/extras.css`:
```css
:root {
  --brand-primary: #YOUR_COLOR;
  --brand-secondary: #YOUR_COLOR;
}
```

### Add Your Logo
```bash
cp your-logo.png flavors/qyx-mainnet/www/img/logo.png
```

## 🔧 Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `API_URL` | QYX node RPC endpoint | `http://localhost:8332/` |
| `SITE_TITLE` | Explorer title | `QYX Explorer` |
| `CANONICAL_URL` | Production URL | - |
| `FLAVOR` | Configuration flavor | `qyx-mainnet` |

## 📚 Complete Documentation

- **[📖 Deployment Guide](DEPLOYMENT.md)** - Detailed deployment for all platforms
- **[🎨 Whitelabeling Guide](WHITELABELING.md)** - Complete customization reference
- **[🐳 Docker Examples](docker-compose.qyx.yml)** - Production Docker setup
- **[☸️ Kubernetes Config](kubernetes-deployment.yaml)** - Scalable K8s deployment

## 🌍 Network Configurations

### Mainnet
```bash
./deploy.sh --flavor qyx-mainnet --api-url http://mainnet-node:8332/
```

### Testnet
```bash
./deploy.sh --flavor qyx-testnet --api-url http://testnet-node:18332/
```

## 🔍 Verification

After deployment, verify your explorer:

```bash
# Check if explorer is running
curl http://localhost/api/blocks/tip/height

# Check Docker containers
docker ps

# View logs
docker logs qyx-explorer
```

## 🆘 Troubleshooting

### Explorer not loading
```bash
# Check container status
docker ps -a

# View logs
docker logs qyx-explorer -f
```

### API not responding
```bash
# Verify blockchain node connection
curl -u rpcuser:rpcpass http://localhost:8332/
```

### Build failures
```bash
# Clean and rebuild
rm -rf node_modules client/node_modules
npm install
```

## 🎯 Production Checklist

- [ ] Set strong RPC credentials
- [ ] Configure SSL/HTTPS
- [ ] Set up monitoring
- [ ] Configure backups
- [ ] Update `CANONICAL_URL`
- [ ] Test on mobile devices
- [ ] Set up log rotation

## 💡 Pro Tips

1. **Use Docker for consistency** across environments
2. **Enable SSL** for production deployments  
3. **Monitor disk space** (blockchain data grows)
4. **Regular backups** of blockchain data
5. **Test thoroughly** before production

## 🤝 Getting Help

- **Issues**: [GitHub Issues](https://github.com/quantumyield-blockchain/qyx-explorer/issues)
- **Documentation**: Check the guides in this repository
- **Community**: Join QuantumYield Discord/Telegram

---

**Need more details?** Check out the comprehensive guides:
- [DEPLOYMENT.md](DEPLOYMENT.md) for detailed deployment instructions
- [WHITELABELING.md](WHITELABELING.md) for complete customization options