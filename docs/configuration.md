```
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗ ██████╗ ███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██╔═══██╗██╔══██╗██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██████╔╝█████╗  
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██╔══██╗██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║      ╚██████╗╚██████╔╝██║  ██║███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
```

# 🐺 Configuration Guide - LXR-Core Resources

**Comprehensive Configuration Reference**

═══════════════════════════════════════════════════════════════════════════════

## Configuration Philosophy

All wolves.land resources follow a **standardized configuration pattern**:

- 🎯 **Centralized** - All settings in `config.lua`
- 📝 **Documented** - Inline comments explain every option
- 🎨 **Branded** - Consistent structure with section banners
- 🔐 **Secure** - Security settings included
- ⚡ **Optimized** - Performance options available
- 🌍 **Multi-Framework** - Framework auto-detection

═══════════════════════════════════════════════════════════════════════════════

## Standard Configuration Structure

Every resource config follows this pattern:

### 1. Resource Name Protection
```lua
-- Runtime check to ensure correct folder name
local REQUIRED_RESOURCE_NAME = "lxr-resourcename"
local currentResourceName = GetCurrentResourceName()

if currentResourceName ~= REQUIRED_RESOURCE_NAME then
    error(string.format([[
        ═══════════════════════════════════════════════════════════════════
        ❌ CRITICAL ERROR: RESOURCE NAME MISMATCH ❌
        ═══════════════════════════════════════════════════════════════════
        Expected: %s
        Got: %s
        
        Rename the folder to "%s" to continue.
        🐺 wolves.land - The Land of Wolves
        ═══════════════════════════════════════════════════════════════════
    ]], REQUIRED_RESOURCE_NAME, currentResourceName, REQUIRED_RESOURCE_NAME))
end
```

### 2. Server Information
```lua
Config.ServerInfo = {
    name = 'The Land of Wolves 🐺',
    tagline = 'Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!',
    description = 'ისტორია ცოცხლდება აქ!', -- History Lives Here!
    type = 'Serious Hardcore Roleplay',
    access = 'Discord & Whitelisted',
    website = 'https://www.wolves.land',
    discord = 'https://discord.gg/CrKcWdfd3A',
    github = 'https://github.com/iBoss21',
    store = 'https://theluxempire.tebex.io',
    serverListing = 'https://servers.redm.net/servers/detail/8gj7eb',
    developer = 'iBoss21 / The Lux Empire',
    tags = {'RedM', 'Georgian', 'SeriousRP', 'Whitelist'}
}
```

### 3. Framework Configuration
```lua
Config.Framework = 'auto' -- or: 'lxr-core', 'rsg-core', 'vorp_core', etc.

Config.FrameworkSettings = {
    ['lxr-core'] = {
        resource = 'lxr-core',
        notifications = 'ox_lib',
        inventory = 'lxr-inventory',
        target = 'ox_target'
    },
    -- Other frameworks...
}
```

### 4. Language Settings
```lua
Config.Lang = 'en' -- Language code
```

### 5. General Settings
```lua
Config.General = {
    enabled = true,
    debug = false,
    -- Feature flags
}
```

### 6. Keys (RedM Key Hashes)
```lua
Config.Keys = {
    interact = 0x760A9C6F,  -- G
    cancel = 0x156F7119,    -- BACKSPACE
    confirm = 0xC7B5340A,   -- ENTER
}
```

### 7. Cooldowns / Timing
```lua
Config.Cooldowns = {
    globalCooldown = 300000,  -- 5 minutes in ms
    actionTimeout = 10000,    -- 10 seconds
}
```

### 8. Economy / Rewards
```lua
Config.Economy = {
    currency = 'cash',
    prices = {
        item1 = 100,
        item2 = 200,
    },
    rewards = {
        min = 10,
        max = 50,
    }
}
```

### 9. Security Settings
```lua
Config.Security = {
    enabled = true,
    maxDistance = 5.0,
    validateServerSide = true,
    rateLimitPerMinute = 10,
    logSuspicious = true,
}
```

### 10. Performance Settings
```lua
Config.Performance = {
    cacheEnabled = true,
    updateInterval = 1000,
    maxTrackedEntities = 50,
    cleanupInterval = 300000,
}
```

### 11. Debug Settings
```lua
Config.Debug = false -- Enable debug logging
```

### 12. End of Config Banner + Startup Print
```lua
-- End of configuration banner
print([[
    ═══════════════════════════════════════════════════════════════════
    🐺 RESOURCE NAME - SUCCESSFULLY LOADED
    ═══════════════════════════════════════════════════════════════════
    Version:     1.0.0
    Framework:   Auto-detect
    Status:      Ready
    ═══════════════════════════════════════════════════════════════════
]])
```

═══════════════════════════════════════════════════════════════════════════════

## Core Framework Configuration

### lxr-core/config.lua

