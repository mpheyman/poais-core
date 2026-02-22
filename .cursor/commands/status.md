# Command: /status

## Syntax

```
/status <product-folder> [optional week-of YYYY-MM-DD]
```

## Expected arguments

- **product-folder** — Path to the product directory (e.g. `product`). Must exist; command fails clearly if not.
- **week-of** (optional) — Week identifier for the status (e.g. `2026-02-22`). If omitted, use current week or latest from STATUS.md.

## Delegation

Delegates to the **status-composer** subagent.

## Behavior

1. Resolve product-folder and optional week.
2. Run the status-composer subagent: compose team, stakeholder, and exec updates from EXECUTION, DECISIONS, RISKS (and optional ROADMAP/portfolio).
3. Update the product folder’s STATUS.md with the stakeholder update (and set “Week Of” if week-of provided).
4. Return all three drafts and list of files updated.

## Output format

- **Team update** — detailed draft.
- **Stakeholder update** — clear draft (written to STATUS.md).
- **Exec summary** — very concise draft.
- **Files updated** — typically the product folder’s STATUS.md (e.g. `product/STATUS.md`).

## Guardrails

- Never invent metrics or progress. Use “Metric Snapshot: TBD” if metrics are missing.
- Only use information present in POAIS artifacts.
