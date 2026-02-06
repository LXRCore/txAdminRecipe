--[[
  ╦ ╦╔═╗╦  ╦  ╦╔═╗╔═╗  ╦  ╔═╗╔╗╔╔╦╗
  ║║║║ ║║  ╚╗╔╝║╣ ╚═╗  ║  ╠═╣║║║ ║║
  ╚╩╝╚═╝╩═╝ ╚╝ ╚═╝╚═╝  ╩═╝╩ ╩╝╚╝═╩╝
  ════════════════════════════════════════════════════════════
  Template Resource - Example Looting System
  Production-Ready Reference Implementation
  ════════════════════════════════════════════════════════════
  wolves.land | discord.gg/lxr | lxrcore.com
  ════════════════════════════════════════════════════════════
]]

-- ═══════════════════════════════════════════════════════════
-- ██████ REDM PRERELEASE WARNING ████████████████████████████
-- ═══════════════════════════════════════════════════════════
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources WILL become incompatible once RedM ships.'

-- ═══════════════════════════════════════════════════════════
-- ██████ MANIFEST METADATA ██████████████████████████████████
-- ═══════════════════════════════════════════════════════════
fx_version 'cerulean'
game 'rdr3'
lua54 'yes'

name 'template-resource'
author 'wolves.land Development Team'
description 'Production-ready template resource demonstrating LXR coding standards - Example looting system'
version '1.0.0'
repository 'https://github.com/wolves-land/template-resource'

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
