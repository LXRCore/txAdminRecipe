# Boot order

Every LXRCore resource declares what it needs in its `fxmanifest.lua`
(`dependencies { … }`), so FXServer starts the chain in a valid order even when
`server.cfg` lines are shuffled. The order below is the one the recipe writes
and the one to keep when adding resources by hand.

| # | resource | needs | why here |
|---|---|---|---|
| 1 | `oxmysql` | — | database |
| 2 | `lxr-core` | oxmysql | framework API (`GetCoreObject`, `GetLXR`, RPC, Commands, Prompts, Notify, Log, DB, Items, Player), catalog + 1899 ledger, migrations |
| 3 | `lxr-nui` | — (uses core when present) | the kit provider: toasts, menus, inputs, progress. Core's `Config.Notify.backend = 'auto'` routes notifications here once it is started |
| 4 | `lxr-mapcolor` | — | route and blip colours; other resources probe `GetResourceState('lxr-mapcolor')` at runtime, never at boot |
| 4b | `lxr-interact` | core | the interaction layer — every later resource registers its points, zones, models and entities here |
| 5 | `lxr-inventory` | core | items, stashes, usable items — before anything that hands items out |
| 6 | `lxr-clothing` | core | the appearance engine: game tables, validator, apply layer, tailor + wardrobe doors |
| 7 | `lxr-creator` | core, clothing | loads `@lxr-clothing/shared/*`, writes the first look through `SaveAppearance` |
| 8 | `lxr-barber` | core, clothing | same engine dependency; writes through `SaveBarber` |
| 9 | `lxr-spawn` | core | listens for `lxr-spawn:client:setupSpawnUI` from the creator |
| 10 | `lxr-me` | core | overlay |
| 11 | `lxr-horses` | core, inventory | catalog horses, feed / brush / deed items |
| 12 | `lxr-trains` | core | managed lines, stations, tickets |
| 13 | `lxr-hud` | core, nui | needs, consumables, the frame |
| 14 | `lxr-weapons` | core, nui, inventory | weapon and cartridge items become usable here; the HUD reads the `weapon` state bag |
| 15 | `lxr-doors` | core, interact | lock states before the law and the bank register their doors |
| 16 | `lxr-lockpick` | core | the minigame doors call back into |
| 17 | `lxr-shops` | core, nui, inventory, interact | counters from the catalog |
| 18 | `lxr-bank` | core, nui, inventory, interact | books before the law, businesses and payroll need them |
| 19 | `[lxr]`, `[standalone]` | core | consumers — see the workspace `docs/CHAIN.md` for the tiers |

## Rules

* **Providers before consumers.** Anything that *shows* an interface comes after
  `lxr-nui`; anything that *changes a look* comes after `lxr-clothing`;
  anything that *gives an item* comes after `lxr-inventory`.
* **Runtime probes, never boot-time assumptions.** Optional integrations
  (`lxr-mapcolor`, `ox_lib`) are checked with `GetResourceState` when used.
* **One hand-off chain for a new player:** `lxr-creator` (select → identity →
  traits → appearance → create) → `lxr-spawn` (picker) → world. No other
  resource may open UI during that chain.
* **Migrations run in core's order** — a resource registers its migration with
  `LXRCore.DB.RegisterMigration(resource, id, sql)` at start and core applies
  it before the resource's first query.
