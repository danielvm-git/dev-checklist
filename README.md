# dev-checklist

[![GitHub](https://img.shields.io/badge/github-danielvm--git%2Fdev--checklist-blue?logo=github)](https://github.com/danielvm-git/dev-checklist)

Post-CLI checks for the **agentic coding stack** (five layers, spec-to-code gap). Run from your **application repo root** after opening Cursor, Claude Code, Gemini CLI, or any terminal.

## Claude Code (install from GitHub)

See **[docs/claude-code.md](docs/claude-code.md)** for cloning or downloading this repo from GitHub, using the **Claude Code terminal** in an app project, optional [RTK](https://github.com/rtk-ai/rtk) for Claude Code (`rtk init -g`), and [`.stack-check.yaml.example`](.stack-check.yaml.example) for phase requirements.

**Post-clone one-liner** (from a clone of this repo):

```bash
chmod +x stack-check && ./stack-check
```

## Quick start

```bash
cd /path/to/your/repo
/path/to/dev-checklist/stack-check
```

Or copy or symlink `stack-check` onto your `PATH`, then:

```bash
stack-check
```

Copy [`.stack-check.yaml.example`](.stack-check.yaml.example) to `.stack-check.yaml` when a **phase** needs stricter requirements (e.g. require RTK or GSD).

### Environment

| Variable | Meaning |
|----------|---------|
| `STACK_CHECK_STRICT=1` | Treat advisory **WARN** lines as failure (exit 1). |
| `STACK_CHECK_NO_REMEDIATION=1` | Omit **Remediate** blocks (e.g. noisy CI logs). |
| `STACK_CHECK_DEGRADED_EXIT=1` | Exit **2** when there are warnings but no required-check failure. |

### Exit codes

- **0** — `ready` (all required checks pass) or `degraded` (only advisory warnings; default).
- **1** — `not_ready` (a required check failed, or `STRICT` and a warning fired).
- **2** — only if `STACK_CHECK_DEGRADED_EXIT=1` and the run is degraded (warnings, no required failure).

### Legacy entry point

[`verify-readiness.sh`](verify-readiness.sh) delegates to `stack-check` so older scripts keep working.

## What to read next

- [readiness-checklist.md](readiness-checklist.md) — full manual layers and the spec-to-code “missing link.”
- [session-start.md](session-start.md) — short daily boot (optional: run `stack-check` when you need stack confidence).
- Stack map: [The Agentic Coding Stack (Dev Genius)](https://blog.devgenius.io/the-agentic-coding-stack-7-tools-5-layers-and-the-missing-link-nobody-has-built-yet-de264b260db3)

## Troubleshooting

Failures print **Remediate** lines (doc link + example command). The script does **not** install anything for you.

- **specs/** — [github/spec-kit](https://github.com/github/spec-kit) or BMAD: `npx bmad-method install` (see BMAD-METHOD repo).
- **RTK** — [rtk-ai/rtk](https://github.com/rtk-ai/rtk): `brew install rtk` or the install script in the README.
- **Cursor rules** — [Cursor rules for AI](https://docs.cursor.com/context/rules-for-ai); or add [AGENTS.md](https://agents.md).
- **Ctxo / semantic tools** — confirm MCP + indexing in the IDE; see the manual line in the script and `readiness-checklist.md`.

## Limitations (by design)

`stack-check` only sees filesystem and `PATH` signals. It cannot prove Ctxo index freshness, that the agent uses context-mode, or gsd-2 worktree policy—use [readiness-checklist.md](readiness-checklist.md) for that.
