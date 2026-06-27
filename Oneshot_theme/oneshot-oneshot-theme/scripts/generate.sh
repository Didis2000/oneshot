#!/bin/bash
# Generate Oneshot theme from wallpaper via tinct color extraction
set -euo pipefail

REPO_ROOT=~/.config/omarchy/themes/oneshot
THEME_DIR="$REPO_ROOT/Oneshot_theme/oneshot-oneshot-theme"
TINCT_CMD="/home/idriss/.local/share/mise/installs/go/1.26.2/bin/tinct"

# --- Fixed Oneshot identity colors (always override) ---
BG="#070324"
GOLD="#d4a54a"
GOLD_BRIGHT="#f0c860"
CREAM="#e8d5b7"
CREAM_DIM="#b8a88a"
CYAN="#6a9a9a"

# --- Default fallback palette (used when no wallpaper or tinct) ---
SURFACE="#0f0544"
CONTAINER="#2b0e77"
BASE="#5f2680"
BORDER="#1a0544"
RED="#e07a5f"
GREEN="#8bba7a"
BLUE="#4a6a9a"
MAGENTA="#c4a0b0"

# --- Parse flags ---
WALLPAPER=""
WALLPAPER_SRC=""
DRY_RUN=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --wallpaper)
            if [[ -n "${2:-}" && ! "$2" =~ ^-- ]]; then
                WALLPAPER="$2"; shift
            else
                WALLPAPER="default"
            fi
            ;;
        --dry-run)
            DRY_RUN=true
            ;;
        *)
            echo "Usage: $0 [--wallpaper <path>] [--dry-run]"
            exit 1
            ;;
    esac
    shift
done

# --- Resolve wallpaper source ---
if [[ "$WALLPAPER" == "default" ]]; then
    WALLPAPER_SRC=$(readlink -f ~/.config/omarchy/current/background 2>/dev/null || echo "")
    if [[ -z "$WALLPAPER_SRC" ]]; then
        echo "Warning: no current wallpaper symlink, using hardcoded palette"
        WALLPAPER=""
    fi
elif [[ -n "$WALLPAPER" ]]; then
    WALLPAPER_SRC="$WALLPAPER"
fi

# --- Verify tinct is available and wallpaper exists ---
if [[ -n "$WALLPAPER" ]]; then
    if ! [[ -x "$TINCT_CMD" ]]; then
        echo "Warning: tinct not found at $TINCT_CMD, using hardcoded palette"
        WALLPAPER=""
    elif [[ ! -f "$WALLPAPER_SRC" ]]; then
        echo "Warning: wallpaper '$WALLPAPER_SRC' not found, using hardcoded palette"
        WALLPAPER=""
    fi
fi

# --- Extract supporting colors from wallpaper via tinct ---
if [[ -n "$WALLPAPER" && -n "$WALLPAPER_SRC" ]]; then
    echo "Extracting colors from: $WALLPAPER_SRC"
    TINCT_JSON=$($TINCT_CMD extract -i image -p "$WALLPAPER_SRC" --format json 2>/dev/null) || true
    if [[ -n "$TINCT_JSON" ]]; then
        echo "$TINCT_JSON" > /tmp/tinct_palette.json
        eval "$(
            python3 -c '
import json
with open("/tmp/tinct_palette.json") as f:
    data = json.load(f)
c = data.get("colours", {})
def g(role, default=""):
    entry = c.get(role, {})
    return entry.get("hex", default)
out = {
    "SURFACE":   g("surface", "#0f0544"),
    "CONTAINER": g("surfaceVariant", "#2b0e77"),
    "BASE":      g("backgroundMuted", "#5f2680"),
    "BORDER":    g("outline", "#1a0544"),
    "RED":       g("danger", "#e07a5f"),
    "GREEN":     g("success", "#8bba7a"),
    "BLUE":      g("info", "#4a6a9a"),
    "MAGENTA":   g("accent1", "#c4a0b0"),

}
for k, v in out.items():
    print(f"{k}={v}")
'
        )" || true
    else
        echo "Warning: tinct extraction failed, using hardcoded palette"
    fi
fi

# --- Dry run: show palette and exit ---
if $DRY_RUN; then
    echo "=== Color Palette ==="
    echo "BG=$BG"
    echo "GOLD=$GOLD"
    echo "GOLD_BRIGHT=$GOLD_BRIGHT"
    echo "CREAM=$CREAM"
    echo "CREAM_DIM=$CREAM_DIM"
    echo "CYAN=$CYAN"
    echo "SURFACE=$SURFACE"
    echo "CONTAINER=$CONTAINER"
    echo "BASE=$BASE"
    echo "BORDER=$BORDER"
    echo "RED=$RED"
    echo "GREEN=$GREEN"
    echo "BLUE=$BLUE"
    echo "MAGENTA=$MAGENTA"
    echo ""
    echo "Dry run complete. Run without --dry-run to generate files."
    exit 0
