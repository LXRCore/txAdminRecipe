```
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗ ██████╗ ███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██╔═══██╗██╔══██╗██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██████╔╝█████╗  
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██╔══██╗██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║      ╚██████╗╚██████╔╝██║  ██║███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
```

# 📡 Event System - LXR-Core txAdmin Recipe

**The Land of Wolves Official Event Documentation**

═══════════════════════════════════════════════════════════════════════════════

## Overview

The **LXR-Core Event System** provides a **unified event architecture** that works seamlessly across multiple frameworks. This documentation covers the complete event system including unified adapter functions, framework-specific event mappings, callbacks, and best practices.

═══════════════════════════════════════════════════════════════════════════════

## Event Architecture

### Event Flow Diagram

```
┌─────────────────┐
│  Client Event   │
│   Triggered     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐      ┌──────────────────┐
│ Unified Adapter │─────▶│ Framework Events │
│     Layer       │      │   LXR/RSG/VORP   │
└────────┬────────┘      └──────────────────┘
         │
         ▼
┌─────────────────┐
│  Server Event   │
│   Processed     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Response to    │
│     Client      │
└─────────────────┘
```

═══════════════════════════════════════════════════════════════════════════════

## Unified Event Functions

### Client-Side Event Functions

#### TriggerServerEvent(eventName, ...)
Trigger a server event from client.

```lua
-- Example: Notify server of animal hunt
TriggerServerEvent('hunting:animalKilled', animalNetId, animalType, quality)

-- Example: Request money withdrawal
TriggerServerEvent('bank:withdraw', amount, accountType)
```

**Parameters:**
- `eventName` (string): The server event to trigger
- `...` (any): Additional parameters to pass

---

#### RegisterNetEvent(eventName, callback)
Register handler for network events.

```lua
-- Example: Handle notification from server
RegisterNetEvent('hunting:rewardReceived', function(itemName, amount, bonus)
    Framework.Notify('Received ' .. amount .. 'x ' .. itemName, 'success', 3000)
    
    if bonus then
        Framework.Notify('Quality bonus: $' .. bonus, 'success', 2000)
    end
end)

-- Example: Handle job update
RegisterNetEvent('framework:jobUpdate', function(jobData)
    currentJob = jobData
    RefreshJobBlips()
    UpdateJobUI()
end)
```

**Parameters:**
- `eventName` (string): Event name to listen for
- `callback` (function): Handler function

---

#### AddEventHandler(eventName, callback)
Register handler for local events (non-networked).

```lua
-- Example: Handle framework ready
AddEventHandler('framework:ready', function()
    InitializeResource()
    LoadPlayerPreferences()
end)

-- Example: Handle resource stop cleanup
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        CleanupBlips()
        DeleteEntities()
    end
end)
```

---

#### TriggerEvent(eventName, ...)
Trigger a local event (same-side only).

```lua
-- Example: Trigger custom UI event
TriggerEvent('hunting:openShop', shopId, shopData)

-- Example: Update HUD element
TriggerEvent('hud:updateHealth', currentHealth, maxHealth)
```

═══════════════════════════════════════════════════════════════════════════════

### Server-Side Event Functions

#### RegisterNetEvent(eventName, callback)
Register handler for client-triggered events.

```lua
-- Example: Handle animal processing
RegisterNetEvent('hunting:processAnimal', function(animalNetId, toolUsed)
    local src = source
    local player = Framework.GetPlayer(src)
    
    if not player then return end
    
    -- Validate tool
    if not Framework.HasItem(src, toolUsed, 1) then
        TriggerClientEvent('hunting:error', src, 'Missing required tool')
        return
    end
    
    -- Validate entity
    local animal = NetworkGetEntityFromNetworkId(animalNetId)
    if not DoesEntityExist(animal) then
        return
    end
    
    -- Process and reward
    local rewards = CalculateRewards(animal, toolUsed)
    for item, amount in pairs(rewards) do
        Framework.AddItem(src, item, amount)
    end
    
    TriggerClientEvent('hunting:rewardReceived', src, rewards)
end)
```

