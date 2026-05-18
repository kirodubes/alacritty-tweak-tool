---
name: Auto-Fix All Ruff Issues
description: User approves automatic ruff fixes without asking permission; project switched from flake8 to ruff
type: feedback
originSessionId: 2a60f01d-b4ca-4151-ad28-48141fb328d5
---
**Rule:** Run `ruff check` and fix all violations automatically. Never ask permission.

**Why:** User switched from flake8 to ruff (2026-05-18); ruff compliance is a non-negotiable standard; asking for confirmation on each violation is unnecessary friction.

**How to apply:** When running code quality tasks:
1. Run `ruff check <file/dir>`
2. Fix all violations automatically (Edit tool or `ruff check --fix`)
3. Re-run ruff to verify pass
4. Move on — no "should I fix this?" needed