fi

# Strip # for no-hash variants
strip() { echo "${1//#/}"; }

BG_N=$(strip "$BG")
GOLD_N=$(strip "$GOLD")
GOLD_BRIGHT_N=$(strip "$GOLD_BRIGHT")
CREAM_N=$(strip "$CREAM")
CONTAINER_N=$(strip "$CONTAINER")
SURFACE_N=$(strip "$SURFACE")
BASE_N=$(strip "$BASE")
RED_N=$(strip "$RED")
GREEN_N=$(strip "$GREEN")
BLUE_N=$(strip "$BLUE")
MAGENTA_N=$(strip "$MAGENTA")
CYAN_N=$(strip "$CYAN")
CREAM_DIM_N=$(strip "$CREAM_DIM")
BORDER_N=$(strip "$BORDER")
SURFACE_N=$(strip "$SURFACE")

lighten() {
  python3 -c "h='$1'.lstrip('#');r,g,b=int(h[0:2],16),int(h[2:4],16),int(h[4:6],16);p=$2/100;r=min(255,int(r+(255-r)*p));g=min(255,int(g+(255-g)*p));b=min(255,int(b+(255-b)*p));print(f'#{r:02x}{g:02x}{b:02x}')"
}
darken() {
  python3 -c "h='$1'.lstrip('#');r,g,b=int(h[0:2],16),int(h[2:4],16),int(h[4:6],16);p=$2/100;r=max(0,int(r*(1-p)));g=max(0,int(g*(1-p)));b=max(0,int(b*(1-p)));print(f'#{r:02x}{g:02x}{b:02x}')"
}

BRIGHT_GOLD=$(lighten "$GOLD" 10)
BRIGHT_CREAM=$(lighten "$CREAM" 5)
BRIGHT_RED=$(lighten "$RED" 20)
BRIGHT_GREEN=$(lighten "$GREEN" 15)
BRIGHT_BLUE=$(lighten "$BLUE" 15)
BRIGHT_MAGENTA=$(lighten "$MAGENTA" 15)
BRIGHT_CYAN=$(lighten "$CYAN" 15)
DARK_GOLD=$(darken "$GOLD" 20)
DIM_CREAM=$CREAM_DIM
DIM_BG=$(darken "$BG" 10)

BRIGHT_CREAM_N=$(strip "$BRIGHT_CREAM")
BRIGHT_RED_N=$(strip "$BRIGHT_RED")
BRIGHT_GREEN_N=$(strip "$BRIGHT_GREEN")
BRIGHT_BLUE_N=$(strip "$BRIGHT_BLUE")
BRIGHT_MAGENTA_N=$(strip "$BRIGHT_MAGENTA")
BRIGHT_CYAN_N=$(strip "$BRIGHT_CYAN")

echo "Generating theme from: bg=$BG gold=$GOLD cream=$CREAM"

cat > "$THEME_DIR/colors.toml" << EOF
accent = "$GOLD"
cursor = "$GOLD"
foreground = "$CREAM"
background = "$BG"

selection_foreground = "#1e1e2e"
selection_background = "$GOLD"

color0  = "$BG"          # black
color1  = "$RED"         # red
color2  = "$GREEN"       # green
color3  = "$GOLD"        # yellow
color4  = "$BLUE"        # blue
color5  = "$MAGENTA"     # magenta
color6  = "$CYAN"        # cyan
color7  = "$CREAM"       # white

color8  = "$SURFACE"     # bright black
color9  = "$BRIGHT_RED"  # bright red
color10 = "$BRIGHT_GREEN" # bright green
color11 = "$GOLD_BRIGHT" # bright yellow
color12 = "$BRIGHT_BLUE" # bright blue
color13 = "$BRIGHT_MAGENTA" # bright magenta
color14 = "$BRIGHT_CYAN" # bright cyan
color15 = "$BRIGHT_CREAM" # bright white
EOF
echo "  colors.toml ✓"

cat > "$THEME_DIR/colors.conf" << EOF
\$background = rgb($BG_N)
\$foreground = rgb($CREAM_N)
EOF
echo "  colors.conf ✓"

cat > "$THEME_DIR/hyprland.conf" << EOF
\$activeBorderColor = rgb($CREAM_N)

