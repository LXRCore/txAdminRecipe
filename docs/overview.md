```
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗ ██████╗ ███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██╔═══██╗██╔══██╗██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██████╔╝█████╗  
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██╔══██╗██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║      ╚██████╗╚██████╔╝██║  ██║███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
```

# 🐺 Overview - LXR-Core txAdmin Recipe

**The Land of Wolves Official Deployment System**

═══════════════════════════════════════════════════════════════════════════════

## Purpose

The **LXR-Core txAdmin Recipe** is a comprehensive, production-grade deployment solution designed for serious RedM roleplay servers. It automates the entire server setup process, from database initialization to resource configuration, ensuring a consistent, secure, and optimized deployment every time.

═══════════════════════════════════════════════════════════════════════════════

## What is a txAdmin Recipe?

A **txAdmin Recipe** is an automated deployment configuration that:

- 📥 Downloads and organizes all required resources
- 💾 Sets up database schemas automatically
- ⚙️ Configures server settings and resource parameters
- 🔐 Implements security best practices
- 🎨 Maintains consistent branding and structure
- 📚 Includes comprehensive documentation

Think of it as a "one-click installer" for your entire RedM server infrastructure.

═══════════════════════════════════════════════════════════════════════════════

## Architecture Overview

### Directory Structure

```
server/
├── resources/
│   ├── [cfx-default]/      # Default CFX resources
│   ├── [standalone]/       # Framework-independent resources
│   │   ├── oxmysql/
│   │   ├── pma-voice/
│   │   ├── menuv/
│   │   ├── PolyZone/
│   │   ├── progressbar/
│   │   └── connectqueue/
│   └── [lxr]/             # LXR-Core framework resources
│       ├── lxr-core/
│       ├── lxr-multicharacter/
│       ├── lxr-inventory/
│       ├── lxr-hud/
│       ├── lxr-target/
│       ├── lxr-menu/
│       ├── lxr-shops/
│       ├── lxr-banking/
│       ├── lxr-policejob/
│       ├── lxr-ambulancejob/
│       └── [... additional resources]
├── server.cfg
├── myLogo.png
└── txData/
```

### Resource Organization

Resources are organized into three categories:

1. **[cfx-default]** - Core FiveM/RedM resources (chat, spawnmanager, etc.)
2. **[standalone]** - Framework-independent utilities and libraries
3. **[lxr]** - LXR-Core framework and related resources

═══════════════════════════════════════════════════════════════════════════════

## Core Components

### 1. LXR-Core Framework

The heart of the system, providing:
- Player management and character system
- Job and gang systems
- Inventory and economy
- Permission and admin systems
- Event and callback infrastructure

### 2. Standalone Dependencies

Essential libraries that all resources depend on:
- **oxmysql** - Database connector (replaces mysql-async)
- **pma-voice** - Voice chat system with proximity, radio, phone
- **menuv** - Menu framework
- **PolyZone** - Zone and targeting system
- **progressbar** - Progress bar UI
- **connectqueue** - Connection queue with priority system

### 3. Gameplay Systems

#### Jobs & Economy
- **lxr-shops** - General stores, weapon shops, doctors
- **lxr-banking** - Banking system with accounts
- **lxr-management** - Business and employee management
- **lxr-mining** - Mining job with sellpoints
- **lxr-hunting** - Hunting and skinning system
- **lxr-farming** - Farming and crop system
- **lxr-moonshine** - Moonshine production

#### Emergency Services
- **lxr-policejob** - Law enforcement with evidence, jail, fines
- **lxr-ambulancejob** - Medical system with revive and hospital

#### Utilities
- **lxr-weathersync** - Synchronized weather system
- **lxr-spawn** - Spawn selection
- **lxr-stable** - Horse and mount management
- **lxr-clothing** - Outfit and barber system
- **lxr-doorlock** - Door locking system
- **lxr-interiors** - Interior system
- **lxr-smallresources** - Collection of small utilities

#### User Interface
- **lxr-hud** - Player HUD with health, stamina, status
- **lxr-menu** - Unified menu system
- **lxr-input** - Input dialog system
- **lxr-scoreboard** - Player list

#### Core Systems
- **lxr-multicharacter** - Character selection
- **lxr-inventory** - Advanced inventory
- **lxr-target** - Interaction targeting
- **lxr-weapons** - Weapon handling
- **lxr-lockpick** - Lockpicking minigame
- **lxr-adminmenu** - Admin tools

═══════════════════════════════════════════════════════════════════════════════

## Deployment Process

The recipe executes the following steps automatically:

### Step 1: Download Recipe Files
- Downloads this repository to temporary directory
- Extracts server.cfg, database schema, and logo

