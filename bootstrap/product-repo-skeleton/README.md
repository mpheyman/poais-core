# Product repo skeleton

Use this skeleton to start a new product repo that uses POAIS (poais-core).

## Steps

1. **Rename `<product-name>`**  
   Replace the folder `products/product-name/` with your product name (e.g. `products/my-app/`). Use lowercase, hyphenated names.

2. **Copy into your product repo**  
   Copy the contents of this `bootstrap/product-repo-skeleton/` into your product repo root (e.g. copy `products/` and any other top-level folders you need).

3. **Add poais-core via subtree**  
   From your product repo root, add poais-core as a subtree under `poais/` (see [INSTALL_SUBTREE.md](../../INSTALL_SUBTREE.md) in the poais-core repo).

4. **Sync Cursor runtime**  
   Run the sync script so `.cursor/` is installed at your repo root (required for Cursor to see POAIS commands):
   - macOS/Linux: `bash poais/tools/sync-cursor-runtime.sh`
   - Windows PowerShell: `powershell -ExecutionPolicy Bypass -File poais\tools\sync-cursor-runtime.ps1`

5. **Use POAIS in Cursor**  
   Use the commands in Cursor: `/process`, `/distill`, `/align`, `/status`. See `poais/.cursor/commands/README.md` for syntax.

## What’s in the skeleton

- **products/product-name/** — One product folder with:
  - CONTEXT.md, DISCOVERY.md, PLAN.md, EXECUTION.md, DECISIONS.md, RISKS.md, ROADMAP.md, STATUS.md
  - FEATURES/, MEETINGS/, INPUTS/ (empty; add files as you go)

You can add more products by copying the `product-name` folder and renaming it. You can also add `portfolio/` and `shared/` at repo root if you use portfolio-level POAIS (see poais-core docs).