general {
    gaps_in = 3
    gaps_out = 4
    border_size = 2
    col.active_border = rgb($GOLD_N) rgb($BG_N) rgb($BG_N) rgb($GOLD_N) 30deg
    col.inactive_border = rgb($CONTAINER_N) rgb($BG_N) rgb($BG_N) rgb($BG_N) 90deg
    resize_on_border = true
    extend_border_grab_area = 15
    allow_tearing = false
    layout = dwindle
}

decoration {
    rounding = 6
}
EOF
echo "  hyprland.conf ✓"

cat > "$THEME_DIR/hyprlock.conf" << EOF
\$color = rgba($BG_N,1.0)
\$inner_color = rgba($BG_N,0.8)
\$outer_color = rgba($GOLD_N,1.0)
\$font_color = rgba($CREAM_N,1.0)
\$check_color = rgba($GOLD_BRIGHT_N,1.0)
EOF
echo "  hyprlock.conf ✓"

cat > "$THEME_DIR/waybar.css" << EOF
@define-color foreground $GOLD;
@define-color background $BG;
EOF
echo "  waybar.css ✓"

cat > "$THEME_DIR/mako.ini" << EOF
include=~/.local/share/omarchy/default/mako/core.ini

text-color=$CREAM
border-color=$GOLD
background-color=$BG
EOF
echo "  mako.ini ✓"

cat > "$THEME_DIR/icons.theme" << EOF
Yaru-purple
EOF
echo "  icons.theme ✓"

cat > "$THEME_DIR/neovim.lua" << EOF
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
EOF
echo "  neovim.lua ✓"

cat > "$THEME_DIR/vscode.json" << EOF
{
  "name": "Oneshot",
  "extension": "idriss.oneshot"
}
EOF
echo "  vscode.json ✓"

cat > "$THEME_DIR/firefox.css" << EOF
:root {
--color00: $BG;
--color01: $BG;
--color02: $BG;
--color03: $CREAM;
--color04: $CREAM_DIM;
--color05: $CREAM;
--color06: $CREAM_DIM;
--color07: $CREAM_DIM;
--color08: $RED;
--color09: $GOLD;
--color0A: $GOLD;
--color0B: $GREEN;
--color0C: $CYAN;
--color0D: $BLUE;
--color0E: $MAGENTA;
--color0F: $RED;
}
EOF
echo "  firefox.css ✓"

cat > "$THEME_DIR/chromium.theme" << EOF
${BG_N}
EOF
echo "  chromium.theme ✓"

