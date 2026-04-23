#!/usr/bin/env bash
# Remove symlinks created by install.sh. Does NOT delete the local checkout
# at $GHOSTTY_CONFIG_DIR; remove it manually if you want a full cleanup.

set -euo pipefail

SRC_DIR="${GHOSTTY_CONFIG_DIR:-$HOME/.config/ghostty-config}"
DST_DIR="${GHOSTTY_TARGET_DIR:-$HOME/.config/ghostty}"

log()  { printf '\033[1;34m[ghostty-config]\033[0m %s\n' "$*"; }

unlink_if_ours() {
  local dst="$1"
  if [ -L "$dst" ]; then
    local target
    target="$(readlink "$dst")"
    case "$target" in
      "$SRC_DIR"/*)
        rm "$dst"
        log "Removed symlink $dst"
        ;;
      *)
        log "Skipping $dst (points to $target, not managed by this repo)"
        ;;
    esac
  fi
}

unlink_if_ours "$DST_DIR/config"

if [ -d "$DST_DIR/themes" ]; then
  for f in "$DST_DIR/themes"/*; do
    [ -e "$f" ] || continue
    unlink_if_ours "$f"
  done
fi

log "Done. Symlinks removed. The local checkout at $SRC_DIR was kept — delete it manually if you want."

# Show any backups so the user knows how to restore.
shopt -s nullglob
backups=( "$DST_DIR"/*.backup.* "$DST_DIR"/themes/*.backup.* )
shopt -u nullglob

if [ ${#backups[@]} -gt 0 ]; then
  echo
  log "Backups found from previous installs:"
  for b in "${backups[@]}"; do
    printf '  %s\n' "$b"
  done
  echo
  log "To restore one, strip the .backup.<timestamp> suffix, e.g.:"
  printf '  mv "%s/config.backup.<timestamp>" "%s/config"\n' "$DST_DIR" "$DST_DIR"
fi
