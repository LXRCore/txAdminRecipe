--[[
  ╦ ╦╔═╗╦  ╦  ╦╔═╗╔═╗  ╦  ╔═╗╔╗╔╔╦╗
  ║║║║ ║║  ╚╗╔╝║╣ ╚═╗  ║  ╠═╣║║║ ║║
  ╚╩╝╚═╝╩═╝ ╚╝ ╚═╝╚═╝  ╩═╝╩ ╩╝╚╝═╩╝
  ════════════════════════════════════════════════════════════
  Template Resource - Server Main Script
  Example Looting System - Server-Side Implementation
  ════════════════════════════════════════════════════════════
  wolves.land | discord.gg/lxr | lxrcore.com
  ════════════════════════════════════════════════════════════
]]

-- ═══════════════════════════════════════════════════════════
-- ██████ SERVER VARIABLES ███████████████████████████████████
-- ═══════════════════════════════════════════════════════════

local lootedProps = {}          -- Track looted props globally
local playerCooldowns = {}      -- Track player cooldowns
local playerAttempts = {}       -- Track attempts for anti-exploit

-- ═══════════════════════════════════════════════════════════
-- ██████ UTILITY FUNCTIONS ██████████████████████████████████
-- ═══════════════════════════════════════════════════════════

---Check if player is near a prop
---@param source number Player source
---@param propCoords vector3 Prop coordinates
---@return boolean Is near prop
local function IsPlayerNearProp(source, propCoords)
    local playerPed = GetPlayerPed(source)
    if not DoesEntityExist(playerPed) then return false end
    
    local playerCoords = GetEntityCoords(playerPed)
    local distance = #(playerCoords - vector3(propCoords.x, propCoords.y, propCoords.z))
    
    return distance <= Config.Security.maxDistance
end

---Check if prop is on cooldown
---@param propNetId number Network ID of prop
---@return boolean Is on cooldown
local function IsPropOnCooldown(propNetId)
    if not Config.Cooldowns.enabled then return false end
    
    if lootedProps[propNetId] then
        local timeSince = os.time() - lootedProps[propNetId]
        return timeSince < (Config.Cooldowns.perPropCooldown / 1000)
    end
    
    return false
end

---Check player cooldown
---@param source number Player source
---@return boolean Is on cooldown
local function IsPlayerOnCooldown(source)
    if not Config.Cooldowns.enabled then return false end
    
    if playerCooldowns[source] then
        local timeSince = os.time() - playerCooldowns[source]
        return timeSince < (Config.Cooldowns.globalCooldown / 1000)
    end
    
    return false
end

---Check for speed hacks / exploits
---@param source number Player source
---@return boolean Is exploiting
local function IsPlayerExploiting(source)
    if not Config.Security.detectSpeedHacks then return false end
    
    local currentTime = os.time()
    
    -- Initialize tracking
    if not playerAttempts[source] then
        playerAttempts[source] = {
            attempts = {},
            lastReset = currentTime
        }
    end
    
    local data = playerAttempts[source]
    
    -- Reset counter every minute
    if currentTime - data.lastReset >= 60 then
        data.attempts = {}
        data.lastReset = currentTime
    end
    
    -- Add attempt
    table.insert(data.attempts, currentTime)
    
    -- Check if exceeded max attempts
    if #data.attempts > Config.Security.maxAttemptsPerMinute then
        return true
    end
    
    return false
end

---Get random loot from tier
---@param tier string Tier name (tier1, tier2, tier3)
---@return table|nil Loot item or nil
local function GetRandomLootFromTier(tier)
    local lootTable = Config.LootTables[tier]
    if not lootTable or #lootTable == 0 then return nil end
    
    for _, loot in ipairs(lootTable) do
        local roll = math.random(100)
        if roll <= loot.chance then
            local amount = math.random(loot.min, loot.max)
            return {
                item = loot.item,
                amount = amount
            }
        end
    end
    
    return nil
end

