--[[ ═══════════════════════════════════════════════════════════════════════════
     TEMPLATE-RESOURCE — Server
     ═══════════════════════════════════════════════════════════════════════════
     The only place that decides anything. Every request is rate limited,
     checked against the config (does the point exist, is the player near it,
     is the cooldown over) and logged. Then the item is given.
     ═══════════════════════════════════════════════════════════════════════════
     © 2026 iBoss21 / LXRCore | lxrcore.com
     ═══════════════════════════════════════════════════════════════════════════ ]]

local LXRCore = exports['lxr-core']:GetCoreObject()
local LXR = exports['lxr-core']:GetLXR()

local buckets = {}      -- rate limit state per source
local lastDrink = {}    -- citizenid → os.time() of the last draught

local function pointById(id)
    for _, p in ipairs(Config.Points) do if p.id == id then return p end end
    return nil
end

-- the whole example: fn(src, ...) returns ok, payload-or-error-key
LXR.RPC.Register('template-resource:drink', function(src, id)
    if not LXRCore.RateLimit(buckets, src, Config.Security.rateLimit.burst, Config.Security.rateLimit.windowMs) then return false, 'rate' end
    local Player = LXRCore.Functions.GetPlayer(src)
    local point = type(id) == 'string' and pointById(id)
    if not Player or not point then return false, 'invalid' end

    local ped = GetPlayerPed(src)
    if #(GetEntityCoords(ped) - point.coords) > Config.Security.range then
        LXRCore.Log.exploit(src, 'template-resource: point used from afar', { id = id })
        return false, 'too_far'
    end

    local cid = Player.PlayerData.citizenid
    local last = lastDrink[cid] or 0
    if os.time() - last < Config.CooldownSeconds then return false, 'cooldown' end

    if not LXRCore.Inventory.CanCarry(src, point.item, point.amount) then return false, 'full' end
    if not Player.Functions.AddItem(point.item, point.amount, nil, nil, 'template-resource:' .. id) then return false, 'invalid' end
    lastDrink[cid] = os.time()
    LXRCore.Log.info('template-resource', 'drink', { source = src, citizenid = cid, id = id })
    return true
end)

-- a command: /well tells the player where the nearest point is
LXRCore.Commands.Add('well', Lang:t('command.well'), {}, false, function(src)
    local ped = GetPlayerPed(src)
    local here = GetEntityCoords(ped)
    local best, dist
    for _, p in ipairs(Config.Points) do
        local d = #(here - p.coords)
        if not dist or d < dist then best, dist = p, d end
    end
    if not best then return LXRCore.Notify(src, Lang:t('error.none'), 'error') end
    LXRCore.Notify(src, Lang:t('info.nearest', { m = math.floor(dist) }), 'info')
end, 'user')

-- framework events you will usually want
AddEventHandler('lxr:player:loaded', function(Player)
    LXRCore.Log.debug('template-resource', 'loaded', { citizenid = Player.PlayerData.citizenid })
end)
AddEventHandler('lxr:player:unloaded', function(src)
    buckets[src] = nil
end)
AddEventHandler('playerDropped', function() buckets[source] = nil end)
