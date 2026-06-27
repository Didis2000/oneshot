#!/bin/bash
# Oneshot Theme Installer
# Clones and sets up the Oneshot theme for Omarchy/Hyprland

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info()  { echo -e "${BLUE}[INFO]${NC} $1"; }
log_ok()    { echo -e "${GREEN}[OK]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_SRC="$SCRIPT_DIR/Oneshot_theme/oneshot-oneshot-theme"
THEME_DEST="$HOME/.config/omarchy/themes/oneshot"
CURRENT="$HOME/.config/omarchy/current/theme"

log_info "Installing Oneshot theme..."

mkdir -p "$HOME/.config/omarchy/themes"

# Remove existing if any
if [[ -d "$THEME_DEST" ]]; then
  rm -rf "$THEME_DEST"
fi

# Symlink theme source to Omarchy themes dir
ln -sfn "$THEME_SRC" "$THEME_DEST"

# Set as current theme
mkdir -p "$(dirname "$CURRENT")"
rm -f "$CURRENT"
ln -sfn "$THEME_DEST" "$CURRENT"
echo "oneshot" > "$HOME/.config/omarchy/current/theme.name"

log_ok "Theme installed at $THEME_DEST"
log_info "Run script/cycle-theme.sh to cycle wallpapers"
log_info "Or press SUPER SHIFT + R (if binding is configured)"