cat > "$THEME_DIR/gtk.css" << 'GTKEOF'
    @define-color background     #070324;
    @define-color foreground     #e8d5b7;
    @define-color black          #070324;
    @define-color red            #e07a5f;
    @define-color green          #8bba7a;
    @define-color yellow         #d4a54a;
    @define-color blue           #4a6a9a;
    @define-color magenta        #c4a0b0;
    @define-color cyan           #6a9a9a;
    @define-color white          #e8d5b7;
    @define-color bright_black   #0f0544;
    @define-color bright_red     #f08a6f;
    @define-color bright_green   #9bca8a;
    @define-color bright_yellow  #f0c860;
    @define-color bright_blue    #5a7aaa;
    @define-color bright_magenta #d4b0c0;
    @define-color bright_cyan    #7aaaaa;
    @define-color bright_white   #eddcc3;

    @define-color accent_bg_color @yellow;
    @define-color accent_fg_color @background;
    @define-color accent_color @cyan;

    @define-color window_bg_color @background;
    @define-color window_fg_color @foreground;

    @define-color view_bg_color @black;
    @define-color view_fg_color @foreground;
    @define-color sidebar_bg_color @black;
    @define-color sidebar_fg_color @foreground;
    @define-color sidebar_backdrop_color @black;
    @define-color sidebar_shade_color @black;

    @define-color headerbar_bg_color alpha(@foreground, 0.1);
    @define-color headerbar_fg_color @foreground;
    @define-color headerbar_backdrop_color @black;
    @define-color headerbar_shade_color @black;
    @define-color card_bg_color alpha(@foreground, 0.1);
    @define-color card_fg_color @foreground;

    @define-color popover_bg_color @black;
    @define-color popover_fg_color @foreground;

    @define-color destructive_bg_color @red;
    @define-color destructive_fg_color @background;

    @define-color success_bg_color @green;
    @define-color success_fg_color @background;

    @define-color warning_bg_color @yellow;
    @define-color warning_fg_color @background;

    @define-color error_bg_color @red;
    @define-color error_fg_color @background;

    @define-color dialog_bg_color @background;
    @define-color dialog_fg_color @foreground;

    @define-color borders alpha(@foreground, 0.1);

    @define-color theme_fg_color @foreground;
    @define-color theme_text_color @foreground;
    @define-color theme_bg_color @background;
    @define-color theme_base_color @black;
    @define-color theme_selected_bg_color @yellow;
    @define-color theme_selected_fg_color @background;
    @define-color insensitive_bg_color @background;
    @define-color insensitive_fg_color @bright_black;
    @define-color insensitive_base_color @black;
    @define-color theme_unfocused_fg_color @foreground;
    @define-color theme_unfocused_text_color @foreground;
    @define-color theme_unfocused_bg_color @background;
    @define-color theme_unfocused_base_color @black;
    @define-color theme_unfocused_selected_bg_color @yellow;
    @define-color theme_unfocused_selected_fg_color @background;
    @define-color unfocused_insensitive_color @bright_black;
    @define-color unfocused_borders alpha(@foreground, 0.1);
    @define-color warning_color @yellow;
    @define-color error_color @red;
    @define-color success_color @green;
    @define-color destructive_color @red;

    @define-color content_view_bg @black;
    @define-color text_view_bg @black;

    messagedialog {
        background-color: @dialog_bg_color;
    }

    messagedialog label {
        color: @dialog_fg_color;
        font-size: 14pt;
        font-weight: bold;
    }

    messagedialog .secondary-text {
        font-size: 10pt;
        font-style: italic;
    }

    messagedialog button {
        background-color: @black;
        color: @foreground;
        border: 1px solid @bright_black;
        padding: 10px;
    }

    messagedialog button:hover {
        background-color: @yellow;
    }

    banner revealer widget {
        background: @bright_black;
        padding: 5px;
        color: @foreground;
    }

    alertdialog.background {
        background-color: @dialog_bg_color;
        color: @dialog_fg_color;
    }

    alertdialog .titlebar {
        background-color: @headerbar_bg_color;
        color: @headerbar_fg_color;
    }

    alertdialog box {
        background-color: @dialog_bg_color;
    }

    alertdialog label {
        color: @dialog_fg_color;
    }

    filechooser .dialog-action-box {
        border-top: 1px solid @bright_black;
    }

    filechooser .dialog-action-box:backdrop {
        border-top-color: @black;
    }

    filechooser #pathbarbox {
        border-bottom: 1px solid @bright_black;
    }

    filechooserbutton:drop(active) {
        box-shadow: none;
        border-color: transparent;
    }

    toast {
        background-color: @black;
        color: @foreground;
    }

    toast button.circular.flat.image-button:hover {
        color: @background;
        background-color: @red;
    }

    .svg-icon {
        filter: invert(79%) sepia(18%) saturate(611%) hue-rotate(192deg)
            brightness(103%) contrast(94%);
    }
GTKEOF
echo "  gtk.css ✓"

cat > "$THEME_DIR/alacritty.toml" << EOF
[colors.primary]
background = "$BG"
foreground = "$CREAM"
dim_foreground = "$DIM_CREAM"
bright_foreground = "$BRIGHT_CREAM"

[colors.cursor]
text = "#1e1e2e"
cursor = "$GOLD"

[colors.vi_mode_cursor]
text = "#1e1e2e"
cursor = "$GOLD"

[colors.search.matches]
foreground = "#1e1e2e"
background = "$DIM_CREAM"

[colors.search.focused_match]
foreground = "#1e1e2e"
background = "$GREEN"

[colors.footer_bar]
foreground = "#1e1e2e"
background = "$DIM_CREAM"

[colors.hints.start]
foreground = "#1e1e2e"
background = "$GOLD"

[colors.hints.end]
foreground = "#1e1e2e"
background = "$DIM_CREAM"

[colors.selection]
text = "#1e1e2e"
background = "$GOLD"

[colors.normal]
black = "$BG"
red = "$RED"
green = "$GREEN"
yellow = "$GOLD"
blue = "$BLUE"
magenta = "$MAGENTA"
cyan = "$CYAN"
white = "$CREAM"

[colors.bright]
black = "$SURFACE"
red = "$BRIGHT_RED"
green = "$BRIGHT_GREEN"
yellow = "$GOLD_BRIGHT"
blue = "$BRIGHT_BLUE"
magenta = "$BRIGHT_MAGENTA"
cyan = "$BRIGHT_CYAN"
white = "$BRIGHT_CREAM"

[[colors.indexed_colors]]
index = 16
color = "$GOLD"

[[colors.indexed_colors]]
index = 17
color = "$GOLD_BRIGHT"
EOF
echo "  alacritty.toml ✓"

cat > "$THEME_DIR/foot.ini" << EOF
[colors]
foreground = $CREAM_N
background = $BG_N

selection-foreground = 1e1e2e
selection-background = $GOLD_N

