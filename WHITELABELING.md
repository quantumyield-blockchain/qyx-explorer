# QYX Explorer Whitelabeling Guide

This guide explains how to customize and whitelabel the QYX Explorer for your blockchain project, including branding, theming, and feature customization.

## Table of Contents

- [Overview](#overview)
- [Flavor System](#flavor-system)
- [Creating a Custom Flavor](#creating-a-custom-flavor)
- [Branding Customization](#branding-customization)
- [Theme Customization](#theme-customization)
- [Feature Configuration](#feature-configuration)
- [Advanced Customization](#advanced-customization)
- [Multi-Network Setup](#multi-network-setup)
- [Deployment with Custom Flavor](#deployment-with-custom-flavor)

## Overview

The QYX Explorer uses a "flavor" system that allows complete customization of branding, styling, and functionality. Each flavor is a self-contained configuration that defines:

- Site title, description, and metadata
- Color scheme and styling
- Logo and visual assets
- Menu structure and navigation
- Footer content and links
- Feature toggles and behavior

## Flavor System

### Structure

Flavors are stored in the `flavors/` directory with the following structure:

```
flavors/
├── your-flavor-name/
│   ├── config.env          # Main configuration file
│   ├── extras.css          # Custom CSS styles (optional)
│   ├── www/                # Static assets (optional)
│   │   ├── favicon.ico     # Custom favicon
│   │   ├── img/           # Images and logos
│   │   └── ...            # Other static files
│   └── LICENSE.md         # License information (optional)
```

### Existing Flavors

- `bitcoin-mainnet` - Basic Bitcoin mainnet configuration
- `liquid-mainnet` - Liquid network configuration  
- `blockstream` - Blockstream.info branded configuration
- `qyx-mainnet` - QYX blockchain configuration (example)

## Creating a Custom Flavor

### Step 1: Create Flavor Directory

```bash
mkdir -p flavors/your-brand-mainnet/www/img
```

### Step 2: Create Configuration File

Create `flavors/your-brand-mainnet/config.env`:

```bash
#!/bin/bash

# Basic Site Information
export SITE_TITLE='Your Brand Explorer'
export HOME_TITLE='Your Brand Blockchain Explorer'
export SITE_DESC='Your Brand Explorer provides detailed blockchain data for the Your Brand network.'
export SITE_FOOTER='© 2025 Your Company. Powered by Esplora.'

# Asset Configuration
export NATIVE_ASSET_LABEL=YBT              # Your token symbol
export NATIVE_ASSET_NAME='Your Brand Token'
export MENU_ACTIVE='Your Brand Mainnet'

# SEO and Social Media
export HEAD_HTML=\
'<meta property="og:image" content="/img/your-brand-social.png">'\
'<meta name="twitter:image" content="/img/your-brand-social.png">'\
'<meta name="twitter:card" content="summary_large_image">'\
'<meta name="twitter:site" content="@YourBrandOfficial">'\
'<meta name="og:title" content="Your Brand Blockchain Explorer">'\
'<meta name="og:site_name" content="Your Brand Explorer">'\
'<meta name="og:description" content="Your Brand Explorer provides detailed blockchain data for the Your Brand network.">'\
'<meta name="twitter:description" content="Your Brand Explorer provides detailed blockchain data for the Your Brand network.">'\
'<meta name="twitter:title" content="Your Brand Blockchain Explorer">'

# Navigation Menu
export MENU_ITEMS='{
  "Mainnet": "/"
, "Testnet": "/testnet/"
, "Documentation": "https://docs.yourbrand.com"
}'

# Footer Social Links
export FOOTER_LINKS='{
  "/img/github.svg": "https://github.com/yourbrand"
, "/img/twitter.svg": "https://x.com/YourBrandOfficial"  
, "/img/telegram.svg": "https://t.me/yourbrand"
, "/img/discord.svg": "https://discord.gg/yourbrand"
, "/img/website.svg": "https://yourbrand.com"
}'

# Custom assets and styling
export CUSTOM_ASSETS="$CUSTOM_ASSETS flavors/your-brand-mainnet/www/*"
export CUSTOM_CSS="$CUSTOM_CSS flavors/your-brand-mainnet/extras.css"

# Features
export NOSCRIPT_REDIR=1
export NAVBAR_HTML=1

# Legal pages (optional)
export TERMS="https://yourbrand.com/terms"
export PRIVACY="https://yourbrand.com/privacy"

# Production URL (set when deploying)
# export CANONICAL_URL="https://explorer.yourbrand.com/"
```

### Step 3: Add Custom Styling

Create `flavors/your-brand-mainnet/extras.css`:

```css
/* Your Brand Custom Styling */

/* Brand Color Variables */
:root {
  --brand-primary: #YOUR_PRIMARY_COLOR;
  --brand-secondary: #YOUR_SECONDARY_COLOR;
  --brand-accent: #YOUR_ACCENT_COLOR;
  --brand-dark: #YOUR_DARK_COLOR;
  --brand-light: #YOUR_LIGHT_COLOR;
}

/* Logo Styling */
.navbar-brand {
  font-weight: bold;
  color: var(--brand-primary) !important;
}

.navbar-brand img {
  max-height: 40px;
  width: auto;
}

/* Navigation */
.navbar-nav .nav-link:hover {
  color: var(--brand-accent) !important;
}

/* Buttons */
.btn-primary {
  background-color: var(--brand-primary);
  border-color: var(--brand-primary);
}

.btn-primary:hover {
  background-color: var(--brand-secondary);
  border-color: var(--brand-secondary);
}

/* Links */
a {
  color: var(--brand-primary);
}

a:hover {
  color: var(--brand-accent);
}

/* Footer */
footer {
  background-color: var(--brand-dark);
  color: #ffffff;
}

footer a {
  color: var(--brand-accent);
}

/* Add more custom styles as needed */
```

### Step 4: Add Visual Assets

```bash
# Copy your assets to the flavor directory
cp your-logo.png flavors/your-brand-mainnet/www/img/logo.png
cp your-favicon.ico flavors/your-brand-mainnet/www/favicon.ico
cp social-sharing-image.png flavors/your-brand-mainnet/www/img/your-brand-social.png
```

## Branding Customization

### Logo Integration

To add a logo to your explorer:

1. **Add logo file**: Place your logo in `flavors/your-flavor/www/img/logo.png`

2. **Update CSS**: Add logo styling to your `extras.css`:
   ```css
   .navbar-brand::before {
     content: '';
     display: inline-block;
     width: 32px;
     height: 32px;
     background-image: url('/img/logo.png');
     background-size: contain;
     background-repeat: no-repeat;
     margin-right: 10px;
     vertical-align: middle;
   }
   ```

3. **Alternative**: Modify the HTML template directly (advanced)

### Favicon

Replace the default favicon:

```bash
cp your-favicon.ico flavors/your-flavor/www/favicon.ico
```

### Social Media Images

Add OpenGraph and Twitter card images:

```bash
# Recommended size: 1200x630 pixels
cp your-social-image.png flavors/your-flavor/www/img/social-sharing.png
```

### Custom Fonts

Add custom fonts by including them in your flavor:

1. **Add font files**:
   ```bash
   mkdir flavors/your-flavor/www/fonts
   cp your-font.woff2 flavors/your-flavor/www/fonts/
   ```

2. **Update CSS**:
   ```css
   @font-face {
     font-family: 'YourCustomFont';
     src: url('/fonts/your-font.woff2') format('woff2');
     font-display: swap;
   }

   body {
     font-family: 'YourCustomFont', sans-serif;
   }
   ```

## Theme Customization

### Color Schemes

#### Light Theme Colors

```css
:root {
  /* Primary colors */
  --primary-color: #your-primary;
  --secondary-color: #your-secondary;
  --accent-color: #your-accent;
  
  /* Text colors */
  --text-primary: #333333;
  --text-secondary: #666666;
  --text-muted: #999999;
  
  /* Background colors */
  --bg-primary: #ffffff;
  --bg-secondary: #f8f9fa;
  --bg-tertiary: #e9ecef;
  
  /* Border colors */
  --border-color: #dee2e6;
  --border-light: #f1f3f4;
}
```

#### Dark Theme Colors

```css
.dark-theme {
  /* Override colors for dark theme */
  --primary-color: #your-primary-dark;
  --secondary-color: #your-secondary-dark;
  
  --text-primary: #ffffff;
  --text-secondary: #cccccc;
  --text-muted: #999999;
  
  --bg-primary: #1a1a1a;
  --bg-secondary: #2d2d2d;
  --bg-tertiary: #404040;
  
  --border-color: #555555;
  --border-light: #444444;
}
```

### Component Styling

#### Transaction Cards

```css
.transaction-card {
  border-left: 4px solid var(--primary-color);
  background: var(--bg-secondary);
  border-radius: 8px;
  padding: 1rem;
  margin-bottom: 1rem;
}

.transaction-confirmed {
  border-left-color: var(--success-color);
}

.transaction-unconfirmed {
  border-left-color: var(--warning-color);
}
```

#### Block Information

```css
.block-info {
  background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
  color: white;
  padding: 2rem;
  border-radius: 12px;
  margin-bottom: 2rem;
}

.block-height {
  font-size: 2.5rem;
  font-weight: bold;
  text-shadow: 0 2px 4px rgba(0,0,0,0.3);
}
```

#### Search Interface

```css
.search-container {
  position: relative;
  max-width: 600px;
  margin: 2rem auto;
}

.search-input {
  width: 100%;
  padding: 1rem 1.5rem;
  border: 2px solid var(--primary-color);
  border-radius: 50px;
  font-size: 1.1rem;
  background: var(--bg-primary);
  color: var(--text-primary);
}

.search-input:focus {
  outline: none;
  border-color: var(--accent-color);
  box-shadow: 0 0 0 0.2rem rgba(var(--primary-color-rgb), 0.25);
}
```

## Feature Configuration

### Toggle Features

```bash
# In your config.env file

# Enable/disable features
export NOSCRIPT_REDIR=1         # Redirect noscript users
export NAVBAR_HTML=1            # Show navigation bar
export NO_PRECACHE=0            # Enable address precaching (better performance)
export NO_ADDRESS_SEARCH=0      # Enable address prefix search
export ENABLE_LIGHTMODE=0       # Disable for full feature set

# Privacy features
export CORS_ALLOW="https://yourdomain.com"    # CORS policy
export ONION_URL="http://youroniondomain.onion"  # Tor support
```

### Menu Customization

```bash
# Simple menu
export MENU_ITEMS='{
  "Explorer": "/"
, "API Docs": "/api-docs"
}'

# Complex menu with external links
export MENU_ITEMS='{
  "Mainnet": "/"
, "Testnet": "/testnet/"
, "API": "/api-docs"
, "GitHub": "https://github.com/yourproject"
, "Documentation": "https://docs.yourproject.com"
}'

# Set active menu item
export MENU_ACTIVE='Mainnet'
```

### Footer Customization

```bash
# Social media links
export FOOTER_LINKS='{
  "/img/github.svg": "https://github.com/yourproject"
, "/img/twitter.svg": "https://twitter.com/yourproject"
, "/img/telegram.svg": "https://t.me/yourproject"
, "/img/discord.svg": "https://discord.gg/yourproject"
, "/img/medium.svg": "https://medium.com/@yourproject"
, "/img/website.svg": "https://yourproject.com"
}'

# Custom footer text
export SITE_FOOTER='© 2025 Your Project. Built with ❤️ for the community.'
```

### Legal and Compliance

```bash
# Add legal page links
export TERMS="https://yourproject.com/terms"
export PRIVACY="https://yourproject.com/privacy"
export COOKIES="https://yourproject.com/cookies"

# Add compliance text to footer
export FOOT_HTML='<div class="mt-3 text-center text-muted">
<small>
  <a href="/terms">Terms of Service</a> | 
  <a href="/privacy">Privacy Policy</a> | 
  <a href="/cookies">Cookie Policy</a>
</small>
</div>'
```

## Advanced Customization

### Custom HTML Head

```bash
# Add analytics, custom meta tags, etc.
export HEAD_HTML=\
'<meta name="keywords" content="blockchain, explorer, cryptocurrency">'\
'<meta name="author" content="Your Company">'\
'<link rel="canonical" href="https://explorer.yourproject.com/">'\
'<!-- Google Analytics -->'\
'<script async src="https://www.googletagmanager.com/gtag/js?id=GA_MEASUREMENT_ID"></script>'\
'<script>window.dataLayer=window.dataLayer||[];function gtag(){dataLayer.push(arguments);}gtag("js",new Date());gtag("config","GA_MEASUREMENT_ID");</script>'\
'<!-- End Google Analytics -->'
```

### Custom Footer HTML

```bash
# Add newsletter signup, additional links, etc.
export FOOT_HTML='<div class="newsletter-signup mt-4">
<h6>Stay Updated</h6>
<form action="https://yourproject.com/newsletter" method="post">
  <div class="input-group">
    <input type="email" class="form-control" placeholder="Enter your email">
    <button class="btn btn-primary" type="submit">Subscribe</button>
  </div>
</form>
</div>'
```

### Elements/Liquid Chain Support

For Elements-based chains (like Liquid):

```bash
# Enable Elements features
export IS_ELEMENTS=1
export NATIVE_ASSET_ID='your-native-asset-id'
export BLIND_PREFIX=12  # Confidential address prefix

# Parent chain linking
export PARENT_CHAIN_EXPLORER_TXOUT='https://explorer.parentchain.com/tx/{txid}#output:{vout}'
export PARENT_CHAIN_EXPLORER_ADDRESS='https://explorer.parentchain.com/address/{addr}'

# Asset registry
export ASSET_MAP_URL='https://assets.yourproject.com/registry.json'
```

## Multi-Network Setup

### Creating Multiple Flavors

For projects with multiple networks:

```bash
# Mainnet flavor
flavors/yourproject-mainnet/config.env
flavors/yourproject-mainnet/extras.css

# Testnet flavor  
flavors/yourproject-testnet/config.env
flavors/yourproject-testnet/extras.css

# Regtest flavor (for development)
flavors/yourproject-regtest/config.env
```

### Shared Configuration

Create base configuration that other flavors can inherit:

```bash
# flavors/yourproject-base/config.env
#!/bin/bash

# Shared configuration
export SITE_DESC='YourProject blockchain explorer'
export SITE_FOOTER='© 2025 YourProject Team'
export CUSTOM_ASSETS="$CUSTOM_ASSETS flavors/yourproject-base/www/*"
export CUSTOM_CSS="$CUSTOM_CSS flavors/yourproject-base/extras.css"

# flavors/yourproject-mainnet/config.env
#!/bin/bash
source flavors/yourproject-base/config.env

export SITE_TITLE='YourProject Mainnet Explorer'
export MENU_ACTIVE='Mainnet'
export CANONICAL_URL='https://explorer.yourproject.com/'
```

### Network-Specific Menu

```bash
# In mainnet config
export MENU_ITEMS='{
  "Mainnet": "/"
, "Testnet": "https://testnet-explorer.yourproject.com/"
, "Regtest": "https://regtest-explorer.yourproject.com/"
}'

export MENU_ACTIVE='Mainnet'

# In testnet config  
export MENU_ITEMS='{
  "Mainnet": "https://explorer.yourproject.com/"
, "Testnet": "/"
, "Regtest": "https://regtest-explorer.yourproject.com/"
}'

export MENU_ACTIVE='Testnet'
```

## Deployment with Custom Flavor

### Build with Custom Flavor

```bash
# Build your custom flavor
./build.sh your-brand-mainnet

# The built files will be in dist/
ls dist/
```

### Docker with Custom Flavor

```bash
# Build Docker image
docker build -t your-brand-explorer -f contrib/Dockerfile .

# Run with your flavor
docker run -d \
  --name your-brand-explorer \
  -p 80:80 \
  -p 50001:50001 \
  -v your_brand_data:/data \
  -e CANONICAL_URL=https://explorer.yourbrand.com \
  your-brand-explorer \
  bash -c "/srv/explorer/run.sh your-brand-mainnet explorer"
```

### Multiple Flavors in One Container

```bash
# Build multiple flavors in Dockerfile
RUN DEST=/srv/explorer/static/your-brand-mainnet \
    npm run dist -- your-brand-mainnet \
 && DEST=/srv/explorer/static/your-brand-testnet \
    npm run dist -- your-brand-testnet
```

### Environment-Specific Configuration

```bash
# Production
export CANONICAL_URL="https://explorer.yourbrand.com"
export NODE_ENV="production"

# Staging
export CANONICAL_URL="https://staging-explorer.yourbrand.com" 
export NODE_ENV="development"
export SITE_TITLE="YourBrand Explorer (Staging)"
```

## Testing Your Customization

### Local Testing

```bash
# Test build
./build.sh your-flavor

# Start dev server with your flavor
API_URL=http://localhost:8332/ npm run dev-server

# Or test with static files
cd dist && python3 -m http.server 8000
```

### Validation Checklist

- [ ] Site loads correctly
- [ ] All custom assets load (logo, favicon, images)
- [ ] Colors and theming appear correct
- [ ] Navigation menu works
- [ ] Footer links are functional  
- [ ] Social meta tags are correct
- [ ] Mobile responsiveness maintained
- [ ] API endpoints respond correctly
- [ ] Search functionality works
- [ ] Transaction and block pages display properly

## Best Practices

1. **Version Control**: Keep your flavor configurations in version control
2. **Asset Optimization**: Optimize images for web (WebP, appropriate sizes)
3. **Performance**: Test performance impact of custom CSS
4. **Accessibility**: Ensure custom styling maintains accessibility
5. **Testing**: Test across different browsers and devices
6. **Documentation**: Document your custom configuration for your team
7. **Backup**: Keep backups of your flavor configurations
8. **Updates**: Plan for updating base explorer while maintaining customizations

## Examples

### Minimal Flavor

For a simple rebrand with just title and colors:

```bash
#!/bin/bash
export SITE_TITLE='My Crypto Explorer'
export SITE_FOOTER='© 2025 My Company'
export CUSTOM_CSS="$CUSTOM_CSS flavors/my-flavor/simple.css"
```

### Corporate Flavor

For a professional corporate setup:

```bash
#!/bin/bash
export SITE_TITLE='CorporateCoin Explorer'
export SITE_DESC='Official blockchain explorer for CorporateCoin network'
export SITE_FOOTER='© 2025 CorporateCoin Inc. All rights reserved.'
export MENU_ITEMS='{"Explorer": "/", "About": "https://corporatecoin.com/about", "Contact": "https://corporatecoin.com/contact"}'
export HEAD_HTML='<link rel="stylesheet" href="/corporate-theme.css">'
export TERMS="https://corporatecoin.com/terms"
export PRIVACY="https://corporatecoin.com/privacy"
```

### Community Project Flavor

For open-source community projects:

```bash
#!/bin/bash
export SITE_TITLE='CommunityChain Explorer'
export SITE_DESC='Community-driven explorer for the CommunityChain network'
export SITE_FOOTER='Built by the community, for the community'
export FOOTER_LINKS='{"/img/github.svg": "https://github.com/communitychain", "/img/discord.svg": "https://discord.gg/communitychain"}'
export MENU_ITEMS='{"Explorer": "/", "GitHub": "https://github.com/communitychain", "Docs": "https://docs.communitychain.org"}'
```

---

For deployment instructions, see [DEPLOYMENT.md](DEPLOYMENT.md).