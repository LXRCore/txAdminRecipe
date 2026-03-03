--[[
  ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗ ██████╗ ███████╗
  ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██╔═══██╗██╔══██╗██╔════╝
  ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██████╔╝█████╗
  ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██╔══██╗██╔══╝
  ███████╗██╔╝ ██╗██║  ██║      ╚██████╗╚██████╔╝██║  ██║███████╗
  ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
  ════════════════════════════════════════════════════════════════
  🐺 Template Resource — Framework Bridge/Adapter
  Universal Multi-Framework Support System
  ════════════════════════════════════════════════════════════════
  SERVER INFORMATION
  ──────────────────────────────────────────────────────────────
  Server:    The Land of Wolves 🐺
  Developer: iBoss21 / The Lux Empire
  Website:   https://www.wolves.land
  Discord:   https://discord.gg/CrKcWdfd3A
  Store:     https://theluxempire.tebex.io
  ════════════════════════════════════════════════════════════════
  SUPPORTED FRAMEWORKS:
  ──────────────────────────────────────────────────────────────
  • LXR-Core      (Primary - wolves.land framework)
  • RSG-Core      (Primary - RedM framework)
  • VORP Core     (Supported / Legacy)
  • RedEM:RP      (Optional - RedM roleplay framework)
  • QBR-Core      (Optional - QB RedM port)
  • QR-Core       (Optional - Another QB RedM port)
  • Standalone    (Fallback - No framework)
  ════════════════════════════════════════════════════════════════
  © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
  ════════════════════════════════════════════════════════════════
]]

Framework = {}
Framework.Type = nil
Framework.Object = nil
Framework.PlayerData = {}

-- ═══════════════════════════════════════════════════════════
-- ██████ FRAMEWORK AUTO-DETECTION ███████████████████████████
-- ═══════════════════════════════════════════════════════════

---Detect which framework is running
---@return string Framework type
local function DetectFramework()
    if Config.Framework ~= 'auto' then
        return Config.Framework
    end
    
    -- Try LXR-Core first (wolves.land primary framework)
    if GetResourceState('lxr-core') == 'started' then
        return 'lxr-core'
    end
    
    -- Try RSG-Core
    if GetResourceState('rsg-core') == 'started' then
        return 'rsg-core'
    end
    
    -- Try VORP
    if GetResourceState('vorp_core') == 'started' then
        return 'vorp'
    end
    
    -- Try RedEM:RP
    if GetResourceState('redemrp_core') == 'started' then
        return 'redem'
    end
    
    -- Try QBR-Core
    if GetResourceState('qbr-core') == 'started' then
        return 'qbr'
    end
    
    -- Try QR-Core
    if GetResourceState('qr-core') == 'started' then
        return 'qr'
    end
    
    -- Fallback to standalone
    return 'standalone'
end

-- ═══════════════════════════════════════════════════════════
-- ██████ FRAMEWORK INITIALIZATION ███████████████████████████
-- ═══════════════════════════════════════════════════════════

---Initialize framework object
local function InitializeFramework()
    Framework.Type = DetectFramework()
    local settings = Config.FrameworkSettings[Framework.Type]
    
    if Config.Debug.printFrameworkDetection then
        print("^2[Framework] ^0Detected: ^3" .. Framework.Type .. "^0")
    end
    
    if Framework.Type == 'lxr-core' then
        if settings.useNewExport then
            Framework.Object = exports['lxr-core']:GetCoreObject()
        else
            while Framework.Object == nil do
                TriggerEvent('lxr-core:getSharedObject', function(obj) Framework.Object = obj end)
                Wait(100)
            end
        end
        
    elseif Framework.Type == 'rsg-core' then
        if settings.useNewExport then
            Framework.Object = exports['rsg-core']:GetCoreObject()
        else
            while Framework.Object == nil do
                TriggerEvent('rsg-core:getSharedObject', function(obj) Framework.Object = obj end)
                Wait(100)
            end
        end
        
    elseif Framework.Type == 'vorp' then
        Framework.Object = {}
        TriggerEvent("getCore", function(core)
            Framework.Object = core
        end)
        
    elseif Framework.Type == 'redem' then
        Framework.Object = exports['redemrp_core']:GetCoreObject()
        
    elseif Framework.Type == 'qbr' then
        if settings.useNewExport then
            Framework.Object = exports['qbr-core']:GetCoreObject()
        else
            while Framework.Object == nil do
                TriggerEvent('qbr-core:getSharedObject', function(obj) Framework.Object = obj end)
                Wait(100)
            end
        end
        
    elseif Framework.Type == 'qr' then
        if settings.useNewExport then
            Framework.Object = exports['qr-core']:GetCoreObject()
        else
            while Framework.Object == nil do
                TriggerEvent('qr-core:getSharedObject', function(obj) Framework.Object = obj end)
                Wait(100)
            end
        end
        
    else
        -- Standalone mode
        Framework.Object = nil
    end
    
    return Framework.Object ~= nil or Framework.Type == 'standalone'
