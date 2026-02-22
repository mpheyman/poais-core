# Command: /distill

## Syntax

```
/distill <path-to-meeting-file>
```

## Expected arguments

- **path-to-meeting-file** — Path to a meeting note or transcript (e.g. `product/MEETINGS/2025-02-20-sprint-planning.md`). Can be relative to repo root or absolute. Must exist; command fails clearly if not.

## Delegation

Delegates to the **meeting-distiller** subagent.

## Behavior

1. Load the meeting file (or prompt user to save pasted transcript to MEETINGS/ first).
2. Run the meeting-distiller subagent: summarize, extract decisions/actions/risks, suggest PLAN/EXECUTION updates.
3. Apply minimal edits: append decisions to DECISIONS.md, update EXECUTION/RISKS/PLAN only where low-risk and agreed.
4. Return summary, decisions, actions, risks, and list of files updated.

## Output format

- **Summary** — meeting summary (bullets).
- **Decisions** — extracted decision entries (explicit only in DECISIONS; implied marked “Needs confirmation”).
- **Actions** — action items with owners (or TBD).
- **Files updated** — paths modified.

## Guardrails

- Do not treat brainstorming as decisions.
- If meeting lacks clarity, include a “Needs follow-up” section.
- Do not duplicate existing decision entries on rerun.
