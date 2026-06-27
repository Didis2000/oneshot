#!/bin/bash
# Apply the generated oneshot theme directly (bypasses slow omarchy-theme-set)
set -euo pipefail

THEME_NAME="oneshot"
CURRENT="$HOME/.config/omarchy/current/theme"
SOURCE="$HOME/.config/omarchy/themes/$THEME_NAME"

# Copy theme files
rm -rf "$CURRENT"
mkdir -p "$CURRENT"
cp -r "$SOURCE/"* "$CURRENT/"

# Store theme name
echo "$THEME_NAME" > "$HOME/.config/omarchy/current/theme.name"

# Restart services
pkill -x waybar 2>/dev/null || true
setsid -w uwsm-app -- waybar >/dev/null 2>&1 &
disown

systemctl --user daemon-reload 2>/dev/null || true
pkill -x swayosd-server 2>/dev/null || true
setsid -w uwsm-app -- swayosd-server >/dev/null 2>&1 &
disown

makoctl reload 2>/dev/null || true
hyprctl reload 2>/dev/null || true

# Set VSCode theme via symlink
VSCODE_EXT="$HOME/.vscode/extensions/idriss.oneshot"
if [[ -d "$HOME/.vscode/extensions" ]]; then
  ln -sfn "$SOURCE" "$VSCODE_EXT"
fi

# Kill swaybg if awww is handling wallpapers now
if pgrep -x awww-daemon >/dev/null 2>&1; then
  pkill -x swaybg 2>/dev/null || true
fi

# Run spicetify hook directly
if command -v spicetify &>/dev/null; then
  spicetify config current_theme oneshot > /dev/null
  spicetify config color_scheme base > /dev/null
  spicetify apply > /dev/null 2>&1 &
fi

# Apply Firefox colors + wallpaper
for ffdir in "$HOME/.mozilla/firefox"/*.default* "$HOME/.mozilla/firefox/chrome"; do
  chomedir="$ffdir/chrome"
  if [[ -d "$chomedir" ]]; then
    cp "$CURRENT/firefox.css" "$chomedir/colors.css"
    cp "$CURRENT/backgrounds/"*.png "$chomedir/newtab-bg.png" 2>/dev/null || true
  fi
done

notify-send -t 2000 "Oneshot theme applied"
