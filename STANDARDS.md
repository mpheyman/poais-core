# Standards

- **Every product** must have: CONTEXT, PLAN, EXECUTION, DECISIONS, STATUS. Other artifacts (PRD, DISCOVERY, RISKS, ROADMAP, FEATURES/, MEETINGS/, INPUTS/, IDEAS/) are encouraged and flexible. **PRD** (Product Requirements Document) is the single source of truth for development handoff: requirements for a feature, application, or product that engineering works from; it can be filled and kept in sync from CONTEXT, PLAN, EXECUTION, DECISIONS. ROADMAP has a required Milestones section and is fed by PLAN, EXECUTION, DECISIONS. POAIS repos use **portfolio** layout: product dirs under `products/<name>/` and **portfolio/** with PRIORITIES.md and STATUS.md (roll-up from `/status portfolio`).
- **Decisions** are logged with: Date, Decision, Context, Aligned With, Impact.
- **STATUS** is updated weekly (even if brief).
- **POAIS reflects reality**: if execution diverges from PLAN, update PLAN; if scope changes, log a decision; if risk emerges, add to RISKS.
