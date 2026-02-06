```
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗ ██████╗ ███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██╔═══██╗██╔══██╗██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██████╔╝█████╗  
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██╔══██╗██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║      ╚██████╗╚██████╔╝██║  ██║███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
```

# 🔧 Multi-Framework Support - LXR-Core txAdmin Recipe

**The Land of Wolves Official Framework Documentation**

═══════════════════════════════════════════════════════════════════════════════

## Overview

The **LXR-Core txAdmin Recipe** implements a sophisticated **framework adapter pattern** that provides seamless compatibility across multiple RedM frameworks. This system allows resources to work universally without code modifications, automatically detecting and adapting to the underlying framework.

### Supported Frameworks

- 🟢 **LXR-Core** (Primary framework for wolves.land)
- 🟢 **RSG-Core** (Full compatibility)
- 🟢 **VORP Core** (Full compatibility)
- 🟡 **Custom Frameworks** (Extensible adapter system)

═══════════════════════════════════════════════════════════════════════════════

## Auto-Detection Mechanism

The framework detection system runs automatically during resource initialization and identifies the active framework through a priority-based check system.

### Detection Flow

```lua
-- Server-Side Detection (server/framework.lua)
local function DetectFramework()
    -- Priority 1: LXR-Core
    if GetResourceState('lxr-core') == 'started' then
        return 'lxr-core'
    end
    
    -- Priority 2: RSG-Core
    if GetResourceState('rsg-core') == 'started' then
        return 'rsg-core'
    end
    
    -- Priority 3: VORP Core
    if GetResourceState('vorp_core') == 'started' then
        return 'vorp'
    end
    
    -- Fallback
    return 'standalone'
end

Framework = {
    name = DetectFramework(),
    object = nil,
    ready = false
}
```

### Client-Side Detection

```lua
-- Client-Side Detection (client/framework.lua)
CreateThread(function()
    while not Framework.object do
        if Framework.name == 'lxr-core' then
            Framework.object = exports['lxr-core']:GetCoreObject()
        elseif Framework.name == 'rsg-core' then
            Framework.object = exports['rsg-core']:GetCoreObject()
        elseif Framework.name == 'vorp' then
            Framework.object = exports.vorp_core:GetCore()
        end
        
        if Framework.object then
            Framework.ready = true
            TriggerEvent('framework:ready')
        end
        
        Wait(100)
    end
end)
```

═══════════════════════════════════════════════════════════════════════════════

## Framework Adapter Pattern

The adapter pattern provides a **unified API** that translates to framework-specific implementations. This allows you to write code once and have it work across all supported frameworks.

### Architecture

```
┌─────────────────────────────────────┐
│      Your Resource Code             │
│  (Uses Unified Framework API)       │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│     Framework Adapter Layer         │
│  (Translates to specific framework) │
└──────────────┬──────────────────────┘
               │
        ┌──────┴──────┬──────────────┐
        │             │              │
┌───────▼───────┐ ┌──▼────────┐ ┌──▼────────┐
│   LXR-Core    │ │ RSG-Core  │ │   VORP    │
│ Implementation│ │   Impl.   │ │   Impl.   │
└───────────────┘ └───────────┘ └───────────┘
```

═══════════════════════════════════════════════════════════════════════════════

## Unified API Functions

### Client-Side Functions

#### Notify(message, type, duration)
Display notifications to players.

```lua
-- Unified Usage
Framework.Notify('Welcome to The Land of Wolves!', 'success', 5000)
Framework.Notify('You do not have permission', 'error', 3000)
Framework.Notify('Task in progress...', 'info', 2000)

-- Adapter Implementation
function Framework.Notify(message, type, duration)
    if Framework.name == 'lxr-core' or Framework.name == 'rsg-core' then
        Framework.object.Functions.Notify(message, type, duration)
        
    elseif Framework.name == 'vorp' then
        local vorpType = type == 'success' and 'success' or 
                         type == 'error' and 'error' or 'tip'
        Framework.object.NotifyTip(message, duration or 3000)
    end
end
```

**Parameters:**
- `message` (string): The notification message
- `type` (string): 'success', 'error', 'info', 'warning'
- `duration` (number): Display time in milliseconds (default: 3000)

---

#### GetPlayerData()
Retrieve the player's data object.

```lua
-- Unified Usage
local playerData = Framework.GetPlayerData()
print('Player Job:', playerData.job.name)
print('Player Money:', playerData.money.cash)

-- Adapter Implementation
function Framework.GetPlayerData()
    if Framework.name == 'lxr-core' or Framework.name == 'rsg-core' then
        return Framework.object.Functions.GetPlayerData()
        
    elseif Framework.name == 'vorp' then
        return VORPcore.User  -- Cached VORP user object
    end
end
```

