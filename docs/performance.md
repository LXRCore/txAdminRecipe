```
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗ ██████╗ ███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██╔═══██╗██╔══██╗██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██████╔╝█████╗  
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██╔══██╗██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║      ╚██████╗╚██████╔╝██║  ██║███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
```

# ⚡ Performance Optimization - LXR-Core txAdmin Recipe

**The Land of Wolves Official Performance Guide**

═══════════════════════════════════════════════════════════════════════════════

## Overview

Performance optimization is **critical** for smooth gameplay and server stability. This guide covers best practices for minimizing resource usage, reducing lag, and maximizing server performance in RedM/FiveM environments.

> **Golden Rule:** Optimize early, profile often, and never assume.

═══════════════════════════════════════════════════════════════════════════════

## Understanding Performance Metrics

### Key Metrics

- **ms/tick**: Milliseconds per frame (target: <0.5ms for most resources)
- **FPS**: Frames per second (target: 60 FPS on client)
- **Server FPS**: Server ticks per second (target: 50-100 FPS)
- **Network Traffic**: Data sent/received (minimize packet size)
- **Memory Usage**: RAM consumption (watch for leaks)

### Monitoring Performance

```bash
# In F8 console (client)
resmon

# In server console
profiler record 60  # Record for 60 seconds
profiler view       # View results
```

═══════════════════════════════════════════════════════════════════════════════

## Tick Minimization Strategies

### The Problem with Tight Loops

❌ **Bad - Runs every frame (~0ms wait):**
```lua
CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        -- Check something every frame
        if IsPedShooting(playerPed) then
            DoSomething()
        end
        
        Wait(0)  -- Runs ~60 times per second!
    end
end)
```
**Problem:** Runs 60+ times per second, wasting CPU cycles.

---

### Solution 1: Increase Wait Time

✅ **Good - Appropriate wait time:**
```lua
CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        -- Check less frequently
        if IsPedShooting(playerPed) then
            DoSomething()
        end
        
        Wait(100)  -- Runs 10 times per second
    end
end)
```
**Improvement:** 6x fewer iterations = 6x better performance.

---

### Solution 2: Event-Driven Logic

✅ **Best - Event-driven instead of polling:**
```lua
-- Instead of constantly checking, listen for events
AddEventHandler('weaponDamageEvent', function(sender, data)
    -- React to shooting immediately
    DoSomething()
end)

-- Or use native events
AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkEntityDamage' then
        -- Handle damage event
    end
end)
```
**Improvement:** Zero overhead until event occurs.

---

### Solution 3: Conditional Threading

✅ **Smart - Only run when needed:**
```lua
local isHunting = false

-- Start thread only when hunting begins
function StartHuntingThread()
    if isHunting then return end  -- Already running
    
    isHunting = true
    
    CreateThread(function()
        while isHunting do
            -- Check for animals
            local animals = GetNearbyAnimals()
            DisplayAnimalMarkers(animals)
            
            Wait(1000)  -- 1 second
        end
    end)
end

-- Stop when not needed
function StopHuntingThread()
    isHunting = false
end

-- Activate based on job
RegisterNetEvent('framework:jobUpdate', function(job)
    if job.name == 'hunter' then
        StartHuntingThread()
    else
        StopHuntingThread()
    end
end)
```

═══════════════════════════════════════════════════════════════════════════════

## Caching Best Practices

### Cache Native Results

❌ **Bad - Repeated native calls:**
```lua
CreateThread(function()
    while true do
        local ped = PlayerPedId()  -- Called every frame
        local coords = GetEntityCoords(PlayerPedId())  -- Called again!
        local heading = GetEntityHeading(PlayerPedId())  -- And again!
        
        Wait(0)
    end
end)
```

✅ **Good - Cache results:**
```lua
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)  -- Reuse ped variable
        local heading = GetEntityHeading(ped)
        
        Wait(100)
    end
end)
```

✅ **Better - Cache outside loop when possible:**
```lua
local playerPed = PlayerPedId()

CreateThread(function()
    while true do
        -- Update cache periodically
        playerPed = PlayerPedId()
        
        local coords = GetEntityCoords(playerPed)
        local heading = GetEntityHeading(playerPed)
        
        Wait(1000)  -- Update every second
    end
end)
```

---

### Cache Configuration Data

❌ **Bad - Load config every time:**
```lua
RegisterNetEvent('hunting:processAnimal', function(animalType)
    local cfg = LoadResourceFile(GetCurrentResourceName(), 'config.json')
    local config = json.decode(cfg)
    local reward = config.animals[animalType].reward
    
    -- Process...
end)
```

