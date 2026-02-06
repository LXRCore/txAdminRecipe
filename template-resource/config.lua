--[[
  ╦ ╦╔═╗╦  ╦  ╦╔═╗╔═╗  ╦  ╔═╗╔╗╔╔╦╗
  ║║║║ ║║  ╚╗╔╝║╣ ╚═╗  ║  ╠═╣║║║ ║║
  ╚╩╝╚═╝╩═╝ ╚╝ ╚═╝╚═╝  ╩═╝╩ ╩╝╚╝═╩╝
  ════════════════════════════════════════════════════════════
  Template Resource - Configuration File
  Production-Ready Reference Implementation
  ════════════════════════════════════════════════════════════
  wolves.land | discord.gg/lxr | lxrcore.com
  ════════════════════════════════════════════════════════════
  
  CONFIGURATION INSTRUCTIONS:
  ──────────────────────────────────────────────────────────
  1. This config demonstrates ALL wolves.land coding standards
  2. Copy this structure for your own resources
  3. Adjust values to match your server's requirements
  4. Keep the branded headers and section dividers
  5. DO NOT modify REQUIRED_RESOURCE_NAME unless renaming
  ════════════════════════════════════════════════════════════
]]

Config = {}

-- ═══════════════════════════════════════════════════════════
-- ██████ RESOURCE PROTECTION ████████████████████████████████
-- ═══════════════════════════════════════════════════════════
-- This prevents the resource from starting if renamed improperly
-- Change this if you rename the resource folder
REQUIRED_RESOURCE_NAME = "template-resource"

if GetCurrentResourceName() ~= REQUIRED_RESOURCE_NAME then
    print("^1═══════════════════════════════════════════════════════════^0")
    print("^1ERROR: Invalid Resource Name^0")
    print("^1═══════════════════════════════════════════════════════════^0")
    print("^3Expected: ^2" .. REQUIRED_RESOURCE_NAME .. "^0")
    print("^3Got: ^1" .. GetCurrentResourceName() .. "^0")
    print("^1═══════════════════════════════════════════════════════════^0")
    return
end

-- ═══════════════════════════════════════════════════════════
-- ██████ SERVER INFORMATION █████████████████████████████████
-- ═══════════════════════════════════════════════════════════
Config.ServerInfo = {
    name = "wolves.land",
    discord = "discord.gg/lxr",
    website = "lxrcore.com",
    support = "https://discord.gg/lxr",
    documentation = "https://docs.lxrcore.com"
}

-- ═══════════════════════════════════════════════════════════
-- ██████ FRAMEWORK DETECTION ████████████████████████████████
-- ═══════════════════════════════════════════════════════════
-- Options: 'auto', 'lxr-core', 'rsg-core', 'vorp', 'redem', 'qbr', 'qr', 'standalone'
-- 'auto' will automatically detect your framework
Config.Framework = 'auto'

-- Framework-Specific Settings
Config.FrameworkSettings = {
    ['lxr-core'] = {
        scriptName = 'lxr-core',
        useNewExport = true,
        inventoryType = 'ox_inventory', -- or 'lxr-inventory'
    },
    ['rsg-core'] = {
        scriptName = 'rsg-core',
        useNewExport = true,
        inventoryType = 'rsg-inventory',
    },
    ['vorp'] = {
        scriptName = 'vorp_core',
        useNewExport = false,
        inventoryType = 'vorp_inventory',
    },
    ['redem'] = {
        scriptName = 'redemrp_core',
        useNewExport = false,
        inventoryType = 'redemrp_inventory',
    },
    ['qbr'] = {
        scriptName = 'qbr-core',
        useNewExport = true,
        inventoryType = 'qbr-inventory',
    },
    ['qr'] = {
        scriptName = 'qr-core',
        useNewExport = true,
        inventoryType = 'qr-inventory',
    },
    ['standalone'] = {
        scriptName = nil,
        useNewExport = false,
        inventoryType = 'standalone',
    }
}

-- ═══════════════════════════════════════════════════════════
-- ██████ LOCALIZATION ███████████████████████████████████████
-- ═══════════════════════════════════════════════════════════
-- Available: 'en', 'es', 'fr', 'de', 'pt'
Config.Lang = 'en'