### Step 2: Database Setup
- Connects to MySQL/MariaDB
- Executes schema creation script (lxrcore.sql)
- Creates tables for players, jobs, items, etc.

### Step 3: Download Standalone Resources
- Downloads CFX default resources
- Downloads oxmysql (latest release)
- Clones standalone repositories (voice, menu, polyzone, etc.)

### Step 4: Download LXR-Core Resources
- Clones all LXR-Core resources from GitHub
- Organizes them in [lxr] resource folder
- Maintains correct directory structure

### Step 5: Cleanup
- Removes temporary files
- Finalizes configuration

### Step 6: Ready to Start
- Server is fully configured
- All resources are loaded
- Database is initialized
- Ready for first launch

═══════════════════════════════════════════════════════════════════════════════

## System Requirements

### Minimum Requirements
- **CPU:** 2 cores @ 2.5GHz
- **RAM:** 4GB
- **Storage:** 10GB free space
- **OS:** Windows Server 2016+ or Linux (Ubuntu 18.04+)
- **Database:** MySQL 8.0+ or MariaDB 10.6+

### Recommended Requirements
- **CPU:** 4+ cores @ 3.0GHz+
- **RAM:** 8GB+
- **Storage:** 20GB+ SSD
- **OS:** Windows Server 2019+ or Linux (Ubuntu 20.04+)
- **Database:** MySQL 8.0+ with dedicated server
- **Network:** 100Mbps+ upload speed

═══════════════════════════════════════════════════════════════════════════════

## Security Features

The recipe implements multiple security layers:

- ✅ **Database Security** - Prepared statements, parameterized queries
- ✅ **Server Authority** - All validation server-side
- ✅ **Rate Limiting** - Cooldowns on repeatable actions
- ✅ **Distance Checks** - Validates player proximity
- ✅ **State Validation** - Verifies player state before actions
- ✅ **Anti-Cheat Integration** - Compatible with anti-cheat systems
- ✅ **Logging** - Comprehensive audit trails
- ✅ **Access Control** - Permission-based systems

See [Security Documentation](security.md) for details.

═══════════════════════════════════════════════════════════════════════════════

## Performance Optimizations

Built-in optimizations include:

- ⚡ **Tick Minimization** - Reduces server load
- ⚡ **Caching** - Reduces database queries
- ⚡ **Lazy Loading** - Loads resources only when needed
- ⚡ **Event Throttling** - Prevents event spam
- ⚡ **Client-Side Prediction** - Improves responsiveness
- ⚡ **Database Indexing** - Fast query performance
- ⚡ **Resource Monitoring** - Built-in performance tracking

See [Performance Documentation](performance.md) for details.

═══════════════════════════════════════════════════════════════════════════════

## Multi-Framework Support

While primarily designed for **LXR-Core**, the template resources support:

- **LXR-Core** (Primary) - Full support
- **RSG-Core** (Primary) - Full support
- **VORP Core** (Supported) - Compatible
- **RedEM:RP** (Optional) - If detected
- **QBR-Core** (Optional) - If detected
- **QR-Core** (Optional) - If detected
- **Standalone** (Fallback) - Basic functionality

See [Framework Documentation](frameworks.md) for details.

═══════════════════════════════════════════════════════════════════════════════

## Branding Standards

All resources follow the **wolves.land** branding standards:

- 🎨 ASCII art headers on every file
- 🎨 Branded section banners with █████ blocks
- 🎨 Consistent formatting and structure
- 🎨 Runtime resource name protection
- 🎨 Startup boot banners
- 🎨 wolves.land server information

These standards ensure:
- Professional appearance
- Easy navigation
- Consistent documentation
- Brand identity
- Quality assurance

═══════════════════════════════════════════════════════════════════════════════

## Next Steps

After understanding this overview:

1. Read [Installation Guide](installation.md) for deployment instructions
2. Review [Configuration Guide](configuration.md) for customization
3. Check [Framework Guide](frameworks.md) for multi-framework details
4. Study [Template Resource](/template-resource) for coding standards
5. Review [Security](security.md) and [Performance](performance.md) guides

═══════════════════════════════════════════════════════════════════════════════

## Support & Resources

- 📚 **Documentation:** `/docs` directory
- 💬 **Discord:** https://discord.gg/CrKcWdfd3A
- 🐛 **Issues:** GitHub Issues
- 🌐 **Website:** https://www.wolves.land
- 📦 **GitHub:** https://github.com/iBoss21

═══════════════════════════════════════════════════════════════════════════════

**Developer:** iBoss21 / The Lux Empire  
**Server:** The Land of Wolves 🐺  
**© 2026 wolves.land | All Rights Reserved**

═══════════════════════════════════════════════════════════════════════════════
