# Dates and Deadlines

- **Always normalize dates to ISO: YYYY-MM-DD.**

- **Ambiguous or short dates** (e.g. `3/1/25`):
  - Flag ambiguity and request confirmation.
  - Never assume a past date is intended.

- **Deadline classification** (use these exact labels):
  - **Confirmed deadline** — explicitly agreed/committed.
  - **Requested deadline** — stakeholder demand, not yet accepted.
  - **Target** — internal goal.
  - **Constraint** — external dependency.

- **Where to record:**
  - **PLAN.md** — Timeline/Milestones section with ISO dates and classification.
  - **ROADMAP.md** — Milestones section: use same deadline classification (Confirmed/Target/Requested/At risk).
  - **RISKS.md** — schedule risk if deadline is aggressive or uncertain.
  - **DECISIONS.md** — only when the team explicitly commits/accepts a deadline.