cursor = $GOLD_BRIGHT_N 1e1e2e

regular0 = $BG_N
bright0  = $SURFACE_N

regular1 = $RED_N
bright1  = $BRIGHT_RED_N

regular2 = $GREEN_N
bright2  = $BRIGHT_GREEN_N

regular3 = $GOLD_N
bright3  = $GOLD_BRIGHT_N

regular4 = $BLUE_N
bright4  = $BRIGHT_BLUE_N

regular5 = $MAGENTA_N
bright5  = $BRIGHT_MAGENTA_N

regular6 = $CYAN_N
bright6  = $BRIGHT_CYAN_N

regular7 = $CREAM_N
bright7  = $BRIGHT_CREAM_N
EOF
echo "  foot.ini ✓"

cat > "$THEME_DIR/kitty.conf" << EOF
## name:     Oneshot
## blurb:    Warm purple & gold theme

foreground              $CREAM
background              $BG
selection_foreground    #1E1E2E
selection_background    $GOLD

cursor                  $GOLD_BRIGHT
cursor_text_color       #1E1E2E

url_color               $GOLD_BRIGHT

active_border_color     $GOLD
inactive_border_color   $SURFACE
bell_border_color       $GOLD_BRIGHT

wayland_titlebar_color system
macos_titlebar_color system

active_tab_foreground   #11111B
active_tab_background   $GOLD
inactive_tab_foreground $CREAM
inactive_tab_background $BG
tab_bar_background      $BG

mark1_foreground #1E1E2E
mark1_background $GOLD
mark2_foreground #1E1E2E
mark2_background $GOLD_BRIGHT
mark3_foreground #1E1E2E
mark3_background $CYAN

color0  #$BG_N
color8  #$SURFACE_N

color1  #$RED_N
color9  #$BRIGHT_RED_N

color2  #$GREEN_N
color10 #$BRIGHT_GREEN_N

color3  #$GOLD_N
color11 #$GOLD_BRIGHT_N

color4  #$BLUE_N
color12 #$BRIGHT_BLUE_N

color5  #$MAGENTA_N
color13 #$BRIGHT_MAGENTA_N

color6  #$CYAN_N
color14 #$BRIGHT_CYAN_N

color7  #$CREAM_N
color15 #$BRIGHT_CREAM_N
EOF
echo "  kitty.conf ✓"

cat > "$THEME_DIR/ghostty.conf" << EOF
foreground = $CREAM
background = $BG

selection-foreground = #1e1e2e
selection-background = $GOLD

cursor-color = $GOLD_BRIGHT

palette = 0=$BG
palette = 8=$SURFACE

palette = 1=$RED
palette = 9=$BRIGHT_RED

palette = 2=$GREEN
palette = 10=$BRIGHT_GREEN

palette = 3=$GOLD
palette = 11=$GOLD_BRIGHT

palette = 4=$BLUE
palette = 12=$BRIGHT_BLUE

palette = 5=$MAGENTA
palette = 13=$BRIGHT_MAGENTA

palette = 6=$CYAN
palette = 14=$BRIGHT_CYAN

palette = 7=$CREAM
palette = 15=$BRIGHT_CREAM
EOF
echo "  ghostty.conf ✓"

cat > "$THEME_DIR/swayosd.css" << EOF
@define-color background-color $SURFACE;
@define-color border-color $GOLD;
@define-color label $CREAM;
@define-color image $CREAM;
@define-color progress $GOLD;
EOF
echo "  swayosd.css ✓"

cat > "$THEME_DIR/btop.theme" << EOF
theme[main_bg]="$BG"
theme[main_fg]="$CREAM"
theme[title]="$GOLD"
theme[hi_fg]="$GOLD_BRIGHT"
theme[selected_bg]="$CONTAINER"
theme[selected_fg]="$GOLD"
theme[inactive_fg]="$DIM_CREAM"
theme[graph_text]="$GOLD_BRIGHT"
theme[meter_bg]="$SURFACE"
theme[proc_misc]="$CREAM"

theme[cpu_box]="$GOLD"
theme[mem_box]="$GREEN"
theme[net_box]="$RED"
theme[proc_box]="$BLUE"

theme[div_line]="$SURFACE"

theme[temp_start]="$GREEN"
theme[temp_mid]="$GOLD"
theme[temp_end]="$RED"

theme[cpu_start]="$CYAN"
theme[cpu_mid]="$GOLD"
theme[cpu_end]="$GOLD_BRIGHT"

theme[free_start]="$MAGENTA"
theme[free_mid]="$CREAM"
theme[free_end]="$GOLD"

theme[cached_start]="$CYAN"
theme[cached_mid]="$BRIGHT_CYAN"
theme[cached_end]="$CREAM"