-- ═══════════════════════════════════════════════════════════
-- ██████ GENERAL SETTINGS ███████████████████████████████████
-- ═══════════════════════════════════════════════════════════
Config.General = {
    enableLooting = true,           -- Master switch for looting system
    useOxTarget = true,             -- Use ox_target for interactions (if available)
    useBsyPrompts = false,          -- Use bsyPrompts for RedM prompts
    interactionDistance = 2.0,      -- Distance to interact with props (meters)
    searchTime = 5000,              -- Time to search prop (milliseconds)
    showHelpText = true,            -- Show help text when near lootable props
    playAnimations = true,          -- Play search animations
    enableParticles = true,         -- Show particle effects on successful loot
    persistentProps = false,        -- Props stay looted until server restart
}

-- ═══════════════════════════════════════════════════════════
-- ██████ KEYBINDS (REDM KEY HASHES) █████████████████████████
-- ═══════════════════════════════════════════════════════════
-- RedM Input Hash Reference: https://docs.fivem.net/docs/game-references/controls/
Config.Keys = {
    lootProp = 0x760A9C6F,          -- G key - Interact with lootable prop
    cancel = 0x8FD015D8,            -- Backspace - Cancel action
}

-- ═══════════════════════════════════════════════════════════
-- ██████ COOLDOWN SETTINGS ██████████████████████████████████
-- ═══════════════════════════════════════════════════════════
Config.Cooldowns = {
    enabled = true,                 -- Enable cooldown system
    globalCooldown = 5000,          -- Cooldown between any loot attempts (ms)
    perPropCooldown = 300000,       -- 5 minutes per prop cooldown (ms)
    resetOnRestart = true,          -- Reset cooldowns on resource restart
}

-- ═══════════════════════════════════════════════════════════
-- ██████ ECONOMY SETTINGS ███████████████████████████████████
-- ═══════════════════════════════════════════════════════════
Config.Economy = {
    moneyType = 'cash',             -- 'cash' or 'bank' for money rewards
    minMoneyReward = 5,             -- Minimum money reward
    maxMoneyReward = 25,            -- Maximum money reward
    moneyChance = 60,               -- Chance to find money (percentage)
}

-- ═══════════════════════════════════════════════════════════
-- ██████ LOOTABLE PROPS █████████████████████████████████████
-- ═══════════════════════════════════════════════════════════
-- Define which prop models can be looted
Config.LootableProps = {
    -- Crates and Boxes
    `p_crate01x`,
    `p_crate02x`,
    `p_crate03x`,
    `p_crate04x`,
    `p_crate05x`,
    `p_crate06x`,
    `p_crate07x`,
    `p_crate08x`,
    
    -- Barrels
    `p_barrel01x`,
    `p_barrel02x`,
    `p_barrel03x`,
    `p_barrel04x`,
    `p_barrelgroup01x`,
    
    -- Chests and Lockboxes
    `p_chest01x`,
    `p_chest02x`,
    `p_chest03x`,
    `p_lockbox01x`,
    `p_lockbox02x`,
    
    -- Safes
    `p_safe01x`,
    `p_safe02x`,
    
    -- Sacks and Bags
    `p_sack01x`,
    `p_sack02x`,
    `p_sack03x`,
    
    -- Misc
    `p_drawer01x`,
    `p_drawer02x`,
}

-- ═══════════════════════════════════════════════════════════
-- ██████ LOOT TABLES ████████████████████████████████████████
-- ═══════════════════════════════════════════════════════════
-- Define what items can be found and their drop rates
-- Each tier has different quality items

Config.LootTables = {
    -- Common items - Found frequently
    tier1 = {
        {item = 'water',            chance = 40, min = 1, max = 2},
        {item = 'bread',            chance = 35, min = 1, max = 3},
        {item = 'consumable_herb_common_bulrush', chance = 30, min = 1, max = 5},
        {item = 'consumable_herb_creeping_thyme', chance = 25, min = 1, max = 4},
        {item = 'ammo_bullet_cartridge_small_game', chance = 20, min = 5, max = 15},
    },
    
    -- Uncommon items - Found occasionally
    tier2 = {
        {item = 'consumable_meat_gristly_mutton', chance = 25, min = 1, max = 2},
        {item = 'consumable_peach',     chance = 20, min = 1, max = 3},
        {item = 'ammo_bullet_cartridge_express', chance = 18, min = 5, max = 20},
        {item = 'consumable_herb_wintergreen_berry', chance = 15, min = 1, max = 3},
        {item = 'lockpick',             chance = 10, min = 1, max = 2},
    },
    
    -- Rare items - Found rarely
    tier3 = {
        {item = 'goldbar',              chance = 5,  min = 1, max = 1},
        {item = 'consumable_tonic_potent_health_tonic', chance = 8, min = 1, max = 2},
        {item = 'consumable_tonic_potent_stamina_tonic', chance = 8, min = 1, max = 2},
        {item = 'ammo_bullet_cartridge_high_velocity', chance = 10, min = 10, max = 25},
        {item = 'weapon_melee_knife',   chance = 3,  min = 1, max = 1},
    }
}