✅ **Good - Load once, cache forever:**
```lua
-- Load at resource start
local AnimalConfig = {}

CreateThread(function()
    local cfg = LoadResourceFile(GetCurrentResourceName(), 'config.json')
    AnimalConfig = json.decode(cfg)
end)

RegisterNetEvent('hunting:processAnimal', function(animalType)
    local reward = AnimalConfig.animals[animalType].reward
    
    -- Process...
end)
```

---

### Cache Database Queries

❌ **Bad - Query database repeatedly:**
```lua
CreateThread(function()
    while true do
        MySQL.query('SELECT * FROM player_hunting WHERE citizenid = ?', {citizenid}, function(result)
            local stats = result[1]
            UpdateUI(stats)
        end)
        
        Wait(5000)
    end
end)
```

✅ **Good - Cache with event-driven updates:**
```lua
local playerStats = {}

-- Load once on player load
RegisterNetEvent('framework:playerLoaded', function()
    MySQL.query('SELECT * FROM player_hunting WHERE citizenid = ?', {citizenid}, function(result)
        if result[1] then
            playerStats = result[1]
            UpdateUI(playerStats)
        end
    end)
end)

-- Update cache when stats change
RegisterNetEvent('hunting:statsUpdated', function(newStats)
    playerStats = newStats
    UpdateUI(playerStats)
end)
```

═══════════════════════════════════════════════════════════════════════════════

## Distance-Based Loading

Only process entities/actions within relevant range.

### Basic Distance Check

```lua
CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        -- Only check shops within 50 meters
        for shopId, shop in pairs(Config.Shops) do
            local distance = #(playerCoords - shop.coords)
            
            if distance < 50.0 then
                -- Close enough to matter
                if distance < 3.0 then
                    -- Show prompt
                    ShowHelpText('Press [E] to open shop')
                    
                    if IsControlJustPressed(0, 0x0322F03D) then
                        OpenShop(shopId)
                    end
                end
            end
        end
        
        Wait(500)  -- Check twice per second
    end
end)
```

---

### Optimized Distance Check with Zones

```lua
-- Define zones for different check frequencies
local ZONES = {
    immediate = 3.0,   -- Show prompts
    nearby = 20.0,     -- Show blips
    distant = 100.0    -- Load entities
}

local nearbyShops = {}

-- Update nearby shops less frequently
CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())
        nearbyShops = {}
        
        for shopId, shop in pairs(Config.Shops) do
            local distance = #(playerCoords - shop.coords)
            
            if distance < ZONES.distant then
                table.insert(nearbyShops, {
                    id = shopId,
                    data = shop,
                    distance = distance
                })
            end
        end
        
        Wait(2000)  -- Update every 2 seconds
    end
end)

-- Check immediate vicinity frequently
CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())
        
        for _, shop in ipairs(nearbyShops) do
            local distance = #(playerCoords - shop.data.coords)
            
            if distance < ZONES.immediate then
                ShowHelpText('Press [E] to open shop')
                
                if IsControlJustPressed(0, 0x0322F03D) then
                    OpenShop(shop.id)
                end
            end
        end
        
        Wait(0)  -- Only runs when shops are nearby
    end
end)
```

═══════════════════════════════════════════════════════════════════════════════

## Event Throttling

Prevent event spam from degrading performance.

### Debouncing

Only trigger event after delay without additional calls.

```lua
local debounceTimer = nil

function DebouncedAction()
    if debounceTimer then
        -- Cancel previous timer
        ClearTimeout(debounceTimer)
    end
    
    -- Set new timer
    debounceTimer = SetTimeout(500, function()
        -- Execute after 500ms of no calls
        ActualAction()
        debounceTimer = nil
    end)
end

-- Usage: Rapid calls will only execute once
DebouncedAction()  -- Starts timer
DebouncedAction()  -- Resets timer
DebouncedAction()  -- Resets timer
-- 500ms passes -> ActualAction() executes once
```

---

### Throttling

Limit execution rate.

```lua
local lastExecution = 0
local throttleDelay = 1000  -- 1 second

function ThrottledAction()
    local currentTime = GetGameTimer()
    
    if currentTime - lastExecution < throttleDelay then
        -- Too soon, skip
        return
    end
    
    lastExecution = currentTime
    ActualAction()
end

-- Usage: Only executes once per second max
ThrottledAction()  -- Executes
ThrottledAction()  -- Skipped (too soon)
-- Wait 1+ seconds
ThrottledAction()  -- Executes
```

---

### Server-Side Event Throttling

