```
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗ ██████╗ ███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██╔═══██╗██╔══██╗██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██████╔╝█████╗  
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██╔══██╗██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║      ╚██████╗╚██████╔╝██║  ██║███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
```

# 📸 Screenshot Requirements - LXR-Core txAdmin Recipe

**The Land of Wolves Official Screenshot Documentation**

═══════════════════════════════════════════════════════════════════════════════

## Overview

Screenshots are **required** for documenting resource functionality, debugging issues, and providing visual proof of proper configuration. This guide outlines all required screenshots, naming conventions, quality standards, and storage locations.

═══════════════════════════════════════════════════════════════════════════════

## Required Screenshots Checklist

### 1. Server Startup & Console

#### 1.1 Initial Startup Console
**File:** `docs/assets/screenshots/01-startup-console.png`

**What to Capture:**
- ✅ LXR-Core initialization messages
- ✅ Framework detection confirmation
- ✅ Resource loading sequence
- ✅ Database connection success
- ✅ No red error messages
- ✅ "Successfully loaded" message

**How to Capture:**
1. Start your server
2. Watch console output
3. Take screenshot showing clean startup
4. Ensure all resources show "Started successfully"

**Example Content:**
```
[LXR-Core] Framework initialized successfully
[LXR-Core] Framework detected: lxr-core
[oxmysql] Database connection established
[yourresource] Configuration loaded
[yourresource] Started successfully
```

---

#### 1.2 Resource Status
**File:** `docs/assets/screenshots/02-resource-status.png`

**What to Capture:**
- ✅ `resources` command output
- ✅ All required resources shown as "started"
- ✅ Your resource in the list
- ✅ No failed/stopped resources

**How to Capture:**
1. Type `resources` in server console
2. Take screenshot of output
3. Verify all dependencies are started

---

### 2. Configuration Files

#### 2.1 Config.lua Overview
**File:** `docs/assets/screenshots/03-config-overview.png`

**What to Capture:**
- ✅ Main configuration file open in editor
- ✅ Framework settings visible
- ✅ Key configuration values
- ✅ Proper syntax highlighting

**Sections to Show:**
```lua
Config.Framework = 'lxr-core'
Config.Debug = false
Config.Locale = 'en'
```

---

#### 2.2 Database Configuration
**File:** `docs/assets/screenshots/04-database-config.png`

**What to Capture:**
- ✅ Database connection settings (sanitized)
- ✅ Table names/structure
- ✅ Successful connection test

**Note:** ⚠️ **NEVER** show actual passwords or connection strings!

**Safe to Show:**
```lua
Config.Database = {
    type = 'oxmysql',
    tables = {
        players = 'lxr_players',
        hunting = 'player_hunting'
    }
}
```

---

### 3. Framework Detection

#### 3.1 Framework Detection Success
**File:** `docs/assets/screenshots/05-framework-detected.png`

**What to Capture:**
- ✅ Console message showing framework detection
- ✅ Framework name identified
- ✅ Framework version (if applicable)
- ✅ Confirmation of successful initialization

**Example:**
```
[YourResource] Detecting framework...
[YourResource] Framework detected: LXR-Core
[YourResource] Framework ready: true
[YourResource] All systems operational
```

---

#### 3.2 Framework Adapter Status
**File:** `docs/assets/screenshots/06-adapter-status.png`

**What to Capture:**
- ✅ Adapter initialization messages
- ✅ Unified API loaded
- ✅ Event mappings registered
- ✅ No adapter errors

---

### 4. In-Game UI & Interaction

#### 4.1 Main UI/Menu
**File:** `docs/assets/screenshots/07-main-ui.png`

**What to Capture:**
- ✅ Clean UI rendering
- ✅ wolves.land branding visible
- ✅ All UI elements properly aligned
- ✅ Proper colors and styling
- ✅ Readable text at 1920x1080

**Requirements:**
- Resolution: 1920x1080 minimum
- No debug overlays
- Clean game environment
- Good lighting

---

#### 4.2 Notification System
**File:** `docs/assets/screenshots/08-notifications.png`

**What to Capture:**
- ✅ Success notification example
- ✅ Error notification example
- ✅ Info notification example
- ✅ Proper positioning
- ✅ Readable text

**How to Trigger:**
```lua
-- In game, press F8 console
Framework.Notify('Success message example', 'success', 5000)
Framework.Notify('Error message example', 'error', 5000)
Framework.Notify('Info message example', 'info', 5000)
```

---

#### 4.3 Progress Bar
**File:** `docs/assets/screenshots/09-progress-bar.png`

**What to Capture:**
- ✅ Progress bar mid-action
- ✅ Label text visible
- ✅ Progress indicator
- ✅ Proper positioning

