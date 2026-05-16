# Alacritty Tweak Tool — To-Do List

Tasks that are known but not yet scheduled. Move to CLAUDE.md milestones when scheduled.

---

## In Progress / Near-term

- [ ] **VTE logo squashed in Themes tab** — fastfetch ASCII logo renders squashed/flat in the
      Themes tab VTE despite using `_build_vte_panel` (same function as Creator/Appearance).
      Root cause: Themes VTE is realized at startup while GTK layout is still settling;
      Creator/Appearance are realized later (on tab switch) so layout is complete.
      Attempted: `timeout_add(200)`, `PRIORITY_LOW` idle, `size-allocate` signal (not exposed on Vte.Terminal).
      Next idea: connect to `map` signal instead of `realize`, or pass `--logo-width` / `COLUMNS` env to constrain fastfetch output width explicitly.

- [ ] **Dark/Light auto-split** — detect background luminance; add a filter button alongside search to show only dark or only light themes

---

## Backlog / Future

- [ ] **More theme sources** — extend `data/themes/` with new subdirectories; each subdir is
      auto-discovered by `load_themes_by_source()` — no code changes needed for discovery.
      Future targets (confirm `.toml` format before adding):
      - Everforest — no alacritty `.toml` in official repo; skip unless a standalone source is found
      - Any other AUR package that installs alacritty `.toml` files

- [ ] **Theme Creator — VTE copy integration** — copy the VTE terminal instance from Themes tab
      into Creator tab so colors update live; currently Creator spawns a separate VTE

- [ ] **Theme Sources GUI** — "Dev/Sources" section showing each source with install status,
      theme count, and Update/Install buttons (backed by `data/themes/registry.json`)

---

*Keep this list short — if an item is scheduled into a milestone, move it there and delete it from here.*