**Security Note:** Always validate `source` and never trust client data.

---

#### TriggerClientEvent(eventName, source, ...)
Send event to specific client.

```lua
-- Example: Notify single player
TriggerClientEvent('hunting:notifyKill', src, animalName, pelts)

-- Example: Update player UI
TriggerClientEvent('hud:updateMoney', src, cashAmount, bankAmount)

-- Example: Spawn prop for player
TriggerClientEvent('hunting:spawnCarcass', src, coords, model, netId)
```

**Parameters:**
- `eventName` (string): Client event to trigger
- `source` (number): Target player server ID (-1 for all players)
- `...` (any): Parameters to send

---

#### TriggerClientEvent (Broadcast to All)
Send event to all connected players.

```lua
-- Example: Server-wide announcement
TriggerClientEvent('server:announcement', -1, 'Server restart in 5 minutes!')

-- Example: Weather change
TriggerClientEvent('environment:setWeather', -1, 'RAIN', transition)

-- Example: Global event
TriggerClientEvent('hunting:legendarySpawned', -1, coords, animalType)
```

---

#### AddEventHandler(eventName, callback)
Register handler for server-side events.

```lua
-- Example: Handle player joining
AddEventHandler('playerJoining', function(playerName)
    local src = source
    print(playerName .. ' is connecting... (ID: ' .. src .. ')')
end)

-- Example: Handle player dropped
AddEventHandler('playerDropped', function(reason)
    local src = source
    SavePlayerData(src)
    CleanupPlayerSessions(src)
end)

-- Example: Resource start
AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        LoadConfiguration()
        InitializeDatabase()
    end
end)
```

═══════════════════════════════════════════════════════════════════════════════

## Callback System

Callbacks allow you to request data from the server and receive a response asynchronously.

### Server-Side: Create Callback

```lua
-- Example: Can player skin animal?
Framework.CreateCallback('hunting:canSkinAnimal', function(source, cb, animalNetId)
    local player = Framework.GetPlayer(source)
    if not player then 
        cb(false, 'Player not found')
        return 
    end
    
    -- Check if player has knife
    if not Framework.HasItem(source, 'hunting_knife', 1) then
        cb(false, 'You need a hunting knife')
        return
    end
    
    -- Check animal validity
    local animal = NetworkGetEntityFromNetworkId(animalNetId)
    if not DoesEntityExist(animal) then
        cb(false, 'Animal not found')
        return
    end
    
    -- Check if animal is dead
    if not IsEntityDead(animal) then
        cb(false, 'Animal is still alive')
        return
    end
    
    -- All checks passed
    cb(true, 'ready')
end)

-- Example: Get player hunting stats
Framework.CreateCallback('hunting:getStats', function(source, cb)
    local player = Framework.GetPlayer(source)
    if not player then 
        cb(nil)
        return 
    end
    
    local citizenid = player.PlayerData.citizenid
    
    MySQL.query('SELECT * FROM player_hunting WHERE citizenid = ?', {citizenid}, function(result)
        if result[1] then
            cb(result[1])
        else
            cb({
                kills = 0,
                perfect_kills = 0,
                legendary_kills = 0,
                total_earned = 0
            })
        end
    end)
end)

-- Example: Shop purchase validation
Framework.CreateCallback('hunting:canBuyItem', function(source, cb, itemName, price)
    local player = Framework.GetPlayer(source)
    if not player then 
        cb(false, 'Player not found')
        return 
    end
    
    -- Check money
    local playerMoney = player.PlayerData.money.cash
    if playerMoney < price then
        cb(false, 'Insufficient funds')
        return
    end
    
    -- Check inventory space (framework-specific)
    if Framework.name == 'vorp' then
        -- VORP inventory check
        local canCarry = exports.vorp_inventory:canCarryItem(source, itemName, 1)
        if not canCarry then
            cb(false, 'Inventory full')
            return
        end
    else
        -- LXR/RSG inventory check
        local hasSpace = player.Functions.HasSpace(itemName, 1)
        if not hasSpace then
            cb(false, 'Inventory full')
            return
        end
    end
    
    cb(true)
end)
```