```lua
Config.ServerName = 'The Land of Wolves'
Config.ServerLogo = 'https://www.wolves.land/logo.png'

-- Money Configuration
Config.Money = {
    MoneyTypes = {'cash', 'bank'},
    DontAllowMinus = {'cash', 'bank'},
    PayCheckTimeOut = 30,
    PayCheckSociety = false
}

-- Player Configuration
Config.Player = {
    MaxPlayers = GetConvarInt('sv_maxclients', 32),
    ReviveRewards = 200,
    EnablePVP = true,
    EnableHunger = true,
    EnableThirst = true,
}

-- Job Configuration
Config.DefaultJob = 'unemployed'
Config.DefaultGang = 'none'

-- Vehicle Configuration
Config.UseVehicleKeys = true
Config.VehicleDespawnTime = 300000 -- 5 minutes
```

═══════════════════════════════════════════════════════════════════════════════

## Key Configuration Files by Resource

### lxr-shops

**Purpose:** Configure shop locations, items, and prices

**Key Settings:**
```lua
Config.Shops = {
    ['general'] = {
        label = 'General Store',
        locations = {
            vector3(2825.84, -1317.08, 46.75), -- Valentine
            vector3(-324.64, 803.68, 117.88),  -- Strawberry
        },
        items = {
            [1] = { name = 'bread', price = 2, amount = 50 },
            [2] = { name = 'water', price = 1, amount = 50 },
        },
        blip = {
            sprite = 1475976774,
            color = 'BLIP_MODIFIER_MP_COLOR_8'
        }
    }
}
```

### lxr-banking

**Purpose:** Banking system configuration

**Key Settings:**
```lua
Config.BankLocations = {
    ['valentine'] = {
        coords = vector3(-308.37, 776.48, 118.7),
        blip = true
    }
}

Config.ATMModels = {
    `prop_atm_01`,
    `prop_atm_02`,
}

Config.Interest = {
    enabled = true,
    rate = 0.01, -- 1% per interval
    interval = 3600000 -- 1 hour
}
```

### lxr-inventory

**Purpose:** Inventory system settings

**Key Settings:**
```lua
Config.MaxWeight = 120000 -- grams
Config.MaxSlots = 40

Config.ItemWeights = {
    ['bread'] = 200,
    ['water'] = 500,
    ['weapon_pistol'] = 1000,
}

Config.UseTarget = true
Config.CloseOnClick = false
```

### lxr-policejob

**Purpose:** Law enforcement system

**Key Settings:**
```lua
Config.PoliceStations = {
    ['valentine'] = {
        coords = vector3(-275.96, 807.66, 119.38),
        blip = true,
        armory = vector3(-278.08, 807.01, 119.38),
        vehicles = vector3(-268.41, 803.97, 118.38),
        jail = vector3(-278.47, 809.68, 119.38),
    }
}

Config.JailPrices = {
    [1] = 500,  -- Minor crime
    [2] = 1000, -- Moderate crime
    [3] = 2500, -- Serious crime
}

Config.JailTimes = {
    [1] = 5,  -- 5 minutes
    [2] = 10, -- 10 minutes
    [3] = 20, -- 20 minutes
}
```

### lxr-ambulancejob

**Purpose:** Medical services configuration

**Key Settings:**
```lua
Config.Hospitals = {
    ['valentine'] = {
        coords = vector3(-282.43, 809.58, 119.38),
        respawn = vector3(-283.55, 807.93, 119.38),
        blip = true
    }
}

Config.RespawnPoint = vector3(-1035.71, -2733.20, 25.75) -- Default respawn
Config.RespawnTime = 300 -- seconds
Config.ReviveReward = 50
Config.MinimumDoctors = 2
Config.MaxRevives = 3 -- per incident
```

### lxr-hud

**Purpose:** HUD display settings

**Key Settings:**
```lua
Config.ShowHealth = true
Config.ShowStamina = true
Config.ShowHunger = true
Config.ShowThirst = true
Config.ShowCash = true
Config.ShowJob = true
Config.ShowCompass = true
Config.ShowStreetName = true
Config.ShowTime = true

Config.HUDPosition = {
    x = 0.5,
    y = 0.95
}
```

### lxr-target

**Purpose:** Interaction targeting system

**Key Settings:**
```lua
Config.RaycastDistance = 5.0
Config.UseTraceFlag = 511 -- All entities
Config.DebugPoly = false
Config.SuccessSound = true

Config.DefaultOptions = {
    distance = 2.5,
    offset = vector3(0.0, 0.0, 0.0),
    debugPoly = false
}
```

═══════════════════════════════════════════════════════════════════════════════

## Database Configuration

### MySQL Connection String

Set in `server.cfg`:

```bash
# MySQL/MariaDB Connection
set mysql_connection_string "mysql://username:password@localhost/database?charset=utf8mb4"
```

### Connection String Formats

**Basic:**
```
mysql://user:password@host/database
```

**With port:**
```
mysql://user:password@host:3306/database
```

**With options:**
```
mysql://user:password@host/database?charset=utf8mb4&connectTimeout=10000
```

**Unix socket (Linux):**
```
mysql://user:password@localhost/database?socket=/var/run/mysqld/mysqld.sock
```

### Database Tables

