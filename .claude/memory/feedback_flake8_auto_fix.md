---
name: Auto-Fix All Ruff Issues
description: User approves automatic ruff fixes without asking permission; project switched from flake8 to ruff
type: feedback
originSessionId: 2a60f01d-b4ca-4151-ad28-48141fb328d5
---
**Rule:** Run `ruff check` (or `flake8`) and fix all violations automatically. Never ask permission to run either tool, and never ask permission to fix violations.

**Why:** User switched from flake8 to ruff (2026-05-18); ruff compliance is a non-negotiable standard; asking for confirmation on each violation is unnecessary friction. Explicitly extended to cover flake8 as well (2026-05-18).

**How to apply:** When running code quality tasks:
1. Run `ruff check <file/dir>` — no permission needed
2. Fix all violations automatically (Edit tool or `ruff check --fix`)
3. Re-run ruff to verify pass
4. Move on — no "should I fix this?" or "should I run ruff?" needed
