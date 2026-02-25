# Changelog

Versioning follows [Semantic Versioning](https://semver.org/). The canonical version is in [VERSION](VERSION). Product repos can check `poais/VERSION` after a subtree pull to see what they have and avoid drift.

**Before every push to main:** promote "Unreleased" to a new version below, set the release date, update [VERSION](VERSION), then add and commit all changes (message: version + short description of changes) and push.

---

## Unreleased

- (none)

---

## [0.1.10] - 2026-02-24

- **PRD (Product Requirements Document):** PRD.md added as optional product artifact and single source of truth for development handoff. STANDARDS and GETTING_STARTED updated; bootstrap portfolio skeleton includes PRD.md stub (Summary/Goal, Scope, Users, Functional and non-functional requirements, Constraints, References). Rule 05: PRD is the artifact engineering uses for requirements; redirect build requests to update PRD. Align: alignment_check and alignment-checker include optional PRD (scope vs PLAN, EXECUTION vs PRD). Process: input-processor proposes PRD updates when input implies new or changed requirements.
- /process chunked processing: input files can be run repeatedly; only unprocessed content is processed each run. A **Processed (POAIS)** block (heading + table at end of file) records what was processed and when (line ranges, optional section names). PM can keep a running input file, add to it, and process in chunks; to re-process the whole file, clear the block and run /process again. Command spec, input-processor subagent, summarize_input skill, rule 27, commands README, .cursor README, and GETTING_STARTED updated.
- Portfolio-only default: every new init creates `products/` and `portfolio/`; no single-product option. Init scripts (poais-init.sh, poais-init.ps1) and /setup-poais always use portfolio layout; product names default to product-a, product-b.
- Single-product skeleton moved to archive/single-product-repo-skeleton/; bootstrap and docs reference portfolio scaffold only.
- Upgrade and doctor preserve existing POAIS_LOCK (workspace_root, products, portfolio) for backward compatibility; new lock from upgrade uses portfolio default.

---

## [0.1.9] - 2026-02-22

- Onboarding simplified: install/upgrade in README (agent /setup-poais and CLI first); GETTING_STARTED shortened; INSTALL_SUBTREE.md removed.
- /setup-poais: conversational setup flow; rule 28 and command.
- /create-meeting-notes and /capture-idea with subagents (meeting-notes-creator, idea-capture); rule 27; IDEAS/ in bootstrap skeletons.
- Templates: only product/ used by init; reference-only meeting/feature/input/idea removed; templates/README.
- Doc index: .cursor/README.md, tools/README.md, bootstrap/README.md; command spec table in .cursor/commands/README.md.

---

## [0.1.8] - 2026-02-22

- Portfolio (multi-product) support: POAIS_LOCK products array and portfolio; init --layout=portfolio; doctor checks all products and portfolio; upgrade preserves products/portfolio.
- Bootstrap: portfolio-repo-skeleton (products/product-a, product-b, portfolio/PRIORITIES.md, STATUS.md).
- /distill-meeting: derive MEETINGS path from input path (works for product/ and products/<name>/).
- /status portfolio: aggregate from all products, write portfolio/STATUS.md; status-composer and compose_status_updates support portfolio roll-up.
- Docs and rule 05: portfolio layout, init mode, /status portfolio, product-folder means product/ or products/<name>/.

---

## [0.1.7] - 2026-02-22

- ROADMAP: rule 26-roadmap (Milestones, Current Quarter, Next, Themes); fed by PLAN, EXECUTION, DECISIONS; stakeholder visibility.
- ROADMAP templates and skeleton: Milestones table; dates rule and formatting rule updated.
- Alignment and status skills: ROADMAP alignment check; Key dates (roadmap) and optional Roadmap snapshot in status drafts.
- Docs: GETTING_STARTED, STANDARDS, status command updated for ROADMAP.

---

## [0.1.6] - 2026-02-22

- Meeting workflow: INPUTS = single source for all raw input (including meeting jottings); /distill-meeting refines and catalogues to MEETINGS/; /process on catalogued MEETINGS file updates artifacts.
- /distill-meeting and meeting-distiller: standardized meeting doc template; prompt PM for missing attendees/time/agenda when not deducible (proceed without); write refined record to MEETINGS/.
- Rule 05-no-code-generation (numbered to match existing rules); release command requires version + short description in every release commit.
- Docs: GETTING_STARTED, README, commands README, process, distill-meeting, meeting-distiller, bootstrap README updated for new flow.

---

## [0.1.5] - 2026-02-22

- Rule: 05-no-code-generation.md — POAIS repos specs/artifacts only; redirect "build/implement" requests to product docs (FEATURES, PLAN, EXECUTION, RISKS) and implementation repo; recommend Implementation Repositories in CONTEXT.md.
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
