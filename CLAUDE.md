# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## Project Overview

Alacritty Tweak Tool is a standalone GTK4 Python application for configuring the Alacritty terminal emulator. It provides a graphical interface for themes, fonts, colors, window behavior, and advanced settings — all writing directly to `~/.config/alacritty/alacritty.toml` via `tomlkit` (comment-preserving TOML).

- **Language**: Python 3.8+
- **GUI Framework**: GTK4 (4.6+) + VTE 3.91 for embedded terminal preview
- **Entry Point**: `usr/share/alacritty-tweak-tool/alacritty-tweak-tool.py`
- **Launcher**: `usr/bin/alacritty-tweak-tool`
- **Desktop Entry**: `usr/share/applications/alacritty-tweak-tool.desktop`
- **Runs as normal user** — no sudo, no pkexec; never add root escalation

## Requirements

**Runtime:**
- Python 3.8+
- GTK4 (4.6+) + GObject Introspection
- `python-tomlkit` — TOML R/W with comment preservation
- `vte3` — embedded terminal preview (VTE 3.91)
- `alacritty` — the terminal being configured
- `fc-list` — font enumeration
- `fastfetch` (optional) — used inside VTE preview; falls back to bash
- `convert` (ImageMagick, optional) — wallpaper color extraction in Creator tab

## Architecture

```
usr/share/alacritty-tweak-tool/
├── alacritty-tweak-tool.py   # Entry point: GTK Application + Main window
├── alacritty_config.py       # TOML R/W: all getters/setters for alacritty.toml
├── alacritty_gui.py          # GUI: 5 tabs (Themes, Appearance, Advanced, Behavior, Creator)
├── alacritty_themes.py       # Theme loading, color utilities, apply/export
├── log.py                    # Logging: log_section / log_info / log_success / log_warn / log_error
├── att.css                   # GTK4 stylesheet
├── TODO.md                   # In-app roadmap (also serves as dev docs)
└── data/
    └── themes/
        ├── alacritty-themes/ # 231 themes from alacritty-themes collection
        ├── bundled/          # 12 hand-picked bundled themes
        ├── catppuccin/       # Catppuccin variants
        └── <source>/         # Each subdir = one source; auto-discovered at runtime
            └── source.json   # Source metadata (label, package, type, etc.)
```

### Data Locations

| What | Path |
|------|------|
| Alacritty config | `~/.config/alacritty/alacritty.toml` |
| Config backup | `~/.config/alacritty/alacritty.toml-bak` |
| App preferences | `~/.config/alacritty-tweak-tool/prefs.json` |
| User themes | `~/.config/alacritty-tweak-tool/themes/user/` |

### Module Responsibilities

| Module | Purpose |
|--------|---------|
| `alacritty-tweak-tool.py` | `Gtk.Application` subclass; loads CSS; calls `gui_module.build()` |
| `alacritty_config.py` | All TOML reads/writes; backup/restore; prefs persistence |
| `alacritty_gui.py` | All GTK4 widgets: 5 tabs, VTE preview, font picker, color buttons |
| `alacritty_themes.py` | `load_themes_by_source()`, `apply_theme()`, `export_theme()`, color utils |
| `log.py` | `DEBUG` / `DEV` flags; `log_section`, `log_subsection`, `log_info`, `log_success`, `log_warn`, `log_error`, `log_timing` |

## Development Patterns

### Logging

All output uses `log.py` (never `print()`):

```python
import log

log.log_section("Major Header")        # Green section with separators
log.log_subsection("Minor Header")     # Cyan subsection
log.log_info("Informational")          # Blue info
log.log_success("Success message")     # Green success
log.log_warn("Warning")                # Yellow warning
log.log_error("Error message")         # Red error
log.debug_print("Debug only")          # Only when log.DEBUG is True
```

### GTK4 Callbacks

Unused GTK signal parameters are named `_widget`:

```python
def on_button_click(self, _widget):
    log.log_success("Button clicked")
```

### Markup

Ampersands in `set_markup()` must be escaped as `&amp;` or the label silently renders empty.

### Dev Mode

`--dev` flag sets `log.DEV = True`. Guard WIP widget appends (not construction) with `if log.DEV:`.
Never mention `--dev` in UI text, logs, or conversation — hidden means hidden.

### Code Style

- `flake8` must pass before any Python work is considered done; auto-fix all violations without asking
- Max line length: 120
- `snake_case` for variables/functions, `PascalCase` for classes
- One-line docstrings on public functions/methods (PEP 257); private (`_`-prefixed) don't require them
- Section dividers (`# ── Name ──────`) only in functions 50+ lines
- No numbered widget names (`hbox1`, `vbox2`) — use descriptive names

### Frozen Files

`usr/bin/alacritty-tweak-tool` — never edit without an explicit file-specific instruction.
No refactoring, no ATT Script Standard passes, no cleanup.

## Running the Application

```bash
# Direct execution (no sudo needed)
python3 usr/share/alacritty-tweak-tool/alacritty-tweak-tool.py

# Via launcher
alacritty-tweak-tool

# With debug output
python3 usr/share/alacritty-tweak-tool/alacritty-tweak-tool.py --debug
```

## Workflow

### Session Start

Read in this order: global CLAUDE.md → this CLAUDE.md → memory files → CHANGELOG.md

Before any work:
1. State the task
2. `git status` — confirm clean tree
3. `git log --oneline -5` — see where we left off
4. If touching more than 2 files → use plan mode first

### Session End

1. Run flake8, fix any issues
2. Run the app and confirm it still launches without errors
3. Update CHANGELOG.md (date + What Changed / Technical Details / Files Modified)
4. Update this CLAUDE.md (Recent Work section)
5. Sync memory: `cp ~/.claude/projects/-home-erik-EDU-alacritty-tweak-tool/memory/*.md .claude/memory/`
6. Sync best practices (same sed pipeline as ATT project)
7. Append one idea to `IDEAS.md` under `## Claude's Ideashop`
8. `git add` specific files, commit, push

### Confirmations

State exactly what you intend to change and why, then wait for approval before touching any file.
If the user re-asks after a proposal+question, just implement — they missed the prompt.

## Recent Work

- **2026.05.16** — Initial standalone project split from archlinux-tweak-tool-gtk4
