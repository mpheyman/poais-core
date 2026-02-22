# Single-product repo scaffold

Use this scaffold to bootstrap a **one-product-per-repo** workspace. The product lives at `product/` (not under `products/<name>/`).

## Copy into your product repo

From your product repo root (after adding poais-core as a subtree under `poais/`):

```bash
cp -R poais/bootstrap/single-product-repo-skeleton/* .
```

This creates `product/` at repo root with CONTEXT, PLAN, DECISIONS, STATUS, and the standard subfolders.

## After subtree add or pull

Run the `.cursor` sync script so Cursor sees POAIS commands:

- **macOS/Linux / Git Bash:** `bash poais/tools/sync-cursor-runtime.sh`
- **Windows PowerShell:** `powershell -ExecutionPolicy Bypass -File poais\tools\sync-cursor-runtime.ps1`

## Example first run

1. Create an input file, e.g. `product/INPUTS/2026-02-22-notes.md`.
2. In Cursor, run: `/process product/INPUTS/2026-02-22-notes.md`

See `poais/.cursor/commands/README.md` for `/distill`, `/align`, and `/status` syntax.