**Returns:** Player data table with job, money, metadata

---

#### GetJob()
Get the player's current job information.

```lua
-- Unified Usage
local job = Framework.GetJob()
print('Job:', job.name, 'Grade:', job.grade.level)

if job.name == 'police' and job.grade.level >= 2 then
    -- Allow access to advanced features
end

-- Adapter Implementation
function Framework.GetJob()
    local playerData = Framework.GetPlayerData()
    
    if Framework.name == 'lxr-core' or Framework.name == 'rsg-core' then
        return playerData.job
        
    elseif Framework.name == 'vorp' then
        return {
            name = playerData.job,
            label = playerData.jobLabel or playerData.job,
            grade = {
                level = playerData.jobGrade or 0,
                name = playerData.jobGrade or '0'
            }
        }
    end
end
```

**Returns:** Job table with name, label, grade

---

#### ProgressBar(label, duration, useWhileDead, canCancel, disableControls, callback)
Display a progress bar for timed actions.

```lua
-- Unified Usage
Framework.ProgressBar('Skinning Animal', 5000, false, true, {
    disableMovement = true,
    disableCarMovement = true,
    disableMouse = false,
    disableCombat = true,
}, function(cancelled)
    if not cancelled then
        -- Action completed successfully
        TriggerServerEvent('hunting:processCarcass', animalId)
    else
        -- Action was cancelled
        Framework.Notify('Skinning cancelled', 'error', 2000)
    end
end)

-- Adapter Implementation
function Framework.ProgressBar(label, duration, useWhileDead, canCancel, disableControls, callback)
    if Framework.name == 'lxr-core' or Framework.name == 'rsg-core' then
        Framework.object.Functions.Progressbar('action', label, duration, useWhileDead, canCancel, disableControls, callback)
        
    elseif Framework.name == 'vorp' then
        -- Use standalone progressbar
        exports['progressbar']:Progress({
            name = 'action',
            duration = duration,
            label = label,
            useWhileDead = useWhileDead,
            canCancel = canCancel,
            controlDisables = disableControls,
            animation = {},
        }, callback)
    end
end
```

---

#### TriggerCallback(name, callback, ...)
Execute a server callback and receive response.

```lua
-- Unified Usage
Framework.TriggerCallback('hunting:canSkinAnimal', function(canSkin, reason)
    if canSkin then
        StartSkinningProcess()
    else
        Framework.Notify(reason, 'error', 3000)
    end
end, animalNetId)

-- Adapter Implementation
function Framework.TriggerCallback(name, callback, ...)
    if Framework.name == 'lxr-core' or Framework.name == 'rsg-core' then
        Framework.object.Functions.TriggerCallback(name, callback, ...)
        
    elseif Framework.name == 'vorp' then
        Framework.object.Callback.TriggerAsync(name, callback, ...)
    end
end
```

═══════════════════════════════════════════════════════════════════════════════

### Server-Side Functions

#### GetPlayer(source)
Get player object by server ID.

```lua
-- Unified Usage
local player = Framework.GetPlayer(source)
if not player then return end

print('Player Identifier:', player.PlayerData.citizenid)
print('Player Name:', player.PlayerData.charinfo.firstname)

-- Adapter Implementation
function Framework.GetPlayer(source)
    if Framework.name == 'lxr-core' or Framework.name == 'rsg-core' then
        return Framework.object.Functions.GetPlayer(source)
        
    elseif Framework.name == 'vorp' then
        return Framework.object.getUser(source)
    end
end
```

---

#### GetPlayerByCitizenId(citizenid)
Get player object by citizen ID (even if offline).

```lua
-- Unified Usage
local player = Framework.GetPlayerByCitizenId('ABC12345')
if player then
    -- Player is online
else
    -- Query database for offline player
end

-- Adapter Implementation
function Framework.GetPlayerByCitizenId(citizenid)
    if Framework.name == 'lxr-core' or Framework.name == 'rsg-core' then
        return Framework.object.Functions.GetPlayerByCitizenId(citizenid)
        
    elseif Framework.name == 'vorp' then
        -- VORP uses different identifier system
        return Framework.object.getUserByCharIdentifier(citizenid)
    end
end
```

---

#### AddMoney(source, account, amount, reason)
Add money to player's account.

