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
| 3 | `lxr-loading` | core | the loading screen (`loadscreen`, manual shutdown once the session is up) |
| 3 | `lxr-chat` | core | the chat box; `provide 'chat'`, keeps `chat:addMessage` / `chat:addSuggestions` for every script |
| 4 | `lxr-mapcolor` | — | route and blip colours; other resources probe `GetResourceState('lxr-mapcolor')` at runtime, never at boot |
| 4a | `lxr-weather` | core | the calendar and the sky — `GlobalState.hour` before anything with opening hours |
| 4b | `lxr-interact` | core | the interaction layer — every later resource registers its points, zones, models and entities here |
| 5 | `lxr-inventory` | core | items, stashes, usable items — before anything that hands items out |
| 6 | `lxr-clothing` | core | the appearance engine: game tables, validator, apply layer, tailor + wardrobe doors |
| 7 | `lxr-creator` | core, clothing | loads `@lxr-clothing/shared/*`, writes the first look through `SaveAppearance`; the spawn step (towns, last position, arrival protection) is its last page |
| 8 | `lxr-barber` | core, clothing | same engine dependency; writes through `SaveBarber` |
| 10 | `lxr-me` | core | overlay |
| 11 | `lxr-horses` | core, inventory | catalog horses, feed / brush / deed items |
| 12 | `lxr-trains` | core | managed lines, stations, tickets |
| 13 | `lxr-hud` | core, nui | needs, consumables, the frame |
| 13a | `lxr-radial` | core | the action wheel; other resources add entries at runtime (`exports['lxr-radial']:Add`) |
| 13b | `lxr-clothingradial` | clothing, radial | the clothing wheel (murphy_radialmenu fork, GPL-3); lxr-radial's *Clothing* hands over to it when present |
| — | `lxr-vehicles` | core, interact | the first motor cars; **off by default** — prop bodies on an invisible wagon desync between players |
| 14 | `lxr-weapons` | core, nui, inventory | weapon and cartridge items become usable here; the HUD reads the `weapon` state bag |
| 15 | `lxr-doors` | core, interact | lock states before the law and the bank register their doors |
| 16 | `lxr-lockpick` | core | the minigame doors call back into |
| 17 | `lxr-shops` | core, nui, inventory, interact | counters from the catalog |
| 18 | `lxr-bank` | core, nui, inventory, interact | books before the law, businesses and payroll need them |
| 19 | `lxr-dispatch` | core, nui | the wire — before the law and the doctors |
| 20 | `lxr-lawman` | core, nui, inventory, interact | the law, after dispatch and the bank it pays into |
| 21 | `lxr-doctor` | core, nui, inventory, interact | death and the doctors |
| 22 | `lxr-business` | core, nui, interact, bank | the ledgers |
| 23 | `lxr-lasso`, `lxr-blindfold` | core, interact | restraints (blindfold reads the cuffed / tied state bags) |
| 24 | `lxr-contraband` | core, interact, dispatch | running contracts — after the wire it tips off |
| 25 | `lxr-farming`, `lxr-hunting`, `lxr-mining`, `lxr-moonshine`, `lxr-interiors` | core, interact, weather, dispatch | the trades — plants read the season; poaching goes on the wire |
| 26 | `lxr-admin`, `lxr-census`, `lxr-warden`, `lxr-frontier` | core, doctor, weather, interact | staff and the small things — after everything they reach into |
| 27 | `lxr-love`, `lxr-storage`, `lxr-market`, `lxr-craft`, `lxr-post`, `lxr-safe`, `lxr-camp` | core, nui, inventory, interact | paired interactions; rented lock-ups; the second-hand stalls; the craft book; the mail; the iron safe; the camp |
| 28 | `[lxr]`, `[standalone]` | core | consumers — see the workspace `docs/CHAIN.md` for the tiers |

## Rules

* **Providers before consumers.** Anything that *shows* an interface comes after
  `lxr-nui`; anything that *changes a look* comes after `lxr-clothing`;
  anything that *gives an item* comes after `lxr-inventory`.
* **Runtime probes, never boot-time assumptions.** Optional integrations
  (`lxr-mapcolor`, `ox_lib`) are checked with `GetResourceState` when used.
* **One hand-off chain for a new player:** `lxr-creator` (select → identity →
  traits → appearance → create → where the story starts) → world. No other
  resource may open UI during that chain.
* **Migrations run in core's order** — a resource registers its migration with
  `LXRCore.DB.RegisterMigration(resource, id, sql)` at start and core applies
  it before the resource's first query.
