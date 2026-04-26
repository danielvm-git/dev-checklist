#!/usr/bin/env bats
# Integration tests for stack-check (Layer 2 Superpowers + minimal stack tree).

setup() {
  export FIXTURE
  FIXTURE="$(mktemp -d "${BATS_TEST_TMPDIR:-/tmp}/stack-check-fixture.XXXXXX")"
  export REPO_ROOT
  REPO_ROOT="$(cd "$(dirname "${BATS_TEST_FILENAME}")/.." && pwd)"
}

teardown() {
  rm -rf "$FIXTURE"
}

stack_minimal_tree() {
  mkdir -p "$FIXTURE/specs"
  touch "$FIXTURE/.cursorrules" "$FIXTURE/README.md"
  git -C "$FIXTURE" init -q
}

@test "Layer 2 Superpowers OK when AGENTS.md links obra/superpowers" {
  stack_minimal_tree
  printf '%s\n' "Stack: https://github.com/obra/superpowers" >"$FIXTURE/AGENTS.md"
  cd "$FIXTURE" || exit 1
  run bash "$REPO_ROOT/stack-check"
  [[ "$status" -eq 0 ]]
  [[ "$output" == *"Superpowers / Layer 2 stack signal"* ]]
  [[ "$output" != *"[WARN]"*"Superpowers signal (Layer 2, optional)"* ]]
}

@test "Layer 2 Superpowers OK when README.md links obra/superpowers" {
  stack_minimal_tree
  printf '%s\n' "We use [Superpowers](https://github.com/obra/superpowers)." >"$FIXTURE/README.md"
  cd "$FIXTURE" || exit 1
  run bash "$REPO_ROOT/stack-check"
  [[ "$status" -eq 0 ]]
  [[ "$output" == *"Superpowers / Layer 2 stack signal"* ]]
  [[ "$output" != *"Superpowers signal (Layer 2, optional)"* ]]
}

@test "Layer 2 Superpowers advisory WARN when no signal" {
  stack_minimal_tree
  cd "$FIXTURE" || exit 1
  run bash "$REPO_ROOT/stack-check"
  [[ "$status" -eq 0 ]]
  [[ "$output" == *"Superpowers signal (Layer 2, optional)"* ]]
  [[ "$output" == *"L2:superpowers (advisory)"* ]] || [[ "$output" == *"superpowers"* ]]
}

@test "require_layer2_superpowers true fails without repo-local signal" {
  stack_minimal_tree
  cat >"$FIXTURE/.stack-check.yaml" <<'EOF'
require_layer1: true
require_layer2: true
require_layer2_superpowers: true
require_layer3: true
require_layer4_rtk: false
require_layer4_context_mode: false
require_layer5_gitsurface: true
require_layer5_gsd: false
EOF
  cd "$FIXTURE" || exit 1
  run bash "$REPO_ROOT/stack-check"
  [[ "$status" -eq 1 ]]
  [[ "$output" == *"[FAIL]"*"Superpowers signal (Layer 2)"* ]] || [[ "$output" == *"Superpowers signal"* ]]
  [[ "$output" == *"not_ready"* ]]
}

@test "skills/using-superpowers/SKILL.md counts as signal" {
  stack_minimal_tree
  mkdir -p "$FIXTURE/skills/using-superpowers"
  printf '%s\n' '---' 'name: using-superpowers' '---' >"$FIXTURE/skills/using-superpowers/SKILL.md"
  cd "$FIXTURE" || exit 1
  run bash "$REPO_ROOT/stack-check"
  [[ "$status" -eq 0 ]]
  [[ "$output" == *"Superpowers / Layer 2 stack signal"* ]]
}

@test "Layer 3 Ctxo warns when config exists but no index/runtime evidence" {
  stack_minimal_tree
  cat >"$FIXTURE/.mcp.json" <<'EOF'
{
  "mcpServers": {
    "ctxo": { "command": "npx", "args": ["@ctxo/cli", "mcp"] }
  }
}
EOF
  cd "$FIXTURE" || exit 1
  run bash "$REPO_ROOT/stack-check"
  [[ "$status" -eq 0 ]]
  [[ "$output" == *"[WARN]"*"Ctxo runtime health"* ]]
}

@test "Layer 3 Ctxo OK when config index and runtime evidence exist" {
  stack_minimal_tree
  mkdir -p "$FIXTURE/.ctxo" "$FIXTURE/bin"
  touch "$FIXTURE/.ctxo/index-manifest.json"
  cat >"$FIXTURE/.mcp.json" <<'EOF'
{
  "mcpServers": {
    "ctxo": { "command": "npx", "args": ["@ctxo/cli", "mcp"] }
  }
}
EOF
  cat >"$FIXTURE/bin/ctxo" <<'EOF'
#!/usr/bin/env bash
if [[ "${1-}" == "status" ]]; then
  exit 0
fi
exit 0
EOF
  chmod +x "$FIXTURE/bin/ctxo"
  cd "$FIXTURE" || exit 1
  PATH="$FIXTURE/bin:$PATH" run bash "$REPO_ROOT/stack-check"
  [[ "$status" -eq 0 ]]
  [[ "$output" == *"[OK]"*"Ctxo runtime health: configured + indexed + status healthy"* ]]
}

@test "require_layer3_ctxo true fails when Ctxo evidence is missing" {
  stack_minimal_tree
  cat >"$FIXTURE/.stack-check.yaml" <<'EOF'
require_layer1: true
require_layer2: true
require_layer2_superpowers: false
require_layer3: true
require_layer3_ctxo: true
require_layer4_rtk: false
require_layer4_context_mode: false
require_layer5_gitsurface: true
require_layer5_gsd: false
EOF
  cd "$FIXTURE" || exit 1
  run bash "$REPO_ROOT/stack-check"
  [[ "$status" -eq 1 ]]
  [[ "$output" == *"[FAIL]"*"Ctxo runtime health"* ]]
}
