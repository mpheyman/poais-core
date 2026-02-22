# Single-product repo scaffold

Use this scaffold to bootstrap a **one-product-per-repo** workspace. The product lives at `product/` (not under `products/<name>/`).

## Recommended: use poais-init

**From an empty repo (one command):** see [README](https://github.com/mpheyman/poais-core#quickstart) — `curl -fsSL ... | bash -s -- <repo-url>` (Mac/Linux) or set `$env:POAIS_CORE_REPO_URL` and `irm ... | iex` (Windows).

From your product repo root when `poais/` already exists, run:

- **macOS/Linux / Git Bash:** `bash poais/tools/poais-init.sh https://github.com/mpheyman/poais-core.git`
- **Windows PowerShell:** `powershell -ExecutionPolicy Bypass -File poais\tools\poais-init.ps1 -RepoUrl https://github.com/mpheyman/poais-core.git`

Init syncs `.cursor/`, copies this scaffold into repo root (safe copy: does not overwrite existing files), ensures INPUTS/MEETINGS/FEATURES and required artifact files exist, and creates/updates `POAIS_LOCK.json`.

## Legacy: manual copy

From your product repo root (after adding poais-core as a subtree under `poais/`):

```bash
cp -R poais/bootstrap/single-product-repo-skeleton/* .
```

Then run the Cursor sync script: `bash poais/tools/sync-cursor-runtime.sh` (or `.ps1` on Windows).

## Example first run

1. Create an input file, e.g. `product/INPUTS/2026-02-22-notes.md`.
2. In Cursor, run: `/process product/INPUTS/2026-02-22-notes.md`

See `poais/.cursor/commands/README.md` for `/distill-meeting`, `/align`, and `/status` syntax. For full PM workflow (new product, feature, or roadmap), see `poais/GETTING_STARTED.md`.
