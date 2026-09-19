--[[ ═══════════════════════════════════════════════════════════════════════════
     TEMPLATE-RESOURCE — Client
     ═══════════════════════════════════════════════════════════════════════════
     One prompt per point from config.lua. Pressing it asks the server through
     an RPC; the server decides and answers. The client never gives itself
     anything — it draws, asks, and shows the answer.
     ═══════════════════════════════════════════════════════════════════════════
     © 2026 iBoss21 / LXRCore | lxrcore.com
     ═══════════════════════════════════════════════════════════════════════════ ]]

local LXRCore = exports['lxr-core']:GetCoreObject()   -- the classic object (Functions, Prompts, …)
local LXR = exports['lxr-core']:GetLXR()               -- the native API (Player, RPC, UI, Events)

local function drink(id)
    local ok, err = LXR.RPC.Server('template-resource:drink', id)
    if ok then
        LXR.UI.Notify(Lang:t('info.filled'), 'success')
    else
        LXR.UI.Notify(Lang:t('error.' .. tostring(err), { s = Config.CooldownSeconds }), 'error')
    end
end

local function placePrompts()
    for _, p in ipairs(Config.Points) do
        LXRCore.Prompts.Create('template-resource:' .. p.id, p.coords, Config.Prompt.key, Lang:t('prompt.drink'),
            { type = 'callback', event = function() drink(p.id) end }, Config.Prompt.distance, nil, 0)
    end
end

-- the character stands in the world: place the prompts (and again after a resource restart mid-session)
AddEventHandler('lxr:client:loaded', placePrompts)
CreateThread(function() if LXR.Player.IsLoaded() then placePrompts() end end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for _, p in ipairs(Config.Points) do LXRCore.Prompts.Delete('template-resource:' .. p.id) end
end)
