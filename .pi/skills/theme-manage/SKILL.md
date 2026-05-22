---
name: theme-manage
description: Use when the user wants to create, edit, preview, or manage terminal themes (washi light/dark). Covers Alacritty, tmux, nvim, and pi themes — keeps all four in sync.
---

# Theme Management — 和紙 (Washi) Themes

Manage the unified washi theme system across Alacritty, tmux, nvim, and pi.

## Architecture

All theme files live in this dotfiles repo. Symlinks connect them to their expected locations.

### File locations (relative to repo root)

| App | Light | Dark |
|-----|-------|------|
| **Alacritty** | `config/alacritty/themes/washi.toml` | Uses `kanagawa_dragon` (external) |
| **Tmux** | `config/tmux/tmux.conf` (WASHI_* vars) | Same file, toggled by theme-toggle |
| **Nvim** | `config/nvim/colors/washi.lua` | Uses `kanagawa-dragon` (external) |
| **Pi** | `config/pi/themes/washi-light.json` | `config/pi/themes/washi-dark.json` |
| **Toggle** | `bin/theme-toggle` | — |

### Symlinks (created by install.sh)

- `~/.pi/agent/themes/washi-light.json` → `config/pi/themes/washi-light.json`
- `~/.pi/agent/themes/washi-dark.json` → `config/pi/themes/washi-dark.json`

### Theme toggle

`bin/theme-toggle [light|dark]` switches all apps at once:
- Swaps Alacritty import between `washi.toml` and `kanagawa_dragon.toml`
- Sed-replaces WASHI_* vars in tmux.conf and reloads tmux
- Sends colorscheme command to running nvim instances
- Swaps `theme` in `~/.pi/agent/settings.json`
- Writes mode to `~/.config/theme-mode`

## Current Light Palette

Core colors shared across all apps:

| Name | Hex | Role |
|------|-----|------|
| paper | `#f0f0ee` | Background — cool Japanese paper white |
| bar | `#e6e5e2` | Subtle raised surface (status bars, message boxes) |
| cloud | `#c0bdb8` | Muted borders, selection bg |
| stone | `#7a8279` | Accent, secondary text |
| ash | `#908a82` | Dim/muted text |
| ink | `#1a1816` | Primary text — near black |

ANSI normals (darkened for contrast on light bg):

| Color | Hex |
|-------|-----|
| red | `#8a2820` |
| green | `#2a5828` |
| yellow | `#6a5018` |
| blue | `#1a4a70` |
| magenta | `#602060` |
| cyan | `#1a5850` |

ANSI brights:

| Color | Hex |
|-------|-----|
| red | `#a04038` |
| green | `#4a7040` |
| yellow | `#8a6e30` |
| blue | `#3a6488` |
| magenta | `#7a4a7a` |
| cyan | `#3a7068` |

## Current Dark Palette (pi only — Alacritty/nvim use kanagawa_dragon)

| Name | Hex | Role |
|------|-----|------|
| yami | `#1e1c1a` | Deep background |
| kuro | `#2a2724` | Background |
| sumi | `#3a3632` | Borders |
| hai | `#605a52` | Muted text |
| nezumi | `#908a82` | Secondary text |
| kinu | `#c8c3ba` | Tertiary text |
| shiro | `#e8e4df` | Primary text |

## Workflows

### Editing an existing color

1. Identify which palette value to change
2. Update **all files** that reference it — use the table above to find which files apply
3. For tmux, also update the matching value in `bin/theme-toggle` (both LIGHT_* and DARK_* sections)
4. Verify: Alacritty live-reloads on save; for tmux run `tmux source-file ~/.config/tmux/tmux.conf`; pi hot-reloads active custom themes

### Adding a new color to the palette

1. Add to Alacritty theme (ANSI slot or primary/selection)
2. Add to nvim `washi.lua` `local c = { ... }` table and create highlight groups
3. Add to pi theme `vars` and reference in `colors`
4. If it affects tmux status bar, add a WASHI_* var in tmux.conf and bin/theme-toggle

### Creating a new theme variant

1. Copy the closest existing theme files as a starting point
2. Define the full palette (core + ANSI) before touching any files
3. Create all four app theme files in one pass
4. Add the new variant to `bin/theme-toggle`
5. Update `install.sh` to symlink/copy the new files

### Design principles

- **Japanese minimalism** — restrained palette, few accent colors, generous whitespace
- **Contrast first** — every text color must be clearly readable on its background
- **Warm neutrals** — avoid pure black/white; use warm undertones (#1a1816 not #000000)
- **Earthy ANSI** — syntax colors drawn from natural dyes: 藍 indigo, 抹茶 matcha, 柿渋 persimmon, 紅 crimson, 藤 wisteria, 青磁 celadon
- **Consistent mapping** — same semantic color (e.g. "error red") should use the same hex across all apps
