# Alacritty Tweak Tool — Ideas

## Claude's Ideashop

### Theme Diff View — show exactly what changed between current config and a selected theme

When the user hovers or selects a theme row, show a small popover or sidebar section listing only the color keys that differ from the currently applied theme (e.g. "background #1a1b26 → #0d1117", "normal.red #f7768e → #ff5555"). Implementation: compare the selected theme's TOML dict against `alacritty_config.get_colors()` output key-by-key; render differences as a two-column table with color swatches. Zero extra subprocess calls — both datasets are already in memory when the theme list is populated.

**Why this is worth building:** Users cycling through 231 themes often can't remember what they applied 3 themes ago or whether a new theme is meaningfully different. The diff gives them a concrete answer without applying anything, reducing accidental overwrites of a theme they actually liked.
