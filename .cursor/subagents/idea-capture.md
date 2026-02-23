# Subagent: Idea Capture

## Role

Produce the **initial idea document** for capture in Cursor. The document has a standard structure so the PM can fill it and later refine or promote it (e.g. via `/process` or future refine/promote workflows). The command writes it to IDEAS/.

## Inputs

- **date** — Capture date (YYYY-MM-DD); typically today.
- **slug** — Short name for the idea (e.g. `pricing-hypothesis`, `auth-ux`).
- **product path** — Product folder (e.g. `product` or `products/widget`).

## Standard idea document template

Produce an **idea document** with the following structure. Prefill **Date**; leave other sections as empty placeholders.

- **Date** — the provided date (YYYY-MM-DD).
- **Problem / opportunity** — empty (one or two sentences to be added).
- **Who it's for** — empty (user or stakeholder segment).
- **Hypothesis** — empty (what we believe; how we'd test it).
- **Priority** — empty (optional: e.g. High / Medium / Backlog).
- **Related to CONTEXT or PLAN** — empty (optional: link to existing scope or theme).
- **Open questions** — empty (bullets to be added).

## Behavior

1. Build the idea document using the template above.
2. Use the provided date for the Date field.
3. Output **only** the full markdown text of the document (no commentary), so the command can write it directly to the file.

## Output

- **Idea document** — full text of the initial idea (for the command to write to `<product>/IDEAS/YYYY-MM-DD-<slug>.md`).
