#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

MODE="existing"
TARGET=""
ENV_TARGET="all"
YES=0
DRY_RUN=0
STRICT=0

STEP_FAILS=()

usage() {
  cat <<'EOF'
install-stack.sh — 9-step tyre-change setup aligned with stack-check.

Usage:
  bash install-stack.sh --mode greenfield --target /path/to/app --env all --strict --yes
  bash install-stack.sh --mode existing --target . --env cursor --strict

Options:
  --mode greenfield|existing   Create a new app folder or use existing repo (default: existing)
  --target PATH                App repo path (required)
  --env cursor|claude|antigravity|gemini|all (default: all)
  --strict                     Write strict .stack-check.yaml and require strict pass at step 9
  --yes                        Non-interactive mode
  --dry-run                    Print commands and file writes without applying
  -h, --help                   Show help
EOF
}

say() { printf '%s\n' "$*"; }
warn() { printf 'WARN: %s\n' "$*" >&2; }
die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

run_cmd() {
  local cmd="$1"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    say "[dry-run] $cmd"
    return 0
  fi
  bash -lc "$cmd"
}

ensure_parent_exists() {
  local p="$1"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    return 0
  fi
  local parent
  parent="$(cd "$(dirname "$p")" && pwd)"
  [[ -d "$parent" ]] || die "Parent directory not found: $parent"
}

write_file() {
  local p="$1"
  local content="$2"
  ensure_parent_exists "$p"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    say "[dry-run] write $p"
    return 0
  fi
  printf '%s\n' "$content" >"$p"
}

append_if_missing() {
  local p="$1"
  local needle="$2"
  local line="$3"
  if [[ -f "$p" ]] && rg -n "$needle" "$p" >/dev/null 2>&1; then
    return 0
  fi
  if [[ "$DRY_RUN" -eq 1 ]]; then
    say "[dry-run] append to $p: $line"
    return 0
  fi
  printf '%s\n' "$line" >>"$p"
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --mode) MODE="${2:-}"; shift 2 ;;
      --target) TARGET="${2:-}"; shift 2 ;;
      --env) ENV_TARGET="${2:-}"; shift 2 ;;
      --strict) STRICT=1; shift ;;
      --yes) YES=1; shift ;;
      --dry-run) DRY_RUN=1; shift ;;
      -h|--help) usage; exit 0 ;;
      *) die "Unknown argument: $1" ;;
    esac
  done

  [[ -n "$TARGET" ]] || die "--target is required"
  [[ "$MODE" == "greenfield" || "$MODE" == "existing" ]] || die "--mode must be greenfield|existing"
  case "$ENV_TARGET" in
    cursor|claude|antigravity|gemini|all) ;;
    *) die "--env must be cursor|claude|antigravity|gemini|all" ;;
  esac
}

check_command() {
  command -v "$1" >/dev/null 2>&1
}

step_header() {
  say ""
  say "== Step $1: $2 =="
}

maybe_prompt() {
  local msg="$1"
  if [[ "$YES" -eq 1 || "$DRY_RUN" -eq 1 ]]; then
    return 0
  fi
  read -r -p "$msg [y/N] " ans
  [[ "$ans" == "y" || "$ans" == "Y" ]]
}

step1_folder() {
  step_header 1 "Create folder / validate existing repo"
  if [[ "$MODE" == "greenfield" ]]; then
    run_cmd "mkdir -p \"$TARGET\""
    if [[ ! -d "$TARGET/.git" ]]; then
      run_cmd "git -C \"$TARGET\" init"
    fi
    if [[ ! -f "$TARGET/README.md" ]]; then
      write_file "$TARGET/README.md" "# App\n"
    fi
  else
    [[ -d "$TARGET" ]] || die "Target directory does not exist: $TARGET"
    if [[ ! -d "$TARGET/.git" ]]; then
      warn "No .git found in existing mode. Initializing git so Layer 5 check can pass."
      run_cmd "git -C \"$TARGET\" init"
    fi
  fi
}

step2_spec_kit() {
  step_header 2 "Install spec-kit in checker-visible way"
  if check_command specify; then
    say "specify already on PATH."
  else
    if check_command uv; then
      run_cmd "uv tool install specify-cli --from git+https://github.com/github/spec-kit.git || true"
    elif check_command pipx; then
      run_cmd "pipx install git+https://github.com/github/spec-kit.git || true"
    else
      warn "uv/pipx not found. Install one, then install spec-kit manually: https://github.com/github/spec-kit"
    fi
  fi

  if [[ ! -d "$TARGET/specs" ]]; then
    run_cmd "mkdir -p \"$TARGET/specs\""
    write_file "$TARGET/specs/.keep" "# checker signal for Layer 1\n"
  fi
}

