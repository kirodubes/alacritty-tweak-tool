# Alacritty Tweak Tool — To-Do List

Tasks that are known but not yet scheduled. Move to CLAUDE.md milestones when scheduled.

---

## Backlog / Future

- [ ] **More theme sources** — extend `data/themes/` with new subdirectories (19 sources present as of 2026-05-18);
      each subdir is auto-discovered by `load_themes_by_source()` — no code changes needed for discovery.
      Future targets (confirm `.toml` format before adding):
      - Everforest — no alacritty `.toml` in official repo; skip unless a standalone source is found
      - Any other AUR package that installs alacritty `.toml` files

- [ ] **Theme Creator — VTE copy integration** — copy the VTE terminal instance from Themes tab
      into Creator tab so colors update live; currently Creator spawns a separate VTE

- [ ] **Theme Sources GUI** — "Dev/Sources" section showing each source with install status,
      theme count, and Update/Install buttons (backed by `data/themes/registry.json`)

---

*Keep this list short — if an item is scheduled into a milestone, move it there and delete it from here.*
