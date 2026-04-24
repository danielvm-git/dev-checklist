# dev-checklist

**Agentic stack checks for your repo** — a `stack-check` script that prints **VERDICT**, **OK/WARN/FAIL**, and **Remediate** (doc + example command). Best experience in **Claude Code** as a **plugin** so `stack-check` is on the Bash tool `PATH`.

[![GitHub](https://img.shields.io/badge/github-danielvm--git%2Fdev--checklist-blue?logo=github)](https://github.com/danielvm-git/dev-checklist)

---

## Install for Claude Code (recommended)

1. **Add this repo as a plugin marketplace** (GitHub: `danielvm-git/dev-checklist`):

   ```text
   /plugin marketplace add danielvm-git/dev-checklist
   ```

2. **Install the plugin** (catalog id `dev-checklist-catalog`):

   ```text
   /plugin install dev-checklist@dev-checklist-catalog
   ```

3. **Reload:** `/reload-plugins`

4. In your **app** project root, in the **Bash** / terminal tool, run:

   ```bash
   stack-check
   ```

Full detail, scopes (`--scope project`), and RTK: **[docs/claude-code.md](docs/claude-code.md)**.

**What gets installed:** the plugin adds [`bin/stack-check`](bin/stack-check) to the Bash `PATH` ([Claude Code `bin/` behavior](https://code.claude.com/docs/en/plugins-reference#file-locations-reference)). The real script and [`readiness-checklist.md`](readiness-checklist.md) live in the same repo.

**Cursor, VS Code, Google Antigravity, etc.** — no Claude Code plugin. **Install from GitHub** (clone + `PATH`):

```bash
curl -fsSL https://raw.githubusercontent.com/danielvm-git/dev-checklist/main/install.sh | bash
```

Details, review-before-run, and Antigravity terminal allow list: **[docs/cursor-and-antigravity.md](docs/cursor-and-antigravity.md)**. Optional: [RTK](https://github.com/rtk-ai/rtk) flags `--agent cursor` / `--agent antigravity`.

---

## Without `install.sh` (manual Git)

From **your application repo** with a one-off clone path:

```bash
git clone https://github.com/danielvm-git/dev-checklist.git
cd /path/to/your/application
../dev-checklist/stack-check
```

**Single file only:**  
`https://raw.githubusercontent.com/danielvm-git/dev-checklist/main/stack-check` — save, `chmod +x`. Best with a full clone or copy [`readiness-checklist.md`](readiness-checklist.md) next to the script.

---

## Environment

| Variable | Meaning |
|----------|---------|
| `STACK_CHECK_STRICT=1` | Treat advisory **WARN** as failure (exit 1). |
| `STACK_CHECK_NO_REMEDIATION=1` | Hide **Remediate** blocks. |
| `STACK_CHECK_DEGRADED_EXIT=1` | Exit **2** on degraded (warnings, no hard fail on required checks). |

## Exit codes

- **0** — `ready` or `degraded` (advisory warnings only, by default).
- **1** — `not_ready` or `STRICT` with a warning.
- **2** — only with `STACK_CHECK_DEGRADED_EXIT=1` when result is **degraded**.

## Phase rules (optional)

Copy [`.stack-check.yaml.example`](.stack-check.yaml.example) to **your app** as `.stack-check.yaml` and set `require_layer4_rtk`, etc.

## Repo layout (for contributors)

| Path | Role |
|------|------|
| [`stack-check`](stack-check) | Main verifier. |
| [`bin/stack-check`](bin/stack-check) | Wrapper for the Claude Code plugin; calls repo-root `stack-check`. |
| [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json) | Plugin manifest. |
| [`.claude-plugin/marketplace.json`](.claude-plugin/marketplace.json) | Marketplace catalog (install via `@dev-checklist-catalog`). |
| [readiness-checklist.md](readiness-checklist.md) | Full five layers + spec-to-code gap (manual). |
| [session-start.md](session-start.md) | Short daily session boot. |
| [docs/cursor-and-antigravity.md](docs/cursor-and-antigravity.md) | **Cursor + Antigravity: install from GitHub** via [`install.sh`](install.sh). |
| [install.sh](install.sh) | Clone/update repo + add `~/.local/share/dev-checklist` to `PATH` (zsh/bash). |
| [verify-readiness.sh](verify-readiness.sh) | Legacy; runs `stack-check`. |

**Background:** [The Agentic Coding Stack (Dev Genius)](https://blog.devgenius.io/the-agentic-coding-stack-7-tools-5-layers-and-the-missing-link-nobody-has-built-yet-de264b260db3)

## Troubleshooting

- **Remediate** lines point to install docs; the script does not run installers.
- **Limitations:** filesystem / `PATH` only — no proof of Ctxo index or gsd-2 worktrees; see [readiness-checklist.md](readiness-checklist.md).

## README style

Aim: clear “install + use” for newcomers ([kickass README](https://meakaakka.medium.com/a-beginners-guide-to-writing-a-kickass-readme-7ac01da88ab3), [Readme Driven Development](http://tom.preston-werner.com/2010/08/23/readme-driven-development.html)).
