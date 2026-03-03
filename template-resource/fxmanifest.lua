--[[
  ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗ ██████╗ ███████╗
  ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██╔═══██╗██╔══██╗██╔════╝
  ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██████╔╝█████╗
  ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██╔══██╗██╔══╝
  ███████╗██╔╝ ██╗██║  ██║      ╚██████╗╚██████╔╝██║  ██║███████╗
  ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
  ════════════════════════════════════════════════════════════════
  🐺 Template Resource — Example Looting System
  Production-Ready Reference Implementation
  ════════════════════════════════════════════════════════════════
  SERVER INFORMATION
  ──────────────────────────────────────────────────────────────
  Server:    The Land of Wolves 🐺
  Developer: iBoss21 / The Lux Empire
  Website:   https://www.wolves.land
  Discord:   https://discord.gg/CrKcWdfd3A
  Store:     https://theluxempire.tebex.io
  ════════════════════════════════════════════════════════════════
  © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
  ════════════════════════════════════════════════════════════════
]]

-- ═══════════════════════════════════════════════════════════
-- ██████ MANIFEST METADATA ██████████████████████████████████
-- ═══════════════════════════════════════════════════════════
fx_version 'cerulean'
game 'rdr3'

-- ═══════════════════════════════════════════════════════════
-- ██████ REDM PRERELEASE WARNING ████████████████████████████
-- ═══════════════════════════════════════════════════════════
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

lua54 'yes'

name 'template-resource'
author 'iBoss21 / The Lux Empire'
description 'Production-ready template resource demonstrating LXR coding standards - Example looting system | wolves.land'
version '1.0.0'
repository 'https://github.com/LXRCore/txAdminRecipe'

-- ═══════════════════════════════════════════════════════════
-- ██████ SHARED SCRIPTS █████████████████████████████████████
-- ═══════════════════════════════════════════════════════════
shared_scripts {
    'config.lua',
    'shared/locale.lua',
    'shared/framework.lua'
}

-- ═══════════════════════════════════════════════════════════
-- ██████ CLIENT SCRIPTS █████████████████████████████████████
-- ═══════════════════════════════════════════════════════════
client_scripts {
    'client/main.lua'
}

-- ═══════════════════════════════════════════════════════════
-- ██████ SERVER SCRIPTS █████████████████████████████████████
-- ═══════════════════════════════════════════════════════════
server_scripts {
    'server/main.lua'
}

-- ═══════════════════════════════════════════════════════════
-- ██████ DEPENDENCIES ███████████████████████████████████████
-- ═══════════════════════════════════════════════════════════
-- NO HARD DEPENDENCIES - Supports Multi-Framework Detection
-- Optional: ox_target, ox_lib for enhanced features
