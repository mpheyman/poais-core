# Command: /process

## Syntax

```
/process <path-to-input-file>
```

## Path handling

If the provided `<path-to-input-file>` does not exist:

1. If the parent directory does not exist, create it.
2. Create the file.
3. If the user has provided input text in chat, write it into the file and proceed.
4. If no input text is provided, stop and ask the user to paste content into the newly created file, then rerun /process.

## Expected arguments

- **path-to-input-file** — Path to a file containing messy input (e.g. `product/INPUTS/YYYY-MM-DD-<slug>.md`, or a path to a meeting doc, email paste, or chat export). Can be relative to repo root or absolute. **Catalogued meeting records** in `product/MEETINGS/` (output of `/distill-meeting`) are ideal to run through `/process` to extract key data and update DECISIONS, PLAN, EXECUTION, RISKS.

## Delegation

Delegates to the **input-processor** subagent.

## Behavior

1. If the file does not exist, apply path handling above (create parent dir and file; use pasted content if provided, else ask user to paste and rerun).
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
