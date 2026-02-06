```
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗ ██████╗ ███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██╔═══██╗██╔══██╗██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██████╔╝█████╗  
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██╔══██╗██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║      ╚██████╗╚██████╔╝██║  ██║███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
```

# 🔒 Security Best Practices - LXR-Core txAdmin Recipe

**The Land of Wolves Official Security Documentation**

═══════════════════════════════════════════════════════════════════════════════

## Overview

Security is **critical** in FiveM/RedM resource development. This document outlines comprehensive security practices, anti-abuse measures, exploit prevention, and monitoring strategies to protect your server from malicious users.

> **Golden Rule:** Never trust the client. Always validate on the server.

═══════════════════════════════════════════════════════════════════════════════

## Server Authority Principles

### The Trust Model

```
┌─────────────────────┐
│   CLIENT (Player)   │ ◄─── NEVER TRUST
│  • Can be modified  │
│  • Can send fake    │
│  • Can be exploited │
└──────────┬──────────┘
           │ Sends Request
           ▼
┌─────────────────────┐
│  SERVER (Authority) │ ◄─── ALWAYS TRUST
│  • Validates all    │
│  • Calculates all   │
│  • Authorizes all   │
└─────────────────────┘
```

### Core Principles

1. **Server Determines Everything**: Rewards, prices, distances, success/failure
2. **Client Only Requests**: Client asks, server decides
3. **Validate All Inputs**: Check type, range, existence, ownership
4. **Double-Check Critical Operations**: Money transactions, item transfers
5. **Log Suspicious Activity**: Track potential exploits

═══════════════════════════════════════════════════════════════════════════════

## Input Validation

### Validate Player Source

❌ **Vulnerable:**
```lua
RegisterNetEvent('hunting:giveReward', function(amount)
    -- No player validation!
    Framework.AddMoney(source, 'cash', amount)
end)
```

✅ **Secure:**
```lua
RegisterNetEvent('hunting:giveReward', function()
    local src = source
    
    -- Validate player exists
    local player = Framework.GetPlayer(src)
    if not player then 
        print('[SECURITY] Invalid player source: ' .. src)
        return 
    end
    
    -- Server calculates reward, not client
    local reward = CalculatePlayerReward(src)
    Framework.AddMoney(src, 'cash', reward, 'Hunting reward')
end)
```

---

### Validate Entity Existence

❌ **Vulnerable:**
```lua
RegisterNetEvent('hunting:skinAnimal', function(animalNetId)
    -- Trusts client blindly
    local reward = 500  -- Fixed reward, exploitable
    Framework.AddMoney(source, 'cash', reward)
end)
```

✅ **Secure:**
```lua
RegisterNetEvent('hunting:skinAnimal', function(animalNetId)
    local src = source
    local player = Framework.GetPlayer(src)
    if not player then return end
    
    -- Validate entity exists
    local animal = NetworkGetEntityFromNetworkId(animalNetId)
    if not DoesEntityExist(animal) then
        print('[SECURITY] Player ' .. src .. ' sent invalid entity')
        return
    end
    
    -- Validate entity is dead
    if not IsEntityDead(animal) then
        print('[SECURITY] Player ' .. src .. ' tried to skin living animal')
        return
    end
    
    -- Server determines reward based on actual entity
    local animalModel = GetEntityModel(animal)
    local quality = DetermineQuality(animal)
    local reward = Config.AnimalRewards[animalModel] or 0
    
    Framework.AddMoney(src, 'cash', reward, 'Skinned animal')
    DeleteEntity(animal)
end)
```

---

### Validate Numeric Inputs

❌ **Vulnerable:**
```lua
RegisterNetEvent('shop:buyItem', function(itemName, quantity)
    -- No validation on quantity!
    Framework.AddItem(source, itemName, quantity)
end)
```

