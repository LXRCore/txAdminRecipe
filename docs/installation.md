```
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗ ██████╗ ███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██╔═══██╗██╔══██╗██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██████╔╝█████╗  
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██╔══██╗██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║      ╚██████╗╚██████╔╝██║  ██║███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
```

# 🐺 Installation Guide - LXR-Core txAdmin Recipe

**Step-by-Step Deployment Instructions**

═══════════════════════════════════════════════════════════════════════════════

## Prerequisites

Before starting, ensure you have:

- ✅ **RedM Server Build** - Download from https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/ (Linux) or Windows equivalent
- ✅ **txAdmin** - Included with server build or install separately
- ✅ **MySQL/MariaDB** - Version 8.0+ (MySQL) or 10.6+ (MariaDB)
- ✅ **Server License Key** - Get from https://keymaster.fivem.net
- ✅ **Basic Server Knowledge** - Understanding of server configuration

═══════════════════════════════════════════════════════════════════════════════

## Method 1: txAdmin Recipe Deployment (Recommended)

This is the easiest and fastest way to deploy an LXR-Core server.

### Step 1: Start txAdmin

#### On Linux:
```bash
cd /path/to/server
./run.sh
```

#### On Windows:
```cmd
cd C:\path\to\server
FXServer.exe
```

### Step 2: Access txAdmin Interface

1. Open your web browser
2. Navigate to `http://localhost:40120` (or your server IP)
3. If first time, create an admin account

### Step 3: Create New Server

1. Click **"New Server"** or **"Server Deployer"**
2. Choose **"Popular Templates"** OR **"Custom Repository"**

### Step 4: Configure Recipe

#### Option A: Popular Templates (if available)
1. Search for **"LXR-Core"**
2. Select **"LXR-Core Framework RedM"**
3. Click **"Next"**

#### Option B: Custom Repository
1. Select **"Custom Repository"**
2. Enter repository URL: `https://github.com/LXRCore/txAdminRecipe`
3. Select branch: `main`
4. Recipe file: `lxrcore.yaml`
5. Click **"Next"**

### Step 5: Database Configuration

Enter your database credentials:

```
Database Host: localhost (or your DB server IP)
Database Port: 3306
Database Name: lxrcore (or your preferred name)
Database User: root (or your DB user)
Database Password: your_password
```

**Important Notes:**
- Database will be created automatically if it doesn't exist
- User must have CREATE, ALTER, INSERT, UPDATE, DELETE privileges
- For production, create a dedicated database user (not root)

### Step 6: Server Configuration

Configure your server settings:

```
Server Name: Your Server Name
Max Players: 32 (recommended, adjust as needed)
Server License Key: your-key-from-keymaster
```

### Step 7: Start Deployment

1. Review all settings
2. Click **"Run Recipe"** or **"Deploy"**
3. Wait for deployment to complete (5-15 minutes depending on connection)
4. Monitor progress in the console

### Step 8: First Launch

1. Once deployment is complete, click **"Start Server"**
2. Monitor server console for any errors
3. Wait for all resources to load (may take 1-2 minutes)
4. Look for "Server started" or similar message

### Step 9: Connect to Server

1. Open RedM
2. Press F8 to open console
3. Type: `connect your-server-ip:30120`
4. Or add to favorites: Direct Connect → `your-server-ip:30120`

### Step 10: Post-Installation

1. **Test Connection** - Verify you can connect and load in
2. **Create Character** - Test character creation system
3. **Check Console** - Monitor for errors or warnings
4. **Configure Resources** - Customize configs as needed

═══════════════════════════════════════════════════════════════════════════════

## Method 2: Manual Installation

For advanced users who want more control.

### Step 1: Prepare Server Directory

```bash
mkdir /path/to/server
cd /path/to/server
mkdir resources
```

### Step 2: Download Server Files

Download RedM server build:
```bash
wget https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/[BUILD-ID]/fx.tar.xz
tar xf fx.tar.xz
```

### Step 3: Download Recipe Files

```bash
git clone https://github.com/LXRCore/txAdminRecipe.git tmp/recipe
cp tmp/recipe/server.cfg ./server.cfg
cp tmp/recipe/lxrcore.sql ./lxrcore.sql
```

### Step 4: Setup Database

