# Cursor runtime (POAIS)

This directory is the source for the Cursor runtime that product repos use. After init, it is synced to the repo root as `.cursor/` so Cursor sees POAIS commands, rules, skills, and subagents. POAIS is built for [Cursor](https://cursor.com).

## Commands

User-facing Cursor commands. Each command has a spec in `commands/<name>.md` and may delegate to a subagent.

| Command | Spec | Delegates to | Purpose |
|---------|------|--------------|---------|
| `/setup-poais` | [commands/setup-poais.md](commands/setup-poais.md) | — | Conversational POAIS setup: layout, product names, repo URL; runs init; "what's next" menu. |
| `/process` | [commands/process.md](commands/process.md) | input-processor | Process messy input into summary and artifact updates. |
| `/distill-meeting` | [commands/distill-meeting.md](commands/distill-meeting.md) | meeting-distiller | Refine raw meeting notes from INPUTS; catalogue to MEETINGS/. |
| `/create-meeting-notes` | [commands/create-meeting-notes.md](commands/create-meeting-notes.md) | meeting-notes-creator | Create a MEETINGS file for live capture in Cursor. |
| `/capture-idea` | [commands/capture-idea.md](commands/capture-idea.md) | idea-capture | Create an IDEAS file for idea capture. |
| `/align` | [commands/align.md](commands/align.md) | alignment-checker | Alignment check on CONTEXT, PLAN, EXECUTION, DECISIONS (and ROADMAP). |
| `/status` | [commands/status.md](commands/status.md) | status-composer | Compose status drafts; update STATUS.md (or portfolio/STATUS.md). |
| `/release` | [commands/release.md](commands/release.md) | — | (poais-core repo only) Version release: CHANGELOG, VERSION, commit, push. |

Full reference: [commands/README.md](commands/README.md).

## Rules

Numbered rules that define purpose, guardrails, and formatting. Cursor applies them in the repo.

| Rule | Purpose |
|------|---------|
| [00-poais-purpose.md](rules/00-poais-purpose.md) | POAIS purpose: human-led orchestration, messy inputs → structured outputs, alignment layer. |
| [05-no-code-generation.md](rules/05-no-code-generation.md) | POAIS repos are specs/artifacts only; redirect build/implement to product docs or implementation repo. |
| [10-mutation-guardrails.md](rules/10-mutation-guardrails.md) | Propose first; auto-apply only low-risk edits; no large rewrites without approval. |
| [20-formatting-standards.md](rules/20-formatting-standards.md) | Markdown and doc formatting. |
| [25-dates-and-deadlines.md](rules/25-dates-and-deadlines.md) | ISO dates, deadline taxonomy (Confirmed / Requested / Target / Constraint). |
| [26-roadmap.md](rules/26-roadmap.md) | ROADMAP structure: Milestones, Current Quarter, Next, Themes. |
| [27-meetings-ideas-inputs.md](rules/27-meetings-ideas-inputs.md) | INPUTS (unstructured), MEETINGS (live or from INPUTS), IDEAS (capture-idea). |
| [28-setup-onboarding.md](rules/28-setup-onboarding.md) | Use `/setup-poais` for setup/onboarding; guide conversationally. |

## Subagents

Subagents are invoked by commands. They use skills and produce structured output (e.g. proposed edits, document content).

| Subagent | Used by | Purpose |
|----------|---------|---------|
| [input-processor](subagents/input-processor.md) | /process | Process messy input → summary, decisions, risks, proposed artifact updates. |
| [meeting-distiller](subagents/meeting-distiller.md) | /distill-meeting | Raw meeting notes → refined meeting record; catalogue to MEETINGS/. |
| [meeting-notes-creator](subagents/meeting-notes-creator.md) | /create-meeting-notes | Produce initial meeting-notes document for live capture. |
| [idea-capture](subagents/idea-capture.md) | /capture-idea | Produce initial idea document for IDEAS/. |
| [alignment-checker](subagents/alignment-checker.md) | /align | Compare artifacts; Alignment Report and suggested edits. |
| [status-composer](subagents/status-composer.md) | /status | Compose status drafts; update STATUS.md (or portfolio roll-up). |

## Skills

Reusable capabilities used by subagents. Each skill has a spec in `skills/<name>.md`.

| Skill | Used by | Purpose |
|-------|---------|---------|
| [summarize_input](skills/summarize_input.md) | input-processor, meeting-distiller | High-signal summary, decisions, risks, scope changes, feature ideas, open questions. |
| [extract_decisions](skills/extract_decisions.md) | input-processor, meeting-distiller | Formatted DECISIONS entries; explicit vs implied. |
| [update_plan_execution](skills/update_plan_execution.md) | input-processor | Suggested edits to PLAN.md and EXECUTION.md. |
| [alignment_check](skills/alignment_check.md) | alignment-checker | Compare CONTEXT, PLAN, EXECUTION, DECISIONS; drift report. |
| [compose_status_updates](skills/compose_status_updates.md) | status-composer | Status drafts and STATUS.md content. |
