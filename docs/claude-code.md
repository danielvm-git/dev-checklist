# Install and run under Claude Code

This repo is a **Claude Code plugin**: files in `bin/` are added to the **Bash tool `PATH`** while the plugin is enabled, so you can type `stack-check` in the integrated terminal (same behavior as the [plugin reference: `bin/`](https://code.claude.com/docs/en/plugins-reference#file-locations-reference)).

**Repository:** [https://github.com/danielvm-git/dev-checklist](https://github.com/danielvm-git/dev-checklist)

## 1. Add the marketplace (once)

In **Claude Code** (or your normal terminal with `claude` on `PATH`):

```bash
/plugin marketplace add danielvm-git/dev-checklist
```

Or CLI equivalent:

```bash
claude plugin marketplace add danielvm-git/dev-checklist
```

If the command is not found, update [Claude Code](https://code.claude.com/docs/en/discover-plugins#plugin-command-not-recognized) and try again.

## 2. Install the plugin (user or project scope)

**In the Claude Code slash palette:**

```text
/plugin install dev-checklist@dev-checklist-catalog
```

**Or CLI:**

```bash
claude plugin install dev-checklist@dev-checklist-catalog
```

- Use **`--scope project`** to pin it in the current app repo (`.claude/settings.json`, shared with the team) if you want everyone on that repo to have the check.
- Default **user** scope: available in all your projects.

## 3. Reload plugins

```text
/reload-plugins
```

## 4. Run `stack-check` in your *application* project

1. `cd` to the **root of the project you are building** (not the `dev-checklist` clone).
2. In the **Bash** tool / terminal, run:

```bash
stack-check
```

`stack-check` is on `PATH` only while the **dev-checklist** plugin is enabled. It validates that repo’s tree (`specs/`, rules, `README`, git, etc.) and prints a **VERDICT** and **Remediate** lines.

3. Optional: copy [`.stack-check.yaml.example`](../.stack-check.yaml.example) to that app as `.stack-check.yaml` to require RTK, GSD, etc. for a stricter **phase**.

## If you can’t use marketplaces (offline / policy)

- **Per session:** `claude --plugin-dir /path/to/your/clone` when starting Claude Code, then `stack-check` in Bash after `cd` to your app.  
- **Plain shell:** `git clone` this repo and run `/path/to/clone/stack-check` or add `clone/bin` to `PATH` (see [README.md](../README.md#without-the-plugin-plain-git)).

## Optional: RTK (Layer 4) for Claude Code

[RTK](https://github.com/rtk-ai/rtk) hooks shell output; with Claude Code:

```bash
rtk init -g
```

Then restart Claude Code. `stack-check` will **WARN** if `rtk` is missing unless you require it in `.stack-check.yaml`.

## References

- [Plugins reference (bin/ on PATH)](https://code.claude.com/docs/en/plugins-reference#file-locations-reference)
- [Discover and install plugins](https://code.claude.com/docs/en/discover-plugins)
- [readiness-checklist.md](../readiness-checklist.md) — manual layers and spec-to-code “missing link”
- [README.md](../README.md) — environment variables, exit codes, non–Claude Code use