✅ **Secure:**
```lua
RegisterNetEvent('shop:buyItem', function(itemName, quantity)
    local src = source
    local player = Framework.GetPlayer(src)
    if not player then return end
    
    -- Validate quantity is a number
    if type(quantity) ~= 'number' then
        print('[SECURITY] Player ' .. src .. ' sent non-numeric quantity')
        return
    end
    
    -- Validate quantity is positive and reasonable
    if quantity < 1 or quantity > 100 then
        print('[SECURITY] Player ' .. src .. ' sent invalid quantity: ' .. quantity)
        return
    end
    
    -- Validate item exists in shop config
    if not Config.ShopItems[itemName] then
        print('[SECURITY] Player ' .. src .. ' tried to buy invalid item: ' .. itemName)
        return
    end
    
    -- Calculate and verify price
    local itemPrice = Config.ShopItems[itemName].price
    local totalCost = itemPrice * quantity
    
    -- Check player has money
    if player.PlayerData.money.cash < totalCost then
        TriggerClientEvent('shop:notify', src, 'Insufficient funds', 'error')
        return
    end
    
    -- Process purchase
    if Framework.RemoveMoney(src, 'cash', totalCost, 'Shop purchase') then
        Framework.AddItem(src, itemName, quantity)
    end
end)
```

---

### Validate String Inputs

❌ **Vulnerable:**
```lua
RegisterNetEvent('server:log', function(message)
    -- Accepts any string, potential for injection
    MySQL.execute('INSERT INTO logs (message) VALUES (?)', {message})
end)
```

✅ **Secure:**
```lua
RegisterNetEvent('server:log', function(message)
    local src = source
    
    -- Validate message is string
    if type(message) ~= 'string' then return end
    
    -- Validate length (prevent spam)
    if #message < 1 or #message > 500 then return end
    
    -- Sanitize input (remove special characters)
    message = message:gsub('[^%w%s%p]', '')
    
    -- Add server-side context
    local player = Framework.GetPlayer(src)
    local timestamp = os.date('%Y-%m-%d %H:%M:%S')
    
    MySQL.execute('INSERT INTO logs (player_id, message, timestamp) VALUES (?, ?, ?)', {
        player.PlayerData.citizenid,
        message,
        timestamp
    })
end)
```

═══════════════════════════════════════════════════════════════════════════════

## Distance Validation

### Why Distance Checks Matter

Players can teleport or trigger events from anywhere. Always verify proximity to prevent:
- Remote resource collection
- Long-distance trading
- Teleport exploits
- Out-of-range interactions

### Implementing Distance Checks

```lua
RegisterNetEvent('hunting:skinAnimal', function(animalNetId)
    local src = source
    local player = Framework.GetPlayer(src)
    if not player then return end
    
    -- Get player position
    local playerPed = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(playerPed)
    
    -- Get animal position
    local animal = NetworkGetEntityFromNetworkId(animalNetId)
    if not DoesEntityExist(animal) then return end
    
    local animalCoords = GetEntityCoords(animal)
    
    -- Calculate distance
    local distance = #(playerCoords - animalCoords)
    
    -- Validate distance (5 meters max)
    if distance > 5.0 then
        print('[SECURITY] Player ' .. src .. ' too far from animal: ' .. distance .. 'm')
        TriggerClientEvent('hunting:notify', src, 'Too far from animal', 'error')
        return
    end
    
    -- Continue processing...
end)
```

### Shop/Vendor Distance Check

```lua
RegisterNetEvent('shop:open', function(shopId)
    local src = source
    local player = Framework.GetPlayer(src)
    if not player then return end
    
    -- Get shop location
    local shopConfig = Config.Shops[shopId]
    if not shopConfig then return end
    
    -- Get player position
    local playerPed = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(playerPed)
    
    -- Check distance to shop
    local distance = #(playerCoords - shopConfig.coords)
    
    if distance > 10.0 then
        print('[SECURITY] Player ' .. src .. ' tried to open shop from ' .. distance .. 'm away')
        return
    end
    
    -- Open shop
    TriggerClientEvent('shop:display', src, shopConfig)
end)
```

### Dynamic Distance Check Function

