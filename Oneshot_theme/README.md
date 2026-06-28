# Oneshot Theme

Warm purple & gold desktop theme for Hyprland, Waybar, terminals, editors, and more.

## What's Included

| Config | App |
|--------|-----|
| `hyprland.conf` | Hyprland window manager |
| `waybar.css` | Waybar status bar |
| `mako.ini` | Mako notification daemon |
| `hyprlock.conf` | Hyprlock screen locker |
| `swayosd.css` | SwayOSD on-screen display |
| `walker.css` | Walker application launcher |
| `gtk.css` | GTK3/4 theme |
| `foot.ini` | Foot terminal |
| `kitty.conf` | Kitty terminal (colors only) |
| `alacritty.toml` | Alacritty terminal (colors only) |
| `ghostty.conf` | Ghostty terminal (colors only) |
| `btop.theme` | Btop system monitor |
| `cava_theme` | Cava audio visualizer |
| `firefox.css` | Firefox (via userChrome.css) |
| `neovim.lua` | Neovim colorscheme |
| `nvim-oneshot.lua` | Neovim colorscheme source |
| `emacs-oneshot-theme.el` | Doom Emacs theme |
| `vscode.json` | VS Code theme config |
| `themes/oneshot-color-theme.json` | Full VS Code extension theme |
| `chromium.theme` | Chromium theme |
| `tmux-colors.conf` | Tmux terminal multiplexer (gpakosz/.tmux colors) |
| `icons.theme` | Icon theme config |
| `colors.toml` / `colors.conf` | Shared color variables |
| `floatbar/` | Float bar OSD |

## Color System

| Role | Color |
|------|-------|
| Background | `#070324` |
| Gold accent | `#d4a54a` |
| Gold bright | `#f0c860` |
| Cream text | `#e8d5b7` |
| Cream dim | `#b8a88a` |
| Cyan | `#6a9a9a` |
| Surface | extracted from wallpaper |

Supporting colors (SURFACE, CONTAINER, BASE, BORDER, RED, GREEN, BLUE, MAGENTA) are dynamically extracted from the current wallpaper using [tinct](https://github.com/Blade2901/tinct). Identity colors (BG, GOLD, GOLD_BRIGHT, CREAM, CREAM_DIM, CYAN) are fixed overrides.

## Quick Start

### Requirements
- [Omarchy](https://omarchy.dev) desktop environment
- [awww](https://codeberg.org/seraphicfae/awww) wallpaper daemon
- [tinct](https://github.com/Blade2901/tinct) color extractor
- A terminal emulator (foot, kitty, alacritty, or ghostty)

### Install
```bash
THEME_DIR="$HOME/.config/omarchy/themes/oneshot"
git clone https://github.com/Didis2000/oneshot $THEME_DIR
ln -sfn "$THEME_DIR/Oneshot_theme/oneshot-oneshot-theme" "$HOME/.config/omarchy/current/theme"
omarchy theme set oneshot
```

### Cycling
Press `SUPER SHIFT + R` to cycle wallpapers and regenerate the theme.

Or manually:
```bash
cd ~/.config/omarchy/themes/oneshot/Oneshot_theme/oneshot-oneshot-theme/scripts
./cycle-theme.sh
```

### Regenerate from wallpaper
```bash
./scripts/generate.sh --wallpaper
```

### Regenerate with hardcoded palette
```bash
./scripts/generate.sh
```

## Scripts

- `scripts/generate.sh` — regenerate all config files (no args = hardcoded palette, `--wallpaper` = extract from current wallpaper)
- `scripts/cycle-theme.sh` — cycle wallpaper → extract → apply
- `scripts/apply-theme.sh` — copy theme files, restart services

## License

MIT
