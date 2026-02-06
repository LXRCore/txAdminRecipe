```
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗ ██████╗ ███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██╔═══██╗██╔══██╗██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██████╔╝█████╗  
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██╔══██╗██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║      ╚██████╗╚██████╔╝██║  ██║███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
```

# 🐺 txAdminRecipe for LXR-Core RedM Framework

**The Land of Wolves Official txAdmin Deployment Recipe**

> *ისტორია ცოცხლდება აქ!* (History Lives Here!)

═══════════════════════════════════════════════════════════════════════════════

## 📋 Overview

This **txAdminRecipe** provides a production-grade, streamlined deployment process for setting up a **RedM server** using the **LXR-Core Framework**. Designed for serious roleplay servers, this recipe automates the installation of all core resources, dependencies, and configurations needed to launch a fully-functional RedM server.

**Built for:** The Land of Wolves 🐺 | Georgian RP Server  
**Author:** iBoss21 / The Lux Empire  
**Framework:** LXR-Core (Primary), RSG-Core (Compatible), VORP (Supported)

═══════════════════════════════════════════════════════════════════════════════

## 🚀 Features

- **🎯 One-Click Deployment** - Full server setup via txAdmin interface
- **🔧 Pre-Configured Resources** - All LXR-Core resources included and configured
- **💾 Database Auto-Setup** - Automatic database schema creation
- **📦 Dependency Management** - Standalone resources automatically installed
- **🔐 Production Ready** - Security, performance, and optimization built-in
- **🐺 Wolves.Land Branded** - Official branding and configuration standards
- **📚 Comprehensive Documentation** - Full docs for setup, configuration, and customization
- **🌍 Multi-Framework Support** - Template resources support LXR, RSG, and VORP cores

═══════════════════════════════════════════════════════════════════════════════

## 📦 What's Included

### Core Framework
- **lxr-core** - Primary framework
- **lxr-multicharacter** - Character selection system
- **lxr-hud** - Player HUD interface

### Essential Systems
- **lxr-inventory** - Advanced inventory system
- **lxr-target** - Interaction targeting system
- **lxr-menu** - Menu framework
- **lxr-input** - Input handling

### Job Systems
- **lxr-policejob** - Law enforcement system
- **lxr-ambulancejob** - Medical services
- **lxr-management** - Business management

### Economy & Gameplay
- **lxr-shops** - Shop system
- **lxr-banking** - Banking system
- **lxr-mining** - Mining job
- **lxr-hunting** - Hunting system
- **lxr-farming** - Farming system
- **lxr-moonshine** - Moonshine production

### Utilities
- **lxr-weathersync** - Weather synchronization
- **lxr-spawn** - Spawn management
- **lxr-stable** - Horse/mount system
- **lxr-clothing** - Clothing system
- **lxr-doorlock** - Door locking system

### Standalone Dependencies
- **oxmysql** - Database connector
- **pma-voice** - Voice chat
- **menuv** - Menu library
- **PolyZone** - Zone system
- **progressbar** - Progress bars
- **connectqueue** - Connection queue

═══════════════════════════════════════════════════════════════════════════════

## 🛠️ Requirements

- **txAdmin** (latest version)
- **RedM Server** (latest build)
- **MySQL Database** (MySQL 8.0+ or MariaDB 10.6+)
- **Server Resources** (minimum 4GB RAM recommended)

═══════════════════════════════════════════════════════════════════════════════

## 📥 Installation

### Method 1: txAdmin Recipe (Recommended)

1. Open **txAdmin** web interface
2. Click **"New Server"** or **"Recipe Deployer"**
3. Select **"Popular Templates"** or **"Custom Repository"**
4. Enter repository URL: `https://github.com/LXRCore/txAdminRecipe`
5. Select branch: `main`
6. Click **"Next"** and follow the setup wizard
7. Configure your database credentials
8. Wait for the deployment to complete
9. Start your server and enjoy!

### Method 2: Manual Installation

See [Installation Documentation](/docs/installation.md) for detailed manual setup instructions.

═══════════════════════════════════════════════════════════════════════════════

## 📖 Documentation

Comprehensive documentation is available in the `/docs` directory:

- **[Overview](/docs/overview.md)** - Complete system overview
- **[Installation](/docs/installation.md)** - Step-by-step installation guide
- **[Configuration](/docs/configuration.md)** - Configuration reference
- **[Frameworks](/docs/frameworks.md)** - Multi-framework support guide
- **[Events](/docs/events.md)** - Event system and adapter documentation
- **[Security](/docs/security.md)** - Security best practices
- **[Performance](/docs/performance.md)** - Performance optimization
- **[Screenshots](/docs/screenshots.md)** - Required screenshots checklist

═══════════════════════════════════════════════════════════════════════════════

## 🎨 Template Resource

This repository includes a **production-ready template resource** (`/template-resource`) that demonstrates the wolves.land coding standards:

- ✅ Branded ASCII headers on all files
- ✅ Multi-framework auto-detection
- ✅ Unified framework adapter/bridge
- ✅ Runtime resource name protection
- ✅ Security and anti-abuse measures
- ✅ Performance optimizations
- ✅ Comprehensive configuration system
- ✅ Complete documentation

Use this template as a reference when creating or converting resources to wolves.land standards.

═══════════════════════════════════════════════════════════════════════════════

## 🔧 Configuration

After deployment, customize your server by editing:

- **`server.cfg`** - Server settings, license key, max players
- **`resources/[lxr]/lxr-core/config.lua`** - Core framework configuration
- **Individual resource configs** - Each resource has its own config.lua

All configuration files follow the wolves.land branding and organization standards.

═══════════════════════════════════════════════════════════════════════════════

## 🌐 Server Information

**Server:** The Land of Wolves 🐺  
**Tagline:** Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!  
**Type:** Serious Hardcore Roleplay  
**Access:** Discord & Whitelisted  

**Links:**
- 🌍 Website: https://www.wolves.land
- 💬 Discord: https://discord.gg/CrKcWdfd3A
- 📦 GitHub: https://github.com/iBoss21
- 🛒 Store: https://theluxempire.tebex.io
- 🎮 Server Listing: https://servers.redm.net/servers/detail/8gj7eb

═══════════════════════════════════════════════════════════════════════════════

## 🤝 Support

Need help? Reach out through:

1. **Discord**: Join our [Discord server](https://discord.gg/CrKcWdfd3A) for community support
2. **GitHub Issues**: Report bugs or request features via GitHub Issues
3. **Documentation**: Check the `/docs` folder for comprehensive guides

═══════════════════════════════════════════════════════════════════════════════

## 📜 License

© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved

This recipe and template resources are provided for use with The Land of Wolves server and LXR-Core framework. See [LICENSE](LICENSE) for details.

═══════════════════════════════════════════════════════════════════════════════

## 🏆 Credits

**Script Author:** iBoss21 / The Lux Empire  
**Framework:** LXR-Core Development Team  
**Server:** The Land of Wolves  
**Community:** wolves.land community

═══════════════════════════════════════════════════════════════════════════════

## 🔖 Tags

`RedM` `Georgian` `SeriousRP` `Whitelist` `Economy` `RPG` `txAdmin` `LXR-Core` `RSG-Core` `VORP` `Framework` `Recipe` `Deployment`

═══════════════════════════════════════════════════════════════════════════════

🐺 **wolves.land** - Where History Lives! - *ისტორია ცოცხლდება აქ!*