theme[available_start]="$GOLD"
theme[available_mid]="$GOLD_BRIGHT"
theme[available_end]="$RED"

theme[used_start]="$GREEN"
theme[used_mid]="$CYAN"
theme[used_end]="$BLUE"

theme[download_start]="$GOLD"
theme[download_mid]="$GOLD_BRIGHT"
theme[download_end]="$RED"

theme[upload_start]="$GREEN"
theme[upload_mid]="$CYAN"
theme[upload_end]="$BLUE"

theme[process_start]="$CYAN"
theme[process_mid]="$GOLD"
theme[process_end]="$GOLD_BRIGHT"
EOF
echo "  btop.theme ✓"

cat > "$THEME_DIR/cava_theme" << EOF
[color]
horizontal_gradient = 1
horizontal_gradient_color_1 = '$RED'
horizontal_gradient_color_2 = '$GOLD'
horizontal_gradient_color_3 = '$GOLD_BRIGHT'
horizontal_gradient_color_4 = '$CREAM'
horizontal_gradient_color_5 = '$CYAN'
horizontal_gradient_color_6 = '$BLUE'
horizontal_gradient_color_7 = '$MAGENTA'
horizontal_gradient_color_8 = '$SURFACE'
EOF
echo "  cava_theme ✓"

SPICEFY_THEME_DIR="$HOME/.config/spicetify/Themes/oneshot"
mkdir -p "$SPICEFY_THEME_DIR/images"

cat > "$SPICEFY_THEME_DIR/color.ini" << EOF
[base]
star                    = $GOLD_BRIGHT_N
star-glow               = $GOLD_BRIGHT_N
shooting-star           = $GOLD_N
shooting-star-glow      = $GOLD_N

main                    = $BG_N
main-elevated           = $SURFACE_N
card                    = $SURFACE_N

sidebar                 = $CONTAINER_N
sidebar-alt             = $BG_N

text                    = $CREAM_N
subtext                 = $CREAM_DIM_N

button-active           = $GOLD_BRIGHT_N
button                  = $GOLD_N
button-disabled         = $SURFACE_N

highlight               = $CONTAINER_N
highlight-elevated      = $SURFACE_N

shadow                  = 000000
selected-row            = $GOLD_N
misc                    = $BORDER_N
notification-error      = $RED_N
notification            = $GOLD_N
tab-active              = $CONTAINER_N
player                  = $BG_N
EOF
echo "  spicetify/color.ini ✓"

cat > "$THEME_DIR/nvim-oneshot.lua" << EOF
local c = vim.g.oneshot_palette or {
  bg          = "$BG",
  fg          = "$CREAM",
  gold        = "$GOLD",
  gold_bright = "$GOLD_BRIGHT",
  surface     = "$SURFACE",
  container   = "$CONTAINER",
  base        = "$BASE",
  border      = "$BORDER",
  red         = "$RED",
  green       = "$GREEN",
  blue        = "$BLUE",
  magenta     = "$MAGENTA",
  cyan        = "$CYAN",
  cream_dim   = "$CREAM_DIM",
}

local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

hl("Normal",         { fg = c.fg, bg = c.bg })
hl("NormalFloat",    { fg = c.fg, bg = c.container })
hl("NormalSB",       { fg = c.fg, bg = c.bg })

hl("Comment",        { fg = c.cream_dim, italic = true })
hl("Todo",           { fg = c.bg, bg = c.gold })
hl("Note",           { fg = c.fg, bg = c.blue })

hl("Constant",       { fg = c.gold })
hl("String",         { fg = c.green })
hl("Character",      { fg = c.green })
hl("Number",         { fg = c.gold_bright })
hl("Boolean",        { fg = c.gold_bright })
hl("Float",          { fg = c.gold_bright })

hl("Identifier",     { fg = c.magenta })
hl("Function",       { fg = c.blue })

hl("Statement",      { fg = c.gold })
hl("Conditional",    { fg = c.gold })
hl("Repeat",         { fg = c.gold })
hl("Label",          { fg = c.gold })
hl("Operator",       { fg = c.gold })
hl("Keyword",        { fg = c.gold })
hl("Exception",      { fg = c.red })

hl("PreProc",        { fg = c.magenta })
hl("Include",        { fg = c.magenta })
hl("Define",         { fg = c.magenta })
hl("Macro",          { fg = c.magenta })

hl("Type",           { fg = c.cyan })
hl("StorageClass",   { fg = c.cyan })
hl("Structure",      { fg = c.cyan })
hl("Typedef",        { fg = c.cyan })