```lua
-- Reusable distance validation
function ValidatePlayerDistance(src, coords, maxDistance, actionName)
    local playerPed = GetPlayerPed(src)
    if not playerPed or playerPed == 0 then 
        print('[SECURITY] Invalid player ped for ' .. src)
        return false 
    end
    
    local playerCoords = GetEntityCoords(playerPed)
    local distance = #(playerCoords - coords)
    
    if distance > maxDistance then
        print(string.format('[SECURITY] Player %s too far for %s: %.2fm (max: %.2fm)', 
            src, actionName, distance, maxDistance))
        return false
    end
    
    return true
end

-- Usage
RegisterNetEvent('hunting:processCarcass', function(netId)
    local src = source
    local animal = NetworkGetEntityFromNetworkId(netId)
    if not DoesEntityExist(animal) then return end
    
    local animalCoords = GetEntityCoords(animal)
    
    if not ValidatePlayerDistance(src, animalCoords, 5.0, 'skin animal') then
        return
    end
    
    -- Process...
end)
```

═══════════════════════════════════════════════════════════════════════════════

## Anti-Abuse Measures

### Cooldown System

Prevent action spam and exploits.

```lua
local PlayerCooldowns = {}

-- Cooldown configuration
local COOLDOWNS = {
    skin_animal = 3000,      -- 3 seconds
    sell_items = 5000,       -- 5 seconds
    use_bait = 10000,        -- 10 seconds
    spawn_legendary = 300000 -- 5 minutes
}

-- Check if player is on cooldown
function IsOnCooldown(src, action)
    local identifier = src .. '_' .. action
    local lastAction = PlayerCooldowns[identifier]
    
    if not lastAction then
        return false
    end
    
    local currentTime = GetGameTimer()
    local cooldownTime = COOLDOWNS[action] or 5000
    
    if currentTime - lastAction < cooldownTime then
        local remaining = math.ceil((cooldownTime - (currentTime - lastAction)) / 1000)
        return true, remaining
    end
    
    return false
end

-- Set cooldown for player
function SetCooldown(src, action)
    local identifier = src .. '_' .. action
    PlayerCooldowns[identifier] = GetGameTimer()
end

-- Usage in events
RegisterNetEvent('hunting:skinAnimal', function(netId)
    local src = source
    
    -- Check cooldown
    local onCooldown, remaining = IsOnCooldown(src, 'skin_animal')
    if onCooldown then
        TriggerClientEvent('hunting:notify', src, 
            'Please wait ' .. remaining .. ' seconds', 'error')
        return
    end
    
    -- Process action
    -- ... validation and processing ...
    
    -- Set cooldown
    SetCooldown(src, 'skin_animal')
end)
```

---

### Rate Limiting

Track action frequency to detect spam/exploits.

```lua
local RateLimits = {}

-- Rate limit configuration (max actions per time window)
local RATE_LIMITS = {
    skin_animal = { max = 10, window = 60000 },      -- 10 per minute
    buy_item = { max = 20, window = 60000 },         -- 20 per minute
    sell_item = { max = 15, window = 60000 },        -- 15 per minute
    use_ability = { max = 5, window = 30000 }        -- 5 per 30 seconds
}

-- Check if player exceeds rate limit
function CheckRateLimit(src, action)
    local config = RATE_LIMITS[action]
    if not config then return true end -- No limit configured
    
    local identifier = src .. '_' .. action
    local currentTime = GetGameTimer()
    
    -- Initialize tracking
    if not RateLimits[identifier] then
        RateLimits[identifier] = {
            count = 0,
            windowStart = currentTime
        }
    end
    
    local limit = RateLimits[identifier]
    
    -- Reset window if expired
    if currentTime - limit.windowStart > config.window then
        limit.count = 0
        limit.windowStart = currentTime
    end
    
    -- Increment counter
    limit.count = limit.count + 1
    
    -- Check if exceeded
    if limit.count > config.max then
        print(string.format('[SECURITY] Player %s exceeded rate limit for %s: %d/%d', 
            src, action, limit.count, config.max))
        
        -- Optional: Kick or ban player
        if limit.count > config.max * 2 then
            DropPlayer(src, 'Rate limit exceeded - suspected exploit')
        end
        
        return false
    end
    
    return true
end

-- Usage
RegisterNetEvent('hunting:skinAnimal', function(netId)
    local src = source
    
    -- Check rate limit
    if not CheckRateLimit(src, 'skin_animal') then
        TriggerClientEvent('hunting:notify', src, 'Action rate limit exceeded', 'error')
        return
    end
    
    -- Process action...
end)
```

