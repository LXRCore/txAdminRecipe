#!/usr/bin/env python3
"""
🐺 LXRCore — txAdmin recipe validator

Checks lxrcore.yaml, server.cfg and lxrcore.sql for the mistakes that break a
clean deployment *before* anyone runs txAdmin:

  * YAML parses; every task has a known action with the fields it needs
  * download destinations are unique and live under ./resources or ./tmp
  * move_path / remove_path sources point at something a previous task created
  * every `ensure <name>` in server.cfg resolves to a downloaded resource folder,
    a category folder, a cfx-default resource or a bridge that the recipe moved
  * server.cfg contains only cfg syntax (no Markdown, no '---')
  * SQL contains only idempotent CREATE TABLE IF NOT EXISTS statements
  * --online: every GitHub repository/ref actually exists (uses `gh api`)

Usage:  python tools/validate_recipe.py [--online]
Exit code 1 on any error.  © 2026 iBoss21 / LXRCore
"""
import os
import re
import subprocess
import sys

try:
    import yaml
except ImportError:  # pragma: no cover
    print("PyYAML missing: pip install pyyaml")
    sys.exit(2)

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RECIPE = os.path.join(ROOT, "lxrcore.yaml")
CFG = os.path.join(ROOT, "server.cfg")
SQL = os.path.join(ROOT, "lxrcore.sql")

CFX_DEFAULTS = {"mapmanager", "chat", "spawnmanager", "sessionmanager", "sessionmanager-rdr3", "basic-gamemode", "hardcap",
                "rconlog", "baseevents", "webpack", "yarn", "monitor"}
ACTIONS = {
    "download_github": {"src", "dest"},
    "download_file": {"url", "path"},
    "unzip": {"src", "dest"},
    "move_path": {"src", "dest"},
    "copy_path": {"src", "dest"},
    "remove_path": {"path"},
    "connect_database": set(),
    "query_database": {"file"},
    "waste_time": {"seconds"},
    "ensure_dir": {"path"},
    "write_file": {"file", "data"},
    "replace_string": {"file"},
    "load_vars": {"src"},
    "dump_vars": {"file"},
}

errors, warnings = [], []
RESOURCE_TASKS = {}


def dest_is_resource(i):
    return RESOURCE_TASKS.get(i, False)


def err(msg):
    errors.append(msg)


def warn(msg):
    warnings.append(msg)


def load_recipe():
    with open(RECIPE, encoding="utf-8") as fh:
        data = yaml.safe_load(fh)
    for key in ("$engine", "name", "version", "author", "description", "tasks"):
        if key not in data:
            err(f"recipe missing top-level key {key}")
    if data.get("$engine") != 3:
        err("recipe $engine must be 3")
    if str(data.get("$onesync", "")).lower() not in ("on", "true", "legacy", "off"):
        warn("recipe $onesync should be 'on' for LXRCore (state bags / routing buckets)")
    return data


def validate_tasks(tasks):
    created = set()      # paths created by tasks
    dests = {}
    repos = []
    for i, task in enumerate(tasks, 1):
        action = task.get("action")
        if action not in ACTIONS:
            err(f"task {i}: unknown action {action!r}")
            continue
        missing = ACTIONS[action] - set(task)
        if missing:
            err(f"task {i} ({action}): missing fields {sorted(missing)}")
            continue
        if action == "download_github":
            dest = task["dest"]
            src = task["src"]
            if not src.startswith("https://github.com/"):
                err(f"task {i}: src must be a github.com URL ({src})")
            if dest in dests:
                err(f"task {i}: duplicate dest {dest} (also task {dests[dest]})")
            dests[dest] = i
            if not (dest.startswith("./resources/") or dest.startswith("./tmp/")):
                err(f"task {i}: dest {dest} must be under ./resources or ./tmp")
            created.add(dest.rstrip("/"))
            repos.append((i, src, task.get("ref", "main"), task.get("subpath")))
            RESOURCE_TASKS[i] = dest.startswith("./resources/") and not task.get("subpath")
        elif action == "download_file":
            created.add(task["path"])
        elif action == "unzip":
            if task["src"] not in created:
                err(f"task {i}: unzip src {task['src']} was not downloaded earlier")
            created.add(task["dest"].rstrip("/"))
        elif action in ("move_path", "copy_path"):
            src = task["src"]
            if not any(src == c or src.startswith(c + "/") for c in created):
                err(f"task {i}: {action} src {src} is not inside anything created earlier")
            created.add(task["dest"].rstrip("/"))
        elif action == "remove_path":
            path = task["path"]
            if not any(path == c or path.startswith(c + "/") or c.startswith(path + "/") for c in created):
                err(f"task {i}: remove_path {path} does not point at a created path")
        elif action == "query_database":
            f = task["file"]
            if not any(f.startswith(c + "/") for c in created):
                err(f"task {i}: query_database file {f} was not downloaded earlier")
            local = os.path.join(ROOT, os.path.basename(f))
            if not os.path.exists(local):
                err(f"task {i}: {os.path.basename(f)} does not exist in this repository")
    return created, repos


