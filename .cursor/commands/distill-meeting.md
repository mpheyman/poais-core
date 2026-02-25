# Command: /distill-meeting

## Syntax

```
/distill-meeting <path-to-input-file>
```

## Expected arguments

- **path-to-input-file** — Path to a file containing **raw meeting notes** (e.g. `products/<name>/INPUTS/YYYY-MM-DD-<slug>.md`). This is the single source for raw input: the PM can create a blank .md in INPUTS, jot down notes, then run this command. Path can be relative to repo root or absolute. File must exist; command fails clearly if not.

## Delegation

Delegates to the **meeting-distiller** subagent.

## Behavior

1. Load the file (typically under a product’s INPUTS/, e.g. `products/<name>/INPUTS/`).
2. Run the meeting-distiller subagent: refine and format the raw notes into a standardized meeting document; extract summary, decisions, actions, risks.
3. **Missing metadata:** If attendees, meeting time, agenda, or other standard fields cannot be deduced from the content, ask the PM: *"Do you want to add any of the following before I finalize the meeting record? [list missing items]. You can proceed without—I'll save the refined notes as-is."* Allow proceeding without; do not block.
4. **Derive catalogued path:** Parse the input path. If it contains `/INPUTS/`, the product-root is the path segment before `/INPUTS/` (relative to repo root). Write the **refined meeting document** to `<product-root>/MEETINGS/<basename-of-input>`. Example: `products/widget/INPUTS/2026-02-22-standup.md` → `products/widget/MEETINGS/2026-02-22-standup.md`. Create MEETINGS/ if needed.
5. Return summary, decisions, actions, risks, and the path to the **catalogued meeting file**.
6. **Next step for the PM:** Tell the PM they can run **`/process <catalogued-path>`** on that file to extract key data and update artifacts (DECISIONS, PLAN, EXECUTION, RISKS, etc.).

## Output format

- **Summary** — meeting summary (bullets).
- **Decisions** — extracted decision entries (explicit only in DECISIONS; implied marked "Needs confirmation").
- **Actions** — action items with owners (or TBD).
- **Risks** — any risks or open questions.
- **Catalogued file** — path to the refined meeting record written to MEETINGS/.
- **Files updated** — paths modified (including the new MEETINGS file).

## Guardrails

- Do not treat brainstorming as decisions.
- If meeting lacks clarity, include a "Needs follow-up" section in the refined doc.
- Do not duplicate existing decision entries on rerun.
- Always catalogue the refined meeting to MEETINGS/; INPUTS remains the raw source.