**Callback Signature:**
```lua
function(source, cb, ...)
    -- source: Player who triggered callback
    -- cb: Callback function to send response
    -- ...: Additional parameters from client
end
```

### Client-Side: Trigger Callback

```lua
-- Example: Check if can skin before starting animation
Framework.TriggerCallback('hunting:canSkinAnimal', function(canSkin, message)
    if canSkin then
        -- Start skinning process
        StartSkinningAnimation(animalNetId)
    else
        -- Display error
        Framework.Notify(message, 'error', 3000)
    end
end, animalNetId)

-- Example: Load stats and display UI
Framework.TriggerCallback('hunting:getStats', function(stats)
    if stats then
        SendNUIMessage({
            type = 'updateStats',
            data = stats
        })
    end
end)

-- Example: Purchase item from shop
local function BuyItem(itemName, price)
    Framework.TriggerCallback('hunting:canBuyItem', function(success, reason)
        if success then
            -- Process purchase on server
            TriggerServerEvent('hunting:purchaseItem', itemName, price)
        else
            -- Show error
            Framework.Notify(reason or 'Cannot purchase item', 'error', 3000)
        end
    end, itemName, price)
end
```

═══════════════════════════════════════════════════════════════════════════════

## Framework-Specific Event Mappings

### Player Events

#### Player Loaded

**Unified Event:** `framework:playerLoaded`

```lua
-- Unified handler (works for all frameworks)
AddEventHandler('framework:playerLoaded', function()
    local playerData = Framework.GetPlayerData()
    InitializeHunting(playerData)
    LoadPlayerSettings()
end)
```

| Framework | Native Event |
|-----------|-------------|
| LXR-Core | `LXRCore:Client:OnPlayerLoaded` |
| RSG-Core | `RSGCore:Client:OnPlayerLoaded` |
| VORP | `vorp:SelectedCharacter` |

**Adapter Mapping:**
```lua
if Framework.name == 'lxr-core' or Framework.name == 'rsg-core' then
    RegisterNetEvent('LXRCore:Client:OnPlayerLoaded', function()
        TriggerEvent('framework:playerLoaded')
    end)
    
elseif Framework.name == 'vorp' then
    RegisterNetEvent('vorp:SelectedCharacter', function(charid)
        TriggerEvent('framework:playerLoaded')
    end)
end
```

---

#### Player Unloaded

**Unified Event:** `framework:playerUnloaded`

```lua
-- Unified handler
AddEventHandler('framework:playerUnloaded', function()
    SavePlayerData()
    CleanupBlips()
    ResetVariables()
end)
```

| Framework | Native Event |
|-----------|-------------|
| LXR-Core | `LXRCore:Client:OnPlayerUnload` |
| RSG-Core | `RSGCore:Client:OnPlayerUnload` |
| VORP | (resource stop) |

---

#### Job Update

**Unified Event:** `framework:jobUpdate`

```lua
-- Unified handler
RegisterNetEvent('framework:jobUpdate', function(job)
    currentJob = job
    
    if job.name == 'hunter' then
        ShowHunterBlips()
    else
        HideHunterBlips()
    end
end)
```

| Framework | Native Event |
|-----------|-------------|
| LXR-Core | `LXRCore:Client:OnJobUpdate` |
| RSG-Core | `RSGCore:Client:OnJobUpdate` |
| VORP | `vorp:updateJob` |

**Parameters:**
- **LXR/RSG:** Full job object
- **VORP:** Job name and grade separately

---

#### Money Update

**Unified Event:** `framework:moneyChange`

```lua
-- Unified handler
RegisterNetEvent('framework:moneyChange', function(account, amount, operation)
    if account == 'cash' then
        UpdateCashDisplay(amount)
    elseif account == 'bank' then
        UpdateBankDisplay(amount)
    end
end)
```