```lua
-- Unified Usage
Framework.AddMoney(source, 'cash', 150, 'Sold animal pelt')
Framework.AddMoney(source, 'bank', 1000, 'Salary payment')

-- Adapter Implementation
function Framework.AddMoney(source, account, amount, reason)
    local player = Framework.GetPlayer(source)
    if not player then return false end
    
    if Framework.name == 'lxr-core' or Framework.name == 'rsg-core' then
        player.Functions.AddMoney(account, amount, reason)
        
    elseif Framework.name == 'vorp' then
        if account == 'cash' then
            player.addCurrency(0, amount)  -- 0 = cash
        elseif account == 'bank' then
            player.addCurrency(1, amount)  -- 1 = bank
        elseif account == 'gold' then
            player.addCurrency(2, amount)  -- 2 = gold
        end
    end
    
    return true
end
```

**Parameters:**
- `source` (number): Player server ID
- `account` (string): 'cash', 'bank', or 'gold'
- `amount` (number): Amount to add
- `reason` (string): Transaction reason for logging

---

#### RemoveMoney(source, account, amount, reason)
Remove money from player's account.

```lua
-- Unified Usage
if Framework.RemoveMoney(source, 'cash', 50, 'Purchased supplies') then
    -- Payment successful
    Framework.AddItem(source, 'hunting_knife', 1)
else
    -- Insufficient funds
    Framework.Notify(source, 'Not enough money', 'error', 3000)
end

-- Adapter Implementation
function Framework.RemoveMoney(source, account, amount, reason)
    local player = Framework.GetPlayer(source)
    if not player then return false end
    
    if Framework.name == 'lxr-core' or Framework.name == 'rsg-core' then
        return player.Functions.RemoveMoney(account, amount, reason)
        
    elseif Framework.name == 'vorp' then
        if account == 'cash' then
            return player.removeCurrency(0, amount)
        elseif account == 'bank' then
            return player.removeCurrency(1, amount)
        elseif account == 'gold' then
            return player.removeCurrency(2, amount)
        end
    end
    
    return false
end
```

---

#### AddItem(source, item, amount, metadata)
Add item to player's inventory.

```lua
-- Unified Usage
Framework.AddItem(source, 'perfect_pelt', 1, {
    quality = 'perfect',
    animal = 'deer',
    weight = 5.2
})

-- Adapter Implementation
function Framework.AddItem(source, item, amount, metadata)
    local player = Framework.GetPlayer(source)
    if not player then return false end
    
    if Framework.name == 'lxr-core' or Framework.name == 'rsg-core' then
        return player.Functions.AddItem(item, amount, false, metadata)
        
    elseif Framework.name == 'vorp' then
        exports.vorp_inventory:addItem(source, item, amount, metadata)
        return true
    end
end
```

---

#### RemoveItem(source, item, amount, slot)
Remove item from player's inventory.

```lua
-- Unified Usage
if Framework.RemoveItem(source, 'hunting_knife', 1) then
    -- Item removed successfully
    Framework.Notify(source, 'Knife broke from use', 'info', 3000)
end

-- Adapter Implementation
function Framework.RemoveItem(source, item, amount, slot)
    local player = Framework.GetPlayer(source)
    if not player then return false end
    
    if Framework.name == 'lxr-core' or Framework.name == 'rsg-core' then
        return player.Functions.RemoveItem(item, amount, slot)
        
    elseif Framework.name == 'vorp' then
        exports.vorp_inventory:subItem(source, item, amount)
        return true
    end
end
```

---

#### HasItem(source, item, amount)
Check if player has item in inventory.

```lua
-- Unified Usage
if Framework.HasItem(source, 'weapon_lasso', 1) then
    -- Player has lasso equipped
    AllowCapture(source)
end

-- Adapter Implementation
function Framework.HasItem(source, item, amount)
    local player = Framework.GetPlayer(source)
    if not player then return false end
    
    amount = amount or 1
    
    if Framework.name == 'lxr-core' or Framework.name == 'rsg-core' then
        local playerItem = player.Functions.GetItemByName(item)
        return playerItem and playerItem.amount >= amount
        
    elseif Framework.name == 'vorp' then
        local itemCount = exports.vorp_inventory:getItemCount(source, nil, item)
        return itemCount >= amount
    end
    
    return false
end
```

---

#### CreateCallback(name, callback)
Register a server callback that clients can trigger.