**How to Trigger:**
```lua
Framework.ProgressBar('Testing Progress Bar', 10000, false, true, {
    disableMovement = true,
    disableCarMovement = true,
    disableMouse = false,
    disableCombat = true,
}, function(cancelled)
    print('Progress bar test complete')
end)
```

---

#### 4.4 Interaction Prompts
**File:** `docs/assets/screenshots/10-prompts.png`

**What to Capture:**
- ✅ On-screen prompt text
- ✅ Key binding shown
- ✅ Proper formatting
- ✅ Visible in game environment

---

### 5. Gameplay Features

#### 5.1 Feature Showcase 1
**File:** `docs/assets/screenshots/11-feature-1.png`

**What to Capture:**
- ✅ Main feature in action
- ✅ Player character visible
- ✅ Environment context
- ✅ UI elements if applicable

**Example:** Hunting system - Player skinning an animal

---

#### 5.2 Feature Showcase 2
**File:** `docs/assets/screenshots/12-feature-2.png`

**What to Capture:**
- ✅ Secondary feature demonstration
- ✅ Different aspect of resource
- ✅ Clear visibility

**Example:** Hunting system - Shop interface

---

#### 5.3 Feature Showcase 3
**File:** `docs/assets/screenshots/13-feature-3.png`

**What to Capture:**
- ✅ Additional feature or outcome
- ✅ Result of player action
- ✅ Rewards or feedback

**Example:** Hunting system - Inventory with items received

---

### 6. Discord Integration (If Applicable)

#### 6.1 Discord Webhook Logs
**File:** `docs/assets/screenshots/14-discord-logs.png`

**What to Capture:**
- ✅ Discord channel with webhook messages
- ✅ Properly formatted embeds
- ✅ wolves.land branding/footer
- ✅ Accurate information displayed
- ✅ Color-coded by type

**What to Show:**
```
Transaction Log
Player: John_Doe (ABC12345)
Action: Sold hunting pelts
Amount: $450
Timestamp: 2026-01-15 14:23:11

🐺 The Land of Wolves | 2026-01-15 14:23:11
```

**Note:** ⚠️ Redact sensitive player information if needed

---

### 7. Performance Metrics

#### 7.1 txAdmin Performance
**File:** `docs/assets/screenshots/15-txadmin-performance.png`

**What to Capture:**
- ✅ txAdmin resource list
- ✅ Your resource CPU/memory usage
- ✅ Low ms/tick value (<0.5ms ideal)
- ✅ No red flags

**How to Access:**
1. Open txAdmin panel
2. Navigate to "Resources" tab
3. Locate your resource
4. Take screenshot showing metrics

---

#### 7.2 In-Game Resource Monitor (resmon)
**File:** `docs/assets/screenshots/16-resmon.png`

**What to Capture:**
- ✅ F8 resmon output
- ✅ Your resource listed
- ✅ CPU time (ms)
- ✅ Memory usage
- ✅ Thread count

**How to Access:**
1. Press F8 in-game
2. Type `resmon`
3. Find your resource
4. Take screenshot

---

### 8. Error Handling

#### 8.1 Graceful Error Display
**File:** `docs/assets/screenshots/17-error-handling.png`

**What to Capture:**
- ✅ Error message to player (user-friendly)
- ✅ No raw Lua errors visible to player
- ✅ Proper notification styling

**Example:**
```
[Error] You must have a hunting knife to skin animals
```

---

#### 8.2 Console Debug Output
**File:** `docs/assets/screenshots/18-debug-console.png`

**What to Capture:**
- ✅ Debug mode enabled
- ✅ Verbose logging visible
- ✅ No actual errors (just debug info)
- ✅ Clean, readable format

═══════════════════════════════════════════════════════════════════════════════

## Screenshot Storage Structure

### Directory Structure

```
docs/
└── assets/
    └── screenshots/
        ├── 01-startup-console.png
        ├── 02-resource-status.png
        ├── 03-config-overview.png
        ├── 04-database-config.png
        ├── 05-framework-detected.png
        ├── 06-adapter-status.png
        ├── 07-main-ui.png
        ├── 08-notifications.png
        ├── 09-progress-bar.png
        ├── 10-prompts.png
        ├── 11-feature-1.png
        ├── 12-feature-2.png
        ├── 13-feature-3.png
        ├── 14-discord-logs.png
        ├── 15-txadmin-performance.png
        ├── 16-resmon.png
        ├── 17-error-handling.png
        └── 18-debug-console.png
```

### Create Directory

```bash
mkdir -p docs/assets/screenshots
```

═══════════════════════════════════════════════════════════════════════════════

## File Naming Conventions

### Format

```
[number]-[descriptive-name].png
```

### Rules

