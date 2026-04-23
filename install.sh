#!/usr/bin/env bash
# Ghostty config installer — clones this repo to a stable location and
# symlinks the config files into ~/.config/ghostty/.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/xkcoding/ghostty-config/main/install.sh | bash
#   # or, after cloning manually:
#   ./install.sh
#
# Environment overrides:
#   GHOSTTY_CONFIG_REPO   Git URL to clone   (default: https://github.com/xkcoding/ghostty-config.git)
#   GHOSTTY_CONFIG_REF    Branch/tag/commit  (default: main)
#   GHOSTTY_CONFIG_DIR    Local checkout dir (default: $HOME/.config/ghostty-config)
#   GHOSTTY_TARGET_DIR    Ghostty config dir (default: $HOME/.config/ghostty)

set -euo pipefail

REPO_URL="${GHOSTTY_CONFIG_REPO:-https://github.com/xkcoding/ghostty-config.git}"
REF="${GHOSTTY_CONFIG_REF:-main}"
SRC_DIR="${GHOSTTY_CONFIG_DIR:-$HOME/.config/ghostty-config}"
DST_DIR="${GHOSTTY_TARGET_DIR:-$HOME/.config/ghostty}"

log()  { printf '\033[1;34m[ghostty-config]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[ghostty-config]\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31m[ghostty-config]\033[0m %s\n' "$*" >&2; exit 1; }

command -v git >/dev/null 2>&1 || die "git is required but not installed."

# 1. Clone or update the source repo
if [ -d "$SRC_DIR/.git" ]; then
  log "Updating existing checkout at $SRC_DIR"
  git -C "$SRC_DIR" fetch --quiet origin "$REF"
  git -C "$SRC_DIR" checkout --quiet "$REF"
  git -C "$SRC_DIR" pull --quiet --ff-only origin "$REF" || warn "Fast-forward pull failed; leaving local state untouched."
else
  if [ -e "$SRC_DIR" ]; then
    die "$SRC_DIR exists but is not a git checkout. Remove it or set GHOSTTY_CONFIG_DIR."
  fi
  log "Cloning $REPO_URL into $SRC_DIR"
  git clone --quiet --branch "$REF" "$REPO_URL" "$SRC_DIR"
fi

# 2. Make sure the target dir exists
mkdir -p "$DST_DIR" "$DST_DIR/themes"

# 3. Symlink helper: back up real files, replace broken/old symlinks
link() {
  local src="$1" dst="$2"
  [ -e "$src" ] || { warn "Source missing, skipping: $src"; return; }

  if [ -L "$dst" ]; then
    # Existing symlink — just replace it.
    ln -sfn "$src" "$dst"
  elif [ -e "$dst" ]; then
    local backup="${dst}.backup.$(date +%s)"
    log "Backing up existing $dst -> $backup"
    mv "$dst" "$backup"
    ln -sfn "$src" "$dst"
  else
    ln -sfn "$src" "$dst"
  fi
  log "Linked $dst -> $src"
}

link "$SRC_DIR/config" "$DST_DIR/config"

# Symlink every file under themes/ individually so user-added themes coexist.
if [ -d "$SRC_DIR/themes" ]; then
  for theme in "$SRC_DIR/themes"/*; do
    [ -e "$theme" ] || continue
    link "$theme" "$DST_DIR/themes/$(basename "$theme")"
  done
fi

log "Done. Reload Ghostty (cmd+shift+comma) or restart it to apply."
