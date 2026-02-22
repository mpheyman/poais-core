# POAIS Commands

Commands are the user-facing layer. Each command delegates to a subagent and returns structured output. The default workspace root is `product/`.

## Available commands

| Command | Description |
|--------|-------------|
| `/process <path-to-input-file>` | Process messy input (chat, email, doc) into summary, extracted decisions/risks/scope, and minimal artifact updates. |
| `/distill-meeting <path-to-meeting-file>` | Distill a meeting note/transcript into summary, decisions, actions, risks; update DECISIONS, EXECUTION, RISKS, PLAN minimally. |
| `/align <product-folder>` | Run alignment check on product artifacts; output Alignment Report, suggested edits; auto-apply only low-risk consistency fixes. |
| `/status <product-folder> [week-of YYYY-MM-DD]` | Compose team, stakeholder, and exec status drafts; update STATUS.md with stakeholder version. |
| `/release [version]` | **(poais-core repo only)** Promote Unreleased to a new version in CHANGELOG, update VERSION, commit, and push to main. Optional version (e.g. `0.2.0`); if omitted, bump patch. |

## Syntax examples

```text
/process product/INPUTS/YYYY-MM-DD-<slug>.md
/distill-meeting product/MEETINGS/2025-02-20-sprint.md
/align product
/status product
/status product 2026-02-22
/release
/release 0.2.0
```

Commands take a user-provided path (except `/release`, which is for the poais-core repo). For `/process`, if the path does not exist, the command creates the parent directory and file, then uses pasted content if provided or asks the user to paste and rerun. The folder name need not be `product`; it is the default example only.

**Recommended first commands:** `/process product/INPUTS/...`, `/distill-meeting product/MEETINGS/...`, `/align product`, `/status product` (or `/status product YYYY-MM-DD`).

## Short descriptions

- **process** — Turn one input file into high-signal summary + proposed updates to DISCOVERY, PLAN, DECISIONS, RISKS, FEATURES, EXECUTION.
- **distill-meeting** — Turn one meeting file into summary + decisions + actions + risks + minimal artifact updates.
- **align** — Compare CONTEXT, PLAN, EXECUTION, DECISIONS (and optional ROADMAP/portfolio); report drift and suggest fixes.
- **status** — Generate team/stakeholder/exec status drafts from artifacts and update STATUS.md.
- **release** — (poais-core only) Promote CHANGELOG Unreleased to a version, update VERSION, commit, and push to main.
