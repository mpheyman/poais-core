# Changelog

Versioning follows [Semantic Versioning](https://semver.org/). The canonical version is in [VERSION](VERSION). Product repos can check `poais/VERSION` after a subtree pull to see what they have and avoid drift.

**Before every push to main:** promote "Unreleased" to a new version below, set the release date, update [VERSION](VERSION), then add and commit all changes (message: version + short description of changes) and push.

---

## Unreleased

- (none)

---

## [0.1.5] - 2026-02-22

- Rule: no-code-generation.md — POAIS repos specs/artifacts only; redirect "build/implement" requests to product docs (FEATURES, PLAN, EXECUTION, RISKS) and implementation repo; recommend Implementation Repositories in CONTEXT.md.
- GETTING_STARTED.md and doc updates (README, INSTALL_SUBTREE, bootstrap README, commands README).
- Command rename: distill → distill-meeting; doctor script fixes.

---

## [0.1.4] - 2026-02-22

- One-command init: curl | bash and irm | iex from empty product repo; poais-init no longer requires poais/ to exist first.
- poais-init hardened for remote execution: repo root via git rev-parse, step banners, POAIS_CORE_REPO_URL env fallback; safe scaffold copy.
- README and INSTALL_SUBTREE: one-command init (recommended), initial-commit requirement, “open in Cursor then /process” next steps; legacy local-init kept.

---

## [0.1.3] - 2026-02-22

- poais-init, poais-upgrade, poais-doctor scripts (bash + PowerShell): init once, upgrade as needed, diagnose; safe copy, POAIS_LOCK.json, no Node/Python.
- Golden-path docs: README, INSTALL_SUBTREE, commands README, bootstrap README; manual steps kept as legacy.
- Release command: when Unreleased is empty, populate bullets from working tree and changes, then release.
- REPO_RENAME_GUIDE removed; CHANGELOG 0.1.0 entry updated.

---

## [0.1.2] - 2026-02-22

- Rule: dates and deadlines (25-dates-and-deadlines.md) — ISO dates, ambiguity handling, deadline taxonomy (Confirmed/Requested/Target/Constraint), where to record (PLAN, RISKS, DECISIONS). Formatting rule 20 references it.
- Bootstrap: single-product skeleton now includes INPUTS/, MEETINGS/, FEATURES/ with .gitkeep so folders are always in git.
- /process resilience: if target file or parent dir is missing, create them; use pasted chat content if provided, else ask user to paste and rerun. Examples use `product/INPUTS/YYYY-MM-DD-<slug>.md`.

---

## [0.1.1] - 2026-02-22

- Single-product-per-repo model: default bootstrap is `bootstrap/single-product-repo-skeleton/` with workspace at `product/` (not `products/<name>/`).
- Legacy monorepo bootstrap moved to `archive/bootstrap-legacy/product-repo-skeleton/`.
- Docs and command examples updated to use `product/`; commands take user-provided path and fail clearly if path does not exist.

---

## [0.1.0] - (initial; release date not tracked)

- Initial poais-core distribution layout.
- `.cursor/` (rules, commands, skills, subagents) at repo root.
- `templates/`, `tools/`, `bootstrap/product-repo-skeleton/`, `archive/`.
- Sync scripts: `tools/sync-cursor-runtime.sh`, `tools/sync-cursor-runtime.ps1`.
- Docs: README, VISION, STANDARDS, INSTALL_SUBTREE.