hl("Special",        { fg = c.blue })
hl("SpecialChar",    { fg = c.blue })
hl("Delimiter",      { fg = c.fg })
hl("SpecialComment", { fg = c.cream_dim })

hl("Underlined",     { fg = c.blue, underline = true })
hl("Bold",           { bold = true })
hl("Italic",         { italic = true })

hl("Error",          { fg = c.red, bg = c.bg })
hl("ErrorMsg",       { fg = c.red })
hl("WarningMsg",     { fg = c.gold_bright })
hl("MoreMsg",        { fg = c.blue })
hl("ModeMsg",        { fg = c.fg })

hl("Pmenu",          { fg = c.fg, bg = c.surface })
hl("PmenuSel",       { fg = c.bg, bg = c.gold })
hl("PmenuSbar",      { bg = c.surface })
hl("PmenuThumb",     { bg = c.gold })

hl("Cursor",         { fg = c.bg, bg = c.gold })
hl("CursorLine",     { bg = c.surface })
hl("CursorLineNr",   { fg = c.gold, bg = c.surface })
hl("CursorColumn",   { bg = c.surface })

hl("LineNr",         { fg = c.cream_dim })
hl("SignColumn",     { fg = c.cream_dim, bg = c.bg })

hl("Visual",         { bg = c.container })
hl("VisualNOS",      { bg = c.container })

hl("Search",         { fg = c.bg, bg = c.gold_bright })
hl("IncSearch",      { fg = c.bg, bg = c.gold })

hl("StatusLine",     { fg = c.fg, bg = c.surface })
hl("StatusLineNC",   { fg = c.cream_dim, bg = c.surface })
hl("TabLine",        { fg = c.cream_dim, bg = c.bg })
hl("TabLineSel",     { fg = c.bg, bg = c.gold })
hl("TabLineFill",    { bg = c.bg })

hl("SpellBad",       { sp = c.red, undercurl = true })
hl("SpellCap",       { sp = c.blue, undercurl = true })
hl("SpellLocal",     { sp = c.cyan, undercurl = true })
hl("SpellRare",      { sp = c.magenta, undercurl = true })

hl("DiffAdd",        { fg = c.green, bg = c.surface })
hl("DiffChange",     { fg = c.gold, bg = c.surface })
hl("DiffDelete",     { fg = c.red, bg = c.surface })
hl("DiffText",       { fg = c.blue, bg = c.surface })

hl("NonText",        { fg = c.cream_dim })
hl("SpecialKey",     { fg = c.cream_dim })
hl("Whitespace",     { fg = c.surface })
hl("EndOfBuffer",    { fg = c.bg })

hl("Folded",         { fg = c.cream_dim, bg = c.surface })
hl("FoldColumn",     { fg = c.cream_dim, bg = c.bg })

hl("WinSeparator",   { fg = c.border, bg = c.bg })
hl("VertSplit",      { fg = c.border })

vim.g.colors_name = "oneshot"
EOF
echo "  nvim-oneshot.lua ✓"