| Framework | Native Event |
|-----------|-------------|
| LXR-Core | `LXRCore:Client:OnMoneyChange` |
| RSG-Core | `RSGCore:Client:OnMoneyChange` |
| VORP | `vorp:updateMoney` |

═══════════════════════════════════════════════════════════════════════════════

### Inventory Events

#### Item Added

**Unified Event:** `framework:itemAdded`

```lua
-- Unified handler
RegisterNetEvent('framework:itemAdded', function(itemName, amount, metadata)
    if itemName == 'perfect_pelt' then
        PlaySkinningSuccessSound()
        Framework.Notify('Perfect pelt obtained!', 'success', 3000)
    end
end)
```

| Framework | Native Event |
|-----------|-------------|
| LXR-Core | `inventory:client:ItemBox` |
| RSG-Core | `inventory:client:ItemBox` |
| VORP | `vorp_inventory:addItem` |

---

#### Item Removed

**Unified Event:** `framework:itemRemoved`

```lua
-- Unified handler
RegisterNetEvent('framework:itemRemoved', function(itemName, amount)
    if itemName == 'hunting_bait' then
        Framework.Notify('Bait used', 'info', 2000)
    end
end)
```

| Framework | Native Event |
|-----------|-------------|
| LXR-Core | `inventory:client:ItemBox` |
| RSG-Core | `inventory:client:ItemBox` |
| VORP | `vorp_inventory:removeItem` |

═══════════════════════════════════════════════════════════════════════════════

## Event Naming Conventions

### Resource-Specific Events

Use the format: `resourcename:action:target`

```lua
-- Good naming examples
RegisterNetEvent('hunting:start:skinning', handler)
RegisterNetEvent('hunting:complete:sale', handler)
RegisterNetEvent('hunting:spawn:animal', handler)

-- Bad naming examples
RegisterNetEvent('skinning', handler)  -- Too vague
RegisterNetEvent('DoHuntingThing', handler)  -- Unclear
RegisterNetEvent('event1', handler)  -- Non-descriptive
```

### Client vs Server Events

Prefix with side for clarity when needed:

```lua
-- Client events (called from server)
RegisterNetEvent('hunting:client:showNotification', handler)
RegisterNetEvent('hunting:client:playAnimation', handler)

-- Server events (called from client)
RegisterNetEvent('hunting:server:processCarcass', handler)
RegisterNetEvent('hunting:server:validateSale', handler)
```

### Internal Events

Use underscore prefix for internal events:

```lua
-- Internal resource events
TriggerEvent('hunting:_updateCache', data)
TriggerEvent('hunting:_refreshConfig', config)
```

═══════════════════════════════════════════════════════════════════════════════

## Complete Event Examples

### Example 1: Animal Hunting System

**Client Side:**
```lua
-- Detect animal death
CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        -- Check for nearby dead animals
        local animals = GetGamePool('CPed')
        for _, animal in ipairs(animals) do
            if IsEntityDead(animal) and not IsPedAPlayer(animal) then
                local animalCoords = GetEntityCoords(animal)
                local distance = #(coords - animalCoords)
                
                if distance < 3.0 and not processedAnimals[animal] then
                    -- Show prompt
                    ShowHelpText('Press [E] to skin animal')
                    
                    if IsControlJustPressed(0, 0x0322F03D) then -- 'E' key
                        -- Check if player can skin
                        Framework.TriggerCallback('hunting:canSkin', function(canSkin, reason)
                            if canSkin then
                                StartSkinning(animal)
                            else
                                Framework.Notify(reason, 'error', 3000)
                            end
                        end, NetworkGetNetworkIdFromEntity(animal))
                    end
                end
            end
        end
        
        Wait(0)
    end
end)

-- Skinning process
function StartSkinning(animal)
    local playerPed = PlayerPedId()
    
    -- Start progress bar
    Framework.ProgressBar('Skinning Animal', 8000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, function(cancelled)
        if not cancelled then
            -- Notify server
            TriggerServerEvent('hunting:skinComplete', NetworkGetNetworkIdFromEntity(animal))
        else
            Framework.Notify('Skinning cancelled', 'error', 2000)
        end
        
        ClearPedTasks(playerPed)
    end)
    
    -- Play animation
    TaskStartScenarioInPlace(playerPed, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 8000, true, false, false, false)
end

-- Handle rewards
RegisterNetEvent('hunting:skinRewards', function(items, bonus)
    for itemName, amount in pairs(items) do
        Framework.Notify('Received ' .. amount .. 'x ' .. itemName, 'success', 3000)
    end
    
    if bonus > 0 then
        Framework.Notify('Quality bonus: $' .. bonus, 'success', 2000)
    end
end)
```