LXR-Core creates these tables:
- `players` - Player data
- `playerskins` - Character appearance
- `player_jobs` - Job data (if using standalone jobs)
- `player_gangs` - Gang data
- `player_vehicles` - Owned vehicles
- `player_houses` - Owned properties
- `player_items` - Inventory items
- `server_logs` - Action logs
- `bans` - Ban list

═══════════════════════════════════════════════════════════════════════════════

## Environment Variables

### server.cfg Essential Settings

```bash
# Server Identity
set sv_hostname "The Land of Wolves 🐺 | Georgian RP"
set sv_projectName "LXR-Core Framework"
set sv_projectDesc "Serious Hardcore Roleplay Server"
set tags "redm, roleplay, lxr-core, wolves.land, georgian"

# License and Authentication
set sv_licenseKey "YOUR_LICENSE_KEY_HERE"
set steam_webApiKey "YOUR_STEAM_API_KEY_HERE"

# Server Settings
set sv_maxclients 32
set sv_endpointprivacy true
set sv_enforceGameBuild 1491

# OneSync (Required)
set onesync on

# Connection Settings
set sv_timeout 60000
set sv_authMaxVariance 1
set sv_authMinTrust 5

# Script Hook (Disable for security)
set sv_scriptHookAllowed 0

# MySQL Connection
set mysql_connection_string "mysql://lxrcore:password@localhost/lxrcore?charset=utf8mb4"
set mysql_slow_query_warning 150
set mysql_debug false

# Performance
set sv_filterRequestControl 4
set sv_maxUploadMbps 50
```

═══════════════════════════════════════════════════════════════════════════════

## Permission Configuration

### Admin Permissions

Add to `server.cfg`:

```bash
# Admin Permissions
add_ace group.admin command.admin allow
add_ace group.admin command.kick allow
add_ace group.admin command.ban allow
add_ace group.admin command.unban allow
add_ace group.admin command.god allow
add_ace group.admin command.noclip allow

# Add admins
add_principal identifier.steam:STEAM_HEX group.admin
add_principal identifier.license:LICENSE_ID group.admin
```

### Moderator Permissions

```bash
# Moderator Permissions
add_ace group.mod command.kick allow
add_ace group.mod command.warn allow
add_principal identifier.steam:STEAM_HEX group.mod
```

### Custom Permissions

In `lxr-core/server/permissions.lua`:

```lua
QBCore.Functions.AddPermission = function(source, permission)
    -- Custom permission logic
end

QBCore.Functions.HasPermission = function(source, permission)
    -- Check permission
end
```

═══════════════════════════════════════════════════════════════════════════════

## Customization Tips

### 1. Change Server Branding

Edit each `config.lua`:
```lua
Config.ServerInfo.name = 'Your Server Name'
Config.ServerInfo.website = 'https://yoursite.com'
Config.ServerInfo.discord = 'https://discord.gg/yourinvite'
```

### 2. Adjust Economy

Scale all prices:
```lua
Config.Economy.multiplier = 1.5 -- 1.5x prices
```

### 3. Enable/Disable Features

Use feature flags:
```lua
Config.EnableHunger = false -- Disable hunger system
Config.EnablePVP = false -- Disable PVP
```

### 4. Adjust Difficulty

```lua
Config.RespawnTime = 600 -- Longer respawn (10 min)
Config.JailTimes = {[1] = 10, [2] = 20, [3] = 40} -- Longer jail
```

### 5. Custom Locations

Add your own locations:
```lua
Config.CustomLocations = {
    ['mycity'] = {
        coords = vector3(x, y, z),
        label = 'My City',
        blip = true
    }
}
```

═══════════════════════════════════════════════════════════════════════════════

## Configuration Best Practices

1. ✅ **Always backup before editing**
2. ✅ **Test changes on development server first**
3. ✅ **Comment your changes for future reference**
4. ✅ **Keep branding consistent across all resources**
5. ✅ **Use the same currency across all resources**
6. ✅ **Maintain consistent cooldowns and timing**
7. ✅ **Document custom changes in a separate file**
8. ✅ **Use version control (git) for configs**

═══════════════════════════════════════════════════════════════════════════════

## Validation

After making configuration changes:

1. **Syntax Check** - Ensure Lua syntax is valid
2. **Server Start** - Check console for errors
3. **In-Game Test** - Verify changes work as expected
4. **Performance Test** - Monitor server performance
5. **Rollback Plan** - Keep backups for quick rollback

═══════════════════════════════════════════════════════════════════════════════

## Support

Need help with configuration?

- 📖 **Template Resource:** See `/template-resource/config.lua` for examples
- 💬 **Discord:** https://discord.gg/CrKcWdfd3A
- 🐛 **Issues:** GitHub Issues for problems
- 🌐 **Website:** https://www.wolves.land

═══════════════════════════════════════════════════════════════════════════════

**Developer:** iBoss21 / The Lux Empire  
**Server:** The Land of Wolves 🐺  
**© 2026 wolves.land | All Rights Reserved**

═══════════════════════════════════════════════════════════════════════════════