---Generate loot rewards
---@return table Rewards {money = number, items = table}
local function GenerateLoot()
    local rewards = {
        money = 0,
        items = {}
    }
    
    -- Roll for money
    if math.random(100) <= Config.Economy.moneyChance then
        rewards.money = math.random(Config.Economy.minMoneyReward, Config.Economy.maxMoneyReward)
    end
    
    -- Roll for items from each tier
    -- Tier 3 (Rare) - 10% chance
    if math.random(100) <= 10 then
        local loot = GetRandomLootFromTier('tier3')
        if loot then
            table.insert(rewards.items, loot)
        end
    end
    
    -- Tier 2 (Uncommon) - 30% chance
    if math.random(100) <= 30 then
        local loot = GetRandomLootFromTier('tier2')
        if loot then
            table.insert(rewards.items, loot)
        end
    end
    
    -- Tier 1 (Common) - 60% chance
    if math.random(100) <= 60 then
        local loot = GetRandomLootFromTier('tier1')
        if loot then
            table.insert(rewards.items, loot)
        end
    end
    
    return rewards
end

---Get item label (framework-dependent)
---@param item string Item name
---@return string Item label
local function GetItemLabel(item)
    -- Try to get from framework
    if Framework.Type == 'lxr-core' or Framework.Type == 'rsg-core' or Framework.Type == 'qbr' or Framework.Type == 'qr' then
        if Framework.Object and Framework.Object.Shared and Framework.Object.Shared.Items then
            local itemData = Framework.Object.Shared.Items[item]
            if itemData then
                return itemData.label or item
            end
        end
    end
    
    -- Fallback to item name
    return item
end

-- ═══════════════════════════════════════════════════════════
-- ██████ LOOT EVENT HANDLER █████████████████████████████████
-- ═══════════════════════════════════════════════════════════

