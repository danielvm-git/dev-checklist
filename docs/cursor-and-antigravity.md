# Cursor and Google Antigravity — install from GitHub

**Index:** For a single place that covers every terminal, IDE, and CLI (including **Cursor Agent CLI** and **Gemini CLI**), use **[terminals-and-clis.md](terminals-and-clis.md)**. This page focuses on **Cursor and Antigravity** plus review-and-run.

**Claude Code** can use the [native plugin](claude-code.md). **Cursor** and **Google Antigravity** do not support that plugin format, so the supported way to “install from GitHub” is the same for both: run the **install script** from this repository (clone + add `stack-check` to your shell `PATH`).

**Repo:** [github.com/danielvm-git/dev-checklist](https://github.com/danielvm-git/dev-checklist)

## 1) Install from GitHub (same command for Cursor and Antigravity)

**Option A — one-liner** (fetches [install.sh](https://raw.githubusercontent.com/danielvm-git/dev-checklist/main/install.sh) from `main`):

```bash
curl -fsSL https://raw.githubusercontent.com/danielvm-git/dev-checklist/main/install.sh | bash
```

Review the script first if you prefer not to pipe to `bash`:

```bash
curl -fsSL -o /tmp/dev-checklist-install.sh https://raw.githubusercontent.com/danielvm-git/dev-checklist/main/install.sh
less /tmp/dev-checklist-install.sh
bash /tmp/dev-checklist-install.sh
```

**Option B — clone, then run the script locally**

```bash
git clone https://github.com/danielvm-git/dev-checklist.git
cd dev-checklist
chmod +x install.sh
./install.sh
```

**What it does**

- Clones (or `git pull` updates) into **`~/.local/share/dev-checklist`** — override with `DEV_CHECKLIST_HOME=/other/path` if needed.
- Appends a small **`export PATH=…/dev-checklist:$PATH`** block to **`.zshrc`** and/or **`.bashrc`** (only if you don’t already have a `dev-checklist` line).
- Makes `stack-check` executable.
- **Open a new terminal** (or `source ~/.zshrc`) so `stack-check` is on `PATH`.

**Uninstall:** remove the two-line block marked `dev-checklist` from your rc file, then `rm -rf ~/.local/share/dev-checklist` (or your `DEV_CHECKLIST_HOME` path).

## 2) Use it in Cursor

1. After install, open **Terminal** in Cursor (`` Ctrl+` ``).
2. `cd` to your **application** repo (the one you are checking, not the install folder).
3. Run:

   ```bash
   stack-check
   ```

4. **Rules (Layer 2):** add [`.cursorrules`](https://docs.cursor.com/context/rules-for-ai), [`.cursor/rules/`](https://docs.cursor.com), or `AGENTS.md` in that app; `stack-check` looks for those at the repo root. It also looks for a **repo-local** [Superpowers](https://github.com/obra/superpowers) signal (e.g. `.cursor/skills/`, `skills/using-superpowers/`, or a root doc mentioning `obra/superpowers`); see the [Agentic Coding Stack](https://blog.devgenius.io/the-agentic-coding-stack-7-tools-5-layers-and-the-missing-link-nobody-has-built-yet-de264b260db3) for how Layer 2 fits the full stack.

5. **Optional — “Remote rules” from GitHub in Cursor** (editor rules, not the same as `stack-check`): *Cursor Settings → Rules → Add → Remote (GitHub)* can sync rule **files** from a repo. That does not install the `stack-check` binary; use **Option A/B** above for the tool itself.

6. **Optional — RTK** (shell output compression, separate from this repo):

   ```bash
   rtk init -g --agent cursor
   ```

   Then restart Cursor. See [rtk-ai/rtk](https://github.com/rtk-ai/rtk).

## 3) Use it in Google Antigravity

1. Run the same **install** steps as in section 1 (from Cursor’s terminal or any shell).
2. In Antigravity’s **integrated terminal**, `cd` to your **app** workspace and run `stack-check`.
3. If the agent is blocked on shell commands, add **`stack-check`** (or the full path `~/.local/share/dev-checklist/stack-check`) to the **Terminal allow list** in Antigravity settings — see [Google’s Antigravity codelab (terminal policy)](https://codelabs.developers.google.com/getting-started-google-antigravity).
4. **AGENTS.md** at the project root works across tools; it counts toward the “agent rules” check in `stack-check`.
5. **Optional — RTK** for Antigravity (see [rtk](https://github.com/rtk-ai/rtk) README for current flags), e.g. `rtk init --agent antigravity`.

## Summary

| Step | Cursor | Antigravity |
|------|--------|-------------|
| Install from GitHub | `install.sh` (curl or git clone) | same |
| Run checks | Terminal → `cd` app → `stack-check` | same |
| No Claude plugin | use this doc | use this doc |

**Claude Code** users: use the [Claude Code plugin](claude-code.md) instead if you want `stack-check` on the tool `PATH` without shell rc edits.

`stack-check` only reads your **current directory** and `PATH` (e.g. `rtk`). It is not a Cursor or Antigravity “extension package” in the store sense—installation is the GitHub script above plus a working terminal.
