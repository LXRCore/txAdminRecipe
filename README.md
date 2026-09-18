<!--
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗ ██████╗ ███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██╔═══██╗██╔══██╗██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██████╔╝█████╗
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██╔══██╗██╔══╝
    ███████╗██╔╝ ██╗██║  ██║      ╚██████╗╚██████╔╝██║  ██║███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝

    LXRCore txAdmin Recipe — clean RedM server → LXRCore v3
    Developer: iBoss21 / LXRCore · https://www.lxrcore.com
    © 2026 iBoss21 / LXRCore | lxrcore.com | All Rights Reserved
-->

<img src="https://raw.githubusercontent.com/LXRCore/.github/main/profile/lxrcore-logo.png" alt="LXRCore" width="72" align="left" style="margin-right:12px">

# LXRCore txAdmin Recipe (v3)

![Recipe](https://img.shields.io/badge/recipe-3.0.0-c21c37)
![Engine](https://img.shields.io/badge/txAdmin_engine-3-1a1512)
![Validated](https://img.shields.io/badge/validator-54_tasks_%C2%B7_0_errors-brightgreen)
![Platform](https://img.shields.io/badge/platform-RedM-100e0c)

Deploys a complete LXRCore v3 server from an empty txAdmin profile:
framework core, compatibility bridges, standalone dependencies, official LXR
resources, database schema and a working `server.cfg`.

## Use it

1. txAdmin → **Setup** → *Remote URL Template*
2. Paste `https://raw.githubusercontent.com/LXRCore/txAdminRecipe/main/lxrcore.yaml`
3. Fill in the database and licence key prompts; deploy.
4. Start the server. The console prints the LXRCore banner and `ready in <n>ms`.

Requirements: FXServer build 7290+, MariaDB 10.6+ / MySQL 8, OneSync **on**
(the recipe sets it).

## What the recipe does

| Step | Result |
|---|---|
| Base files | `server.cfg`, `myLogo.png` |
| Database | `lxrcore.sql` = lxr-core schema (`players`, `bans`, `lxr_ledger`, `lxr_migrations`) + tables owned by the official resources |
| Cfx defaults | `resources/[cfx-default]` from `citizenfx/cfx-server-data@master` |
| Standalone | `oxmysql` (CommunityOx release), `pma-voice`, `connectqueue`, `progressbar`, `PolyZone`, `menuv`, `mediccamp`, `safecracker` |
| Framework | `resources/[framework]/lxr-core` |
| Bridges | `resources/[lxr-bridges]/{rsg-core, vorp_core, qbr-core, vorp_inventory}` — moved out of `lxr-core/bridges`, **not ensured by default** |
| Official resources | `resources/[lxr]/…` (31 resources) |

`server.cfg` ensures the boot order explicitly (`oxmysql → lxr-core → lxr-nui →
lxr-mapcolor → lxr-inventory → lxr-clothing → lxr-creator → lxr-barber →
lxr-spawn → lxr-me → lxr-horses → lxr-trains → lxr-hud`) and then the
categories; every manifest declares the same dependencies, so the order holds
even when lines move. The reasoning is in [docs/BOOT-ORDER.md](docs/BOOT-ORDER.md). Permission groups
are `lxrcore.<group>`; the txAdmin master account inherits `lxrcore.god`.

## Running RSG / VORP / QBR resources on this server

Uncomment the bridge you need in `server.cfg` **only if the real resource is
not installed**:

```cfg
#ensure rsg-core
#ensure vorp_core
#ensure qbr-core
#ensure vorp_inventory
```
What each bridge supports (and what it deliberately does not) is documented in
[`lxr-core/docs/compatibility.md`](https://github.com/LXRCore/lxr-core/blob/main/docs/compatibility.md).

## Validate before you deploy

```bash
pip install pyyaml
python tools/validate_recipe.py            # structure, ensure/dest consistency, cfg syntax, SQL idempotency
python tools/validate_recipe.py --online   # + every GitHub repo/ref exists (needs `gh`)
```
CI runs both on every push. The validator is what caught the two defects in
the previous recipe: Markdown text inside `server.cfg` and a wrong branch
name for `cfx-server-data`.

## Status

| Check | Result |
|---|---|
| YAML structure, task fields, unique destinations | ✅ validator |
| every `ensure` maps to a downloaded resource | ✅ validator |
| all 41 GitHub sources reachable at the pinned ref | ✅ validator `--online` (2026-09-17) |
| SQL idempotent | ✅ validator |
| full txAdmin deployment on a clean machine | **NOT TESTED** yet — requires a live FXServer + database |
| official resources audited against lxr-core v3 | in progress (core serves their legacy API; see the org README) |

Note: `lxr-core` is downloaded from `main`. Until the v3 rewrite is merged
there, deploy from a fork or change `ref:` to the release tag you want.

## Support

| | |
|---|---|
| 🌐 Website | [lxrcore.com](https://www.lxrcore.com) |
| 🛠 Dev Discord | [discord.gg/ZHMKVYyhBa](https://discord.gg/ZHMKVYyhBa) |
| Community | [discord.gg/wolvesland](https://discord.gg/wolvesland) |

> © 2026 iBoss21 / LXRCore | [lxrcore.com](https://www.lxrcore.com) | All Rights Reserved