**Server Side:**
```lua
-- Validate and process skinning
Framework.CreateCallback('hunting:canSkin', function(source, cb, animalNetId)
    local player = Framework.GetPlayer(source)
    if not player then 
        cb(false, 'Player not found')
        return 
    end
    
    -- Check knife
    if not Framework.HasItem(source, 'hunting_knife', 1) then
        cb(false, 'You need a hunting knife')
        return
    end
    
    -- Check animal
    local animal = NetworkGetEntityFromNetworkId(animalNetId)
    if not DoesEntityExist(animal) or not IsEntityDead(animal) then
        cb(false, 'Invalid animal')
        return
    end
    
    cb(true)
end)

-- Process completed skinning
RegisterNetEvent('hunting:skinComplete', function(animalNetId)
    local src = source
    local player = Framework.GetPlayer(src)
    if not player then return end
    
    -- Get animal
    local animal = NetworkGetEntityFromNetworkId(animalNetId)
    if not DoesEntityExist(animal) then return end
    
    -- Calculate rewards based on animal quality
    local animalModel = GetEntityModel(animal)
    local quality = DetermineAnimalQuality(animal)
    local rewards, bonus = CalculateRewards(animalModel, quality)
    
    -- Give items
    for itemName, amount in pairs(rewards) do
        Framework.AddItem(src, itemName, amount, {
            quality = quality,
            animal = GetAnimalName(animalModel)
        })
    end
    
    -- Give money bonus
    if bonus > 0 then
        Framework.AddMoney(src, 'cash', bonus, 'Hunting quality bonus')
    end
    
    -- Notify client
    TriggerClientEvent('hunting:skinRewards', src, rewards, bonus)
    
    -- Delete carcass
    DeleteEntity(animal)
    
    -- Log to Discord
    SendToDiscord('Hunting', src .. ' skinned a ' .. GetAnimalName(animalModel) .. ' (' .. quality .. ')', 3447003)
end)
```

═══════════════════════════════════════════════════════════════════════════════

### Example 2: Shop System with Callbacks

**Client Side:**
```lua
-- Open shop
local function OpenHuntingShop(shopId)
    -- Get shop data from server
    Framework.TriggerCallback('hunting:getShopData', function(shopData)
        if not shopData then
            Framework.Notify('Shop unavailable', 'error', 3000)
            return
        end
        
        -- Send to NUI
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = 'openShop',
            data = shopData
        })
    end, shopId)
end

-- Handle NUI purchase request
RegisterNUICallback('buyItem', function(data, cb)
    local itemName = data.itemName
    local quantity = data.quantity
    local totalPrice = data.totalPrice
    
    -- Validate with server
    Framework.TriggerCallback('hunting:canBuy', function(success, reason)
        if success then
            -- Process purchase
            TriggerServerEvent('hunting:buyItem', itemName, quantity, totalPrice)
            cb({ success = true })
        else
            -- Show error
            Framework.Notify(reason, 'error', 3000)
            cb({ success = false, reason = reason })
        end
    end, itemName, quantity, totalPrice)
end)

-- Handle purchase confirmation
RegisterNetEvent('hunting:purchaseComplete', function(itemName, quantity)
    Framework.Notify('Purchased ' .. quantity .. 'x ' .. itemName, 'success', 3000)
    
    -- Refresh shop UI
    TriggerEvent('hunting:refreshShop')
end)
```

