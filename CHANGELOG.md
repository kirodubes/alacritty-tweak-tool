# Alacritty Tweak Tool — Changelog

## 2026.06.13 - Remove dead AUR-pulling code from common.sh

### What Changed

- Stripped two dead functions from `common/common.sh` that pulled packages from the AUR: `install_aur_package()` and `install_sddm_git()`. Both were defined but had zero callers anywhere in the project, so this removes an unused AUR-install surface without affecting any feature.
- Prompted by the [Arch AUR malicious-packages incident](https://archlinux.org/news/active-aur-malicious-packages-incident/) (2026-06-12): reducing the number of unattended `yay -S --noconfirm` / `paru -S --noconfirm` paths.

### Technical Details

- `install_aur_package()` (`yay`/`paru` with `--noconfirm`) was only ever called by `install_sddm_git()`, which itself was uncalled — removing both leaves no AUR-helper invocation in `common.sh`.
- ATT's SDDM support is variant-agnostic (`check_package_installed("sddm") or check_package_installed("sddm-git")`), so `sddm-git` is not a requirement; stock `sddm` from the official repos works.
- The `# 10. Download and AUR helpers` section header was renamed to `# 10. Download file`.
- `replace_sddm_with_sddm_git_if_needed()` is also dead but was left in place — it routes through `install_packages` (`pacman -S`), not an AUR helper, so it is out of scope for this AUR cleanup.
- `bash -n common/common.sh` passes; no remaining references to `install_aur_package`, `install_sddm_git`, `yay`, or `paru`.

### Files Modified

- `common/common.sh`

## 2026.05.18 - ruff formatting + VTE resize respawn + Theme Sources GUI in Dev tab + Kiro theme group

### What Changed

- Switched linter/formatter from flake8 to ruff; applied `ruff format` across all Python source files
- Fixed VTE fastfetch logo squashed when app starts from a terminal: strip `COLUMNS` env var so fastfetch reads PTY width via ioctl; use 500ms polling on `map` signal with a two-poll stability check before spawning; `clear` before each respawn
- VTE now respawns fastfetch when column count changes (e.g. window resize) instead of showing stale layout
- Dev tab (hidden behind `--dev`) rewritten to use a central `data/themes/registry.json`; shows all known sources with install status and Install/Update buttons
- Cleared TODO — all items resolved or closed
- Added new **Kiro** theme source group — distro-specific curated themes bundled with the app
- Added two Kiro themes: **Oh So Pale** (from user's existing theme) and **Not So Pale** (extracted from current `~/.config/alacritty/alacritty.toml`, Tokyo Night palette)

### Technical Details

- `ruff check` + `ruff format` replace flake8; both now run in CI and session-end checks
- VTE spawn: `realize` signal replaced by `map` + 500ms `GLib.timeout_add` poll; `state["pending"]` tracks the previous column count so spawn only fires when the count is stable for two consecutive polls; `COLUMNS` stripped from `envv` passed to `spawn_async`; old process killed via `os.kill(pid, signal.SIGTERM)` before respawn; `signal` module added to imports
- `data/themes/registry.json`: master list of 19 sources (dirname, label, type, source_path, theme_count, update_command, notes); new sources can be added here without touching Python
- `_build_dev_tab()`: reads `registry.json`; cross-references against `os.path.isfile(source_json/source.json)` to determine installed status; single `_on_action` handler checks live install state at click time so Install button automatically becomes Update after first successful install; writes `source.json` with `copied_date`/`last_checked` set to today after install completes; dead `return outer` after `return scroll` removed
- Scheduled remote reminder for 2026-07-18 to check for new AUR theme sources
- `data/themes/kiro/`: new directory auto-discovered at runtime like all other sources; `source.json` sets `type: bundled` and `update_command: null`; added to `registry.json`; `0x` hex notation from alacritty.toml converted to `#` notation for theme files

### Files Modified

- `usr/share/alacritty-tweak-tool/alacritty_gui.py`
- `usr/share/alacritty-tweak-tool/alacritty-tweak-tool.py`
- `usr/share/alacritty-tweak-tool/alacritty_config.py`
- `usr/share/alacritty-tweak-tool/alacritty_themes.py`
- `usr/share/alacritty-tweak-tool/log.py`
- `usr/share/alacritty-tweak-tool/data/themes/registry.json` (new, then updated)
- `usr/share/alacritty-tweak-tool/data/themes/kiro/OhSoPale.toml` (new)
- `usr/share/alacritty-tweak-tool/data/themes/kiro/NotSoPale.toml` (new)
- `usr/share/alacritty-tweak-tool/data/themes/kiro/source.json` (new)
- `CLAUDE.md`
- `TODO.md`
- `.claude/memory/feedback_flake8_auto_fix.md`
- `.claude/memory/MEMORY.md`

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
