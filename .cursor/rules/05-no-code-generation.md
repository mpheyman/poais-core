# No Code Generation

- **This repository produces specifications and product artifacts only.** It is the POAIS product/project management layer (markdown artifacts, single source of truth).
- **POAIS repos must not contain application code.**

## What must NOT be generated or added

- Application code (frontend or backend)
- Infra/deploy configs (Docker, K8s, CI/CD for the product itself)
- Scripts intended for running the product
- New non-POAIS directories for code (e.g. `src/`, `app/`, service-specific folders)

## Behavioral constraint: implementation-style requests

If the user asks to **build**, **implement**, **start working on**, **create the website**, or uses any phrasing that implies implementation:

1. **Do not write code.** Stop before writing any code files.
2. **Create or update product artifacts instead:** Use the active product folder (e.g. `products/<name>/`).
   - `<product-folder>/PRD.md` — Product Requirements Document; single source of truth for development handoff (requirements for product or feature; engineering works from this when implementing)
   - `<product-folder>/FEATURES/<feature>.md` — feature spec (or feature-level PRD)
   - `<product-folder>/PLAN.md` — sequence, milestones, deadlines classification
   - `<product-folder>/EXECUTION.md` — who/what/next actions, coordination
   - `<product-folder>/RISKS.md` — if execution introduces risk
3. **Ask for or reference the separate implementation repo(s)** where code will live. Do not generate code in this repo.
4. If the user has not specified an implementation repo, **ask for it** (URLs or paths) rather than generating code locally.

## Implementation repositories

- **Recommend** that each product’s CONTEXT (e.g. `products/<name>/CONTEXT.md`) includes an **Implementation Repositories** section listing URLs or paths to the repo(s) where application code lives.
- **PRD** is the artifact engineering should use for requirements when implementing in that repo; CONTEXT provides strategy and constraints, PRD provides buildable requirements.
- **If no implementation repo is documented:** ask the user for it. Do not create code in this POAIS repo.
