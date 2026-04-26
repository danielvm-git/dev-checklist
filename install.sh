#!/usr/bin/env bash
# Install dev-checklist from GitHub: clone (or update) and add to your shell PATH.
# GitHub: https://github.com/danielvm-git/dev-checklist
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/danielvm-git/dev-checklist/main/install.sh | bash
#   # or:  git clone https://github.com/danielvm-git/dev-checklist.git && ./dev-checklist/install.sh
#
# Update (same as install if already cloned; also):
#   bash /path/to/dev-checklist/install.sh --update-only
#   # or re-run:  curl -fsSL https://raw.githubusercontent.com/danielvm-git/dev-checklist/main/install.sh | bash
#
# Environment:
#   DEV_CHECKLIST_HOME  override install directory (default: ~/.local/share/dev-checklist)

set -euo pipefail

REPO_URL="https://github.com/danielvm-git/dev-checklist.git"
RAW_INSTALL="https://raw.githubusercontent.com/danielvm-git/dev-checklist/main/install.sh"
TARGET="${DEV_CHECKLIST_HOME:-$HOME/.local/share/dev-checklist}"
MARKER="# dev-checklist (https://github.com/danielvm-git/dev-checklist)"

UPDATE_ONLY=0
usage() {
  cat <<'EOF'
install.sh — clone or update dev-checklist and add stack-check to PATH (unless --update-only).

Usage:
  curl -fsSL https://raw.githubusercontent.com/danielvm-git/dev-checklist/main/install.sh | bash
  bash install.sh [options]

Options:
  --update-only   Only git pull in DEV_CHECKLIST_HOME; skip appending to .zshrc / .bashrc
  -h, --help      This help

Env:
  DEV_CHECKLIST_HOME   Install directory (default: ~/.local/share/dev-checklist)
EOF
}

err() { echo "install.sh: $*" >&2; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --update-only) UPDATE_ONLY=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *)
      err "Unknown option: $1 (try: --update-only, --help)"
      exit 1
      ;;
  esac
done

if ! command -v git &>/dev/null; then
  err "git is required."
  exit 1
fi

sync_repo() {
  if [[ -d "$TARGET/.git" ]]; then
    echo "Updating $TARGET ..."
    git -C "$TARGET" pull --ff-only
  elif [[ -e "$TARGET" ]]; then
    err "Path already exists and is not a dev-checklist clone: $TARGET"
    err "Remove it or set DEV_CHECKLIST_HOME to a different directory, then re-run."
    exit 1
  else
    echo "Cloning into $TARGET ..."
    mkdir -p "$(dirname "$TARGET")"
    git clone --depth 1 "$REPO_URL" "$TARGET"
  fi
}

if [[ "$UPDATE_ONLY" -eq 1 ]]; then
  if [[ ! -d "$TARGET/.git" ]]; then
    err "Not a dev-checklist clone: $TARGET"
    err "Run the full install first: curl -fsSL $RAW_INSTALL | bash"
    err "(or set DEV_CHECKLIST_HOME to an existing install directory)"
    exit 1
  fi
  echo "Update-only: $TARGET (skipping shell PATH changes)"
  git -C "$TARGET" pull --ff-only
else
  sync_repo
fi

chmod +x "$TARGET/stack-check" "$TARGET/verify-readiness.sh" 2>/dev/null || true
[[ -f "$TARGET/bin/stack-check" ]] && chmod +x "$TARGET/bin/stack-check"

add_path() {
  local rc_file=$1
  [[ -f "$rc_file" ]] || return 0
  if grep -qF "$MARKER" "$rc_file" 2>/dev/null; then
    echo "PATH already mentioned in $rc_file — skipping append (remove old block manually if you changed $TARGET)."
    return 0
  fi
  {
    echo ""
    echo "$MARKER"
    echo "export PATH=\"$TARGET:\$PATH\""
  } >>"$rc_file"
  echo "Appended PATH to $rc_file"
}

if [[ "$UPDATE_ONLY" -eq 0 ]]; then
  add_path "${ZDOTDIR:-$HOME}/.zshrc"
  add_path "$HOME/.bashrc"
fi

print_revision() {
  if rev=$(git -C "$TARGET" rev-parse --short HEAD 2>/dev/null); then
    echo "Revision: $rev"
  fi
}
print_revision

echo ""
echo "Installed to: $TARGET"
if [[ "$UPDATE_ONLY" -eq 0 ]]; then
  echo "Open a new terminal (or: source ~/.zshrc) then run:  stack-check"
  echo "In your app repo:  cd /path/to/your/app && stack-check"
  echo "Uninstall: remove the two-line block starting with: $MARKER from your shell rc, then rm -rf $TARGET"
fi
echo "Update later: re-run  curl -fsSL $RAW_INSTALL | bash  or:  $TARGET/install.sh --update-only"
if [[ "$UPDATE_ONLY" -eq 1 ]]; then
  echo "Full install + PATH: run without --update-only:  bash $TARGET/install.sh"
fi
