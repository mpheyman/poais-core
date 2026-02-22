# POAIS Commands

Commands are the user-facing layer. Each command delegates to a subagent and returns structured output.

## Available commands

| Command | Description |
|--------|-------------|
| `/process <path-to-input-file>` | Process messy input (chat, email, doc) into summary, extracted decisions/risks/scope, and minimal artifact updates. |
| `/distill <path-to-meeting-file>` | Distill a meeting note/transcript into summary, decisions, actions, risks; update DECISIONS, EXECUTION, RISKS, PLAN minimally. |
| `/align <product-folder>` | Run alignment check on product artifacts; output Alignment Report, suggested edits; auto-apply only low-risk consistency fixes. |
| `/status <product-folder> [week-of YYYY-MM-DD]` | Compose team, stakeholder, and exec status drafts; update STATUS.md with stakeholder version. |
| `/release [version]` | **(poais-core repo only)** Promote Unreleased to a new version in CHANGELOG, update VERSION, commit, and push to main. Optional version (e.g. `0.2.0`); if omitted, bump patch. |

## Syntax examples

```text
/process product/INPUTS/customer-feedback.md
/distill product/MEETINGS/2025-02-20-sprint.md
/align product
/status product
/status product 2026-02-22
/release
/release 0.2.0
```

Commands take a user-provided path (except `/release`, which is for the poais-core repo). If the path does not exist, the command fails with a clear message. The folder name need not be `product`; it is the default example only.

## Short descriptions

- **process** — Turn one input file into high-signal summary + proposed updates to DISCOVERY, PLAN, DECISIONS, RISKS, FEATURES, EXECUTION.
- **distill** — Turn one meeting file into summary + decisions + actions + risks + minimal artifact updates.
- **align** — Compare CONTEXT, PLAN, EXECUTION, DECISIONS (and optional ROADMAP/portfolio); report drift and suggest fixes.
- **status** — Generate team/stakeholder/exec status drafts from artifacts and update STATUS.md.
- **release** — (poais-core only) Promote CHANGELOG Unreleased to a version, update VERSION, commit, and push to main.
