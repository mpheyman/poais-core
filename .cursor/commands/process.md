# Command: /process

## Syntax

```
/process <path-to-input-file>
```

## Expected arguments

- **path-to-input-file** — Path to a file containing messy input (e.g. `products/my-product/INPUTS/notes.md`, or a path to a meeting doc, email paste, or chat export). Can be relative to repo root or absolute.

## Delegation

Delegates to the **input-processor** subagent.

## Behavior

1. Validate that the file exists (or that the user provides pasted content; if pasted, prompt to save to INPUTS first or use a temp path).
2. Run the input-processor subagent on the file (or content).
3. Subagent produces: summary, extracted items, proposed file edits.
4. Apply only minimal, approved edits (append to DISCOVERY, add decision entries, update RISKS/PLAN/EXECUTION as agreed). Do not apply large rewrites without explicit approval.
5. Return the subagent output plus a clear list of files updated.

## Output format

- **Summary** — high-signal bullets from the input.
- **Extracted items** — decisions (explicit/implied), risks, scope changes, feature ideas, open questions.
- **Files updated** — list of paths actually modified.

## Guardrails

- Do not invent outcomes or commitments.
- Implied decisions stay marked “Needs confirmation”; do not add them to DECISIONS without user confirmation.
- Idempotent: on rerun, do not duplicate entries; detect existing and update or skip.
