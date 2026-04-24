# dev-checklist

**Verify your agentic stack in any repo.** A small `stack-check` script (bash) you run from your **application project** after opening Cursor, Claude Code, or any terminal. It reports layer-by-layer **OK / WARN / FAIL** and **Remediate** lines with doc links and example commands (nothing is installed for you).

[![GitHub](https://img.shields.io/badge/github-danielvm--git%2Fdev--checklist-blue?logo=github)](https://github.com/danielvm-git/dev-checklist)

---

## What you need

- **Git** and **bash** (macOS / Linux).
- Your **own repo** to check (the one you are building—not only this tool repo).

---

## Install (get this project)

**Option A — clone (recommended)** — you get `stack-check`, [readiness-checklist.md](readiness-checklist.md), and the rest of the docs.

```bash
git clone https://github.com/danielvm-git/dev-checklist.git
cd dev-checklist
chmod +x stack-check verify-readiness.sh
```

**Option B — download only the script** from the `main` branch:

- URL: `https://raw.githubusercontent.com/danielvm-git/dev-checklist/main/stack-check`  
- Save as `stack-check`, then: `chmod +x stack-check`  
- For full **Remediate** + checklist behavior, use a full clone (the script looks for `readiness-checklist.md` next to it).

**Optional — add to your PATH** (zsh example; adjust the path to your clone):

```bash
echo 'export PATH="$HOME/Projects/dev-checklist:$PATH"' >> ~/.zshrc
# or:   ln -s /full/path/to/dev-checklist/stack-check ~/.local/bin/stack-check
```

---

## How to use (in your app repo)

This is the **main** workflow: run the checker from the **root of the project you are developing** (not necessarily inside `dev-checklist` itself).

1. **Open a terminal** (Claude Code terminal, Cursor, iTerm, etc.).
2. **Go to your application repository:**
   ```bash
   cd /path/to/your/application
   ```
3. **Run `stack-check` by full path** (replace with your clone path):
   ```bash
   /path/to/dev-checklist/stack-check
   ```
4. **Read the output:**
   - **`VERDICT: ready`** — required checks passed (warnings may still appear).
   - **`VERDICT: degraded`** — no required failure; optional tools (e.g. RTK) may be missing.
   - **`VERDICT: not_ready`** — fix **FAIL** lines or follow **Remediate** blocks (link + example command under each problem).
5. **Optional — stricter “phase”** — in your *app* repo, copy [`.stack-check.yaml.example`](.stack-check.yaml.example) to `.stack-check.yaml` and set e.g. `require_layer4_rtk: true` if that phase must enforce RTK.

**Quick self-test in this clone:**

```bash
cd dev-checklist
./stack-check
```

**Claude Code users:** see **[docs/claude-code.md](docs/claude-code.md)** for the same flow in the Claude Code UI, plus optional [RTK](https://github.com/rtk-ai/rtk) (`rtk init -g`).

---

## Environment variables

| Variable | Meaning |
|----------|---------|
| `STACK_CHECK_STRICT=1` | Treat advisory **WARN** lines as failure (exit 1). |
| `STACK_CHECK_NO_REMEDIATION=1` | Omit **Remediate** blocks (e.g. noisy CI). |
| `STACK_CHECK_DEGRADED_EXIT=1` | Exit **2** when there are warnings but no required-check failure. |

## Exit codes

- **0** — `ready` (all required checks pass) or `degraded` (only advisory warnings; default).
- **1** — `not_ready` (a required check failed, or `STRICT` and a warning fired).
- **2** — only if `STACK_CHECK_DEGRADED_EXIT=1` and the run is degraded (warnings, no required failure).

---

## What’s in this repo

| Item | Purpose |
|------|--------|
| [`stack-check`](stack-check) | Main verifier: verdict, exit code, Remediate lines. |
| [`verify-readiness.sh`](verify-readiness.sh) | Legacy; calls `stack-check`. |
| [readiness-checklist.md](readiness-checklist.md) | Full 5 layers + spec-to-code “missing link” (manual). |
| [session-start.md](session-start.md) | Short daily session boot. |
| [docs/claude-code.md](docs/claude-code.md) | Install + use from **Claude Code** + GitHub. |

**Background:** [The Agentic Coding Stack (Dev Genius)](https://blog.devgenius.io/the-agentic-coding-stack-7-tools-5-layers-and-the-missing-link-nobody-has-built-yet-de264b260db3)

---

## Troubleshooting

Failures print **Remediate** lines (doc link + example command). The tool does **not** run installers for you.

- **specs/** — [github/spec-kit](https://github.com/github/spec-kit) or BMAD: `npx bmad-method install`.
- **RTK** — [rtk-ai/rtk](https://github.com/rtk-ai/rtk) (`brew install rtk` or their install script).
- **Cursor rules** — [Cursor rules for AI](https://docs.cursor.com/context/rules-for-ai) or [AGENTS.md](https://agents.md).
- **Ctxo / semantic tools** — configure MCP in your IDE; see the script’s **MANUAL** line and [readiness-checklist.md](readiness-checklist.md).

## Limitations (by design)

`stack-check` only inspects the filesystem and `PATH`. It cannot prove Ctxo index freshness, that the agent uses context-mode, or gsd-2 worktree policy—use [readiness-checklist.md](readiness-checklist.md) for that.

---

## README style

Clear install + usage for newcomers follows ideas from [A beginner’s guide to writing a kickass README](https://meakaakka.medium.com/a-beginners-guide-to-writing-a-kickass-readme-7ac01da88ab3) and [Readme Driven Development](http://tom.preston-werner.com/2010/08/23/readme-driven-development.html).