1. **Two-digit prefix:** `01-`, `02-`, `03-`, etc.
2. **Lowercase names:** Use hyphens for spaces
3. **Descriptive:** Name should indicate content
4. **Extension:** Always `.png` (best quality/compression)

### Examples

✅ **Good:**
- `01-startup-console.png`
- `07-main-ui.png`
- `15-txadmin-performance.png`

❌ **Bad:**
- `Screenshot1.png` (not descriptive)
- `Main UI.png` (spaces, no number)
- `startup.jpg` (wrong format)
- `image.png` (too vague)

═══════════════════════════════════════════════════════════════════════════════

## When Screenshots Are Required

### 1. Initial Development

Capture screenshots as you build features to document:
- Feature implementation
- UI design
- Functionality proof

### 2. Bug Reports

Include screenshots showing:
- Error messages
- Console output
- Visual glitches
- Reproduction steps

### 3. Pull Requests / Updates

Provide screenshots demonstrating:
- New features
- UI changes
- Fixed bugs (before/after)

### 4. Documentation

Use screenshots to illustrate:
- Setup instructions
- Configuration examples
- Usage guides
- Troubleshooting steps

### 5. Release Preparation

Final screenshot set showing:
- All features working
- Clean startup
- Good performance
- Professional appearance

═══════════════════════════════════════════════════════════════════════════════

## How to Capture Screenshots

### In-Game (RedM/FiveM)

**Method 1: Steam (if using Steam version)**
1. Press `F12`
2. Screenshots saved to: `Steam/userdata/[id]/760/remote/[appid]/screenshots`

**Method 2: Windows Snipping Tool**
1. Press `Windows + Shift + S`
2. Select area
3. Paste into image editor
4. Save as PNG

**Method 3: ShareX (Recommended)**
1. Install ShareX (free)
2. Configure hotkey
3. Auto-saves to specified folder
4. Supports annotations

**Method 4: Built-in F8 Console**
```lua
-- Some resources support
screenshot
```

### Server Console

**Method 1: Copy/Paste**
1. Select console text
2. Copy
3. Paste into text file
4. Take screenshot of text file

**Method 2: Windows Snipping Tool**
1. Press `Windows + Shift + S`
2. Select console window
3. Save

### txAdmin Panel

**Browser Built-in:**
1. Navigate to desired page
2. Press `Ctrl + Shift + S` (Firefox) or `F12 > Screenshot` (Chrome)
3. Save full page or selection

═══════════════════════════════════════════════════════════════════════════════

## Screenshot Quality Guidelines

### Resolution

- **Minimum:** 1920x1080 (Full HD)
- **Recommended:** 2560x1440 (QHD)
- **Maximum:** 3840x2160 (4K)

### Format

- **Always use PNG** (lossless compression)
- **Never use JPG** for UI screenshots (artifacts)
- **GIF only for animations** (not covered here)

### Clarity

✅ **Good:**
- Clear, crisp text
- Proper focus
- Good lighting
- Readable at 100% zoom

❌ **Bad:**
- Blurry text
- Motion blur
- Too dark/bright
- Compression artifacts

### Framing

✅ **Good:**
- Subject centered or following rule of thirds
- Relevant context visible
- No unnecessary clutter
- Clean composition

❌ **Bad:**
- Subject cut off
- Too much empty space
- Distracting elements
- Poor angle

### UI Screenshots

- **Hide crosshair** if possible
- **Remove minimap** if it's distracting
- **Disable damage indicators** during capture
- **Clean HUD** - only show relevant elements

### Console Screenshots

- **Scroll to relevant section**
- **Include enough context** (10-20 lines)
- **Highlight key messages** if possible
- **Remove sensitive info** (passwords, IPs)

═══════════════════════════════════════════════════════════════════════════════

## Privacy & Security

### What to Redact

⚠️ **ALWAYS redact:**
- Database passwords
- API keys
- Discord webhook URLs (full URL)
- Server IP addresses
- Player personal information
- Steam IDs (if sensitive)
- License keys

### How to Redact

**Method 1: Blur in Image Editor**
1. Open screenshot in editor (Paint.NET, Photoshop, GIMP)
2. Use blur or pixelate tool
3. Cover sensitive text
4. Save

**Method 2: Black Box**
1. Draw black rectangle over sensitive area
2. Ensure text not visible
3. Save

**Method 3: Replace Text**
1. Use text tool
2. Replace sensitive value with `[REDACTED]` or `***`
3. Match font/size if possible

### Example Sanitization

❌ **Don't show:**
```lua
Config.MySQL = {
    host = '192.168.1.100',
    user = 'admin',
    password = 'SuperSecret123!',
    database = 'lxrcore'
}
```

✅ **Do show:**
```lua
Config.MySQL = {
    host = '[REDACTED]',
    user = '[REDACTED]',
    password = '***',
    database = 'lxrcore'
}
```

