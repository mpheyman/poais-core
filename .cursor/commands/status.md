# Command: /status

## Syntax

```
/status <product-folder> [optional week-of YYYY-MM-DD]
```

## Expected arguments

- **product-folder** — Path to the product directory (e.g. `products/widget`) or the literal **`portfolio`**. Product path must exist. For **`portfolio`**, aggregate status across all products (from POAIS_LOCK.json `products`) and write `portfolio/STATUS.md`; fail clearly if no lock or no `products`.
- **week-of** (optional) — Week identifier for the status (e.g. `2026-02-22`). If omitted, use current week or latest from STATUS.md.

## Delegation

Delegates to the **status-composer** subagent.

## Behavior

1. Resolve product-folder and optional week. If product-folder is **`portfolio`** (or path to repo-root `portfolio/`), treat as portfolio roll-up.
2. **Product path:** Run the status-composer subagent on that product’s artifacts; update that product’s STATUS.md with the stakeholder update (and set “Week Of” if week-of provided).
3. **Portfolio:** Run the status-composer subagent with target=portfolio: read all products listed in POAIS_LOCK.json `products`, read optional `portfolio/PRIORITIES.md`, aggregate EXECUTION/DECISIONS/RISKS (and optional ROADMAP) across products, compose one roll-up draft, and write `portfolio/STATUS.md`. Return the drafts and list of files updated.
4. Return all three drafts (team, stakeholder, exec) and list of files updated.

## Output format

- **Team update** — detailed draft.
- **Stakeholder update** — clear draft (written to STATUS.md of the product or to portfolio/STATUS.md for portfolio).
- **Exec summary** — very concise draft.
- **Files updated** — product STATUS.md (e.g. `product/STATUS.md`) or `portfolio/STATUS.md` when target is portfolio.
- When ROADMAP is present: Key dates (roadmap) in stakeholder/exec drafts; optional Roadmap snapshot for email.

## Guardrails

- Never invent metrics or progress. Use “Metric Snapshot: TBD” if metrics are missing.
- Only use information present in POAIS artifacts.