```lua
local PlayerEventThrottles = {}

function IsEventThrottled(src, eventName, delay)
    local key = src .. '_' .. eventName
    local lastCall = PlayerEventThrottles[key]
    local currentTime = GetGameTimer()
    
    if lastCall and currentTime - lastCall < delay then
        return true
    end
    
    PlayerEventThrottles[key] = currentTime
    return false
end

-- Usage
RegisterNetEvent('hunting:action', function()
    local src = source
    
    if IsEventThrottled(src, 'hunting:action', 2000) then
        -- Throttled
        return
    end
    
    -- Process action
end)
```

═══════════════════════════════════════════════════════════════════════════════

## Database Optimization

### Use Prepared Statements

✅ **Good - Parameterized queries:**
```lua
MySQL.query('SELECT * FROM players WHERE citizenid = ?', {citizenid}, function(result)
    -- Process result
end)
```

❌ **Bad - String concatenation (SQL injection risk!):**
```lua
MySQL.query('SELECT * FROM players WHERE citizenid = "' .. citizenid .. '"', function(result)
    -- Vulnerable!
end)
```

---

### Batch Operations

❌ **Bad - Multiple individual queries:**
```lua
for _, item in ipairs(items) do
    MySQL.insert('INSERT INTO inventory (player, item) VALUES (?, ?)', {
        playerId, item
    })
end
```

✅ **Good - Single batch query:**
```lua
local values = {}
for _, item in ipairs(items) do
    table.insert(values, {playerId, item})
end

MySQL.prepare('INSERT INTO inventory (player, item) VALUES (?, ?)', values)
```

---

### Index Your Tables

```sql
-- Add indexes to frequently queried columns
CREATE INDEX idx_citizenid ON players(citizenid);
CREATE INDEX idx_player_inventory ON inventory(player_id);
CREATE INDEX idx_timestamp ON logs(timestamp);

-- Composite indexes for multi-column queries
CREATE INDEX idx_player_item ON inventory(player_id, item_name);
```

---

### Limit Result Sets

```lua
-- Don't fetch all data if you only need recent
MySQL.query('SELECT * FROM logs WHERE player_id = ? ORDER BY timestamp DESC LIMIT 50', {
    playerId
}, function(result)
    -- Only get last 50 entries
end)
```

---

### Use Async Queries

✅ **Good - Non-blocking:**
```lua
MySQL.query('SELECT * FROM players WHERE citizenid = ?', {citizenid}, function(result)
    if result[1] then
        ProcessPlayer(result[1])
    end
end)
```

❌ **Bad - Blocking (if using sync):**
```lua
local result = MySQL.query.await('SELECT * FROM players WHERE citizenid = ?', {citizenid})
-- Blocks server until query completes!
```

═══════════════════════════════════════════════════════════════════════════════

## Client-Side Prediction

Improve responsiveness by predicting server response.

### Example: Inventory Update

```lua
-- Client predicts item addition
RegisterNetEvent('shop:buyItem', function(itemName)
    -- Optimistically update UI immediately
    UpdateInventoryUI(itemName, '+1')
    
    -- Request from server
    TriggerServerEvent('shop:purchaseItem', itemName)
end)

-- Server validates and responds
RegisterNetEvent('shop:purchaseResponse', function(success, itemName)
    if not success then
        -- Rollback prediction
        UpdateInventoryUI(itemName, '-1')
        Framework.Notify('Purchase failed', 'error', 3000)
    else
        -- Prediction was correct, UI already updated
        Framework.Notify('Purchased ' .. itemName, 'success', 2000)
    end
end)
```

### Example: Money Transaction

```lua
-- Client-side prediction for money
local predictedMoney = 0

function PredictMoneyChange(account, amount)
    predictedMoney = predictedMoney + amount
    UpdateMoneyDisplay(account, predictedMoney)
end

function CorrectMoneyPrediction(account, actualAmount)
    predictedMoney = actualAmount
    UpdateMoneyDisplay(account, predictedMoney)
end

-- Use prediction
RegisterNetEvent('shop:buy', function(price)
    -- Predict money decrease
    PredictMoneyChange('cash', -price)
    
    -- Request from server
    TriggerServerEvent('shop:purchase')
end)

-- Server corrects if needed
RegisterNetEvent('framework:moneyUpdate', function(account, amount)
    CorrectMoneyPrediction(account, amount)
end)
```

═══════════════════════════════════════════════════════════════════════════════

## Resource Monitoring

### Built-in Performance Profiler

```lua
-- server/profiler.lua
if Config.Debug then
    CreateThread(function()
        while true do
            Wait(60000)  -- Every minute
            
            local profile = GetResourceMetrics(GetCurrentResourceName())
            
            print('=== Resource Performance ===')
            print('Memory: ' .. (profile.memory / 1024) .. ' KB')
            print('Ticks: ' .. profile.ticks)
            print('Average tick: ' .. profile.averageTick .. ' ms')
            print('==========================')
        end
    end)
end
```

