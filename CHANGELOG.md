# Alacritty Tweak Tool — Changelog

## 2026.05.17 - VTE optional + window size persistence + theme cache

### What Changed

- Made VTE (terminal preview) optional — app starts and works fully on systems where `vte4` is not installed or where `vte3` (GTK3 build) is installed instead
- Corrected all references from `vte3` to `vte4` (on Arch, `vte3` is GTK3; `vte4` is GTK4)
- Window size is now persisted across launches via `prefs.json`
- Theme list now loads from a JSON cache on second+ launch: **1429ms → 3ms**

### Technical Details

- `alacritty_gui.py`: wrapped `gi.require_version('Vte', '3.91')` + `from gi.repository import Vte` in try/except; set `_VTE_AVAILABLE` flag; `_build_vte_panel()` returns a placeholder label and `None` vte when VTE unavailable; all `.set_font()` and `_apply_vte_colors()` calls guarded against `None`
- `alacritty-tweak-tool.py`: reads `window_width`/`window_height` from prefs on startup (defaults 900×580); connects `close-request` to save actual size via `get_width()`/`get_height()` before exit
- `alacritty_gui.py`: Quit button changed from `get_application().quit()` to `window.close()` so `close-request` fires and size is saved
- `README.md` + `CLAUDE.md`: updated dependency from `vte3` to `vte4 (optional)`
- `alacritty_themes.py`: added `_dir_signature()` (count + max mtime of .toml files), `_load_cache()`, `_save_cache()`; `load_themes_by_source()` checks signature per directory and falls through to tomlkit only on miss; cache written to `~/.config/alacritty-tweak-tool/theme_cache.json`

### Files Modified

- `usr/share/alacritty-tweak-tool/alacritty_gui.py`
- `usr/share/alacritty-tweak-tool/alacritty-tweak-tool.py`
- `usr/share/alacritty-tweak-tool/alacritty_themes.py`
- `CLAUDE.md`
- `README.md`

## 2026.05.16 - Initial standalone project split from archlinux-tweak-tool-gtk4

### What Changed

- Extracted alacritty-tweak-tool into its own standalone repository
- All source code, theme data, launcher, desktop entry, and project docs moved here from the archlinux-tweak-tool-gtk4 monorepo
- Zero code changes — pure filesystem split; alacritty-tweak-tool had no imports from ATT's `functions.py` or any ATT-specific module

### Technical Details

- `usr/share/alacritty-tweak-tool/` contains the full app: 5 Python modules, CSS, 304 bundled theme files across 16 sources
- `usr/bin/alacritty-tweak-tool` — standalone launcher (checks tomlkit + vte3 deps at startup)
- `usr/share/applications/alacritty-tweak-tool.desktop` — desktop entry
- `up.sh` cleaned: removed the ATT-specific nanorc fetch block that referenced the Kiro ISO
- `.claude/memory/` seeded with 24 relevant memory files from the ATT project

### Files Added

- `usr/` — full application tree
- `CLAUDE.md` — project guidance for Claude Code
- `CHANGELOG.md` — this file
- `TODO.md` — merged roadmap from both ATT and in-app TODO.md
- `IDEAS.md` — feature ideashop
- `README.md` — user-facing project description
- `.claude/memory/` — 24 memory files + MEMORY.md index
