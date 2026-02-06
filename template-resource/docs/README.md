# Template Resource - Example Looting System

```
  ╦ ╦╔═╗╦  ╦  ╦╔═╗╔═╗  ╦  ╔═╗╔╗╔╔╦╗
  ║║║║ ║║  ╚╗╔╝║╣ ╚═╗  ║  ╠═╣║║║ ║║
  ╚╩╝╚═╝╩═╝ ╚╝ ╚═╝╚═╝  ╩═╝╩ ╩╝╚╝═╩╝
```

**Production-Ready Template Resource**  
A complete reference implementation demonstrating all wolves.land / LXR coding standards.

---

## 📋 Overview

This is a **production-ready template resource** that showcases best practices for RedM resource development. It implements a simple but fully-functional **example looting system** where players can interact with props (crates, barrels, chests, etc.) to find items and money.

### ✨ Features

- 🎯 **Multi-Framework Support** - Auto-detects and works with:
  - LXR-Core (wolves.land)
  - RSG-Core
  - VORP Core
  - RedEM:RP
  - QBR-Core
  - QR-Core
  - Standalone mode
  
- 🌍 **Multi-Language** - Supports EN, ES, FR, DE, PT
- 🛡️ **Security First** - Anti-exploit, distance checks, cooldowns
- ⚡ **Performance Optimized** - Prop caching, efficient scanning
- 🎨 **Modern Interactions** - ox_target support with prompt fallback
- 🎲 **Tiered Loot System** - Common, Uncommon, and Rare items
- 📊 **Debug Tools** - Comprehensive debugging options
- 📝 **Fully Documented** - Every function and section explained

---

## 🚀 Installation

1. **Download or clone** this resource into your server's `resources` folder:
   ```bash
   cd resources
   git clone https://github.com/wolves-land/template-resource.git
   ```

2. **Add to server.cfg**:
   ```cfg
   ensure template-resource
   ```

3. **Configure** (optional):
   - Edit `config.lua` to customize loot tables, cooldowns, and settings
   - Add your server's custom items to the loot tables
   - Adjust framework settings if needed

4. **Restart your server** or use:
   ```
   restart template-resource
   ```

---

## ⚙️ Configuration

### Framework Settings

The resource automatically detects your framework, but you can force a specific one:

```lua
Config.Framework = 'auto' -- or 'lxr-core', 'rsg-core', 'vorp', 'redem', 'qbr', 'qr', 'standalone'
```

### Lootable Props

Add or remove prop models from the `Config.LootableProps` table:

```lua
Config.LootableProps = {
    `p_crate01x`,
    `p_barrel01x`,
    `p_chest01x`,
    -- Add more prop hashes...
}
```

### Loot Tables

Customize what items players can find:

```lua
Config.LootTables = {
    tier1 = {
        {item = 'water', chance = 40, min = 1, max = 2},
        -- Common items...
    },
    tier2 = {
        {item = 'lockpick', chance = 10, min = 1, max = 2},
        -- Uncommon items...
    },
    tier3 = {
        {item = 'goldbar', chance = 5, min = 1, max = 1},
        -- Rare items...
    }
}
```

### Cooldowns

Control how often props can be looted:

```lua
Config.Cooldowns = {
    enabled = true,
    globalCooldown = 5000,      -- 5 seconds between any loot
    perPropCooldown = 300000,   -- 5 minutes per prop
}
```

### Security

Configure anti-exploit measures:

```lua
Config.Security = {
    enableDistanceCheck = true,
    maxDistance = 5.0,
    detectSpeedHacks = true,
    maxAttemptsPerMinute = 15,
    kickOnExploit = true,
}
```

---

## 🎮 Usage

### For Players

**With ox_target:**
- Look at a lootable prop (crate, barrel, chest, etc.)
- The interaction will appear
- Click to search the container
- Wait for the progress bar to complete
- Receive your loot!

**Without ox_target:**
- Walk up to a lootable prop
- Press **G** (default) when prompted
- Wait for the search to complete
- Collect your rewards

### For Admins

**Commands:**
- `/resetloot` - Reset all loot cooldowns (requires admin)
- `/lootstats` - View loot statistics (console)

---

## 🛠️ Development

### File Structure

```
template-resource/
├── fxmanifest.lua          # Resource manifest
├── config.lua              # Main configuration
├── shared/
│   ├── locale.lua          # Multi-language support
│   └── framework.lua       # Framework bridge/adapter
├── client/
│   └── main.lua            # Client-side logic
├── server/
│   └── main.lua            # Server-side logic
└── docs/
    └── README.md           # This file
```

### Code Standards

This resource demonstrates:

✅ **Branded ASCII Headers** - All files have wolves.land branding  
✅ **Section Dividers** - Clear organization with ═══ dividers  
✅ **Comprehensive Comments** - Every function documented  
✅ **LuaDoc Annotations** - Type hints for better IDE support  
✅ **Error Handling** - Graceful failures and fallbacks  
✅ **Performance** - Optimized prop scanning and caching  
✅ **Security** - Distance checks, cooldowns, anti-exploit  
✅ **Framework Agnostic** - Works with any framework  
✅ **Debug Tools** - Extensive debugging options  

### Extending the Resource

**Adding New Frameworks:**
1. Add framework detection in `shared/framework.lua`
2. Add framework settings to `config.lua`
3. Implement framework-specific functions

