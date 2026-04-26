# dev-checklist

`stack-check` verifies whether your repo shows the agentic setup signals it can actually detect (files in repo + commands on PATH), then prints `OK`, `WARN`, or `FAIL` per layer.

[![GitHub](https://img.shields.io/badge/github-danielvm--git%2Fdev--checklist-blue?logo=github)](https://github.com/danielvm-git/dev-checklist)

## 9-step tyre-change setup (checker-aligned)

Use this if you want a strict sequence where step 9 passes based on what the checker expects.

### One command (recommended)

```bash
bash install-stack.sh --mode greenfield --target /path/to/app --env all --strict --yes
```

For an existing project:

```bash
bash install-stack.sh --mode existing --target /path/to/existing/repo --env all --strict --yes
```

### Manual 9-step sequence

#### Step 1 — Create a folder (or choose existing repo)

- Goal: have a project root with git + docs.
- Command (new folder):

```bash
mkdir -p /path/to/app && cd /path/to/app && git init
test -f README.md || printf '# App\n' > README.md
```

- Checker expects: `.git` and `README.md` or `PROJECT.md`.
- Verify: `test -d .git && test -f README.md && echo OK`.

#### Step 2 — Install spec-kit in a checkable way

- Goal: install spec-kit and ensure Layer 1 signal exists.
- Commands:

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git
mkdir -p specs
```

- Checker expects: `specs/` at repo root.
- Verify: `test -d specs && echo OK`.
- Source: [spec-kit](https://github.com/github/spec-kit).

#### Step 3 — Install Superpowers in a checkable way

- Goal: plugin/runtime install + repo-local signal.
- Commands:

```bash
test -f AGENTS.md || printf '# Agent Rules\n' > AGENTS.md
printf 'Superpowers: https://github.com/obra/superpowers\n' >> AGENTS.md
```

- Install plugin by tool:
  - Cursor: `/add-plugin superpowers`
  - Claude Code: `/plugin install superpowers@claude-plugins-official`
  - Gemini: `gemini extensions install https://github.com/obra/superpowers`
- Checker expects: one scanned root file contains `obra/superpowers` or vendored `skills/using-superpowers/SKILL.md`.
- Verify: `rg -n "obra/superpowers" README.md AGENTS.md CLAUDE.md .cursorrules instructions.md .clinerules`.
- Source: [Superpowers](https://github.com/obra/superpowers).

#### Step 4 — Install RTK in a checkable way

- Goal: `rtk` available on PATH.
- Commands:

```bash
brew install rtk
# or:
curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
```

- Checker expects: `rtk` command resolvable.
- Verify: `command -v rtk && rtk --version`.
- Source: [RTK](https://github.com/rtk-ai/rtk).

#### Step 5 — Install Ctxo in a checkable way

- Goal: Ctxo runtime wired for your IDE/CLI.
- Commands:

```bash
npx -y @ctxo/init
```

- Checker note: Layer 3 Ctxo is marked `MANUAL` in current `stack-check`.
- Verify runtime: use your IDE MCP tools and Ctxo docs flow.
- Optional local signal:

```bash
cat > .mcp.json <<'EOF'
{
  "mcpServers": {
    "ctxo": { "command": "npx", "args": ["-y", "@ctxo/cli"] }
  }
}
EOF
```

- Source: [Ctxo](https://github.com/alperhankendi/Ctxo).

#### Step 7 — Install context-mode in a checkable way

- Goal: context-mode installed and checker heuristic visible.
- Commands:

```bash
npm install -g context-mode
mkdir -p .cursor
cat > .cursor/mcp.json <<'EOF'
{
  "mcpServers": {
    "context-mode": { "command": "context-mode" }
  }
}
EOF
```

- Checker expects (current heuristic): the word `context` in `.cursor/`, `mcps/`, or `mcp.json`.
- Verify: `rg -n "context" .cursor mcps mcp.json`.
- Source: [context-mode](https://github.com/mksglu/context-mode).

#### Step 8 — Install dev-checklist

- Goal: `stack-check` available and strict config applied.
- Commands:

```bash
curl -fsSL https://raw.githubusercontent.com/danielvm-git/dev-checklist/main/install.sh | bash
```

Then in your app repo create strict config:

```bash
cat > .stack-check.yaml <<'EOF'
phase: "bootstrap"
require_layer1: true
require_layer2: true
require_layer2_superpowers: true
require_layer3: true
require_layer4_rtk: true
require_layer4_context_mode: true
require_layer5_gitsurface: true
require_layer5_gsd: false
EOF
```

#### Step 9 — Run stack-check (strict)

- Goal: fail fast if any expected signal is missing.
- Command:

```bash
STACK_CHECK_STRICT=1 stack-check
```

- Expected: exit code `0` and `VERDICT: ready`.
- If not: follow `Address (required)` tags and map to setup step:
  - `L1:specs` -> Step 2
  - `L2:*` -> Step 3
  - `L4:rtk` -> Step 4
  - `L4:context-mode` -> Step 7
  - `L5:git` -> Step 1

## What `stack-check` can and cannot guarantee

- Guaranteed checks are filesystem/PATH signals only.
- Plugin runtime behavior (Ctxo deep indexing, IDE session hooks) still needs runtime verification in your tool.
- This boundary is intentional so results are deterministic and scriptable.

## Fast references

- Universal terminal notes: [docs/terminals-and-clis.md](docs/terminals-and-clis.md)
- Full readiness checklist: [readiness-checklist.md](readiness-checklist.md)
- Daily startup checklist: [session-start.md](session-start.md)
- Kickass README inspiration: [Medium article](https://meakaakka.medium.com/a-beginners-guide-to-writing-a-kickass-readme-7ac01da88ab3)
