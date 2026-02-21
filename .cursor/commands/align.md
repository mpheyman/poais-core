# Command: /align

## Syntax

```
/align <product-folder>
```

## Expected arguments

- **product-folder** — Path to the product directory (e.g. `products/my-product` or `products/my-product/`). Must contain CONTEXT.md, PLAN.md, EXECUTION.md, DECISIONS.md.

## Delegation

Delegates to the **alignment-checker** subagent.

## Behavior

1. Resolve product-folder path (relative to repo root or cwd).
2. Run the alignment-checker subagent on that product’s artifacts (and optionally ROADMAP, portfolio/PRIORITIES).
3. Subagent produces an Alignment Report and proposed edits.
4. Auto-apply only low-risk consistency fixes (e.g. link, heading). All other fixes are suggested only.
5. Return the report, suggested edits, and list of files updated (if any).

## Output format

- **Alignment Report** — misalignments, missing reflections, stale artifacts, questions PM should ask.
- **Suggested edits** — full list of proposed corrections (file + section + change).
- **Files updated** — paths of files modified by auto-applied low-risk fixes.

## Guardrails

- No stage gating. No heavy rewrites.
- Prefer questions + suggested edits over automatic content changes.