**Adding New Loot Items:**
1. Edit `Config.LootTables` in `config.lua`
2. Add item with chance, min, and max amounts
3. Ensure item exists in your framework/inventory

**Adding New Interactions:**
1. Add prop models to `Config.LootableProps`
2. Optionally customize interaction distance
3. Test in-game

---

## 🧪 Testing

### Debug Mode

Enable debug mode for development:

```lua
Config.Debug = {
    enabled = true,
    printLootRolls = true,
    printCooldowns = true,
    printFrameworkDetection = true,
    showPropModels = true,
    testMode = false, -- Skip all checks
}
```

### Test Mode

Enable test mode to skip all security checks:

```lua
Config.Debug.testMode = true
```

---

## 🔧 Troubleshooting

### Props Not Appearing

1. Check `Config.LootableProps` has valid prop hashes
2. Enable `Config.Debug.showPropModels = true` to see markers
3. Increase `Config.Performance.propScanDistance`

### Framework Not Detected

1. Check framework resource is started
2. Enable `Config.Debug.printFrameworkDetection = true`
3. Manually set `Config.Framework` to your framework name

### No Loot Found

1. Check `Config.LootTables` has items
2. Enable `Config.Debug.printLootRolls = true` to see rolls
3. Increase item chances in loot tables
4. Verify items exist in your framework

### ox_target Not Working

1. Ensure ox_target is started before this resource
2. Check `Config.General.useOxTarget = true`
3. Fallback to manual prompts if ox_target unavailable

---

## 📦 Dependencies

### Required
- None! Fully standalone compatible

### Optional (Enhanced Features)
- **ox_target** - For better prop interactions
- **ox_lib** - For enhanced progress bars
- Any supported framework - For full functionality

---

## 🤝 Framework Compatibility

| Framework | Status | Tested | Notes |
|-----------|--------|--------|-------|
| LXR-Core | ✅ Full Support | Yes | Primary framework |
| RSG-Core | ✅ Full Support | Yes | Fully compatible |
| VORP Core | ✅ Full Support | Yes | Community favorite |
| RedEM:RP | ✅ Full Support | Limited | Should work |
| QBR-Core | ✅ Full Support | Limited | QB RedM port |
| QR-Core | ✅ Full Support | Limited | QB RedM port |
| Standalone | ✅ Basic Support | Yes | Limited features |

---

## 🔐 Security Features

- ✅ Server-side distance validation
- ✅ Cooldown enforcement
- ✅ Speed hack detection
- ✅ Exploit attempt logging
- ✅ Automatic kicking/banning
- ✅ Rate limiting

---

## 🌐 Multi-Language Support

Currently supported languages:
- 🇬🇧 English (en)
- 🇪🇸 Spanish (es)
- 🇫🇷 French (fr)
- 🇩🇪 German (de)
- 🇵🇹 Portuguese (pt)

To add a new language:
1. Edit `shared/locale.lua`
2. Add new language table
3. Set `Config.Lang` to your language code

---

## 📊 Performance

- **Prop Scanning:** Optimized with caching
- **Network Events:** Minimized to essential only
- **Database Queries:** None (uses in-memory cooldowns)
- **Client FPS Impact:** < 1ms typical
- **Server CPU Impact:** Negligible

---

## 📝 License

This resource is provided as a **free template** by wolves.land.

You are free to:
- ✅ Use in your server
- ✅ Modify for your needs
- ✅ Learn from the code
- ✅ Share with others

Please:
- ⭐ Keep the wolves.land credits in file headers
- 🔗 Link back to https://lxrcore.com
- 💬 Join our community at discord.gg/lxr

---

## 🆘 Support

**Need Help?**
- 💬 Discord: [discord.gg/lxr](https://discord.gg/lxr)
- 🌐 Website: [lxrcore.com](https://lxrcore.com)
- 📚 Docs: [docs.lxrcore.com](https://docs.lxrcore.com)

**Found a Bug?**
- Open an issue on GitHub
- Include your framework and RedM version
- Provide reproduction steps

---

## 👥 Credits

**Developed by wolves.land Development Team**

Special thanks to:
- LXR-Core community
- RedM development community
- All framework developers
- Our amazing Discord community

---

## 🔄 Changelog

### Version 1.0.0 (Initial Release)
- ✅ Multi-framework support (7 frameworks)
- ✅ Multi-language support (5 languages)
- ✅ Complete loot system with tiers
- ✅ ox_target integration
- ✅ Security & anti-exploit measures
- ✅ Performance optimizations
- ✅ Comprehensive documentation
- ✅ Debug tools

---

## 🎯 Roadmap

Future enhancements (community feedback welcome):
- [ ] MySQL integration for persistent cooldowns
- [ ] Admin UI for managing loot tables
- [ ] Webhook notifications
- [ ] More animation options
- [ ] Job-restricted looting
- [ ] Location-based loot tiers
- [ ] Lockpicking mini-game

---

**Made with ❤️ by wolves.land**

```
  ╦ ╦╔═╗╦  ╦  ╦╔═╗╔═╗  ╦  ╔═╗╔╗╔╔╦╗
  ║║║║ ║║  ╚╗╔╝║╣ ╚═╗  ║  ╠═╣║║║ ║║
  ╚╩╝╚═╝╩═╝ ╚╝ ╚═╝╚═╝  ╩═╝╩ ╩╝╚╝═╩╝
  
  discord.gg/lxr | lxrcore.com
```