def resource_names(created):
    names = set()
    categories = set()
    for path in created:
        if path.startswith("./resources/"):
            parts = path[len("./resources/"):].split("/")
            if parts[0].startswith("[") and parts[0].endswith("]"):
                categories.add(parts[0])
                if len(parts) > 1:
                    names.add(parts[-1])
            else:
                names.add(parts[-1])
    return names, categories


def validate_cfg(names, categories):
    with open(CFG, encoding="utf-8") as fh:
        lines = fh.read().splitlines()
    ensures = []
    for n, raw in enumerate(lines, 1):
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        if line.startswith("---") or line.startswith("**") or line.startswith("```"):
            err(f"server.cfg:{n}: Markdown / separator in cfg file: {line[:40]}")
            continue
        m = re.match(r"^(ensure|start)\s+(\S+)", line)
        if m:
            ensures.append((n, m.group(2)))
            continue
        if not re.match(r"^(set|sets|setr|sv_\w+|net_\w+|increase_pool_size|rcon_password|add_ace|add_principal|remove_principal|exec|load_server_icon|endpoint_add_\w+|\{\{\w+\}\})", line):
            err(f"server.cfg:{n}: unrecognised directive: {line[:60]}")
    # pool sizes: never above the GSS ceiling (tools/pool-limits-redm.json is a cached copy of
    # https://gss.cfx-services.net/v1/public/pool-size-limits/redm)
    try:
        import json
        caps = json.load(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "pool-limits-redm.json"), encoding="utf-8"))
        for n, raw in enumerate(lines, 1):
            m = re.match(r'^increase_pool_size\s+"(\w+)"\s+(\d+)', raw.strip())
            if not m: continue
            cap = caps.get(m.group(1))
            if cap is None: err(f"server.cfg:{n}: pool {m.group(1)} is not in the GSS list")
            elif int(m.group(2)) > int(cap): err(f"server.cfg:{n}: pool {m.group(1)} {m.group(2)} above the GSS ceiling {cap}")
    except FileNotFoundError:
        pass
    for n, target in ensures:
        if target in names or target in categories or target in CFX_DEFAULTS or target == "oxmysql":
            continue
        err(f"server.cfg:{n}: ensure {target} — nothing in the recipe creates that resource")
    if not any(t == "lxr-core" for _, t in ensures):
        err("server.cfg never ensures lxr-core")
    order = [t for _, t in ensures]
    if "oxmysql" in order and "lxr-core" in order and order.index("oxmysql") > order.index("lxr-core"):
        err("server.cfg: oxmysql must be ensured before lxr-core")
    if "{{addPrincipalsMaster}}" not in "\n".join(lines):
        warn("server.cfg has no {{addPrincipalsMaster}} placeholder — txAdmin master will not get permissions")


def validate_sql():
    with open(SQL, encoding="utf-8") as fh:
        sql = fh.read()
    body = re.sub(r"--[^\n]*", "", sql)
    statements = [s.strip() for s in body.split(";") if s.strip()]
    for s in statements:
        if not s.upper().startswith("CREATE TABLE IF NOT EXISTS"):
            err(f"lxrcore.sql: non-idempotent statement: {s[:50]!r}")
    if "CREATE TABLE IF NOT EXISTS `players`" not in sql:
        err("lxrcore.sql: players table missing")
    if "lxr_ledger" not in sql:
        warn("lxrcore.sql: lxr_ledger missing (core will create it at boot)")


def check_online(repos):
    for i, src, ref, subpath in repos:
        repo = src.replace("https://github.com/", "").rstrip("/")
        try:
            # commits/{ref} resolves a branch, a tag or a pinned SHA; branches/{ref} only a branch
            out = subprocess.run(["gh", "api", f"repos/{repo}/commits/{ref}", "--jq", ".sha"],
                                 capture_output=True, text=True, timeout=30)
        except FileNotFoundError:
            err("--online needs the GitHub CLI (gh) on PATH")
            return
        if out.returncode != 0:
            err(f"task {i}: {repo}@{ref} not reachable: {out.stderr.strip()[:80]}")
        elif dest_is_resource(i):
            chk = subprocess.run(["gh", "api", f"repos/{repo}/contents/fxmanifest.lua?ref={ref}", "--jq", ".name"],
                                 capture_output=True, text=True, timeout=30)
            if chk.returncode != 0:
                err(f"task {i}: {repo}@{ref} has no fxmanifest.lua at its root — FXServer cannot start it")
        elif subpath:
            chk = subprocess.run(["gh", "api", f"repos/{repo}/contents/{subpath}?ref={ref}", "--jq", "length"],
                                 capture_output=True, text=True, timeout=30)
            if chk.returncode != 0:
                err(f"task {i}: {repo}@{ref} has no {subpath}/")


def main():
    data = load_recipe()
    created, repos = validate_tasks(data.get("tasks", []))
    names, categories = resource_names(created)
    validate_cfg(names, categories)
    validate_sql()
    if "--online" in sys.argv:
        check_online(repos)
    for w in warnings:
        print(f"WARN  {w}")
    for e in errors:
        print(f"ERROR {e}")
    print(f"{len(data.get('tasks', []))} tasks, {len(names)} resources, {len(errors)} errors, {len(warnings)} warnings")
    sys.exit(1 if errors else 0)


if __name__ == "__main__":
    main()