```bash
mysql -u root -p

CREATE DATABASE lxrcore CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'lxrcore'@'localhost' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON lxrcore.* TO 'lxrcore'@'localhost';
FLUSH PRIVILEGES;
USE lxrcore;
SOURCE lxrcore.sql;
EXIT;
```

### Step 5: Download Standalone Resources

```bash
cd resources
mkdir [cfx-default] [standalone] [lxr]

# CFX Default Resources
cd [cfx-default]
git clone https://github.com/citizenfx/cfx-server-data.git tmp
mv tmp/resources/* ./
rm -rf tmp

# oxmysql
cd ../[standalone]
wget https://github.com/overextended/oxmysql/releases/latest/download/oxmysql.zip
unzip oxmysql.zip -d oxmysql
rm oxmysql.zip

# Other standalone resources
git clone https://github.com/LXRCore/connectqueue.git
git clone https://github.com/LXRCore/progressbar.git
git clone https://github.com/LXRCore/safecracker.git
git clone https://github.com/LXRCore/PolyZone.git
git clone https://github.com/AvarianKnight/pma-voice.git
git clone https://github.com/LXRCore/menuv.git
git clone https://github.com/LXRCore/mediccamp.git
```

### Step 6: Download LXR-Core Resources

```bash
cd ../[lxr]

# Core resources
git clone https://github.com/LXRCore/lxr-core.git
git clone https://github.com/LXRCore/lxr-multicharacter.git
git clone https://github.com/LXRCore/lxr-inventory.git
git clone https://github.com/LXRCore/lxr-hud.git

# Additional resources (see lxrcore.yaml for complete list)
git clone https://github.com/LXRCore/lxr-adminmenu.git
git clone https://github.com/LXRCore/lxr-ambulancejob.git
git clone https://github.com/LXRCore/lxr-banking.git
# ... continue with all resources from lxrcore.yaml
```

### Step 7: Configure server.cfg

Edit `server.cfg` and set:

```bash
# Server Identity
set sv_hostname "Your Server Name"
set sv_licenseKey "your-key-from-keymaster"
set sv_maxclients 32

# MySQL Connection
set mysql_connection_string "mysql://lxrcore:your_password@localhost/lxrcore?charset=utf8mb4"

# Steam Web API Key (optional but recommended)
set steam_webApiKey "your-steam-api-key"
```

### Step 8: Start Server

```bash
cd /path/to/server
./run.sh +exec server.cfg
```

Or on Windows:
```cmd
FXServer.exe +exec server.cfg
```

═══════════════════════════════════════════════════════════════════════════════

## Post-Installation Configuration

### 1. Configure lxr-core

Edit `resources/[lxr]/lxr-core/config.lua`:

```lua
Config.ServerName = "Your Server Name"
Config.ServerLogo = "https://yourserver.com/logo.png"

Config.Money = {
    MoneyTypes = {'cash', 'bank'},
    DontAllowMinus = {'cash', 'bank'},
    PayCheckTimeOut = 30, -- minutes
    PayCheckSociety = false
}
```

### 2. Configure Database in Resources

Most resources auto-detect the database connection, but verify in:
- `lxr-core/server/main.lua`
- Individual resource configs

### 3. Setup Admin Permissions

Connect to your server, then in server console:
```
add_ace group.admin command.admin allow
add_principal identifier.steam:YOUR_STEAM_HEX group.admin
```

Or edit database directly:
```sql
INSERT INTO permissions (steam, permission) VALUES ('steam:YOUR_STEAM_HEX', 'admin');
```

### 4. Configure Jobs

Edit `lxr-core/shared/jobs.lua` to add/modify jobs:

```lua
QBShared.Jobs = {
    ['police'] = {
        label = 'Law Enforcement',
        defaultDuty = true,
        grades = {
            ['0'] = { name = 'Recruit', payment = 50 },
            ['1'] = { name = 'Officer', payment = 75 },
            -- ...
        }
    },
    -- Add more jobs
}
```

### 5. Configure Shops

Edit `lxr-shops/config.lua` to customize:
- Shop locations
- Items available
- Prices
- Blips on map

### 6. Test Each System

Systematically test:
- ✅ Character creation and selection
- ✅ Inventory system
- ✅ Job system and duty
- ✅ Banking and money
- ✅ Shops and purchasing
- ✅ Police/ambulance jobs
- ✅ Voice chat
- ✅ Targeting system

═══════════════════════════════════════════════════════════════════════════════

## Troubleshooting