python3 -c "
import sys, os
colors = {
    '@BG@': '$BG', '@FG@': '$CREAM',
    '@GOLD@': '$GOLD', '@GBR@': '$GOLD_BRIGHT',
    '@SURF@': '$SURFACE', '@CONT@': '$CONTAINER',
    '@BORD@': '$BORDER', '@RED@': '$RED',
    '@GRN@': '$GREEN', '@BLU@': '$BLUE',
    '@MAG@': '$MAGENTA', '@CYN@': '$CYAN', '@DIM@': '$CREAM_DIM',
}
tmpl = r'''(deftheme emacs-oneshot
  \"Oneshot theme for Emacs -- warm purple & gold.\")

(let ((bg \"@BG@\") (fg \"@FG@\") (gold \"@GOLD@\") (gbr \"@GBR@\")
      (surf \"@SURF@\") (cont \"@CONT@\") (bord \"@BORD@\")
      (red \"@RED@\") (grn \"@GRN@\") (blu \"@BLU@\")
      (mag \"@MAG@\") (cyn \"@CYN@\") (dim \"@DIM@\"))
  (custom-theme-set-faces
   'emacs-oneshot

   \`(default             ((t (:foreground ,fg :background ,bg))))
   \`(cursor              ((t (:background ,gold))))
   \`(region              ((t (:background ,gold :foreground ,bg))))
   \`(fringe              ((t (:background ,bg :foreground ,dim))))
   \`(line-number         ((t (:foreground ,dim :background ,bg))))
   \`(line-number-current-line ((t (:foreground ,gold :background ,surf))))
   \`(hl-line             ((t (:background ,surf))))
   \`(mode-line           ((t (:foreground ,fg :background ,surf))))
   \`(mode-line-inactive  ((t (:foreground ,dim :background ,surf))))
   \`(mode-line-highlight ((t (:foreground ,bg :background ,gold))))
   \`(minibuffer-prompt   ((t (:foreground ,gold))))
   \`(font-lock-builtin-face       ((t (:foreground ,mag))))
   \`(font-lock-comment-face       ((t (:foreground ,dim :italic t))))
   \`(font-lock-comment-delimiter-face ((t (:foreground ,dim :italic t))))
   \`(font-lock-constant-face      ((t (:foreground ,gbr))))
   \`(font-lock-doc-face           ((t (:foreground ,grn))))
   \`(font-lock-function-name-face ((t (:foreground ,blu))))
   \`(font-lock-keyword-face       ((t (:foreground ,gold))))
   \`(font-lock-negation-char-face ((t (:foreground ,gold))))
   \`(font-lock-preprocessor-face  ((t (:foreground ,mag))))
   \`(font-lock-regexp-grouping-backslash ((t (:foreground ,cyn))))
   \`(font-lock-regexp-grouping-construct ((t (:foreground ,cyn))))
   \`(font-lock-string-face        ((t (:foreground ,grn))))
   \`(font-lock-type-face          ((t (:foreground ,cyn))))
   \`(font-lock-variable-name-face ((t (:foreground ,mag))))
   \`(font-lock-warning-face       ((t (:foreground ,gbr))))

   \`(show-paren-match    ((t (:background ,cont :foreground ,gold))))
   \`(show-paren-mismatch ((t (:background ,red :foreground ,bg))))

   \`(isearch             ((t (:foreground ,bg :background ,gbr))))
   \`(lazy-highlight      ((t (:foreground ,bg :background ,gold))))
   \`(query-replace       ((t (:foreground ,bg :background ,gold))))

   \`(button              ((t (:foreground ,blu :underline t))))
   \`(link                ((t (:foreground ,blu :underline t))))
   \`(link-visited        ((t (:foreground ,mag :underline t))))

   \`(success             ((t (:foreground ,grn))))
   \`(warning             ((t (:foreground ,gbr))))
   \`(error               ((t (:foreground ,red))))

   \`(header-line         ((t (:foreground ,fg :background ,surf))))
   \`(vertical-border     ((t (:foreground ,bord))))
   \`(window-divider      ((t (:foreground ,bord))))

   \`(tab-bar             ((t (:background ,bg :foreground ,dim))))
   \`(tab-bar-tab         ((t (:background ,gold :foreground ,bg))))
   \`(tab-bar-tab-inactive ((t (:background ,bg :foreground ,dim))))

   \`(tooltip             ((t (:foreground ,fg :background ,surf))))

   \`(dired-directory     ((t (:foreground ,blu))))
   \`(dired-header        ((t (:foreground ,gold))))
   \`(dired-mark          ((t (:foreground ,gold))))

   \`(widget-field        ((t (:background ,surf :foreground ,fg))))
   \`(widget-button       ((t (:foreground ,blu :underline t))))
   \`(widget-single-line-field ((t (:background ,surf :foreground ,fg))))))

(provide-theme 'emacs-oneshot)
'''
for k, v in colors.items():
    tmpl = tmpl.replace(k, v)
with open('$THEME_DIR/emacs-oneshot-theme.el', 'w') as f:
    f.write(tmpl)
" || {
    echo "Warning: failed to generate emacs-oneshot-theme.el"
}
echo "  emacs-oneshot-theme.el ✓"

cat > "$THEME_DIR/tmux.conf" << TMUXEOF
# --- Oneshot tmux theme (auto-generated) ---
set -g status-style "bg=$BG,fg=$CREAM"
set -g message-style "bg=$BG,fg=$GOLD"
set -g message-command-style "bg=$BG,fg=$GOLD"
set -g mode-style "bg=$GOLD,fg=$BG"

set -g status-left "#[fg=$BG,bg=$GOLD,bold] #S "
set -g status-right "#[fg=$GOLD]#{?client_prefix,PREFIX ,}#[fg=$CREAM_DIM] %H:%M "
set -g status-left-length 40
set -g status-right-length 80
set -g window-status-separator ""

set -g window-status-format "#[fg=$CREAM_DIM] #I:#W "
set -g window-status-current-format "#[fg=$BG,bg=$GOLD,bold] #I:#W "

set -g pane-border-style "fg=$BORDER"
set -g pane-active-border-style "fg=$GOLD"
setw -g clock-mode-colour "$GOLD"
TMUXEOF
echo "  tmux.conf ✓"

echo ""
echo "Done! All theme files regenerated from base palette."
