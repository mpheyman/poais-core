# Changelog

Versioning follows [Semantic Versioning](https://semver.org/). The canonical version is in [VERSION](VERSION). Product repos can check `poais/VERSION` after a subtree pull to see what they have and avoid drift.

**Before every push to main:** promote "Unreleased" to a new version below, set the release date, update [VERSION](VERSION), then add and commit all changes (message: version + short description of changes) and push.

---

## Unreleased

- (none)

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
- Docs: README, VISION, STANDARDS, INSTALL_SUBTREE, REPO_RENAME_GUIDE.
