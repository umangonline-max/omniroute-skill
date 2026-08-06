# omniroute-skill

A single, framework-agnostic **agent skill** that gives any AI coding agent (Claude Code, Codex, OpenClaw, Hermes, OpenCode, Cursor, etc.) the ability to **integrate with and control an OmniRoute instance** on the user's behalf — inspect providers, models, keys, combos, quotas, usage, cost, compression, MCP tools, and safely modify the gateway when needed.

> [OmniRoute](https://omniroute.online) is a self-hosted AI gateway: one endpoint in front of ~290 providers with auto-fallback routing, combos, compression, quota/cost tracking, MCP/A2A servers, and per-agent CLI integrations.

## 🚀 Quick start — the one-liner

Paste this single line into any agent that supports skills (Claude Code, Codex, OpenClaw, Hermes, OpenCode, ...):

```
Install the omniroute skill: clone https://github.com/umangonline-max/omniroute-skill into /tmp/omniroute-skill, run its install.sh (install.ps1 on Windows), then read SKILL.md and use it to locate, inspect, and control my local OmniRoute gateway (default http://localhost:20128) — verify with `omniroute health` before changing anything.
```

That's it. The agent will:
1. Download the skill
2. Install it into the correct skills directory for that agent (via `install.sh`, which auto-detects Codex/Claude/Hermes/OpenClaw/OpenCode)
3. Read the skill and use it as a control plane for your gateway

## 📦 Manual install

```bash
git clone https://github.com/umangonline-max/omniroute-skill
cd omniroute-skill
./install.sh        # auto-detects installed agents and copies into all of them
```

**Windows (PowerShell):**
```powershell
git clone https://github.com/umangonline-max/omniroute-skill
cd omniroute-skill
powershell -ExecutionPolicy Bypass -File install.ps1
```

**Windows alternative:** WSL or Git Bash can also run `./install.sh`. Manual install works on any OS — just copy `SKILL.md` into the agent's skills dir.

Or per agent:

| Agent | Location |
|---|---|
| OpenCode | `~/.agents/skills/omniroute/` |
| Codex | `~/.codex/skills/omniroute/` |
| Claude Code | `~/.claude/skills/omniroute/` |
| Hermes | `~/.hermes/skills/omniroute/` |
| OpenClaw | `~/.openclaw/extensions/omniroute/` (extension format via install.sh) |

Install = copy `SKILL.md` (+ `DESCRIPTION.md` for Hermes) into the directory. Symlinks also work: `ln -s ~/.agents/skills/omniroute ~/.codex/skills/omniroute`.

## 🧠 What the skill teaches agents

- **Locate your instance** — detects server via `omniroute` CLI / default port / env overrides
- **Surface ranking** — CLI first, REST second, MCP third (uses whatever the agent has)
- **Full control recipes** (all verified against a live server):
  - Settings read/PATCH (with the whitelist + revision-concurrency caveats)
  - Compression pipeline configuration (strict enum schemas, known-good optimized config)
  - Provider/connection CRUD, live model discovery (`GET /api/providers/{id}/models?refresh=true`), connection testing
  - Gateway API keys (list/create/revoke/regenerate)
  - Combos + all 19 routing strategies, `auto/*` virtual combos
  - Resilience (breakers, cooldowns, lockouts, reset)
  - Cache, quota pools, usage analytics, budgets, cost reports
  - Dry-run routing simulation (`omniroute simulate --explain`)
- **Per-agent integration** — `omniroute setup-opencode|setup-codex|setup-claude|...` auto-generates each agent's config from the live model catalog; manual OpenAI-compatible base URL config as fallback
- **MCP integration** — streamable-http endpoint, session handshake protocol, and a cheat sheet of the 100+ MCP tools
- **Mandatory safety protocol** — read-before-write, no destructive deletes without confirmation, no secret reveals, spend awareness, prefer dry-runs
- **Troubleshooting table** — known gotchas (MCP session-id requirement, passthroughModels registry limits, settings PATCH whitelist, stdio-vs-http MCP 404s)

## 🔧 Requirements

- A running OmniRoute server (`omniroute serve`, default port 20128) — local or reachable
- The `omniroute` CLI on the same machine as the agent (or `OMNIROUTE_BASE_URL`/`OMNIROUTE_API_KEY` set)

## ⚠️ Safety

The skill is built to be safe by default: it reads before writing, verifies after changes, refuses to delete or rotate credentials without explicit user confirmation, and prefers dry-runs over live actions. Review the safety section of `SKILL.md` if you plan to expose agents to a shared/remote instance.

## 📄 License

MIT
