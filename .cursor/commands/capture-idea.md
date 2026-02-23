# Command: /capture-idea

## Syntax

```
/capture-idea [product-folder] [slug]
```

## Expected arguments

- **product-folder** (optional) — Path to the product directory (e.g. `product`, `product/`, or `products/widget`). Default: read POAIS_LOCK.json — use `workspace_root` (single-product) or first entry in `products[]` (portfolio). If no lock or unreadable, use `product`.
- **slug** (optional) — Short name for the idea (e.g. `pricing-hypothesis`, `auth-ux`). Default: `idea`. Date is always today (YYYY-MM-DD); filename becomes `YYYY-MM-DD-<slug>.md`.

## Path resolution

1. If the first argument looks like a product path (e.g. `product`, `product/`, `products/foo`), treat it as product-folder and the second argument as slug.
2. If only one argument is given and it looks like a product path, use it as product-folder and slug = default.
3. If only one argument is given and it does not look like a product path, use default product path and treat the argument as slug.
4. If no arguments: read POAIS_LOCK.json for default product; slug = default.
5. Target path: `<product>/IDEAS/YYYY-MM-DD-<slug>.md`. Create IDEAS/ if it does not exist.

## Delegation

Delegates to the **idea-capture** subagent to produce the initial idea document content.

## Behavior

1. Resolve product path (explicit arg, else POAIS_LOCK, else `product`).
2. Date = today (YYYY-MM-DD); slug = provided or default (`idea`).
3. Target path: `<product>/IDEAS/YYYY-MM-DD-<slug>.md`. Create IDEAS/ if missing.
4. Run the idea-capture subagent with (date, slug, product path); subagent returns the initial markdown.
5. Write the subagent output to the target file.
6. Return the path and: "Refine or promote later with `/process <path>` or a future refine/promote workflow."

## Output format

- **File created** — path to the new idea file in IDEAS/.
- **Next step** — reminder to use `/process <path>` or future workflows to refine or promote.

## Guardrails

- Do not overwrite an existing file without asking; if the file exists, suggest a different slug or date.
- Product path must exist (product/ or products/<name>/); fail clearly if not.