end

-- ═══════════════════════════════════════════════════════════
-- ██████ UNIFIED API FUNCTIONS ██████████████████████████████
-- ═══════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────
-- Notification System
-- ───────────────────────────────────────────────────────────

---Send notification to player
---@param message string Notification message
---@param type string Notification type (success, error, info)
---@param duration number Duration in milliseconds
function Framework.Notify(message, type, duration)
    duration = duration or 5000
    type = type or 'info'
    
    if IsDuplicityVersion() then
        -- Server-side notification
        local src = source
        if Framework.Type == 'lxr-core' or Framework.Type == 'rsg-core' or Framework.Type == 'qbr' or Framework.Type == 'qr' then
            TriggerClientEvent(Framework.Type .. ':client:notify', src, {
                text = message,
                type = type,
                duration = duration
            })
        elseif Framework.Type == 'vorp' then
            TriggerClientEvent('vorp:NotifyLeft', src, _L('notify_title'), message, 'generic_textures', 'tick', duration)
        elseif Framework.Type == 'redem' then
            TriggerClientEvent('redem_roleplay:NotifyLeft', src, _L('notify_title'), message, 'generic_textures', 'tick', duration)
        else
            TriggerClientEvent('chat:addMessage', src, {args = {message}})
        end
    else
        -- Client-side notification
        if Framework.Type == 'lxr-core' or Framework.Type == 'rsg-core' or Framework.Type == 'qbr' or Framework.Type == 'qr' then
            Framework.Object.Functions.Notify(message, type, duration)
        elseif Framework.Type == 'vorp' then
            TriggerEvent('vorp:NotifyLeft', _L('notify_title'), message, 'generic_textures', 'tick', duration)
        elseif Framework.Type == 'redem' then
            TriggerEvent('redem_roleplay:NotifyLeft', _L('notify_title'), message, 'generic_textures', 'tick', duration)
        else
            -- Fallback to chat
            TriggerEvent('chat:addMessage', {args = {message}})
        end
    end
end

-- ───────────────────────────────────────────────────────────
-- Player Data Functions
-- ───────────────────────────────────────────────────────────

---Get player data (client-side)
---@return table Player data
function Framework.GetPlayerData()
    if Framework.Type == 'lxr-core' or Framework.Type == 'rsg-core' or Framework.Type == 'qbr' or Framework.Type == 'qr' then
        return Framework.Object.Functions.GetPlayerData()
    elseif Framework.Type == 'vorp' then
        return Framework.PlayerData
    elseif Framework.Type == 'redem' then
        return Framework.PlayerData
    else
        return {}
    end
end

---Get player job data
---@return table Job data {name, label, grade}
function Framework.GetJob()
    local playerData = Framework.GetPlayerData()
    
    if Framework.Type == 'lxr-core' or Framework.Type == 'rsg-core' or Framework.Type == 'qbr' or Framework.Type == 'qr' then
        return playerData.job or {}
    elseif Framework.Type == 'vorp' then
        return playerData.job or {}
    elseif Framework.Type == 'redem' then
        return playerData.job or {}
    else
        return {name = 'unemployed', label = 'Unemployed', grade = 0}
    end
end

-- ───────────────────────────────────────────────────────────
-- Money Functions
-- ───────────────────────────────────────────────────────────

---Add money to player (server-side)
---@param source number Player source
---@param amount number Amount to add
---@param moneyType string Type of money (cash/bank)
function Framework.AddMoney(source, amount, moneyType)
    moneyType = moneyType or 'cash'
    
    if Framework.Type == 'lxr-core' or Framework.Type == 'rsg-core' or Framework.Type == 'qbr' or Framework.Type == 'qr' then
        local Player = Framework.Object.Functions.GetPlayer(source)
        if Player then
            Player.Functions.AddMoney(moneyType, amount)
        end
    elseif Framework.Type == 'vorp' then
        local User = exports.vorp_core:GetUser(source)
        if User then
            local Character = User.getUsedCharacter
            if moneyType == 'cash' then
                Character.addCurrency(0, amount)
            else
                Character.addCurrency(1, amount)
            end
        end
    elseif Framework.Type == 'redem' then
        local User = exports.redemrp_core:GetUser(source)
        if User then
            User.addMoney(amount)
        end
    end
end