step3_superpowers() {
  step_header 3 "Install Superpowers in checker-visible way"
  run_cmd "mkdir -p \"$TARGET\""
  if [[ ! -f "$TARGET/AGENTS.md" ]]; then
    write_file "$TARGET/AGENTS.md" "# Agent Rules\n"
  fi
  append_if_missing "$TARGET/AGENTS.md" "obra/superpowers" "Superpowers: https://github.com/obra/superpowers"

  say "Plugin commands by environment:"
  say "- Cursor: /add-plugin superpowers"
  say "- Claude Code: /plugin install superpowers@claude-plugins-official"
  say "- Gemini CLI: gemini extensions install https://github.com/obra/superpowers"
}

step4_rtk() {
  step_header 4 "Install RTK and verify PATH"
  if check_command rtk; then
    say "rtk already on PATH."
  else
    if check_command brew; then
      run_cmd "brew install rtk || true"
    else
      run_cmd "curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh || true"
    fi
  fi

  if ! check_command rtk; then
    STEP_FAILS+=("Step 4: rtk not found on PATH")
  else
    run_cmd "rtk --version || true"
  fi
}

step5_ctxo() {
  step_header 5 "Install Ctxo and set runtime signal"
  if check_command npx; then
    run_cmd "cd \"$TARGET\" && npx -y @ctxo/init || true"
  else
    warn "npx not found. Install Node.js/npm to run Ctxo init."
  fi

  if [[ ! -f "$TARGET/.mcp.json" ]]; then
    write_file "$TARGET/.mcp.json" "{\n  \"mcpServers\": {\n    \"ctxo\": {\n      \"command\": \"npx\",\n      \"args\": [\"-y\", \"@ctxo/cli\"]\n    }\n  }\n}\n"
  else
    append_if_missing "$TARGET/.mcp.json" "ctxo" "  \"ctxo\": { \"command\": \"npx\", \"args\": [\"-y\", \"@ctxo/cli\"] }"
  fi
}

step7_context_mode() {
  step_header 7 "Install context-mode and write checker-visible signal"
  if check_command npm; then
    run_cmd "npm install -g context-mode || true"
  else
    warn "npm not found. Install Node.js/npm to install context-mode."
  fi

  run_cmd "mkdir -p \"$TARGET/.cursor\""
  write_file "$TARGET/.cursor/mcp.json" "{\n  \"mcpServers\": {\n    \"context-mode\": {\n      \"command\": \"context-mode\"\n    }\n  }\n}\n"
}

step8_dev_checklist() {
  step_header 8 "Install dev-checklist"
  run_cmd "bash \"$ROOT_DIR/install.sh\""

  write_file "$TARGET/.stack-check.yaml" "phase: \"bootstrap\"\nrequire_layer1: true\nrequire_layer2: true\nrequire_layer2_superpowers: true\nrequire_layer3: true\nrequire_layer4_rtk: true\nrequire_layer4_context_mode: true\nrequire_layer5_gitsurface: true\nrequire_layer5_gsd: false\n"
}

map_failure_to_step() {
  local output="$1"
  local mapped=()
  [[ "$output" == *"L1:specs"* ]] && mapped+=("2")
  [[ "$output" == *"L2:agent-rules"* || "$output" == *"L2:superpowers"* ]] && mapped+=("3")
  [[ "$output" == *"L3:readme"* ]] && mapped+=("1")
  [[ "$output" == *"L4:rtk"* ]] && mapped+=("4")
  [[ "$output" == *"L4:context-mode"* ]] && mapped+=("7")
  [[ "$output" == *"L5:git"* ]] && mapped+=("1")
  if [[ ${#mapped[@]} -gt 0 ]]; then
    say "Failed tags map to steps: ${mapped[*]}"
  fi
}

step9_validate() {
  step_header 9 "Run stack-check (strict)"
  local cmd="cd \"$TARGET\" && STACK_CHECK_STRICT=1 \"$ROOT_DIR/stack-check\""
  if [[ "$DRY_RUN" -eq 1 ]]; then
    say "[dry-run] $cmd"
    return 0
  fi

  local out
  set +e
  out="$(bash -lc "$cmd" 2>&1)"
  local code=$?
  set -e
  printf '%s\n' "$out"

  if [[ "$code" -ne 0 ]]; then
    map_failure_to_step "$out"
    die "Step 9 failed. Fix mapped steps and rerun."
  fi
}

main() {
  parse_args "$@"
  step1_folder
  step2_spec_kit
  step3_superpowers
  step4_rtk
  step5_ctxo
  step7_context_mode
  step8_dev_checklist

  if [[ ${#STEP_FAILS[@]} -gt 0 ]]; then
    printf 'Pre-validation failures:\n' >&2
    printf ' - %s\n' "${STEP_FAILS[@]}" >&2
    exit 1
  fi

  step9_validate
  say ""
  say "Done. 9-step setup completed and strict stack-check passed."
}

main "$@"
