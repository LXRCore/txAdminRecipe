--[[
  ╦ ╦╔═╗╦  ╦  ╦╔═╗╔═╗  ╦  ╔═╗╔╗╔╔╦╗
  ║║║║ ║║  ╚╗╔╝║╣ ╚═╗  ║  ╠═╣║║║ ║║
  ╚╩╝╚═╝╩═╝ ╚╝ ╚═╝╚═╝  ╩═╝╩ ╩╝╚╝═╩╝
  ════════════════════════════════════════════════════════════
  Template Resource - Client Main Script
  Example Looting System - Client-Side Implementation
  ════════════════════════════════════════════════════════════
  wolves.land | discord.gg/lxr | lxrcore.com
  ════════════════════════════════════════════════════════════
]]

-- ═══════════════════════════════════════════════════════════
-- ██████ LOCAL VARIABLES ████████████████████████████████████
-- ═══════════════════════════════════════════════════════════

local playerLoaded = false
local isLooting = false
local nearbyProps = {}
local lootedProps = {}
local lastLootTime = 0
local propCache = {}
local lastCacheUpdate = 0

-- ═══════════════════════════════════════════════════════════
-- ██████ UTILITY FUNCTIONS ██████████████████████████████████
-- ═══════════════════════════════════════════════════════════

---Check if prop model is lootable
---@param model number Prop model hash
---@return boolean Is lootable
local function IsLootableProp(model)
    for _, lootableModel in ipairs(Config.LootableProps) do
        if model == lootableModel then
            return true
        end
    end
    return false
end

---Check if prop is on cooldown
---@param propEntity number Prop entity
---@return boolean Is on cooldown
local function IsOnCooldown(propEntity)
    if not Config.Cooldowns.enabled then return false end
    
    local propNetId = NetworkGetNetworkIdFromEntity(propEntity)
    if lootedProps[propNetId] then
        local timeSince = GetGameTimer() - lootedProps[propNetId]
        return timeSince < Config.Cooldowns.perPropCooldown
    end
    
    return false
end

---Get time remaining on cooldown
---@param propEntity number Prop entity
---@return number Time remaining in seconds
local function GetCooldownRemaining(propEntity)
    if not Config.Cooldowns.enabled then return 0 end
    
    local propNetId = NetworkGetNetworkIdFromEntity(propEntity)
    if lootedProps[propNetId] then
        local timeSince = GetGameTimer() - lootedProps[propNetId]
        local remaining = Config.Cooldowns.perPropCooldown - timeSince
        return math.max(0, math.ceil(remaining / 1000))
    end
    
    return 0
end

---Check global cooldown
---@return boolean Is on global cooldown
local function IsOnGlobalCooldown()
    if not Config.Cooldowns.enabled then return false end
    
    local timeSince = GetGameTimer() - lastLootTime
    return timeSince < Config.Cooldowns.globalCooldown
end

---Get nearby lootable props
---@return table Nearby props
local function GetNearbyLootableProps()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local nearby = {}
    
    -- Use cache if enabled and not expired
    if Config.Performance.enablePropCache then
        local currentTime = GetGameTimer()
        if currentTime - lastCacheUpdate < Config.Performance.cacheRefreshInterval then
            return propCache
        end
        lastCacheUpdate = currentTime
    end
    
    -- Scan for props
    local props = GetGamePool('CObject')
    for _, prop in ipairs(props) do
        if DoesEntityExist(prop) then
            local propCoords = GetEntityCoords(prop)
            local distance = #(playerCoords - propCoords)
            
            if distance <= Config.Performance.propScanDistance then
                local model = GetEntityModel(prop)
                if IsLootableProp(model) then
                    table.insert(nearby, {
                        entity = prop,
                        coords = propCoords,
                        distance = distance,
                        model = model
                    })
                end
            end
        end
    end
    
    -- Sort by distance
    table.sort(nearby, function(a, b) return a.distance < b.distance end)
    
    -- Limit cache size
    if #nearby > Config.Performance.maxCachedProps then
        for i = Config.Performance.maxCachedProps + 1, #nearby do
            nearby[i] = nil
        end
    end
    
    propCache = nearby
    return nearby
end

-- ═══════════════════════════════════════════════════════════
-- ██████ LOOTING FUNCTIONS ██████████████████████████████████
-- ═══════════════════════════════════════════════════════════

---Start looting a prop
---@param propEntity number Prop entity to loot
local function StartLooting(propEntity)
    if isLooting then
        Framework.Notify(_L('loot_failed'), 'error')
        return
    end
    
    -- Check global cooldown
    if IsOnGlobalCooldown() then
        Framework.Notify(_L('loot_cooldown'), 'error')
        return
    end
    
    -- Check prop cooldown
    if IsOnCooldown(propEntity) then
        local remaining = GetCooldownRemaining(propEntity)
        Framework.Notify(_L('loot_cooldown') .. ' (' .. remaining .. 's)', 'error')
        return
    end
    
    -- Check distance
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local propCoords = GetEntityCoords(propEntity)
    local distance = #(playerCoords - propCoords)
    
    if distance > Config.General.interactionDistance then
        Framework.Notify(_L('loot_too_far'), 'error')
        return
    end
    
    isLooting = true
    lastLootTime = GetGameTimer()
    
    -- Play animation
    if Config.General.playAnimations then
        local animDict = "amb_work@world_human_box_pickup@1@male_a@stand_exit_withprop"
        local animName = "exit_front"
        
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(10)
        end
        
        TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, -1, 1, 0, false, false, false)
    end
    
    -- Show progress bar
    Framework.ProgressBar(
        Config.General.searchTime,
        _L('progress_searching'),
        false,
        true,
        {
            move = true,
            car = true,
            combat = true,
            mouse = false
        },
        nil,
        nil,
        function(cancelled)
            ClearPedTasks(playerPed)
            
            if cancelled then
                Framework.Notify(_L('loot_cancelled'), 'error')
                isLooting = false
                return
            end
            
            -- Request loot from server
            local propNetId = NetworkGetNetworkIdFromEntity(propEntity)
            TriggerServerEvent('template-resource:server:lootProp', propNetId, propCoords)
        end
    )