---

### Prevent Duplicate Processing

Track processed entities to prevent double-dipping.

```lua
local ProcessedEntities = {}

-- Clean up old entries every 5 minutes
CreateThread(function()
    while true do
        Wait(300000) -- 5 minutes
        
        local currentTime = GetGameTimer()
        for netId, timestamp in pairs(ProcessedEntities) do
            if currentTime - timestamp > 600000 then -- 10 minutes
                ProcessedEntities[netId] = nil
            end
        end
    end
end)

RegisterNetEvent('hunting:skinAnimal', function(netId)
    local src = source
    
    -- Check if already processed
    if ProcessedEntities[netId] then
        print('[SECURITY] Player ' .. src .. ' tried to skin already processed animal')
        return
    end
    
    -- Validate and process...
    
    -- Mark as processed
    ProcessedEntities[netId] = GetGameTimer()
end)
```

═══════════════════════════════════════════════════════════════════════════════

## State Validation

### Inventory Checks

```lua
RegisterNetEvent('crafting:createItem', function(recipeId)
    local src = source
    local player = Framework.GetPlayer(src)
    if not player then return end
    
    local recipe = Config.Recipes[recipeId]
    if not recipe then return end
    
    -- Validate player has ALL required materials
    for item, amount in pairs(recipe.materials) do
        if not Framework.HasItem(src, item, amount) then
            TriggerClientEvent('crafting:notify', src, 
                'Missing required materials', 'error')
            return
        end
    end
    
    -- Remove materials
    for item, amount in pairs(recipe.materials) do
        Framework.RemoveItem(src, item, amount)
    end
    
    -- Give crafted item
    Framework.AddItem(src, recipe.result, recipe.resultAmount)
end)
```

---

### Job/Permission Checks

```lua
RegisterNetEvent('police:arrest', function(targetId)
    local src = source
    local player = Framework.GetPlayer(src)
    if not player then return end
    
    -- Check if player is police
    local job = player.PlayerData.job
    if job.name ~= 'police' then
        print('[SECURITY] Player ' .. src .. ' attempted arrest without being police')
        return
    end
    
    -- Check rank permission
    if job.grade.level < 2 then
        TriggerClientEvent('police:notify', src, 
            'Insufficient rank for arrests', 'error')
        return
    end
    
    -- Validate target
    local target = Framework.GetPlayer(targetId)
    if not target then return end
    
    -- Check distance
    local playerPed = GetPlayerPed(src)
    local targetPed = GetPlayerPed(targetId)
    local distance = #(GetEntityCoords(playerPed) - GetEntityCoords(targetPed))
    
    if distance > 5.0 then
        print('[SECURITY] Player ' .. src .. ' tried to arrest from ' .. distance .. 'm')
        return
    end
    
    -- Process arrest...
end)
```

---

### Money Validation

```lua
RegisterNetEvent('shop:purchase', function(itemName, quantity)
    local src = source
    local player = Framework.GetPlayer(src)
    if not player then return end
    
    local item = Config.ShopItems[itemName]
    if not item then return end
    
    local totalCost = item.price * quantity
    
    -- Check player has enough money
    local playerMoney = player.PlayerData.money.cash
    if playerMoney < totalCost then
        TriggerClientEvent('shop:notify', src, 'Insufficient funds', 'error')
        return
    end
    
    -- Attempt to remove money
    local success = Framework.RemoveMoney(src, 'cash', totalCost, 'Shop purchase')
    
    -- Verify removal succeeded
    if not success then
        print('[SECURITY] Failed to remove money from player ' .. src)
        return
    end
    
    -- Give item only after money removed
    Framework.AddItem(src, itemName, quantity)
    
    TriggerClientEvent('shop:notify', src, 'Purchase successful', 'success')
end)
```

