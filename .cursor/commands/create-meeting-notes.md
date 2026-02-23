# Command: /create-meeting-notes

## Syntax

```
/create-meeting-notes [product-folder] [slug]
```

## Expected arguments

- **product-folder** (optional) — Path to the product directory (e.g. `product`, `product/`, or `products/widget`). Default: read POAIS_LOCK.json — use `workspace_root` (single-product) or first entry in `products[]` (portfolio). If no lock or unreadable, use `product`.
- **slug** (optional) — Short name for the meeting (e.g. `sprint-review`, `standup`). Default: `meeting`. Date is always today (YYYY-MM-DD); filename becomes `YYYY-MM-DD-<slug>.md`.

## Path resolution

1. If the first argument looks like a product path (e.g. `product`, `product/`, `products/foo`), treat it as product-folder and the second argument as slug.
2. If only one argument is given and it looks like a product path, use it as product-folder and slug = default.
3. If only one argument is given and it does not look like a product path (no slash or single word that could be a slug), use default product path and treat the argument as slug.
4. If no arguments: read POAIS_LOCK.json for default product; slug = default.
5. Target path: `<product>/MEETINGS/YYYY-MM-DD-<slug>.md`. Create MEETINGS/ if it does not exist.

## Delegation

Delegates to the **meeting-notes-creator** subagent to produce the initial document content.

## Behavior

1. Resolve product path (explicit arg, else POAIS_LOCK, else `product`).
2. Date = today (YYYY-MM-DD); slug = provided or default (`meeting`).
3. Target path: `<product>/MEETINGS/YYYY-MM-DD-<slug>.md`. Create MEETINGS/ if missing.
4. Run the meeting-notes-creator subagent with (date, slug, product path); subagent returns the initial markdown.
5. Write the subagent output to the target file.
6. Return the path and: "Run `/process <path>` after the meeting to extract decisions and update artifacts."

## Output format

- **File created** — path to the new meeting-notes file in MEETINGS/.
- **Next step** — reminder to run `/process <path>` after the meeting.

## Guardrails

- Do not overwrite an existing file without asking; if the file exists, suggest a different slug or date.
- Product path must exist (product/ or products/<name>/); fail clearly if not.