═══════════════════════════════════════════════════════════════════════════════

## Organizing Screenshots

### For Development

Keep screenshots organized by:

```
screenshots/
├── development/
│   ├── 2026-01-15/
│   │   ├── feature-hunting.png
│   │   └── ui-mockup.png
│   └── 2026-01-16/
│       └── bugfix-proof.png
├── bugs/
│   ├── bug-001-inventory.png
│   └── bug-002-notification.png
└── final/
    ├── 01-startup-console.png
    ├── 02-resource-status.png
    └── ...
```

### For Documentation

Only include **final** screenshots in docs:

```
docs/assets/screenshots/
├── 01-startup-console.png
├── 02-resource-status.png
├── ...
└── 18-debug-console.png
```

═══════════════════════════════════════════════════════════════════════════════

## Screenshot Checklist Template

Use this checklist for each screenshot:

```
Screenshot: [Name/Number]
─────────────────────────────
[ ] Correct resolution (1920x1080+)
[ ] PNG format
[ ] Clear and in focus
[ ] Relevant content visible
[ ] No sensitive information
[ ] Proper lighting
[ ] Clean composition
[ ] Readable text
[ ] Proper filename
[ ] Saved to correct directory
[ ] Documented in this file
```

═══════════════════════════════════════════════════════════════════════════════

## Embedding Screenshots in Documentation

### Markdown Syntax

```markdown
![Screenshot Description](assets/screenshots/01-startup-console.png)
```

### With Alt Text

```markdown
![LXR-Core startup console showing successful resource initialization](assets/screenshots/01-startup-console.png)
```

### With Caption

```markdown
![Startup Console](assets/screenshots/01-startup-console.png)
*Figure 1: Clean server startup with all resources loaded successfully*
```

### Relative Paths

From `docs/installation.md`:
```markdown
![Framework Detection](assets/screenshots/05-framework-detected.png)
```

From `README.md` (root):
```markdown
![Framework Detection](docs/assets/screenshots/05-framework-detected.png)
```

═══════════════════════════════════════════════════════════════════════════════

## Updating Screenshots

### When to Update

Update screenshots when:
- ✅ UI design changes
- ✅ Major features added
- ✅ Branding updates
- ✅ Framework updates affect appearance
- ✅ Configuration format changes
- ✅ Screenshots become outdated

### Version Control

Consider versioning if needed:

```
docs/assets/screenshots/
├── v1.0/
│   └── 07-main-ui.png
└── v2.0/
    └── 07-main-ui.png
```

Or use dates:

```
07-main-ui-2026-01-15.png
07-main-ui-2026-02-20.png (latest)
```

═══════════════════════════════════════════════════════════════════════════════

## Troubleshooting Screenshot Issues

### Issue: Screenshots Too Large

**Solution:**
1. Use PNG optimizer (TinyPNG, OptiPNG)
2. Reduce resolution (if above 4K)
3. Crop unnecessary areas

### Issue: Text Not Readable

**Solution:**
1. Increase resolution
2. Zoom in before capturing
3. Use higher quality settings
4. Check game graphics settings

### Issue: Screenshot Won't Embed

**Solution:**
1. Verify file path is correct
2. Check file extension (.png)
3. Ensure file exists in repository
4. Use forward slashes `/` in paths

### Issue: Colors Look Wrong

**Solution:**
1. Check monitor calibration
2. Verify game graphics settings
3. Use PNG (not JPG)
4. Check image editor color profile

═══════════════════════════════════════════════════════════════════════════════

## Quick Reference

### Minimum Required Screenshots

1. ✅ Startup console (clean)
2. ✅ Framework detection
3. ✅ Main UI/feature
4. ✅ Performance metrics
5. ✅ Configuration example

### File Checklist

- [ ] All 18 screenshots captured
- [ ] Proper naming convention
- [ ] Correct directory structure
- [ ] PNG format (not JPG)
- [ ] 1920x1080 minimum resolution
- [ ] No sensitive information visible
- [ ] Clean, professional appearance
- [ ] Documented in this guide

═══════════════════════════════════════════════════════════════════════════════

## Support & Resources

- 📚 **Documentation:** `/docs` directory
- 💬 **Discord:** https://discord.gg/CrKcWdfd3A
- 🐛 **Issues:** GitHub Issues
- 🌐 **Website:** https://www.wolves.land
- 📦 **GitHub:** https://github.com/iBoss21

═══════════════════════════════════════════════════════════════════════════════

**Developer:** iBoss21 / The Lux Empire  
**Server:** The Land of Wolves 🐺  
**© 2026 wolves.land | All Rights Reserved**

═══════════════════════════════════════════════════════════════════════════════