═══════════════════════════════════════════════════════════════════════════════

## Common Attack Vectors & Mitigations

### 1. Money Duplication

**Attack:** Exploiting race conditions or client-side calculations.

**Mitigation:**
```lua
-- Use server-side calculations ONLY
RegisterNetEvent('hunting:completeSale', function(items)
    local src = source
    local player = Framework.GetPlayer(src)
    if not player then return end
    
    local totalValue = 0
    
    -- Server calculates value
    for itemName, quantity in pairs(items) do
        -- Verify player actually has items
        if Framework.HasItem(src, itemName, quantity) then
            local itemValue = Config.ItemPrices[itemName] or 0
            totalValue = totalValue + (itemValue * quantity)
            
            -- Remove items BEFORE adding money
            Framework.RemoveItem(src, itemName, quantity)
        end
    end
    
    -- Add money only after items removed
    if totalValue > 0 then
        Framework.AddMoney(src, 'cash', totalValue, 'Sold hunting items')
    end
end)
```

---

### 2. Resource Farming

**Attack:** Rapidly triggering resource collection.

**Mitigation:**
```lua
-- Implement cooldowns and rate limiting
local HarvestCooldowns = {}

RegisterNetEvent('gathering:harvest', function(nodeId)
    local src = source
    
    -- Check cooldown
    if HarvestCooldowns[src] and GetGameTimer() - HarvestCooldowns[src] < 3000 then
        return
    end
    
    -- Validate node exists and not depleted
    if not ActiveNodes[nodeId] or ActiveNodes[nodeId].depleted then
        return
    end
    
    -- Set cooldown
    HarvestCooldowns[src] = GetGameTimer()
    
    -- Process harvest
    GiveHarvestReward(src, nodeId)
    
    -- Deplete node
    ActiveNodes[nodeId].depleted = true
    
    -- Respawn after delay
    SetTimeout(Config.RespawnTime, function()
        ActiveNodes[nodeId].depleted = false
    end)
end)
```

---

### 3. Teleport Exploits

**Attack:** Teleporting to locations or entities.

**Mitigation:**
```lua
-- Always validate distance
RegisterNetEvent('shop:buyItem', function(shopId, itemName)
    local src = source
    local player = Framework.GetPlayer(src)
    if not player then return end
    
    -- Get shop location
    local shop = Config.Shops[shopId]
    if not shop then return end
    
    -- Validate player is at shop
    local playerCoords = GetEntityCoords(GetPlayerPed(src))
    local distance = #(playerCoords - shop.coords)
    
    if distance > 10.0 then
        print('[SECURITY] Player ' .. src .. ' tried to access shop from ' .. distance .. 'm')
        DropPlayer(src, 'Suspected teleport exploit')
        return
    end
    
    -- Process purchase...
end)
```

---

### 4. Item Duplication

**Attack:** Exploiting inventory systems or timing issues.

**Mitigation:**
```lua
-- Atomic transactions: verify -> remove -> add -> verify
RegisterNetEvent('trading:giveMoney', function(targetId, amount)
    local src = source
    local player = Framework.GetPlayer(src)
    local target = Framework.GetPlayer(targetId)
    
    if not player or not target then return end
    
    -- Validate amount
    if amount < 1 or amount > 100000 then return end
    
    -- Check player has money
    if player.PlayerData.money.cash < amount then
        return
    end
    
    -- Remove from sender FIRST
    local removed = Framework.RemoveMoney(src, 'cash', amount, 'Trade to ' .. targetId)
    
    -- Only give if removal succeeded
    if removed then
        Framework.AddMoney(targetId, 'cash', amount, 'Trade from ' .. src)
        
        -- Log transaction
        LogTransaction({
            from = player.PlayerData.citizenid,
            to = target.PlayerData.citizenid,
            amount = amount,
            timestamp = os.time()
        })
    else
        print('[SECURITY] Failed to remove money from ' .. src .. ' in trade')
    end
end)
```

