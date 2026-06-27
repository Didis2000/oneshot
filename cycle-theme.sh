#!/bin/bash
# Cycle to next wallpaper and regenerate theme
set -euo pipefail

# 1. Cycle wallpaper to next one (updates symlink)
omarchy-theme-bg-next

# 2. Display with awww if daemon is running
CURRENT_BG="$HOME/.config/omarchy/current/background"
if pgrep -x awww-daemon >/dev/null 2>&1; then
  pkill -x swaybg 2>/dev/null || true
  awww img "$CURRENT_BG" --transition-type random --transition-step 90 --transition-fps 30 || true
fi

# 3. Regenerate theme configs from the new wallpaper
cd "$HOME/.config/omarchy/themes/oneshot"
bash generate.sh --wallpaper

# 3. Apply theme directly
bash "$HOME/.config/omarchy/themes/oneshot/apply-theme.sh"
