#!/usr/bin/env bash
# Symlinks ~/.zshrc to this repo's zshrc. Safe to re-run: a no-op if
# already linked correctly, and backs up (never deletes) anything
# unexpected found at ~/.zshrc rather than overwriting it.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="$REPO_DIR/zshrc"
TARGET="$HOME/.zshrc"

if [ ! -f "$SOURCE" ]; then
  echo "error: $SOURCE doesn't exist -- is this the env-config repo?" >&2
  exit 1
fi

if [ -L "$TARGET" ] && [ "$(readlink "$TARGET")" = "$SOURCE" ]; then
  echo "OK   $TARGET -> $SOURCE (already linked)"
elif [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
  BACKUP="${TARGET}.bak.$(date +%Y%m%d%H%M%S)"
  echo "Backing up existing $TARGET -> $BACKUP"
  mv "$TARGET" "$BACKUP"
  ln -s "$SOURCE" "$TARGET"
  echo "OK   $TARGET -> $SOURCE  (previous contents saved to $BACKUP)"
else
  ln -s "$SOURCE" "$TARGET"
  echo "OK   $TARGET -> $SOURCE"
fi

echo
echo "Open a new shell (or 'exec zsh') to pick up the change."
