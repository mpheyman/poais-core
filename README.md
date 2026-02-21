# poais-core

**poais-core** is the OS distribution of POAIS (Product Operating AI System): a structured, markdown-first operating system for product work. It is intended to be vendored into many product repos via **git subtree** and used with Cursor.

- **Human-led orchestration** — you decide; AI assists with synthesis and drafting.
- **Inputs are messy** (chat, email, meetings); **outputs are structured** (CONTEXT, PLAN, DECISIONS, STATUS, etc.).
- POAIS does **not** replace execution tools (e.g. GitLab); it is the alignment and intent layer.

## What belongs in product repos

- Your **product data**: `products/<product>/`, optional `portfolio/`, `shared/`
- **poais-core** as a subtree under `poais/` (rules, commands, skills, subagents, templates, tools)
- A **synced** `.cursor/` at repo root (copied from `poais/.cursor/` by the sync script) so Cursor sees POAIS commands

## Quickstart

1. **Create a product repo** (or use an existing one).
2. **Add poais-core via subtree** into `/poais`:
   ```bash
   git subtree add --prefix=poais <POAIS_CORE_REPO_URL> main --squash
   ```
3. **Run the sync script** to install `.cursor/` at repo root (required — Cursor only reads `.cursor/` at root):
   - macOS/Linux / Git Bash: `bash poais/tools/sync-cursor-runtime.sh`
   - Windows PowerShell: `powershell -ExecutionPolicy Bypass -File poais\tools\sync-cursor-runtime.ps1`
4. **Copy the bootstrap skeleton** from `poais/bootstrap/product-repo-skeleton/` into your repo (e.g. `products/<product-name>/`), then rename `<product-name>` to your product.
5. **Use POAIS in Cursor**: `/process`, `/distill`, `/align`, `/status` — see [.cursor/commands/README.md](.cursor/commands/README.md).

## Links

| Resource | Description |
|----------|-------------|
| [INSTALL_SUBTREE.md](INSTALL_SUBTREE.md) | Exact subtree add/update commands and mandatory `.cursor` sync step |
| [tools/sync-cursor-runtime.sh](tools/sync-cursor-runtime.sh) | Sync script (macOS/Linux/Git Bash) |
| [tools/sync-cursor-runtime.ps1](tools/sync-cursor-runtime.ps1) | Sync script (Windows PowerShell) |
| [.cursor/commands/README.md](.cursor/commands/README.md) | POAIS command reference |
| [bootstrap/product-repo-skeleton/](bootstrap/product-repo-skeleton/) | Starter product folder structure |

## Repo layout (this distribution)

- **.cursor/** — Rules, commands, skills, subagents (source for sync; Cursor reads from repo root `.cursor/` in product repos)
- **templates/** — Product/feature/meeting doc templates
- **tools/** — Sync scripts for copying `.cursor/` to product repo root
- **bootstrap/** — Product-repo skeleton to copy into new repos
- **archive/** — Archived product-instance content (not part of the distribution)