---

### Custom Performance Tracking

```lua
local PerformanceMetrics = {
    eventCounts = {},
    eventTimes = {}
}

function TrackEventPerformance(eventName, startTime)
    local duration = (GetGameTimer() - startTime)
    
    if not PerformanceMetrics.eventCounts[eventName] then
        PerformanceMetrics.eventCounts[eventName] = 0
        PerformanceMetrics.eventTimes[eventName] = 0
    end
    
    PerformanceMetrics.eventCounts[eventName] = PerformanceMetrics.eventCounts[eventName] + 1
    PerformanceMetrics.eventTimes[eventName] = PerformanceMetrics.eventTimes[eventName] + duration
    
    if duration > 50 then
        print('[PERFORMANCE] Slow event: ' .. eventName .. ' took ' .. duration .. 'ms')
    end
end

-- Usage
RegisterNetEvent('hunting:processAnimal', function(netId)
    local startTime = GetGameTimer()
    
    -- Process event
    local result = ProcessAnimal(netId)
    
    -- Track performance
    TrackEventPerformance('hunting:processAnimal', startTime)
end)

-- Report command
RegisterCommand('perfstats', function(source)
    for eventName, count in pairs(PerformanceMetrics.eventCounts) do
        local avgTime = PerformanceMetrics.eventTimes[eventName] / count
        print(string.format('%s: %d calls, avg %.2fms', eventName, count, avgTime))
    end
end, true)
```

═══════════════════════════════════════════════════════════════════════════════

## Common Performance Pitfalls

### 1. Unnecessary Entity Enumeration

❌ **Bad:**
```lua
CreateThread(function()
    while true do
        -- Gets ALL peds every frame!
        local peds = GetGamePool('CPed')
        
        for _, ped in ipairs(peds) do
            if IsPedDeadOrDying(ped) then
                ProcessDeadPed(ped)
            end
        end
        
        Wait(0)
    end
end)
```

✅ **Good:**
```lua
-- Use event-driven approach
AddEventHandler('gameEventTriggered', function(event, args)
    if event == 'CEventNetworkEntityDamage' then
        local victim = args[1]
        
        if IsEntityDead(victim) and IsPedAnimal(victim) then
            ProcessDeadPed(victim)
        end
    end
end)
```

---

### 2. String Concatenation in Loops

❌ **Bad:**
```lua
local message = ''
for i = 1, 1000 do
    message = message .. 'Item ' .. i .. '\n'  -- Creates 1000 new strings!
end
```

✅ **Good:**
```lua
local parts = {}
for i = 1, 1000 do
    table.insert(parts, 'Item ' .. i)
end
local message = table.concat(parts, '\n')  -- One concatenation
```

---

### 3. Synchronous Operations

❌ **Bad:**
```lua
-- Blocks everything until complete
local result = exports.oxmysql:executeSync('SELECT * FROM large_table')
ProcessResults(result)
```

✅ **Good:**
```lua
-- Non-blocking
exports.oxmysql:execute('SELECT * FROM large_table', {}, function(result)
    ProcessResults(result)
end)
```

---

### 4. Not Cleaning Up

❌ **Bad:**
```lua
-- Spawns blip but never removes it
function ShowTargetBlip(coords)
    local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, coords)
    -- Blip stays forever, even when no longer needed!
end
```

✅ **Good:**
```lua
local activeBlips = {}

function ShowTargetBlip(id, coords)
    -- Remove old blip if exists
    if activeBlips[id] then
        RemoveBlip(activeBlips[id])
    end
    
    -- Create new blip
    local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, coords)
    activeBlips[id] = blip
    
    return blip
end

function RemoveTargetBlip(id)
    if activeBlips[id] then
        RemoveBlip(activeBlips[id])
        activeBlips[id] = nil
    end
end

-- Clean up on resource stop
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for _, blip in pairs(activeBlips) do
            RemoveBlip(blip)
        end
    end
end)
```

---

### 5. Excessive Network Events

❌ **Bad:**
```lua
-- Sends event every frame
CreateThread(function()
    while true do
        TriggerServerEvent('player:updatePosition', GetEntityCoords(PlayerPedId()))
        Wait(0)  -- 60+ times per second!
    end
end)
```