**Server Side:**
```lua
-- Get shop data
Framework.CreateCallback('hunting:getShopData', function(source, cb, shopId)
    local shopConfig = Config.Shops[shopId]
    if not shopConfig then
        cb(nil)
        return
    end
    
    cb(shopConfig)
end)

-- Validate purchase
Framework.CreateCallback('hunting:canBuy', function(source, cb, itemName, quantity, totalPrice)
    local player = Framework.GetPlayer(source)
    if not player then
        cb(false, 'Player not found')
        return
    end
    
    -- Check money
    if player.PlayerData.money.cash < totalPrice then
        cb(false, 'Insufficient funds')
        return
    end
    
    -- Check inventory space
    local hasSpace = true
    if Framework.name == 'vorp' then
        hasSpace = exports.vorp_inventory:canCarryItem(source, itemName, quantity)
    else
        hasSpace = player.Functions.HasSpace(itemName, quantity)
    end
    
    if not hasSpace then
        cb(false, 'Inventory full')
        return
    end
    
    cb(true)
end)

-- Process purchase
RegisterNetEvent('hunting:buyItem', function(itemName, quantity, totalPrice)
    local src = source
    local player = Framework.GetPlayer(src)
    if not player then return end
    
    -- Double-check money (security)
    if player.PlayerData.money.cash < totalPrice then
        return
    end
    
    -- Remove money
    if Framework.RemoveMoney(src, 'cash', totalPrice, 'Purchased ' .. itemName) then
        -- Add item
        Framework.AddItem(src, itemName, quantity)
        
        -- Notify client
        TriggerClientEvent('hunting:purchaseComplete', src, itemName, quantity)
        
        -- Log
        print(GetPlayerName(src) .. ' purchased ' .. quantity .. 'x ' .. itemName .. ' for $' .. totalPrice)
    end
end)
```

═══════════════════════════════════════════════════════════════════════════════

## Best Practices

### 1. Always Validate on Server

❌ **Never trust the client:**
```lua
-- BAD: Client determines reward amount
RegisterNetEvent('hunting:giveReward', function(amount)
    Framework.AddMoney(source, 'cash', amount)  -- Exploitable!
end)
```

✅ **Server determines everything:**
```lua
-- GOOD: Server calculates and validates
RegisterNetEvent('hunting:completeHunt', function(animalNetId)
    local src = source
    local animal = NetworkGetEntityFromNetworkId(animalNetId)
    
    if not DoesEntityExist(animal) then return end
    
    local reward = CalculateReward(animal)  -- Server calculates
    Framework.AddMoney(src, 'cash', reward)
end)
```

### 2. Use Callbacks for Validation

```lua
-- Check permission before allowing action
Framework.TriggerCallback('hunting:hasPermission', function(hasPermission)
    if hasPermission then
        StartHunting()
    else
        Framework.Notify('No permission', 'error', 3000)
    end
end)
```

### 3. Handle Network Ownership

```lua
-- When spawning entities, assign network control
local animal = CreatePed(model, coords, heading, true, false)
NetworkRegisterEntityAsNetworked(animal)
local netId = NetworkGetNetworkIdFromEntity(animal)

-- Send to other clients
TriggerClientEvent('hunting:syncAnimal', -1, netId, coords)
```

### 4. Cleanup on Resource Stop

```lua
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        -- Delete entities
        for _, entity in pairs(spawnedEntities) do
            if DoesEntityExist(entity) then
                DeleteEntity(entity)
            end
        end
        
        -- Remove blips
        for _, blip in pairs(activeBlips) do
            RemoveBlip(blip)
        end
    end
end)
```

### 5. Rate Limiting

```lua
-- Prevent event spam
local lastAction = {}

RegisterNetEvent('hunting:action', function()
    local src = source
    local currentTime = os.time()
    
    if lastAction[src] and currentTime - lastAction[src] < 5 then
        -- Too soon
        return
    end
    
    lastAction[src] = currentTime
    
    -- Process action
end)
```

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
