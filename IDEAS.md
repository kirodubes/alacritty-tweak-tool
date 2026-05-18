# Alacritty Tweak Tool — Ideas

## Claude's Ideashop

### Theme Diff View — show exactly what changed between current config and a selected theme

When the user hovers or selects a theme row, show a small popover or sidebar section listing only the color keys that differ from the currently applied theme (e.g. "background #1a1b26 → #0d1117", "normal.red #f7768e → #ff5555"). Implementation: compare the selected theme's TOML dict against `alacritty_config.get_colors()` output key-by-key; render differences as a two-column table with color swatches. Zero extra subprocess calls — both datasets are already in memory when the theme list is populated.

**Why this is worth building:** Users cycling through 231 themes often can't remember what they applied 3 themes ago or whether a new theme is meaningfully different. The diff gives them a concrete answer without applying anything, reducing accidental overwrites of a theme they actually liked.

### Theme Favorites — pin themes to a Favorites section at the top of the list

Add a star toggle button on each theme row that persists a `favorites` list in `prefs.json`. The source dropdown gains a "Favorites" option that filters to only starred rows. Implementation: `row.is_favorite` attribute set during async load; `filter_row()` checks it when source is set to the favorites key; star state written to prefs on toggle. Users cycling through 311 themes who find 3–4 they like stop having to remember names or re-scroll — they star and revisit instantly.

### Per-Desktop-Environment Window Geometry — remember size separately for each DE

Store `window_width`/`window_height` under a key derived from `$XDG_CURRENT_DESKTOP` (e.g. `"geometry_XFCE"`, `"geometry_i3"`). Implementation: read `os.environ.get("XDG_CURRENT_DESKTOP", "default")` at startup, use it as the prefs key prefix. Users who switch between XFCE, dwm, and a VM get the size they left it at in each environment rather than one shared value that fits none of them well.

### Kiro Theme Auto-Sync — pull NotSoPale/OhSoPale colors live from the running alacritty.toml

Since `~/.config/alacritty/alacritty.toml` is already parsed by the app, add an "Update from current config" button in the Kiro source row of the Dev tab. It reads the live `[colors]` block, converts `0x` hex to `#`, and overwrites `data/themes/kiro/NotSoPale.toml` in place. Rationale: ohmychadwm-menu manages alacritty colors dynamically — the bundled theme quickly drifts from what the user actually runs. One-click sync keeps the Kiro theme accurate without manual extraction.
