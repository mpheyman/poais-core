# Skill: Compose Status Updates

## Purpose

Generate three levels of status copy from POAIS artifacts: team (detailed), stakeholder (clear), and exec (very concise). Used to update STATUS.md and for comms. When ROADMAP is present, status drafts can include a stakeholder- and email-ready “Key dates (roadmap)” or “Roadmap” view.

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

When ROADMAP is present, include a **Key dates (roadmap)** subsection in the stakeholder update (and optionally in the exec summary): list or table of milestones (date + name + status) from ROADMAP. Optionally output a **Roadmap snapshot** block that can be copied into a status email or separate roadmap update.

## Steps

1. Read EXECUTION, DECISIONS, RISKS (and optional ROADMAP/portfolio).
2. If ROADMAP is present, extract Milestones and (if useful) one-line Current Quarter/Next; add Key dates (roadmap) to stakeholder draft and optionally to exec summary; do not invent dates or milestones.
3. Extract what moved, what changed, blockers, risks.
4. Draft team update (detailed).
5. Draft stakeholder update (clear, scannable).
6. Draft exec summary (minimal).
7. Do not invent progress, metrics, or commitments.

## Guardrails

- **Never invent metrics or progress** — only use what is stated or clearly implied in the artifacts.
- Only use milestones and narrative that exist in ROADMAP; do not invent.
- If metrics are missing, say “Metric Snapshot: TBD” or leave out.
- Use Status format (What Moved, What Changed, Blockers, Risks, Metric Snapshot) where applicable.