end

-- ═══════════════════════════════════════════════════════════
-- ██████ INTERACTION SYSTEM █████████████████████████████████
-- ═══════════════════════════════════════════════════════════

---Setup ox_target interactions
local function SetupOxTarget()
    if GetResourceState('ox_target') ~= 'started' then
        return false
    end
    
    exports.ox_target:addModel(Config.LootableProps, {
        {
            name = 'loot_prop',
            icon = 'fas fa-search',
            label = 'Search Container',
            distance = Config.General.interactionDistance,
            onSelect = function(data)
                StartLooting(data.entity)
            end,
            canInteract = function(entity)
                return not IsOnCooldown(entity) and not isLooting
            end
        }
    })
    
    return true
end

---Manual interaction thread (fallback if no ox_target)
local function StartManualInteraction()
    CreateThread(function()
        while playerLoaded do
            Wait(Config.Performance.propScanInterval)
            
            if not isLooting then
                nearbyProps = GetNearbyLootableProps()
                
                -- Check for closest prop
                if #nearbyProps > 0 then
                    local closestProp = nearbyProps[1]
                    
                    if closestProp.distance <= Config.General.interactionDistance then
                        -- Show help text
                        if Config.General.showHelpText then
                            local helpText = _L('interact_loot')
                            if IsOnCooldown(closestProp.entity) then
                                local remaining = GetCooldownRemaining(closestProp.entity)
                                helpText = _L('interact_looted') .. ' (' .. remaining .. 's)'
                            end
                            
                            -- Draw text on screen
                            SetTextScale(0.35, 0.35)
                            SetTextCentre(true)
                            SetTextColor(255, 255, 255, 255)
                            SetTextEntry("STRING")
                            AddTextComponentString(helpText)
                            DrawText(0.5, 0.95)
                        end
                        
                        -- Check for key press
                        if IsControlJustPressed(0, Config.Keys.lootProp) then
                            if not IsOnCooldown(closestProp.entity) then
                                StartLooting(closestProp.entity)
                            end
                        end
                    end
                end
            end
            
            -- Debug: Show prop models
            if Config.Debug.enabled and Config.Debug.showPropModels then
                for _, prop in ipairs(nearbyProps) do
                    local coords = prop.coords
                    DrawMarker(28, coords.x, coords.y, coords.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 100, false, false, 2, false, nil, nil, false)
                end
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════
-- ██████ EVENT HANDLERS █████████████████████████████████████
-- ═══════════════════════════════════════════════════════════

---Handle loot result from server
RegisterNetEvent('template-resource:client:lootResult', function(success, data)
    isLooting = false
    
    if success then
        -- Mark prop as looted
        if data.propNetId then
            lootedProps[data.propNetId] = GetGameTimer()
        end
        
        -- Show rewards
        if data.money and data.money > 0 then
            Framework.Notify(_L('loot_found_money', data.money), 'success')
        end
        
        if data.items and #data.items > 0 then
            for _, item in ipairs(data.items) do
                Framework.Notify(_L('loot_found_item', item.amount, item.label), 'success')
                Wait(500)
            end
        end
        
        if (not data.money or data.money == 0) and (not data.items or #data.items == 0) then
            Framework.Notify(_L('loot_found_nothing'), 'info')
        end
        
        -- Play particle effect
        if Config.General.enableParticles and data.propCoords then
            local coords = data.propCoords
            RequestNamedPtfxAsset("core")
            while not HasNamedPtfxAssetLoaded("core") do
                Wait(10)
            end
            UseParticleFxAssetNextCall("core")
            StartParticleFxNonLoopedAtCoord("ent_anim_leaf_pine_cone", coords.x, coords.y, coords.z + 0.5, 0.0, 0.0, 0.0, 1.0, false, false, false)
        end
    else
        Framework.Notify(data.message or _L('loot_failed'), 'error')
    end
end)

-- ═══════════════════════════════════════════════════════════
-- ██████ INITIALIZATION █████████████████████████████████════
-- ═══════════════════════════════════════════════════════════

CreateThread(function()
    -- Wait for framework to load
    while not Framework.IsPlayerLoaded() do
        Wait(1000)
    end
    
    playerLoaded = true
    
    if Config.Debug.enabled then
        print("^2[Template Resource] ^0Client initialized^0")
    end
    
    -- Setup interactions
    if Config.General.useOxTarget then
        local oxTargetEnabled = SetupOxTarget()
        if not oxTargetEnabled then
            print("^3[Template Resource] ^0ox_target not found, using manual interaction^0")
            StartManualInteraction()
        end
    else
        StartManualInteraction()
    end
end)

-- Handle player logout
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    playerLoaded = false
    isLooting = false
    nearbyProps = {}
    lootedProps = {}
end)

-- ═══════════════════════════════════════════════════════════
-- ██████ END OF CLIENT SCRIPT ███████████████████████████████
-- ═══════════════════════════════════════════════════════════