---

### 5. Event Injection

**Attack:** Triggering server events with fake data.

**Mitigation:**
```lua
-- Never expose direct reward events
-- ❌ BAD
RegisterNetEvent('hunting:giveReward', function(amount)
    Framework.AddMoney(source, 'cash', amount)
end)

-- ✅ GOOD
RegisterNetEvent('hunting:completeTask', function(taskId)
    local src = source
    local player = Framework.GetPlayer(src)
    if not player then return end
    
    -- Validate task exists
    local task = GetPlayerActiveTask(src, taskId)
    if not task then return end
    
    -- Validate task completion
    if not ValidateTaskCompletion(src, task) then
        return
    end
    
    -- Server determines reward
    local reward = Config.TaskRewards[taskId] or 0
    Framework.AddMoney(src, 'cash', reward, 'Completed task')
    
    -- Mark task complete
    MarkTaskComplete(src, taskId)
end)
```

═══════════════════════════════════════════════════════════════════════════════

## Logging and Monitoring

### Transaction Logging

```lua
function LogTransaction(data)
    local timestamp = os.date('%Y-%m-%d %H:%M:%S')
    
    MySQL.insert('INSERT INTO transaction_logs (player_id, action, amount, details, timestamp) VALUES (?, ?, ?, ?, ?)', {
        data.playerId,
        data.action,
        data.amount,
        json.encode(data.details or {}),
        timestamp
    })
    
    -- Also log to console
    print(string.format('[TRANSACTION] %s | Player: %s | Action: %s | Amount: %d',
        timestamp, data.playerId, data.action, data.amount))
end

-- Usage
RegisterNetEvent('hunting:sellPelt', function(peltType, quantity)
    local src = source
    -- ... validation ...
    
    local totalValue = CalculateValue(peltType, quantity)
    Framework.AddMoney(src, 'cash', totalValue, 'Sold pelts')
    
    -- Log transaction
    LogTransaction({
        playerId = player.PlayerData.citizenid,
        action = 'sell_pelts',
        amount = totalValue,
        details = {
            peltType = peltType,
            quantity = quantity,
            timestamp = os.time()
        }
    })
end)
```

---

### Suspicious Activity Detection

```lua
local SuspiciousActivity = {}

function FlagSuspiciousActivity(src, reason, severity)
    local player = Framework.GetPlayer(src)
    if not player then return end
    
    local citizenid = player.PlayerData.citizenid
    
    if not SuspiciousActivity[citizenid] then
        SuspiciousActivity[citizenid] = {
            flags = {},
            count = 0
        }
    end
    
    -- Add flag
    table.insert(SuspiciousActivity[citizenid].flags, {
        reason = reason,
        severity = severity,
        timestamp = os.time()
    })
    
    SuspiciousActivity[citizenid].count = SuspiciousActivity[citizenid].count + 1
    
    -- Log to console
    print(string.format('[SECURITY] Player %s flagged: %s (Severity: %d)', 
        citizenid, reason, severity))
    
    -- Auto-action based on severity
    if severity >= 3 or SuspiciousActivity[citizenid].count >= 5 then
        -- Kick player
        DropPlayer(src, 'Suspicious activity detected. Contact server administrators.')
        
        -- Send to Discord
        SendToDiscord('Security Alert', string.format(
            'Player: %s\nReason: %s\nSeverity: %d\nTotal Flags: %d',
            citizenid, reason, severity, SuspiciousActivity[citizenid].count
        ), 15158332) -- Red color
    end
end

-- Usage
RegisterNetEvent('hunting:skinAnimal', function(netId)
    local src = source
    local animal = NetworkGetEntityFromNetworkId(netId)
    
    if not DoesEntityExist(animal) then
        FlagSuspiciousActivity(src, 'Invalid entity sent', 1)
        return
    end
    
    local distance = GetDistanceBetweenPlayerAndEntity(src, animal)
    if distance > 10.0 then
        FlagSuspiciousActivity(src, 'Distance exploit attempt: ' .. distance .. 'm', 2)
        return
    end
    
    -- Process...
end)
```

