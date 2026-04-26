# Terminals, IDEs, and CLIs — one install

**`stack-check` is a shell script.** The same install works for any product that can run a normal shell with your `PATH` (integrated terminal, Cursor Agent CLI, Gemini CLI, etc.). You do **not** need a separate installer per tool.

If you want a strict end-to-end setup sequence (spec-kit, superpowers, RTK, Ctxo, context-mode, dev-checklist) aligned to what `stack-check` detects, use:

```bash
bash install-stack.sh --mode greenfield --target /path/to/app --env all --strict --yes
```

Run from this repository root, then execute step 9 in your target app repo.

Project-level MCP guarantee modes:

```bash
# all
bash install-stack.sh --mode existing --target ./ --env all --strict --yes

# claude only
bash install-stack.sh --mode existing --target ./ --env claude --strict --yes

# gemini + antigravity only
bash install-stack.sh --mode existing --target ./ --env gemini --strict --yes

# cursor only
bash install-stack.sh --mode existing --target ./ --env cursor --strict --yes
```

These modes guarantee core MCP entries (`ctxo`, `context-mode`) in project-level config files only.

## Option 1 — Any terminal (recommended for everyone)

Use the same [install.sh](https://github.com/danielvm-git/dev-checklist/blob/main/install.sh) everywhere:

```bash
curl -fsSL https://raw.githubusercontent.com/danielvm-git/dev-checklist/main/install.sh | bash
```

Or clone the repo and run `./install.sh`.

- **Install location:** `~/.local/share/dev-checklist` (override with `DEV_CHECKLIST_HOME`).
- **What it does:** clones or `git pull` updates that directory, appends `export PATH="…/dev-checklist:$PATH"` to `.zshrc` / `.bashrc` if not already present.
- **Open a new terminal** (or `source ~/.zshrc`), `cd` to your **application** repo, run `stack-check`.

## Option 2 — Claude Code only (no shell `PATH` edit)

If you use **Claude Code**, you can install the [plugin](claude-code.md) so `stack-check` is on the Bash tool `PATH` without changing your rc files. Same script and checklist; [bin/stack-check](https://github.com/danielvm-git/dev-checklist/blob/main/bin/stack-check) wraps the repo root `stack-check`.

## Update from bash

- **Re-run the same one-liner** (recommended): the script detects an existing clone and runs `git pull --ff-only`. Your install stays current.
- **Or** (from a machine that already has the clone):

  ```bash
  bash "$HOME/.local/share/dev-checklist/install.sh" --update-only
  ```

  (`--update-only` skips appending to `.zshrc` / `.bashrc`; it only updates the repository.)  
  If your copy lives elsewhere, set `DEV_CHECKLIST_HOME` to that path.

## Per-tool notes (same `PATH` story; different policies)

| Product | What to do after install |
|--------|-------------------------|
| **Cursor (editor)** | Open **Terminal** in the app (`Ctrl+`` `), `cd` to your app repo, run `stack-check`. Ensure the terminal **inherits** your shell `PATH` (e.g. login shell, or the same `~/.zshrc` you use outside Cursor). [Cursor rules (Layer 2)](https://docs.cursor.com/context/rules-for-ai) are separate from installing the script. |
| **Cursor Agent CLI** | Install the [Cursor CLI](https://www.cursor.com/docs/cli/installation) (`agent` in `~/.local/bin` by default). Add dev-checklist to the **same** `PATH` in `~/.zshrc` or `~/.bashrc` (same block as [install.sh](https://raw.githubusercontent.com/danielvm-git/dev-checklist/main/install.sh) appends). `agent update` updates **Cursor Agent**, not dev-checklist — re-run the dev-checklist one-liner to update this repo. Approve or allow **`stack-check`** in the CLI if sandbox or command policy blocks it. |
| **Google Antigravity** | Same install; run `stack-check` in the **integrated terminal** with `cd` to your app. If commands are blocked, add **`stack-check`** to the [terminal allow list](https://codelabs.developers.google.com/getting-started-google-antigravity) (or use the full path, e.g. `~/.local/share/dev-checklist/stack-check`). |
| **Gemini CLI** | Same [install.sh](https://raw.githubusercontent.com/danielvm-git/dev-checklist/main/install.sh); run `stack-check` in the environment where `PATH` includes the clone. [Gemini CLI extensions](https://geminicli.com/docs/extensions/) are **optional** for discoverability — they are not required for `stack-check` to work. |
| **VS Code / other editors** | Same: integrated terminal, app repo root, `stack-check` on `PATH`. |

## Uninstall

Remove the `PATH` block marked `dev-checklist` from your shell rc file, then:

```bash
rm -rf "$HOME/.local/share/dev-checklist"
```

(or your `DEV_CHECKLIST_HOME` path).

## See also

- [Cursor and Google Antigravity (detailed)](cursor-and-antigravity.md) — review-before-run, Antigravity allow list
- [Claude Code (plugin path)](claude-code.md)
- [README](../README.md) — quick links and environment variables for `stack-check`
