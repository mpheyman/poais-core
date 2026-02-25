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

- **path-to-input-file** — Path to a file containing messy input (e.g. `products/<name>/INPUTS/YYYY-MM-DD-<slug>.md`, or a path to a meeting doc, email paste, or chat export). Can be relative to repo root or absolute. **Catalogued meeting records** in `products/<name>/MEETINGS/` (output of `/distill-meeting`) are ideal to run through `/process` to extract key data and update DECISIONS, PLAN, EXECUTION, RISKS, PRD (when requirements change).

## Processed (POAIS) block — chunked processing

The PM can keep a **running input file**, add to it over time, and run `/process` repeatedly. Each run processes only **content that has not yet been processed**. Processed content is recorded in a standard block at the end of the file so the next run knows what to skip.

**Location and format:** At the end of the file, a level-2 heading and table maintained by POAIS:

```markdown
## Processed (POAIS)

| Processed at (UTC) | Content processed |
| ------------------ | ------------------ |
| 2026-02-24 14:32   | Lines 1–45         |
| 2026-02-26 09:00   | Lines 46–82        |
```

- **Processed at (UTC)** — ISO date and time of the run (e.g. `YYYY-MM-DD HH:MM`).
- **Content processed** — What was processed this run: line range (e.g. `Lines 1–45`) and optionally section headings (e.g. `Lines 1–45 (§ Intro, § Decisions)`).
- If the file has no `## Processed (POAIS)` block, the entire file (above any such block) is treated as unprocessed. After the first run, append this heading and table with one row.
- **Content** is defined as everything above the first line of the `## Processed (POAIS)` block. Processed ranges are the union of all line ranges in the table. **Unprocessed** = from (last line of the last processed range + 1) through (last line of content).
- To **re-process the entire file**, the PM may delete or clear the `## Processed (POAIS)` block and run `/process` again.

## Delegation

Delegates to the **input-processor** subagent.

## Behavior

1. If the file does not exist, apply path handling above (create parent dir and file; use pasted content if provided, else ask user to paste and rerun).
2. **Determine processed range:** Read the file. Locate `## Processed (POAIS)` (case-sensitive heading). If present, parse the table for line ranges and compute the **unprocessed** range (from the line after the last processed line through the last content line before the block). If no block exists, unprocessed = entire file (all lines before where the block will be appended).
3. **If there is no unprocessed content:** Report clearly (e.g. "No new content to process; everything above the Processed (POAIS) block has already been processed.") and stop. Optionally remind the PM they can clear the Processed block to re-process the whole file.
4. **Extract unprocessed content:** Pass only the unprocessed slice (by line range) to the input-processor subagent. Record the line range (start–end) and optionally section headings for that slice for the new table row.
5. Run the input-processor subagent on that content (not the full file).
6. Subagent produces: summary, extracted items, proposed file edits.
7. Apply only minimal, approved edits (append to DISCOVERY, add decision entries, update RISKS/PLAN/EXECUTION/PRD as agreed). Do not apply large rewrites without explicit approval.
8. **Update the input file:** Append a new row to the Processed (POAIS) table (or create the block and table if missing) with: Processed at (UTC) = current run timestamp; Content processed = the line range (and optional section names) just processed.
9. Return the subagent output, the **processed range** (e.g. "Processed lines 46–82"), and a clear list of files updated.

## Output format

- **Summary** — high-signal bullets from the input (for the chunk processed).
- **Extracted items** — decisions (explicit/implied), risks, scope changes, feature ideas, open questions.
- **Processed this run** — line range (and optional sections) recorded in the Processed (POAIS) block.
- **Files updated** — list of paths actually modified (including the input file if the Processed block was updated).

## Guardrails

- Do not invent outcomes or commitments.
- Implied decisions stay marked “Needs confirmation”; do not add them to DECISIONS without user confirmation.
- Idempotent: on rerun, do not duplicate entries; detect existing and update or skip.
- When updating the Processed (POAIS) block, do not remove or alter existing rows; only append one new row per run.