---Remove money from player (server-side)
---@param source number Player source
---@param amount number Amount to remove
---@param moneyType string Type of money (cash/bank)
function Framework.RemoveMoney(source, amount, moneyType)
    moneyType = moneyType or 'cash'
    
    if Framework.Type == 'lxr-core' or Framework.Type == 'rsg-core' or Framework.Type == 'qbr' or Framework.Type == 'qr' then
        local Player = Framework.Object.Functions.GetPlayer(source)
        if Player then
            Player.Functions.RemoveMoney(moneyType, amount)
        end
    elseif Framework.Type == 'vorp' then
        local User = exports.vorp_core:GetUser(source)
        if User then
            local Character = User.getUsedCharacter
            if moneyType == 'cash' then
                Character.removeCurrency(0, amount)
            else
                Character.removeCurrency(1, amount)
            end
        end
    elseif Framework.Type == 'redem' then
        local User = exports.redemrp_core:GetUser(source)
        if User then
            User.removeMoney(amount)
        end
    end
end

-- ───────────────────────────────────────────────────────────
-- Item Functions
-- ───────────────────────────────────────────────────────────

---Add item to player (server-side)
---@param source number Player source
---@param item string Item name
---@param amount number Amount to add
---@param metadata table Item metadata
function Framework.AddItem(source, item, amount, metadata)
    amount = amount or 1
    metadata = metadata or {}
    
    if Framework.Type == 'lxr-core' or Framework.Type == 'rsg-core' or Framework.Type == 'qbr' or Framework.Type == 'qr' then
        local Player = Framework.Object.Functions.GetPlayer(source)
        if Player then
            Player.Functions.AddItem(item, amount, false, metadata)
        end
    elseif Framework.Type == 'vorp' then
        exports.vorp_inventory:addItem(source, item, amount, metadata)
    elseif Framework.Type == 'redem' then
        local User = exports.redemrp_core:GetUser(source)
        if User then
            User.addItem(item, amount)
        end
    end
end

---Remove item from player (server-side)
---@param source number Player source
---@param item string Item name
---@param amount number Amount to remove
function Framework.RemoveItem(source, item, amount)
    amount = amount or 1
    
    if Framework.Type == 'lxr-core' or Framework.Type == 'rsg-core' or Framework.Type == 'qbr' or Framework.Type == 'qr' then
        local Player = Framework.Object.Functions.GetPlayer(source)
        if Player then
            Player.Functions.RemoveItem(item, amount)
        end
    elseif Framework.Type == 'vorp' then
        exports.vorp_inventory:subItem(source, item, amount)
    elseif Framework.Type == 'redem' then
        local User = exports.redemrp_core:GetUser(source)
        if User then
            User.removeItem(item, amount)
        end
    end
end

---Check if player has item (server-side)
---@param source number Player source
---@param item string Item name
---@param amount number Amount to check
---@return boolean Has item
function Framework.HasItem(source, item, amount)
    amount = amount or 1
    
    if Framework.Type == 'lxr-core' or Framework.Type == 'rsg-core' or Framework.Type == 'qbr' or Framework.Type == 'qr' then
        local Player = Framework.Object.Functions.GetPlayer(source)
        if Player then
            local itemData = Player.Functions.GetItemByName(item)
            return itemData and itemData.amount >= amount
        end
    elseif Framework.Type == 'vorp' then
        local itemCount = exports.vorp_inventory:getItemCount(source, nil, item)
        return itemCount >= amount
    elseif Framework.Type == 'redem' then
        local User = exports.redemrp_core:GetUser(source)
        if User then
            return User.hasItem(item, amount)
        end
    end
    
    return false
end

-- ───────────────────────────────────────────────────────────
-- Progress Bar
-- ───────────────────────────────────────────────────────────

---Show progress bar (client-side)
---@param duration number Duration in milliseconds
---@param label string Progress bar label
---@param useWhileDead boolean Can be used while dead
---@param canCancel boolean Can be cancelled
---@param disableControls table Controls to disable
---@param animation table Animation data
---@param prop table Prop data
---@param callback function Callback when finished
function Framework.ProgressBar(duration, label, useWhileDead, canCancel, disableControls, animation, prop, callback)
    -- Try ox_lib first (best progress bar for RedM)
    if GetResourceState('ox_lib') == 'started' then
        if lib and lib.progressBar then
            lib.progressBar({
                duration = duration,
                label = label,
                useWhileDead = useWhileDead or false,
                canCancel = canCancel or false,
                disable = disableControls or {move = true, car = true, combat = true},
                anim = animation,
                prop = prop,
            })
            if callback then callback(true) end
            return
        end
    end
    
    -- Framework-specific progress bars
    if Framework.Type == 'lxr-core' or Framework.Type == 'rsg-core' or Framework.Type == 'qbr' or Framework.Type == 'qr' then
        if Framework.Object.Functions.Progressbar then
            Framework.Object.Functions.Progressbar(label, label, duration, useWhileDead, canCancel, disableControls, animation, prop, {}, callback)
            return
        end
    elseif Framework.Type == 'vorp' then
        -- VORP uses its own progress system
        TriggerEvent('vorp:Tip', label, duration)
        Wait(duration)
        if callback then callback(true) end
        return
    end
    
    -- Fallback: Simple wait
    Wait(duration)
    if callback then callback(true) end