### Server Won't Start

**Problem:** Server crashes or won't start

**Solutions:**
1. Check console for errors
2. Verify all resources exist in correct folders
3. Check server.cfg syntax
4. Ensure license key is valid
5. Check ports 30120 and 40120 are open

### Database Connection Failed

**Problem:** `Failed to connect to MySQL database`

**Solutions:**
1. Verify MySQL/MariaDB is running: `systemctl status mysql`
2. Check credentials in server.cfg
3. Test connection: `mysql -u username -p database_name`
4. Ensure user has correct privileges
5. Check MySQL bind-address in `/etc/mysql/my.cnf`

### Resources Not Loading

**Problem:** Resources show as "failed" or "not found"

**Solutions:**
1. Verify folder names match exactly (case-sensitive on Linux)
2. Check fxmanifest.lua syntax in each resource
3. Ensure dependencies are loaded before dependent resources
4. Check file permissions (Linux): `chmod -R 755 resources/`

### Players Can't Connect

**Problem:** Players get "Connection failed" or timeout

**Solutions:**
1. Check firewall allows port 30120 (UDP and TCP)
2. Verify server is actually running: `netstat -tulpn | grep 30120`
3. Check server.cfg has correct `endpoint_add_tcp/udp` lines
4. Ensure server IP is correct (use public IP for external access)
5. Check router port forwarding if behind NAT

### Character Creation Not Working

**Problem:** Stuck on character creation or errors

**Solutions:**
1. Check database tables exist: `SHOW TABLES;` in MySQL
2. Verify lxr-multicharacter is started
3. Check browser console (F12) for errors
4. Clear RedM cache: delete `%LocalAppData%\RedM\data\cache`

### Performance Issues

**Problem:** Server lag or low FPS

**Solutions:**
1. Check server resources: `top` or Task Manager
2. Reduce max players if needed
3. Disable debug modes in resource configs
4. Optimize database queries (add indexes)
5. Use SSD storage instead of HDD
6. Increase server RAM allocation

═══════════════════════════════════════════════════════════════════════════════

## Security Recommendations

After installation, implement these security measures:

### 1. Secure Database
```sql
-- Use strong password
ALTER USER 'lxrcore'@'localhost' IDENTIFIED BY 'V3ry$tr0ng!P@ssw0rd';

-- Restrict to localhost only
DELETE FROM mysql.user WHERE User='lxrcore' AND Host!='localhost';
FLUSH PRIVILEGES;
```

### 2. Secure txAdmin
- Change default admin password
- Enable two-factor authentication if available
- Restrict txAdmin port (40120) to trusted IPs only

### 3. Firewall Configuration
```bash
# UFW (Ubuntu/Debian)
ufw allow 30120/tcp
ufw allow 30120/udp
ufw allow 40120/tcp  # Only from trusted IPs
ufw enable

# Firewalld (CentOS/RHEL)
firewall-cmd --permanent --add-port=30120/tcp
firewall-cmd --permanent --add-port=30120/udp
firewall-cmd --reload
```

### 4. Regular Backups
```bash
# Database backup
mysqldump -u root -p lxrcore > lxrcore_backup_$(date +%Y%m%d).sql

# Resources backup
tar -czf resources_backup_$(date +%Y%m%d).tar.gz resources/
```

═══════════════════════════════════════════════════════════════════════════════

## Updating

To update your server:

### Update Framework
```bash
cd resources/[lxr]/lxr-core
git pull origin main
```

### Update All Resources
```bash
cd resources/[lxr]
for dir in */; do
    cd "$dir"
    git pull origin main
    cd ..
done
```

### Update Database Schema
Check for new migrations and apply them:
```bash
mysql -u lxrcore -p lxrcore < new_migration.sql
```

Always backup before updating!

═══════════════════════════════════════════════════════════════════════════════

## Support

Need help with installation?

- 💬 **Discord:** https://discord.gg/CrKcWdfd3A
- 📖 **Documentation:** `/docs` directory
- 🐛 **GitHub Issues:** Report installation problems
- 🌐 **Website:** https://www.wolves.land

═══════════════════════════════════════════════════════════════════════════════

**Developer:** iBoss21 / The Lux Empire  
**Server:** The Land of Wolves 🐺  
**© 2026 wolves.land | All Rights Reserved**

═══════════════════════════════════════════════════════════════════════════════
