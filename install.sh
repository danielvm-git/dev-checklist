#!/usr/bin/env bash
# Install dev-checklist from GitHub: clone (or update) and add to your shell PATH.
# GitHub: https://github.com/danielvm-git/dev-checklist
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/danielvm-git/dev-checklist/main/install.sh | bash
#   # or:  git clone https://github.com/danielvm-git/dev-checklist.git && ./dev-checklist/install.sh
#
# Environment:
#   DEV_CHECKLIST_HOME  override install directory (default: ~/.local/share/dev-checklist)

set -euo pipefail

REPO_URL="https://github.com/danielvm-git/dev-checklist.git"
RAW_INSTALL="https://raw.githubusercontent.com/danielvm-git/dev-checklist/main/install.sh"
TARGET="${DEV_CHECKLIST_HOME:-$HOME/.local/share/dev-checklist}"
MARKER="# dev-checklist (https://github.com/danielvm-git/dev-checklist)"

err() { echo "install.sh: $*" >&2; }

if ! command -v git &>/dev/null; then
  err "git is required."
  exit 1
fi

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

add_path "${ZDOTDIR:-$HOME}/.zshrc"
add_path "$HOME/.bashrc"

echo ""
echo "Installed to: $TARGET"
echo "Open a new terminal (or: source ~/.zshrc) then run:  stack-check"
echo "In your app repo:  cd /path/to/your/app && stack-check"
echo "Uninstall: remove the two-line block starting with: $MARKER from your shell rc, then rm -rf $TARGET"