═══════════════════════════════════════════════════════════════════════════════

## Discord Webhook Logging (Optional)

### Configuration

```lua
-- config/logging.lua
Config.DiscordWebhooks = {
    enabled = true,
    webhooks = {
        transactions = 'YOUR_WEBHOOK_URL_HERE',
        security = 'YOUR_WEBHOOK_URL_HERE',
        admin = 'YOUR_WEBHOOK_URL_HERE'
    }
}
```

### Send to Discord Function

```lua
function SendToDiscord(title, message, color, webhookType)
    if not Config.DiscordWebhooks.enabled then return end
    
    webhookType = webhookType or 'admin'
    local webhook = Config.DiscordWebhooks.webhooks[webhookType]
    
    if not webhook then return end
    
    local embed = {
        {
            ['title'] = title,
            ['description'] = message,
            ['color'] = color or 3447003,
            ['footer'] = {
                ['text'] = 'The Land of Wolves 🐺 | ' .. os.date('%Y-%m-%d %H:%M:%S')
            }
        }
    }
    
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        username = 'LXR-Core Security',
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end

-- Usage
RegisterNetEvent('hunting:sellItems', function(items, totalValue)
    local src = source
    -- ... processing ...
    
    -- Log to Discord
    SendToDiscord(
        'Item Sale',
        string.format('Player: %s\nItems: %s\nValue: $%d', 
            GetPlayerName(src), json.encode(items), totalValue),
        3447003, -- Blue
        'transactions'
    )
end)

-- Security alerts
function LogSecurityIncident(src, incident)
    local player = Framework.GetPlayer(src)
    
    SendToDiscord(
        '🚨 Security Incident',
        string.format('Player: %s (%s)\nIncident: %s\nTimestamp: %s',
            GetPlayerName(src),
            player.PlayerData.citizenid,
            incident,
            os.date('%Y-%m-%d %H:%M:%S')),
        15158332, -- Red
        'security'
    )
end
```

═══════════════════════════════════════════════════════════════════════════════

## Security Checklist

### Before Release

- [ ] **All server events validate player source**
- [ ] **All numeric inputs validated (type, range, positive)**
- [ ] **All string inputs sanitized**
- [ ] **Distance checks on all location-based actions**
- [ ] **Cooldowns implemented on repeatable actions**
- [ ] **Rate limiting on frequent actions**
- [ ] **Entity existence validated before operations**
- [ ] **Inventory checks before giving/removing items**
- [ ] **Money checks before transactions**
- [ ] **Job/permission checks on restricted actions**
- [ ] **Server calculates all rewards/prices/values**
- [ ] **No direct reward events exposed to client**
- [ ] **Transaction logging implemented**
- [ ] **Suspicious activity detection in place**
- [ ] **Processed entities tracked to prevent double-dipping**
- [ ] **Atomic transactions (verify -> act -> verify)**
- [ ] **Error handling on all database operations**
- [ ] **Client never trusted for critical decisions**

═══════════════════════════════════════════════════════════════════════════════

## Testing for Vulnerabilities

### Manual Testing

1. **Try to trigger events from console**
   ```lua
   TriggerServerEvent('yourresource:giveReward', 999999)
   ```
   Should be blocked by server validation.

2. **Spam actions rapidly**
   Trigger same event 100 times per second.
   Should be rate limited or cooldown protected.

3. **Send invalid data types**
   ```lua
   TriggerServerEvent('shop:buy', 'item', 'not_a_number')
   ```
   Should be type validated.

4. **Teleport and try to interact**
   Teleport far from shop, try to purchase.
   Should be distance checked.

5. **Modify local client files**
   Try to change prices, rewards in client files.
   Should have no effect (server authoritative).

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