-- ═══════════════════════════════════════════════════════════
-- ██████ SECURITY & ANTI-ABUSE ██████████████████████████████
-- ═══════════════════════════════════════════════════════════
Config.Security = {
    enableDistanceCheck = true,     -- Verify player is near prop server-side
    maxDistance = 5.0,              -- Maximum allowed distance from prop
    enableCooldownCheck = true,     -- Enforce cooldowns server-side
    logAttempts = true,             -- Log all loot attempts to console
    detectSpeedHacks = true,        -- Detect rapid loot attempts
    maxAttemptsPerMinute = 15,      -- Max loot attempts per minute
    banOnExploit = false,           -- Ban players exploiting (requires admin system)
    kickOnExploit = true,           -- Kick players exploiting
}

-- ═══════════════════════════════════════════════════════════
-- ██████ PERFORMANCE OPTIMIZATION ███████████████████████████
-- ═══════════════════════════════════════════════════════════
Config.Performance = {
    propScanDistance = 50.0,        -- Distance to scan for props (meters)
    propScanInterval = 1000,        -- How often to scan for props (ms)
    enablePropCache = true,         -- Cache nearby props for performance
    cacheRefreshInterval = 5000,    -- How often to refresh cache (ms)
    maxCachedProps = 50,            -- Maximum props to keep in cache
}

-- ═══════════════════════════════════════════════════════════
-- ██████ DEBUG & DEVELOPMENT ████████████████████████████████
-- ═══════════════════════════════════════════════════════════
Config.Debug = {
    enabled = false,                -- Enable debug mode
    printLootRolls = false,         -- Print loot roll calculations
    printCooldowns = false,         -- Print cooldown information
    printFrameworkDetection = true, -- Print framework detection info
    showPropModels = false,         -- Show prop model hashes on screen
    testMode = false,               -- Skip cooldowns and distance checks
}

-- ═══════════════════════════════════════════════════════════
-- ██████ END OF CONFIGURATION ███████████████████████████████
-- ═══════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════
-- ██████ STARTUP BANNER █████████████████████████████████████
-- ═══════════════════════════════════════════════════════════
if IsDuplicityVersion() then -- Server-side only
    CreateThread(function()
        Wait(100)
        local lootableCount = #Config.LootableProps
        local tier1Count = #Config.LootTables.tier1
        local tier2Count = #Config.LootTables.tier2
        local tier3Count = #Config.LootTables.tier3
        
        print("^2═══════════════════════════════════════════════════════════^0")
        print("^2  ╦ ╦╔═╗╦  ╦  ╦╔═╗╔═╗  ╦  ╔═╗╔╗╔╔╦╗^0")
        print("^2  ║║║║ ║║  ╚╗╔╝║╣ ╚═╗  ║  ╠═╣║║║ ║║^0")
        print("^2  ╚╩╝╚═╝╩═╝ ╚╝ ╚═╝╚═╝  ╩═╝╩ ╩╝╚╝═╩╝^0")
        print("^2═══════════════════════════════════════════════════════════^0")
        print("^3Template Resource ^2v1.0.0 ^3- Example Looting System^0")
        print("^2═══════════════════════════════════════════════════════════^0")
        print("^3Resource: ^2" .. GetCurrentResourceName() .. "^0")
        print("^3Framework: ^2" .. Config.Framework .. "^0")
        print("^3Language: ^2" .. Config.Lang .. "^0")
        print("^2───────────────────────────────────────────────────────────^0")
        print("^3Lootable Props: ^2" .. lootableCount .. "^0")
        print("^3Loot Items: ^2" .. (tier1Count + tier2Count + tier3Count) .. " ^3(T1: ^2" .. tier1Count .. "^3, T2: ^2" .. tier2Count .. "^3, T3: ^2" .. tier3Count .. "^3)^0")
        print("^3Cooldown: ^2" .. (Config.Cooldowns.perPropCooldown / 1000) .. "s ^3per prop^0")
        print("^2═══════════════════════════════════════════════════════════^0")
        print("^3Discord: ^2" .. Config.ServerInfo.discord .. "^0")
        print("^3Website: ^2" .. Config.ServerInfo.website .. "^0")
        print("^2═══════════════════════════════════════════════════════════^0")
    end)
end
