# Skill: Alignment Check

## Purpose

Compare CONTEXT, PLAN, EXECUTION, DECISIONS, and optionally ROADMAP and portfolio PRIORITIES to detect misalignment, missing reflections, and stale artifacts. Output an alignment report and suggested corrections.

## Inputs

- Path to product folder (or contents of):
  - CONTEXT.md
  - PLAN.md
  - EXECUTION.md
  - DECISIONS.md
  - Optional: PRD.md (Product Requirements Document; when present, check PRD scope vs PLAN, EXECUTION vs PRD requirements)
- Optional: ROADMAP.md, portfolio/PRIORITIES.md (when ROADMAP is present, read and check it).

## Output format

**Alignment Report** containing:

1. **Misalignments** — e.g. EXECUTION contradicts PLAN; DECISIONS not reflected in PLAN; PRD scope vs PLAN scope when PRD is present.
2. **Missing reflections** — e.g. decision logged but PLAN or EXECUTION not updated; requirement in input/decisions not reflected in PRD.
3. **Stale artifacts** — e.g. STATUS not updated in >7 days (if dates available); outdated sections; PRD out of sync with CONTEXT/PLAN.
4. **ROADMAP alignment** — when ROADMAP is present: missing or inconsistent milestones vs PLAN/EXECUTION/DECISIONS; suggested ROADMAP edits (e.g. add row, update date/status).
5. **Suggested corrections** — specific, minimal edits (file + section + proposed change).
6. **Questions PM should ask** — clarifications for stakeholders/team to resolve ambiguity.

## Steps

1. Read CONTEXT, PLAN, EXECUTION, DECISIONS (and optional PRD, ROADMAP, PRIORITIES).
2. Check EXECUTION vs PLAN (scope, sequence, milestones). When PRD is present, check PRD scope vs PLAN; check EXECUTION vs PRD requirements.
3. Check DECISIONS vs PLAN/EXECUTION (decisions reflected?). When PRD is present, check whether scope/requirement decisions are reflected in PRD.
4. When ROADMAP is present, check ROADMAP Milestones vs PLAN, EXECUTION, and DECISIONS: missing key dates in ROADMAP, or dates/milestones that contradict other artifacts.
5. Check for stale dates or obviously outdated content. When PRD is present, check PRD is in sync with CONTEXT/PLAN.
6. List misalignments, missing reflections, stale artifacts, and (when present) ROADMAP alignment issues.
7. Propose minimal fixes; list questions for the PM. ROADMAP edits are proposed, not auto-applied, unless trivial (e.g. fixing a heading).
8. Only auto-apply low-risk consistency fixes (e.g. link, heading); otherwise propose and wait.

## Guardrails

- No stage gating or heavy rewrites.
- Prefer questions + suggested edits over automatic large changes.
- Only auto-apply when change is low-risk and purely consistency (e.g. adding a reference, fixing a heading).