end

-- ───────────────────────────────────────────────────────────
-- Utility Functions
-- ───────────────────────────────────────────────────────────

---Get player identifier (server-side)
---@param source number Player source
---@return string Player identifier
function Framework.GetIdentifier(source)
    if Framework.Type == 'lxr-core' or Framework.Type == 'rsg-core' or Framework.Type == 'qbr' or Framework.Type == 'qr' then
        local Player = Framework.Object.Functions.GetPlayer(source)
        return Player and Player.PlayerData.citizenid or nil
    elseif Framework.Type == 'vorp' then
        local User = exports.vorp_core:GetUser(source)
        if User then
            local Character = User.getUsedCharacter
            return Character.charIdentifier
        end
    elseif Framework.Type == 'redem' then
        local User = exports.redemrp_core:GetUser(source)
        return User and User.getIdentifier() or nil
    else
        return GetPlayerIdentifier(source, 0)
    end
end

---Check if player is loaded (client-side)
---@return boolean Is loaded
function Framework.IsPlayerLoaded()
    if Framework.Type == 'lxr-core' or Framework.Type == 'rsg-core' or Framework.Type == 'qbr' or Framework.Type == 'qr' then
        return Framework.Object.Functions.GetPlayerData().citizenid ~= nil
    elseif Framework.Type == 'vorp' or Framework.Type == 'redem' then
        return Framework.PlayerData ~= nil and next(Framework.PlayerData) ~= nil
    else
        return true -- Standalone always loaded
    end
end

---Register server callback
---@param name string Callback name
---@param cb function Callback function
function Framework.RegisterCallback(name, cb)
    if IsDuplicityVersion() then
        -- Server-side
        if Framework.Type == 'lxr-core' or Framework.Type == 'rsg-core' or Framework.Type == 'qbr' or Framework.Type == 'qr' then
            Framework.Object.Functions.CreateCallback(name, cb)
        elseif Framework.Type == 'vorp' then
            exports.vorp_core:addCallback(name, cb)
        else
            RegisterNetEvent(name .. ':server')
            AddEventHandler(name .. ':server', function(...)
                local src = source
                cb(src, function(...)
                    TriggerClientEvent(name .. ':client', src, ...)
                end, ...)
            end)
        end
    end
end

-- ═══════════════════════════════════════════════════════════
-- ██████ FRAMEWORK EVENTS ███████████████████████████████████
-- ═══════════════════════════════════════════════════════════

if not IsDuplicityVersion() then
    -- Client-side player data update events
    if Framework.Type == 'lxr-core' or Framework.Type == 'rsg-core' or Framework.Type == 'qbr' or Framework.Type == 'qr' then
        RegisterNetEvent(Framework.Type .. ':client:OnPlayerLoaded', function()
            Framework.PlayerData = Framework.GetPlayerData()
        end)
        
        RegisterNetEvent(Framework.Type .. ':client:OnPlayerUnload', function()
            Framework.PlayerData = {}
        end)
        
        RegisterNetEvent(Framework.Type .. ':client:OnJobUpdate', function(job)
            Framework.PlayerData.job = job
        end)
        
    elseif Framework.Type == 'vorp' then
        RegisterNetEvent('vorp:SelectedCharacter', function(charid)
            Wait(1000)
            TriggerServerEvent('vorp:getPlayerData', function(data)
                Framework.PlayerData = data
            end)
        end)
        
    elseif Framework.Type == 'redem' then
        RegisterNetEvent('redemrp:playerLoaded', function(player)
            Framework.PlayerData = player
        end)
    end
end

-- ═══════════════════════════════════════════════════════════
-- ██████ INITIALIZATION █████████████████████████████████████
-- ═══════════════════════════════════════════════════════════

CreateThread(function()
    local success = InitializeFramework()
    if success then
        if Config.Debug.printFrameworkDetection then
            print("^2[Framework] ^0Successfully initialized: ^3" .. Framework.Type .. "^0")
        end
    else
        print("^1[Framework] ^0Failed to initialize framework!^0")
    end
end)

-- ═══════════════════════════════════════════════════════════
-- ██████ END OF FRAMEWORK BRIDGE ████████████████████████████
-- ═══════════════════════════════════════════════════════════
