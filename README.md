# poais-core

**poais-core** is the OS distribution of POAIS (Product Operating AI System): a structured, markdown-first operating system for product work. It is intended to be vendored into product repos via **git subtree** and used with Cursor (one product per repo).

- **Human-led orchestration** — you decide; AI assists with synthesis and drafting.
- **Inputs are messy** (chat, email, meetings); **outputs are structured** (CONTEXT, PLAN, DECISIONS, STATUS, etc.).
- POAIS does **not** replace execution tools (e.g. GitLab); it is the alignment and intent layer.

## What belongs in a product repo

- Your **product workspace** at `product/` (CONTEXT, PLAN, DECISIONS, STATUS, INPUTS, MEETINGS, FEATURES)
- **poais-core** as a subtree under `poais/` (rules, commands, skills, subagents, templates, tools)
- A **synced** `.cursor/` at repo root (from `poais/.cursor/` via the sync script) so Cursor sees POAIS commands

## Quickstart

1. **Create a product repo** (or use an existing one).
2. **Add poais-core via subtree** into `poais/`:
   ```bash
   git subtree add --prefix=poais <POAIS_CORE_REPO_URL> main --squash
   ```
3. **Run the sync script** to install `.cursor/` at repo root (required — Cursor only reads `.cursor/` at root):
   - macOS/Linux / Git Bash: `bash poais/tools/sync-cursor-runtime.sh`
   - Windows PowerShell: `powershell -ExecutionPolicy Bypass -File poais\tools\sync-cursor-runtime.ps1`
4. **Copy the bootstrap scaffold** into repo root:
   ```bash
   cp -R poais/bootstrap/single-product-repo-skeleton/* .
   ```
   This creates `product/` with the standard artifact files and INPUTS/MEETINGS/FEATURES folders.
5. **Use POAIS in Cursor**: `/process`, `/distill`, `/align`, `/status` — see [.cursor/commands/README.md](.cursor/commands/README.md).

## Versioning

poais-core uses **Semantic Versioning**. The current release is in [VERSION](VERSION). Before every push to main we:

1. Move "Unreleased" in [CHANGELOG.md](CHANGELOG.md) into a new `## [X.Y.Z] - YYYY-MM-DD` section.
2. Update [VERSION](VERSION) to that number.
3. Commit all changes with a message that includes the version and a short description (e.g. first line `Release vX.Y.Z`, then a one-line summary from the Unreleased bullets). The release commit includes CHANGELOG.md, VERSION, and any other modified or new files.
4. Push to main.

In the poais-core repo you can run **`/release`** (or `/release 0.2.0`) in Cursor to do these steps and push to main; see [.cursor/commands/release.md](.cursor/commands/release.md).

Product repos can check which version they have after a subtree pull:

```bash
cat poais/VERSION
```

Compare with the [poais-core releases / CHANGELOG](CHANGELOG.md) to avoid drift.

## Links

| Resource | Description |
|----------|-------------|
| [VERSION](VERSION) | Current release version (single line) |
| [CHANGELOG.md](CHANGELOG.md) | Release history and unreleased changes |
| [INSTALL_SUBTREE.md](INSTALL_SUBTREE.md) | Subtree add/update and mandatory `.cursor` sync |
| [tools/sync-cursor-runtime.sh](tools/sync-cursor-runtime.sh) | Sync script (macOS/Linux/Git Bash) |
| [tools/sync-cursor-runtime.ps1](tools/sync-cursor-runtime.ps1) | Sync script (Windows PowerShell) |
| [.cursor/commands/README.md](.cursor/commands/README.md) | POAIS command reference |
| [bootstrap/single-product-repo-skeleton/](bootstrap/single-product-repo-skeleton/) | Single-product workspace scaffold |

## Repo layout (this distribution)

- **VERSION** — Single line: current release (e.g. `0.1.0`); used to detect drift in product repos
- **CHANGELOG.md** — Release history; "Unreleased" is promoted to a version before each push to main
- **.cursor/** — Rules, commands, skills, subagents (source for sync; Cursor reads from repo root `.cursor/` in product repos)
- **templates/** — Product/feature/meeting doc templates
- **tools/** — Sync scripts for copying `.cursor/` to product repo root
- **bootstrap/** — Single-product scaffold to copy into new repos
- **archive/** — Legacy or archived content (not part of the distribution)