✅ **Good:**
```lua
-- Send only when needed
local lastPosition = nil

CreateThread(function()
    while true do
        local currentPos = GetEntityCoords(PlayerPedId())
        
        -- Only send if moved significantly
        if not lastPosition or #(currentPos - lastPosition) > 50.0 then
            TriggerServerEvent('player:updatePosition', currentPos)
            lastPosition = currentPos
        end
        
        Wait(5000)  -- Every 5 seconds
    end
end)
```

═══════════════════════════════════════════════════════════════════════════════

## Recommended Update Intervals

Different operations require different frequencies:

| Operation | Recommended Interval | Justification |
|-----------|---------------------|---------------|
| **Input Detection** | 0-50ms | Needs to be responsive |
| **UI Updates** | 100-250ms | Human perception limit |
| **Position Checks** | 500-1000ms | Movement isn't instant |
| **Nearby Entity Scan** | 1000-2000ms | Entities don't teleport |
| **Database Sync** | 5000-10000ms | Data rarely changes rapidly |
| **Statistics Update** | 10000-30000ms | Not time-critical |
| **Cleanup Tasks** | 60000-300000ms | Maintenance operations |

### Example Implementation

```lua
-- Input detection (responsive)
CreateThread(function()
    while true do
        if IsControlJustPressed(0, Config.KeyBinds.open) then
            OpenMenu()
        end
        Wait(0)
    end
end)

-- UI updates (visible changes)
CreateThread(function()
    while true do
        UpdateHUD()
        Wait(250)  -- 4 times per second
    end
end)

-- Position checks (movement-based)
CreateThread(function()
    while true do
        CheckNearbyInteractions()
        Wait(1000)  -- Once per second
    end
end)

-- Background sync (periodic)
CreateThread(function()
    while true do
        SyncPlayerData()
        Wait(30000)  -- Every 30 seconds
    end
end)

-- Cleanup (maintenance)
CreateThread(function()
    while true do
        CleanupStaleData()
        Wait(300000)  -- Every 5 minutes
    end
end)
```

═══════════════════════════════════════════════════════════════════════════════

## Memory Management

### Prevent Memory Leaks

❌ **Bad - Creates leak:**
```lua
CreateThread(function()
    while true do
        local data = {}  -- New table every iteration
        
        for i = 1, 10000 do
            data[i] = GetSomeData()
        end
        
        -- Data never cleaned up if thread continues
        Wait(1000)
    end
end)
```

✅ **Good - Reuse tables:**
```lua
local dataCache = {}  -- Reusable table

CreateThread(function()
    while true do
        -- Clear table
        for k in pairs(dataCache) do
            dataCache[k] = nil
        end
        
        -- Populate with new data
        for i = 1, 10000 do
            dataCache[i] = GetSomeData()
        end
        
        ProcessData(dataCache)
        
        Wait(1000)
    end
end)
```

---

### Garbage Collection

```lua
-- Force garbage collection during non-critical times
CreateThread(function()
    while true do
        Wait(300000)  -- Every 5 minutes
        
        -- Perform manual GC during quiet period
        collectgarbage('collect')
        
        if Config.Debug then
            print('[GC] Memory: ' .. collectgarbage('count') .. ' KB')
        end
    end
end)
```

═══════════════════════════════════════════════════════════════════════════════

## Performance Checklist

### Before Release

- [ ] **No threads with Wait(0) or Wait(1)**
- [ ] **All position checks use appropriate intervals (500ms+)**
- [ ] **Database queries are async and indexed**
- [ ] **Entity pools only scanned when necessary**
- [ ] **Results cached where possible**
- [ ] **Event throttling implemented**
- [ ] **Distance-based culling for rendering/checks**
- [ ] **Cleanup handlers for resource stop**
- [ ] **No string concatenation in hot loops**
- [ ] **Network events minimized and batched**
- [ ] **Client-side prediction where applicable**
- [ ] **Memory leak prevention measures**
- [ ] **Profiling shows <0.5ms average tick**
- [ ] **Resource monitoring implemented for debugging**

═══════════════════════════════════════════════════════════════════════════════

## Profiling Your Resource

### Using txAdmin Profiler

1. Open txAdmin web panel
2. Navigate to Resources
3. Find your resource
4. Click "Profile" button
5. Review ms/tick and memory usage

### Using resmon

1. Press F8 in-game
2. Type `resmon`
3. Find your resource
4. Look at:
   - **CPU time (ms)**: Should be <0.5ms
   - **Memory**: Watch for continuous growth (leak)
   - **Threads**: Minimize active threads

### Optimization Workflow

1. **Identify** bottlenecks with profiler
2. **Analyze** hot code paths
3. **Optimize** most expensive operations first
4. **Test** performance impact
5. **Verify** no functionality broken
6. **Repeat** for next bottleneck

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
