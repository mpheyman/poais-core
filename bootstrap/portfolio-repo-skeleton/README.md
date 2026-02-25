# Portfolio repo scaffold

Use this scaffold to bootstrap a **multi-product (portfolio)** workspace. Products live under `products/<name>/`; optional `portfolio/` at repo root holds PRIORITIES and STATUS roll-up. POAIS is built for [Cursor](https://cursor.com) (commands, rules, skills, subagents); run workflows in Cursor.

## Recommended: use poais-init with portfolio mode

From your product repo root when `poais/` already exists, run:

- **macOS/Linux / Git Bash:** `bash poais/tools/poais-init.sh --layout=portfolio [product-a product-b ...]`
- **Windows PowerShell:** `powershell -ExecutionPolicy Bypass -File poais\tools\poais-init.ps1 -Layout Portfolio [-ProductNames product-a,product-b]`

If you omit product names, init uses the default from this skeleton (`product-a`, `product-b`). Init copies this scaffold (products/ and portfolio/), ensures each product has required dirs and files, and writes `POAIS_LOCK.json` with `products` and `portfolio`.

## Layout

- `products/product-a/`, `products/product-b/` — each has CONTEXT, PLAN, EXECUTION, DECISIONS, STATUS, PRD (optional), DISCOVERY, RISKS, ROADMAP, INPUTS/, MEETINGS/, FEATURES/, IDEAS/.
- `portfolio/PRIORITIES.md` — product priorities and themes.
- `portfolio/STATUS.md` — roll-up written by `/status portfolio`.

## Commands

- `/align products/<name>` — align one product.
- `/status products/<name>` — status for one product.
- `/status portfolio` — aggregate status across all products; writes `portfolio/STATUS.md`.
- `/process products/<name>/INPUTS/...`, `/distill-meeting products/<name>/INPUTS/...` — same as single-product, with product path.

Adding POAIS to the repo is done via the CLI (see [README Setup](../../README.md#setup)). After POAIS is present, run **`/setup-poais`** in Cursor for guided next steps (including portfolio). See `poais/.cursor/commands/README.md` and `poais/GETTING_STARTED.md` for portfolio workflow.
