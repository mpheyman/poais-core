# Skill: Update Plan and Execution

## Purpose

Given proposed scope or sequencing changes (from input processing or a meeting), suggest minimal edits to PLAN.md and EXECUTION.md so they stay consistent with each other and with decisions.

## Inputs

- Proposed scope/sequencing changes (from summarize_input, meeting distiller, or user).
- Current content of PLAN.md and EXECUTION.md (paths or pasted).
- Optional: recent DECISIONS.md entries that affect plan or execution.

## Output format

1. **Suggested edits to PLAN.md** — concrete, minimal changes (e.g. “Add under Non-goals: …”, “Update Scope section: …”). Use bullet or diff-style description.
2. **Suggested edits to EXECUTION.md** — same style; focus on sequencing, active focus, or milestones.
3. **Consistency note** — one short paragraph confirming PLAN and EXECUTION are aligned after the edits.

## Steps

1. Read current PLAN.md and EXECUTION.md.
2. Map proposed changes to specific sections or lines.
3. Propose the smallest set of edits that reflect the changes.
4. Check that PLAN and EXECUTION remain consistent (e.g. no milestone in EXECUTION that contradicts PLAN).
5. Output suggested edits; do not apply unless user approves or guardrails allow low-risk auto-apply.

## Guardrails

- Prefer minimal edits (append, patch) over large rewrites.
- Ensure consistency between PLAN and EXECUTION after edits.
- Do not auto-advance lifecycle or add scope without a logged decision.
