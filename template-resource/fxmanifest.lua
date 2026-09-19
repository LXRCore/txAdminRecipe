--[[
    ██╗     ██╗  ██╗██████╗       ████████╗███████╗███╗   ███╗██████╗ ██╗      █████╗ ████████╗███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ╚══██╔══╝██╔════╝████╗ ████║██╔══██╗██║     ██╔══██╗╚══██╔══╝██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗   ██║   █████╗  ██╔████╔██║██████╔╝██║     ███████║   ██║   █████╗
    ██║      ██╔██╗ ██╔══██╗╚════╝   ██║   ██╔══╝  ██║╚██╔╝██║██╔═══╝ ██║     ██╔══██║   ██║   ██╔══╝
    ███████╗██╔╝ ██╗██║  ██║         ██║   ███████╗██║ ╚═╝ ██║██║     ███████╗██║  ██║   ██║   ███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝         ╚═╝   ╚══════╝╚═╝     ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝

    🐺 LXR Core - Starter for a third-party resource

    Copy this folder, rename it, and build on the native LXRCore v3 API.
    Free to use and change for anything that runs on an LXRCore server.

    Brand:       LXRCore — Lux Empire eXperience RedM Core
    Website:     https://www.lxrcore.com
    Discord:     https://discord.gg/GAhk8cgXe9
    GitHub:      https://github.com/LXRCore

    © 2026 iBoss21 / LXRCore | lxrcore.com
]]

fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
lua54 'yes'

name 'template-resource'
author 'your name'
description 'A starter resource on the LXRCore v3 native API'
version '1.0.0'

shared_scripts {
    '@lxr-core/shared/import.lua',   -- LXRShared (items, helpers) in this VM
    'shared/locale.lua',
    'locales/*.lua',
    'config.lua',
}

client_script 'client/main.lua'
server_script 'server/main.lua'

dependency 'lxr-core'