```lua
-- Unified Usage
Framework.CreateCallback('hunting:canSkinAnimal', function(source, cb, animalNetId)
    local player = Framework.GetPlayer(source)
    
    -- Validate player has knife
    if not Framework.HasItem(source, 'hunting_knife', 1) then
        cb(false, 'You need a hunting knife')
        return
    end
    
    -- Validate animal exists
    local animal = NetworkGetEntityFromNetworkId(animalNetId)
    if not DoesEntityExist(animal) then
        cb(false, 'Animal not found')
        return
    end
    
    cb(true)
end)

-- Adapter Implementation
function Framework.CreateCallback(name, callback)
    if Framework.name == 'lxr-core' or Framework.name == 'rsg-core' then
        Framework.object.Functions.CreateCallback(name, callback)
        
    elseif Framework.name == 'vorp' then
        Framework.object.Callback.Register(name, callback)
    end
end
```

═══════════════════════════════════════════════════════════════════════════════

## Per-Framework Event Mapping

Different frameworks use different event names for common actions. The adapter automatically maps these events.

### Player Loading Events

```lua
-- Unified Event Handler
RegisterNetEvent('framework:playerLoaded', function()
    -- This fires regardless of framework
    InitializePlayerData()
end)

-- Adapter Mapping
if Framework.name == 'lxr-core' or Framework.name == 'rsg-core' then
    RegisterNetEvent('LXRCore:Client:OnPlayerLoaded', function()
        TriggerEvent('framework:playerLoaded')
    end)
    
elseif Framework.name == 'vorp' then
    RegisterNetEvent('vorp:SelectedCharacter', function()
        TriggerEvent('framework:playerLoaded')
    end)
end
```

### Player Logout Events

```lua
-- Unified Event Handler
RegisterNetEvent('framework:playerUnloaded', function()
    -- Cleanup on logout
    CleanupPlayerData()
end)

-- Adapter Mapping
if Framework.name == 'lxr-core' or Framework.name == 'rsg-core' then
    RegisterNetEvent('LXRCore:Client:OnPlayerUnload', function()
        TriggerEvent('framework:playerUnloaded')
    end)
    
elseif Framework.name == 'vorp' then
    AddEventHandler('onResourceStop', function(resource)
        if resource == GetCurrentResourceName() then
            TriggerEvent('framework:playerUnloaded')
        end
    end)
end
```

### Job Update Events

```lua
-- Unified Event Handler
RegisterNetEvent('framework:jobUpdate', function(job)
    currentJob = job
    UpdateJobBlips()
end)

-- Adapter Mapping
if Framework.name == 'lxr-core' or Framework.name == 'rsg-core' then
    RegisterNetEvent('LXRCore:Client:OnJobUpdate', function(job)
        TriggerEvent('framework:jobUpdate', job)
    end)
    
elseif Framework.name == 'vorp' then
    RegisterNetEvent('vorp:updateJob', function(job, jobGrade)
        TriggerEvent('framework:jobUpdate', {
            name = job,
            grade = { level = jobGrade }
        })
    end)
end
```

### Complete Event Reference Table

| Unified Event | LXR-Core / RSG-Core | VORP Core |
|---------------|---------------------|-----------|
| `framework:playerLoaded` | `LXRCore:Client:OnPlayerLoaded` | `vorp:SelectedCharacter` |
| `framework:playerUnloaded` | `LXRCore:Client:OnPlayerUnload` | (resource stop) |
| `framework:jobUpdate` | `LXRCore:Client:OnJobUpdate` | `vorp:updateJob` |
| `framework:gangUpdate` | `LXRCore:Client:OnGangUpdate` | N/A |
| `framework:moneyChange` | `LXRCore:Client:OnMoneyChange` | `vorp:updateMoney` |
| `framework:itemAdded` | `inventory:client:ItemBox` | `vorp_inventory:addItem` |
| `framework:itemRemoved` | `inventory:client:ItemBox` | `vorp_inventory:removeItem` |

═══════════════════════════════════════════════════════════════════════════════

## Adding Support for New Frameworks

To add support for a new framework, follow these steps:

### 1. Update Detection Logic

```lua
-- Add to server/framework.lua and client/framework.lua
local function DetectFramework()
    -- Existing checks...
    
    -- Add new framework check
    if GetResourceState('yourframework-core') == 'started' then
        return 'yourframework'
    end
    
    return 'standalone'
end
```

### 2. Implement Core Functions

```lua
-- Add to each function in the adapter
if Framework.name == 'yourframework' then
    -- Implement framework-specific logic
    Framework.object = exports['yourframework-core']:GetCore()
end
```

### 3. Add Event Mappings

```lua
-- Map framework events to unified events
if Framework.name == 'yourframework' then
    RegisterNetEvent('yourframework:playerLoaded', function()
        TriggerEvent('framework:playerLoaded')
    end)
end
```

### 4. Test All Functions

