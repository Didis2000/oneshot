# Oneshot Theme

Warm purple & gold desktop theme for Hyprland, Waybar, terminals, editors, and more.

## What's Included

### WM & Shell
| Config | App |
|--------|-----|
| `hyprland.conf` | Hyprland window manager |
| `hyprlock.conf` | Hyprlock screen locker |
| `waybar.css` | Waybar status bar |
| `walker.css` | Walker application launcher |
| `swayosd.css` | SwayOSD on-screen display |
| `mako.ini` | Mako notification daemon |
| `tmux-colors.conf` | Tmux (gpakosz/.tmux colors) |

### Terminals
| Config | App |
|--------|-----|
| `foot.ini` | Foot terminal |
| `kitty.conf` | Kitty terminal (colors) |
| `alacritty.toml` | Alacritty terminal (colors) |
| `ghostty.conf` | Ghostty terminal (colors) |

### Editors
| Config | App |
|--------|-----|
| `nvim-oneshot.lua` | Neovim colorscheme |
| `emacs-oneshot-theme.el` | Doom Emacs theme |
| `vscode.json` | VS Code theme config reference |
| `themes/oneshot-color-theme.json` | Full VS Code extension |

### Browsers
| Config | App |
|--------|-----|
| `firefox.css` | Firefox (via userChrome.css) |
| `zen.css` | Zen Browser (via userChrome.css) |
| `chromium.theme` | Chromium-based browsers |

### System & Other
| Config | App |
|--------|-----|
| `gtk.css` | GTK3/4 theme |
| `btop.theme` | Btop system monitor |
| `cava_theme` | Cava audio visualizer |
| `spicetify/color.ini` | Spotify (Spicetify) |
| `icons.theme` | Icon theme config |
| `floatbar/` | Float bar OSD |
| `colors.toml` / `colors.conf` | Shared color variables |

## Color System

| Role | Color | Source |
|------|-------|--------|
| Background | `#070324` | Fixed |
| Gold accent | `#d4a54a` | Fixed |
| Gold bright | `#f0c860` | Fixed |
| Cream text | `#e8d5b7` | Fixed |
| Cream dim | `#b8a88a` | Fixed |
| Cyan | `#6a9a9a` | Fixed |
| Surface | _dynamic_ | Wallpaper |
| Container | _dynamic_ | Wallpaper |
| Red | _dynamic_ | Wallpaper |
| Green | _dynamic_ | Wallpaper |
| Blue | _dynamic_ | Wallpaper |
| Magenta | _dynamic_ | Wallpaper |

**Fixed** identity colors are hardcoded Oneshot overrides. **Dynamic** supporting colors are extracted from the current wallpaper via [tinct](https://github.com/Blade2901/tinct).

## Usage

### Install
```bash
THEME_DIR="$HOME/.config/omarchy/themes/oneshot"
git clone https://github.com/Didis2000/oneshot "$THEME_DIR"
ln -sfn "$THEME_DIR/Oneshot_theme/oneshot-oneshot-theme" "$HOME/.config/omarchy/current/theme"
omarchy theme set oneshot
```

### Cycle wallpaper + regenerate
```
SUPER SHIFT + R
```
or
```bash
./scripts/cycle-theme.sh
```

### Regenerate from current wallpaper
```bash
./scripts/generate.sh --wallpaper
```

### Regenerate with hardcoded palette (no wallpaper)
```bash
./scripts/generate.sh
```

### Apply theme (copy files, restart services)
```bash
./scripts/apply-theme.sh
```

### Preview palette (no file writes)
```bash
./scripts/generate.sh --dry-run
```

## Pipeline

```
cycle-theme.sh
  ├── rotates wallpaper (awww)
  ├── generate.sh --wallpaper
  │     ├── extracts colors from wallpaper (tinct)
  │     └── writes app configs with palette values
  └── apply-theme.sh
        ├── copies configs to ~/.config/omarchy/current/theme
        ├── deploys to app-specific locations
        │     ├── Firefox/Zen profile dirs
        │     ├── Spicetify theme dir
        │     ├── VSCode extension dir
        │     └── tmux (via source-file)
        └── restarts services (waybar, swayosd, hyprctl reload, etc.)
```

## Requirements

- [Omarchy](https://omarchy.dev) desktop environment
- [awww](https://codeberg.org/seraphicfae/awww) wallpaper daemon
- [tinct](https://github.com/Blade2901/tinct) color extractor
- A terminal emulator (foot, kitty, alacritchostty)

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| Zen/Firefox theme not applying | Ensure `toolkit.legacyUserProfileCustomizations.stylesheets` is `true` in `about:config`, then restart the browser |
| Wrong or missing colors | Run `generate.sh --dry-run` to verify the extracted palette |
| Services not restarting | Run `apply-theme.sh` manually and check for errors |

## License

MIT
