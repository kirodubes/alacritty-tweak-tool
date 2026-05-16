# Alacritty Tweak Tool — Changelog

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