Create a test resource to verify:
- ✅ Player data retrieval
- ✅ Money transactions
- ✅ Inventory operations
- ✅ Job/gang functions
- ✅ Callbacks
- ✅ Events
- ✅ Notifications
- ✅ Progress bars

### Example: Adding QBCore Support (Theoretical)

```lua
-- Detection
if GetResourceState('qb-core') == 'started' then
    return 'qbcore'
end

-- Notify Function
elseif Framework.name == 'qbcore' then
    Framework.object.Functions.Notify(source, message, type, duration)

-- AddMoney Function
elseif Framework.name == 'qbcore' then
    player.Functions.AddMoney(account, amount, reason)

-- Event Mapping
if Framework.name == 'qbcore' then
    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        TriggerEvent('framework:playerLoaded')
    end)
end
```

═══════════════════════════════════════════════════════════════════════════════

## Best Practices

### 1. Always Use Unified API

❌ **Don't do this:**
```lua
if Framework.name == 'lxr-core' then
    Framework.object.Functions.Notify('Message', 'success')
elseif Framework.name == 'vorp' then
    Framework.object.NotifyTip('Message', 3000)
end
```

✅ **Do this:**
```lua
Framework.Notify('Message', 'success', 3000)
```

### 2. Check Framework Ready State

```lua
CreateThread(function()
    while not Framework.ready do
        Wait(100)
    end
    
    -- Framework is ready, safe to use
    local playerData = Framework.GetPlayerData()
end)
```

### 3. Handle Framework-Specific Features Gracefully

```lua
-- Some frameworks have features others don't
if Framework.name == 'lxr-core' or Framework.name == 'rsg-core' then
    -- Use gang system
    local gang = Framework.GetGang()
elseif Framework.name == 'vorp' then
    -- VORP doesn't have gang system, use alternative
    Framework.Notify('Gang system not available', 'info', 3000)
end
```

### 4. Server-Side Validation Always

```lua
-- Never trust client completely
RegisterNetEvent('hunting:processCarcass', function(animalNetId)
    local src = source
    
    -- Validate player exists
    local player = Framework.GetPlayer(src)
    if not player then return end
    
    -- Validate player has required item
    if not Framework.HasItem(src, 'hunting_knife', 1) then
        return
    end
    
    -- Validate animal entity
    local animal = NetworkGetEntityFromNetworkId(animalNetId)
    if not DoesEntityExist(animal) then return end
    
    -- Process with confidence
    Framework.AddItem(src, 'animal_pelt', 1)
end)
```

═══════════════════════════════════════════════════════════════════════════════

## Framework Compatibility Matrix

| Feature | LXR-Core | RSG-Core | VORP | Notes |
|---------|----------|----------|------|-------|
| **Player Data** | ✅ | ✅ | ✅ | Full support |
| **Inventory** | ✅ | ✅ | ✅ | Uses framework inventory |
| **Money (Cash)** | ✅ | ✅ | ✅ | Currency type 0 (VORP) |
| **Money (Bank)** | ✅ | ✅ | ✅ | Currency type 1 (VORP) |
| **Money (Gold)** | ✅ | ✅ | ✅ | Currency type 2 (VORP) |
| **Jobs** | ✅ | ✅ | ✅ | Full support |
| **Gangs** | ✅ | ✅ | ⚠️ | VORP uses different system |
| **Notifications** | ✅ | ✅ | ✅ | Visual differences |
| **Progress Bars** | ✅ | ✅ | ✅ | Uses standalone for VORP |
| **Callbacks** | ✅ | ✅ | ✅ | Syntax varies |
| **Stress System** | ✅ | ✅ | ❌ | LXR/RSG specific |
| **Reputation** | ✅ | ✅ | ⚠️ | VORP uses different system |
| **Target System** | ✅ | ✅ | ✅ | Framework-specific targets |

**Legend:**
- ✅ Full Support
- ⚠️ Partial Support / Alternative Method
- ❌ Not Available

═══════════════════════════════════════════════════════════════════════════════

## Troubleshooting

### Framework Not Detected

**Problem:** `Framework.name` returns 'standalone'

**Solution:**
1. Verify framework resource is started: `ensure lxr-core`
2. Check load order in `server.cfg`
3. Confirm framework exports are available

### Functions Return Nil

**Problem:** `Framework.GetPlayerData()` returns nil

**Solution:**
1. Wait for framework ready: `while not Framework.ready do Wait(100) end`
2. Check player is fully loaded
3. Verify framework object exists

### Events Not Firing

**Problem:** `framework:playerLoaded` never triggers

**Solution:**
1. Check event mappings are registered
2. Verify framework-specific events fire
3. Add debug prints to adapter layer

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
