<p align="center">
  <img src="kiro.jpg" alt="Kiro" width="220" />
</p>

# Alacritty Tweak Tool

A GTK4 graphical configuration editor for the [Alacritty](https://alacritty.org/) terminal emulator.

Configure themes, fonts, colors, window behavior, and advanced settings through a clean interface — all changes write directly to `~/.config/alacritty/alacritty.toml` with full comment preservation.

## Features

- **Themes tab** — 300+ bundled themes across 16 sources; live VTE preview; search and source filter; apply, undo, export
- **Appearance tab** — font family + size, window opacity, decorations, startup mode, blur; live VTE preview
- **Advanced tab** — scrollback, cursor shape/blink/thickness, font spacing (character/line offset), window padding
- **Behavior tab** — copy-on-select, hide-mouse-when-typing, live-config-reload toggles
- **Creator tab** — build a theme from scratch with a color-by-color grid, or extract colors from a wallpaper image

## Installation

Add the nemesis_repo to `/etc/pacman.conf`:

```ini
[nemesis_repo]
SigLevel = Never
Server = https://erikdubois.github.io/$repo/$arch
```

Then install:

```bash
sudo pacman -S alacritty-tweak-tool
```

## Requirements

- `python-tomlkit` — `sudo pacman -S python-tomlkit`
- `vte4` — `sudo pacman -S vte4` (optional; enables terminal preview panels)
- `alacritty` — the terminal being configured
- `fastfetch` (optional) — used inside the VTE preview panel
- `imagemagick` (optional) — wallpaper color extraction in Creator tab

## Running

```bash
# Via launcher (after installation)
alacritty-tweak-tool

# Directly from the source tree
python3 usr/share/alacritty-tweak-tool/alacritty-tweak-tool.py

# With debug output
python3 usr/share/alacritty-tweak-tool/alacritty-tweak-tool.py --debug
```

No sudo required — runs as the current user.

<!-- KIRO-FUNDING-FOOTER:START — managed by Kiro-HQ/cascade-readme-footer.sh -->
## Help fund Kiro

Everything I build here stays free and open — always. If Kiro or any of these
tools have ever saved you time or taught you something, a small monthly
contribution helps keep the work going. Donations target break-even, nothing
more — the core always stays free for everyone.

- GitHub Sponsors: https://github.com/sponsors/erikdubois
- Patreon: https://www.patreon.com/c/kiroproject
- YouTube memberships: https://www.youtube.com/@ErikDubois/join
- Ko-fi: https://ko-fi.com/erikdubois
- PayPal: https://www.paypal.me/erikdubois
<!-- KIRO-FUNDING-FOOTER:END -->

## License

GPL-3.0 — see [LICENSE](LICENSE)
