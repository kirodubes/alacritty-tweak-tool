---
name: project-runs-as-normal-user
description: alacritty-tweak-tool runs as the current user, never root — key difference from ATT
metadata:
  type: project
---

alacritty-tweak-tool is launched without sudo or pkexec. It runs as the current user and writes to `~/.config/alacritty/alacritty.toml` and `~/.config/alacritty-tweak-tool/`.

**Why:** It configures a per-user terminal, not system packages or services. Root is not needed and would write to root's home, not the user's.

**How to apply:** Never add sudo prefixes or permission-error handling for file writes inside the app. Never suggest pkexec or polkit integration. If a file write fails, it's a bug in path resolution, not a permissions issue.

Contrast with [[att-runs-as-root]] (ATT always runs as root via pkexec).
