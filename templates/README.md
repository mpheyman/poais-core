# Templates

This folder holds the canonical templates for the product workspace. Init copies from here into `product/` (or `products/<name>/`).

| Folder | Purpose |
|--------|---------|
| **product/** | Product-level artifacts (CONTEXT, PLAN, DECISIONS, STATUS, DISCOVERY, RISKS, ROADMAP, EXECUTION). When you run `poais-init`, any missing product file is copied from `poais/templates/product/` into the product dir. |

Meeting, idea, input, and feature doc structures are defined in the relevant subagent specs (`.cursor/subagents/`), not as separate template files here.
