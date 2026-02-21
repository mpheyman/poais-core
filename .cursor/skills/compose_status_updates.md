# Skill: Compose Status Updates

## Purpose

Generate three levels of status copy from POAIS artifacts: team (detailed), stakeholder (clear), and exec (very concise). Used to update STATUS.md and for comms.

## Inputs

- EXECUTION.md (current focus, progress)
- DECISIONS.md (recent decisions)
- RISKS.md (current risks)
- Optional: ROADMAP.md, portfolio context

## Output format

Produce three drafts:

1. **Team update** — detailed, tactical: what moved, what’s in progress, blockers, next steps. Suitable for team channel or standup.
2. **Stakeholder update** — clear, non-technical: progress, key decisions, risks, asks. Suitable for STATUS.md stakeholder section or email.
3. **Exec summary** — very concise: outcomes, top risk, one or two bullets. No jargon.

Include a **Metric Snapshot** only when real metrics exist in artifacts; otherwise use “Metric Snapshot: TBD” or omit.

## Steps

1. Read EXECUTION, DECISIONS, RISKS (and optional ROADMAP/portfolio).
2. Extract what moved, what changed, blockers, risks.
3. Draft team update (detailed).
4. Draft stakeholder update (clear, scannable).
5. Draft exec summary (minimal).
6. Do not invent progress, metrics, or commitments.

## Guardrails

- **Never invent metrics or progress** — only use what is stated or clearly implied in the artifacts.
- If metrics are missing, say “Metric Snapshot: TBD” or leave out.
- Use Status format (What Moved, What Changed, Blockers, Risks, Metric Snapshot) where applicable.
