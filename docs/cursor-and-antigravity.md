# Cursor and Google Antigravity

`stack-check` is a **bash** script. **Claude Code** is the only environment this repo ships a **native plugin** for (see [claude-code.md](claude-code.md)). **Cursor** and **Google Antigravity** do not load that plugin format—use the **integrated terminal** (or your normal shell) and either **put the script on `PATH`** or call it with a **full path**.

Repository: [danielvm-git/dev-checklist](https://github.com/danielvm-git/dev-checklist)

## Cursor

1. **Install the tool** (clone recommended so `readiness-checklist.md` sits next to `stack-check`):

   ```bash
   git clone https://github.com/danielvm-git/dev-checklist.git
   ```

2. **Run it from your app repo** in Cursor’s **Terminal** (`` Ctrl+` `` / View → Terminal):

   ```bash
   cd /path/to/your/application
   /path/to/dev-checklist/stack-check
   ```

3. **Optional — `stack-check` without a full path** — add the clone directory or a `bin` symlink to your shell `PATH` in `~/.zshrc` / `~/.bashrc` (same idea as [README.md](../README.md#without-the-plugin-plain-git)).

4. **Layer 2 / rules** — Cursor expects project rules (e.g. [`.cursorrules`](https://docs.cursor.com/context/rules-for-ai) or `AGENTS.md`). `stack-check` already looks for `.cursorrules`, `instructions.md`, `.clinerules`, or `AGENTS.md` at the repo root.

5. **Optional — RTK (token compression for shell output)** — if you use [RTK](https://github.com/rtk-ai/rtk), the project supports Cursor hooks, e.g.:

   ```bash
   rtk init -g --agent cursor
   ```

   Then restart Cursor. This is independent of `stack-check`; it only affects how noisy shell output is.

## Google Antigravity

Antigravity is an **agent-first IDE** (VS Code–based) with its own **terminal execution** and **allow/deny lists**. There is no Claude Code–style plugin install for `stack-check` here—treat it like **plain shell + path**.

1. **Clone** this repo (or download `stack-check` + keep `readiness-checklist.md` beside it).

2. In the **integrated terminal**, from your **application** workspace root:

   ```bash
   /path/to/dev-checklist/stack-check
   ```

3. **If the agent must run `stack-check` without approval** — add the exact command (or a stable path) to **Terminal allow list** in Antigravity settings (see [Google’s Antigravity getting started](https://codelabs.developers.google.com/getting-started-google-antigravity) — terminal policy / allow list). If you use “Request review” for all commands, approve the first run or pre-allow `stack-check`.

4. **Shared rules** — Antigravity reads **[AGENTS.md](https://agents.md)** at the project root (same portable file many tools use). Putting `AGENTS.md` in your app satisfies the “agent rules” signal in `stack-check` alongside Cursor-style files.

5. **Optional — RTK** — if you use RTK, their matrix includes Antigravity, e.g.:

   ```bash
   rtk init --agent antigravity
   ```

   (Exact flags follow the [rtk-ai/rtk](https://github.com/rtk-ai/rtk) README; update if the CLI changes.)

## Summary

| Environment | How `stack-check` is meant to run |
|---------------|----------------------------------|
| **Claude Code** | Install [plugin + marketplace](claude-code.md) → `stack-check` on Bash `PATH` |
| **Cursor** | Terminal → full path or `PATH`; optional RTK `--agent cursor` |
| **Antigravity** | Terminal → full path or `PATH`; configure terminal allow list if needed; optional RTK `--agent antigravity` |
| **Any other terminal** | [README.md](../README.md#without-the-plugin-plain-git) |

`stack-check` only inspects the **current directory’s** files (and tools on `PATH` like `rtk`). It does not integrate with a vendor-specific “plugin” API on Cursor or Antigravity beyond that.