RegisterNetEvent('template-resource:server:lootProp', function(propNetId, propCoords)
    local src = source
    
    -- Security checks (skip in test mode)
    if not Config.Debug.testMode then
        -- Check exploit attempts
        if Config.Security.detectSpeedHacks and IsPlayerExploiting(src) then
            if Config.Security.logAttempts then
                print("^1[SECURITY] ^0Player " .. GetPlayerName(src) .. " (ID: " .. src .. ") is exploiting!")
            end
            
            TriggerClientEvent('template-resource:client:lootResult', src, false, {
                message = _L('security_exploit_detected')
            })
            
            if Config.Security.kickOnExploit then
                DropPlayer(src, _L('security_kicked'))
            end
            
            return
        end
        
        -- Check distance
        if Config.Security.enableDistanceCheck then
            if not IsPlayerNearProp(src, propCoords) then
                if Config.Security.logAttempts then
                    print("^3[WARNING] ^0Player " .. GetPlayerName(src) .. " (ID: " .. src .. ") tried to loot from too far away")
                end
                
                TriggerClientEvent('template-resource:client:lootResult', src, false, {
                    message = _L('loot_too_far')
                })
                return
            end
        end
        
        -- Check player cooldown
        if Config.Security.enableCooldownCheck and IsPlayerOnCooldown(src) then
            TriggerClientEvent('template-resource:client:lootResult', src, false, {
                message = _L('loot_cooldown')
            })
            return
        end
        
        -- Check prop cooldown
        if Config.Security.enableCooldownCheck and IsPropOnCooldown(propNetId) then
            TriggerClientEvent('template-resource:client:lootResult', src, false, {
                message = _L('loot_cooldown')
            })
            return
        end
    end
    
    -- Generate loot
    local rewards = GenerateLoot()
    
    -- Debug logging
    if Config.Debug.enabled and Config.Debug.printLootRolls then
        print("^2[LOOT] ^0Player " .. GetPlayerName(src) .. " rolled:")
        print("  Money: $" .. rewards.money)
        print("  Items: " .. #rewards.items)
    end
    
    -- Give rewards
    local itemsGiven = {}
    
    -- Give money
    if rewards.money > 0 then
        Framework.AddMoney(src, rewards.money, Config.Economy.moneyType)
    end
    
    -- Give items
    for _, loot in ipairs(rewards.items) do
        Framework.AddItem(src, loot.item, loot.amount)
        table.insert(itemsGiven, {
            item = loot.item,
            amount = loot.amount,
            label = GetItemLabel(loot.item)
        })
    end
    
    -- Update cooldowns
    lootedProps[propNetId] = os.time()
    playerCooldowns[src] = os.time()
    
    -- Log to console
    if Config.Security.logAttempts then
        print("^2[LOOT] ^0" .. GetPlayerName(src) .. " looted prop #" .. propNetId .. " - Money: $" .. rewards.money .. " Items: " .. #itemsGiven)
    end
    
    -- Send result to client
    TriggerClientEvent('template-resource:client:lootResult', src, true, {
        propNetId = propNetId,
        money = rewards.money,
        items = itemsGiven,
        propCoords = propCoords
    })
end)

-- ═══════════════════════════════════════════════════════════
-- ██████ CLEANUP & MAINTENANCE ██████████████████████████████
-- ═══════════════════════════════════════════════════════════

---Clean up old cooldowns (run every 5 minutes)
CreateThread(function()
    while true do
        Wait(300000) -- 5 minutes
        
        local currentTime = os.time()
        local propCooldownSeconds = Config.Cooldowns.perPropCooldown / 1000
        
        -- Clean prop cooldowns
        for propNetId, timestamp in pairs(lootedProps) do
            if currentTime - timestamp > propCooldownSeconds then
                lootedProps[propNetId] = nil
            end
        end
        
        -- Clean player cooldowns
        local playerCooldownSeconds = Config.Cooldowns.globalCooldown / 1000
        for source, timestamp in pairs(playerCooldowns) do
            if currentTime - timestamp > playerCooldownSeconds then
                playerCooldowns[source] = nil
            end
        end
        
        -- Clean attempt tracking
        for source, data in pairs(playerAttempts) do
            if currentTime - data.lastReset > 120 then -- 2 minutes
                playerAttempts[source] = nil
            end
        end
        
        if Config.Debug.enabled then
            print("^3[CLEANUP] ^0Cleaned up old cooldowns and tracking data^0")
        end
    end
end)

---Handle player disconnect
AddEventHandler('playerDropped', function(reason)
    local src = source
    playerCooldowns[src] = nil
    playerAttempts[src] = nil
end)

---Handle resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    -- Optionally clear cooldowns on restart
    if Config.Cooldowns.resetOnRestart then
        lootedProps = {}
        playerCooldowns = {}
        playerAttempts = {}
        print("^3[Template Resource] ^0Cooldowns reset on resource stop^0")
    end
end)

-- ═══════════════════════════════════════════════════════════
-- ██████ ADMIN COMMANDS (OPTIONAL) ██████████████████████████
-- ═══════════════════════════════════════════════════════════

---Reset all cooldowns (admin only)
RegisterCommand('resetloot', function(source, args, rawCommand)
    -- Check if player is admin (implement your own admin check)
    -- For this template, we'll allow anyone to use it
    
    lootedProps = {}
    playerCooldowns = {}
    playerAttempts = {}
    
    if source == 0 then
        print("^2[Template Resource] ^0All loot cooldowns have been reset^0")
    else
        Framework.Notify(source, 'All loot cooldowns have been reset', 'success')
        print("^2[Template Resource] ^0" .. GetPlayerName(source) .. " reset all loot cooldowns^0")
    end
end, false)

---Get loot statistics
RegisterCommand('lootstats', function(source, args, rawCommand)
    local propsLooted = 0
    for _ in pairs(lootedProps) do
        propsLooted = propsLooted + 1
    end
    
    local playersOnCooldown = 0
    for _ in pairs(playerCooldowns) do
        playersOnCooldown = playersOnCooldown + 1
    end
    
    local message = "^2[LOOT STATS]^0\n"
    message = message .. "  Props Looted: ^3" .. propsLooted .. "^0\n"
    message = message .. "  Players on Cooldown: ^3" .. playersOnCooldown .. "^0\n"
    message = message .. "  Total Lootable Props: ^3" .. #Config.LootableProps .. "^0"
    
    print(message)
    
    if source ~= 0 then
        Framework.Notify(source, 'Check console for loot statistics', 'info')
    end
end, false)

-- ═══════════════════════════════════════════════════════════
-- ██████ INITIALIZATION █████████████████████████████████████
-- ═══════════════════════════════════════════════════════════

CreateThread(function()
    Wait(1000)
    
    if Config.Debug.enabled then
        print("^2[Template Resource] ^0Server initialized^0")
        print("^2[Template Resource] ^0Lootable props: ^3" .. #Config.LootableProps .. "^0")
        print("^2[Template Resource] ^0Framework: ^3" .. Framework.Type .. "^0")
    end
end)

-- ═══════════════════════════════════════════════════════════
-- ██████ END OF SERVER SCRIPT ███████████████████████████████
-- ═══════════════════════════════════════════════════════════
