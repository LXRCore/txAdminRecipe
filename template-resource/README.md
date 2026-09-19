<p align="center"><img src="https://raw.githubusercontent.com/LXRCore/.github/main/profile/img/lxrcore-logo.png" width="96" alt="LXRCore"></p>

# template-resource

A free starter for anyone building a third-party resource on **LXRCore v3**.
Copy the folder, rename it, keep what you need. It is one working example,
not a framework of its own: a well in Valentine that hands out a bottle of
water once per cooldown, and a `/well` command that says where it is.

```
template-resource/
├─ fxmanifest.lua        imports @lxr-core/shared/import.lua, then shared/, locales/, config
├─ config.lua            everything an owner may change (points, prompt key, cooldown, security)
├─ locales/en.lua        every string (English is the fallback)
├─ locales/ka.lua        Georgian
├─ shared/locale.lua     Lang:t('key', { var = 1 }), Lang.bundle() for a NUI
├─ client/main.lua       prompts → one RPC → a toast
└─ server/main.lua       rate limit, distance, cooldown, the item, the log
```

## What it shows

| Need | Native call |
|------|-------------|
| the core objects | `exports['lxr-core']:GetCoreObject()` (classic) · `exports['lxr-core']:GetLXR()` (native) |
| ask the server and wait | `LXR.RPC.Server('name', …)` → `ok, payloadOrErrorKey` |
| answer on the server | `LXR.RPC.Register('name', function(src, …) return ok, … end)` |
| a prompt at a place | `LXRCore.Prompts.Create(id, coords, key, label, { type = 'callback', event = fn }, distance)` |
| a toast | `LXR.UI.Notify(text, 'success' \| 'error' \| 'info')` (client) · `LXRCore.Notify(src, text, kind)` (server) |
| a command | `LXRCore.Commands.Add(name, help, args, required, handler, permission)` |
| the character | `LXRCore.Functions.GetPlayer(src)` → `Player.PlayerData`, `Player.Functions.AddItem(...)` |
| room in the satchel | `LXRCore.Inventory.CanCarry(src, item, amount)` |
| abuse | `LXRCore.RateLimit(bucket, src, burst, windowMs)` · `LXRCore.Log.exploit(src, what, data)` |
| lifecycle | `lxr:player:loaded(Player)` · `lxr:player:unloaded(src)` (server) · `lxr:client:loaded` (client) |

## Rules worth keeping

* **The server decides.** The client draws and asks; nothing of value is granted client side.
* **Config in `config.lua`, strings in `locales/`.** Add a language by adding a file.
* **Verify every native** against [rdr3natives.com](https://rdr3natives.com/) before you ship it.
* If you add a page, build it on the **LXR UI Kit** (`lxr-ui.css` from any official resource): inks and one blood accent, radius 0, index rows.

## Install

```
ensure lxr-core
ensure template-resource
```

Questions, bugs, ideas: [discord.gg/GAhk8cgXe9](https://discord.gg/GAhk8cgXe9)

© 2026 iBoss21 / LXRCore · [lxrcore.com](https://www.lxrcore.com)
