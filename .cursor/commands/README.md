# POAIS Commands

These are **Cursor commands** — POAIS is built for Cursor and uses Cursor commands, rules, skills, and subagents. Commands are the user-facing layer; each command delegates to a subagent and returns structured output. For single-product repos the default workspace is `product/`; for portfolio repos use `products/<name>/` per product.

## Available commands

| Command | Description |
|--------|-------------|
| `/setup-poais` | Conversational POAIS setup: agent asks layout, product names, repo URL; runs init; then offers what's next (CONTEXT, capture-idea, meeting notes, process input, or explore). |
| `/process <path-to-input-file>` | Process messy input (chat, email, doc) into summary, extracted decisions/risks/scope, and minimal artifact updates. |
| `/distill-meeting <path-to-input-file>` | Refine raw meeting notes (typically in INPUTS) into a formatted meeting record; catalogue to MEETINGS/. PM can then run `/process` on the MEETINGS file to update artifacts. |
| `/create-meeting-notes [product-folder] [slug]` | Create a new meeting-notes file in MEETINGS/ for live capture in Cursor. Fill during the meeting, then run `/process` on that file to update artifacts. |
| `/capture-idea [product-folder] [slug]` | Create a new idea file in IDEAS/; fill and refine or promote later with `/process` or future workflows. |
| `/align <product-folder>` | Run alignment check on product artifacts; output Alignment Report, suggested edits; auto-apply only low-risk consistency fixes. |
| `/status <product-folder> [week-of YYYY-MM-DD]` | Compose status drafts; update STATUS.md. Use **`/status portfolio`** to aggregate across all products and write `portfolio/STATUS.md`. |
| `/release [version]` | **(poais-core repo only)** Promote Unreleased to a new version in CHANGELOG, update VERSION, commit, and push to main. Optional version (e.g. `0.2.0`); if omitted, bump patch. |

## Syntax examples

```text
/setup-poais
/process product/INPUTS/YYYY-MM-DD-<slug>.md
/process products/widget/INPUTS/YYYY-MM-DD-<slug>.md
/distill-meeting product/INPUTS/YYYY-MM-DD-<slug>.md
/create-meeting-notes product sprint-review
/create-meeting-notes products/widget standup
/capture-idea product pricing-hypothesis
/capture-idea products/api auth-ux
/align product
/align products/widget
/status product
/status products/widget 2026-02-22
/status portfolio
/release
/release 0.2.0
```

Commands take a user-provided path (except `/release`, which is for the poais-core repo). **INPUTS** is the single source for unstructured raw input (notes, email, meeting jottings, future API/recordings). For meeting notes you can: (1) create a file in INPUTS, jot notes, run `/distill-meeting` to refine and catalogue to MEETINGS/; or (2) run **`/create-meeting-notes`** to create a MEETINGS file and capture live in Cursor. For ideas, run **`/capture-idea`** to create a file in IDEAS/. Then run `/process` on MEETINGS or IDEAS files to extract and update artifacts. For `/process`, if the path does not exist, the command creates the parent directory and file, then uses pasted content if provided or asks the user to paste and rerun. The folder name need not be `product`; it is the default example only.

**Recommended first commands:** `/setup-poais` (for first-time setup), then `/process product/INPUTS/...`, `/distill-meeting product/INPUTS/...` (then `/process product/MEETINGS/...` on the catalogued file), `/create-meeting-notes`, `/capture-idea`, `/align product`, `/status product` (or `/status product YYYY-MM-DD`).

## Short descriptions

- **setup-poais** — Conversational POAIS setup: one question at a time (layout, product names, repo URL), confirm then run init, then "what's next" menu (CONTEXT, capture-idea, meeting notes, process input, explore).
- **process** — Turn one input file into high-signal summary + proposed updates to DISCOVERY, PLAN, DECISIONS, RISKS, FEATURES, EXECUTION.
- **distill-meeting** — Refine raw meeting notes (in INPUTS) into a formatted meeting record; write to MEETINGS/. If attendees, time, or agenda cannot be deduced, ask the PM if they want to add; allow proceeding without. PM then runs `/process` on the MEETINGS file to update artifacts.
- **create-meeting-notes** — Create a new meeting-notes file in MEETINGS/ for live capture; PM fills during the meeting, then runs `/process` on that file.
- **capture-idea** — Create a new idea file in IDEAS/; PM fills and can refine or promote later with `/process`.
- **align** — Compare CONTEXT, PLAN, EXECUTION, DECISIONS (and optional ROADMAP/portfolio); report drift and suggest fixes.
- **status** — Generate team/stakeholder/exec status drafts and update STATUS.md. For portfolio repos, **`/status portfolio`** aggregates from all products and writes `portfolio/STATUS.md`.
- **release** — (poais-core only) Promote CHANGELOG Unreleased to a version, update VERSION, commit, and push to main.

## Command specs (detail)

Each command has a full spec with syntax, arguments, behavior, output format, and guardrails:

| Command | Spec |
|---------|------|
| /setup-poais | [setup-poais.md](setup-poais.md) |
| /process | [process.md](process.md) |
| /distill-meeting | [distill-meeting.md](distill-meeting.md) |
| /create-meeting-notes | [create-meeting-notes.md](create-meeting-notes.md) |
| /capture-idea | [capture-idea.md](capture-idea.md) |
| /align | [align.md](align.md) |
| /status | [status.md](status.md) |
| /release | [release.md](release.md) |
