# poais-core

**poais-core** is the OS distribution of POAIS (Product Operating AI System): a structured, markdown-first operating system for product work. It is intended to be vendored into product repos via **git subtree** and is **built for use with [Cursor](https://cursor.com)** — it utilizes Cursor **commands** (e.g. `/process`, `/align`, `/status`), **rules**, **skills**, and **subagents** so that product work stays aligned and repeatable inside the editor. **Single product (default):** one workspace at `product/`. **Portfolio:** multiple products at `products/<name>/`; run init with portfolio mode.

- **Human-led orchestration** — you decide; AI assists with synthesis and drafting.
- **Inputs are messy** (chat, email, meetings); **outputs are structured** (CONTEXT, PLAN, DECISIONS, STATUS, etc.).
- POAIS does **not** replace execution tools (e.g. GitLab); it is the alignment and intent layer.

## What belongs in a product repo

- Your **product workspace** at `product/` (single-product) or **products/** plus optional **portfolio/** (multi-product). Each product has CONTEXT, PLAN, DECISIONS, STATUS, INPUTS, MEETINGS, IDEAS, FEATURES.
- **poais-core** as a subtree under `poais/` (rules, commands, skills, subagents, templates, tools)
- A **synced** `.cursor/` at repo root (from `poais/.cursor/` via the sync script) so Cursor sees POAIS commands

## Quickstart

**Preferred:** Open your product repo in Cursor and run **`/setup-poais`**. The agent will check your repo, ask layout (single vs portfolio) and options, run init, then guide you to the next step. No need to run commands from the docs.

**CLI option:** From the product repo root (with at least one commit): run the one-liner below. Then open the repo in Cursor; see [GETTING_STARTED.md](GETTING_STARTED.md) for workflow.

**Mac/Linux / Git Bash:**

```bash
curl -fsSL https://raw.githubusercontent.com/mpheyman/poais-core/main/tools/poais-init.sh | bash -s -- https://github.com/mpheyman/poais-core.git
```

**Windows PowerShell:**

```powershell
$env:POAIS_CORE_REPO_URL = 'https://github.com/mpheyman/poais-core.git'; irm https://raw.githubusercontent.com/mpheyman/poais-core/main/tools/poais-init.ps1 | iex
```

*(Replace `mpheyman` with your GitHub org or fork if needed.)* No commit yet? Create one: `echo "# myproduct" > README.md` then `git add README.md` and `git commit -m "Initial commit"`.

**More:** Re-scaffold or portfolio (with `poais/` already present), upgrade, or diagnose: see [tools/README.md](tools/README.md) for init/upgrade/doctor usage.

### Manual install (legacy)

Without using the init script:

| Step | Action |
|------|--------|
| Add poais-core | `git subtree add --prefix=poais https://github.com/mpheyman/poais-core.git main --squash` |
| Copy scaffold | `cp -R poais/bootstrap/single-product-repo-skeleton/* .` |
| Sync .cursor | `bash poais/tools/sync-cursor-runtime.sh` (or `.ps1` on Windows) |
| Update later | `git subtree pull --prefix=poais https://github.com/mpheyman/poais-core.git main --squash` then re-run sync |

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
| [GitHub — mpheyman/poais-core](https://github.com/mpheyman/poais-core) | Repo root |
| [VERSION](VERSION) | Current release version (single line) |
| [CHANGELOG.md](CHANGELOG.md) | Release history and unreleased changes |
| [VISION.md](VISION.md) | Vision and role of poais-core |
| [GETTING_STARTED.md](GETTING_STARTED.md) | PM workflow: where to start, artifacts, commands |
| [STANDARDS.md](STANDARDS.md) | Product standards: required artifacts, decisions, STATUS, POAIS reflects reality |
| [.cursor/README.md](.cursor/README.md) | Cursor runtime index: commands, rules, subagents, skills |
| [.cursor/commands/README.md](.cursor/commands/README.md) | POAIS command reference and syntax |
| [tools/README.md](tools/README.md) | Init, upgrade, doctor, sync scripts (purpose and usage) |
| [tools/poais-init.sh](tools/poais-init.sh) | Init script (macOS/Linux/Git Bash) |
| [tools/poais-init.ps1](tools/poais-init.ps1) | Init script (Windows PowerShell) |
| [tools/poais-upgrade.sh](tools/poais-upgrade.sh) | Upgrade script (macOS/Linux/Git Bash) |
| [tools/poais-upgrade.ps1](tools/poais-upgrade.ps1) | Upgrade script (Windows PowerShell) |
| [tools/poais-doctor.sh](tools/poais-doctor.sh) | Diagnostics (macOS/Linux/Git Bash) |
| [tools/poais-doctor.ps1](tools/poais-doctor.ps1) | Diagnostics (Windows PowerShell) |
| [tools/sync-cursor-runtime.sh](tools/sync-cursor-runtime.sh) | Sync script (macOS/Linux/Git Bash) |
| [tools/sync-cursor-runtime.ps1](tools/sync-cursor-runtime.ps1) | Sync script (Windows PowerShell) |
| [bootstrap/README.md](bootstrap/README.md) | Bootstrap skeletons (single-product and portfolio) |
| [bootstrap/single-product-repo-skeleton/](bootstrap/single-product-repo-skeleton/) | Single-product workspace scaffold |
| [bootstrap/portfolio-repo-skeleton/](bootstrap/portfolio-repo-skeleton/) | Portfolio workspace scaffold |
| [templates/README.md](templates/README.md) | Product doc templates (copied by init) |

## Repo layout (this distribution)

- **VERSION** — Single line: current release (e.g. `0.1.0`); used to detect drift in product repos
- **CHANGELOG.md** — Release history; "Unreleased" is promoted to a version before each push to main
- **.cursor/** — Cursor rules, commands, skills, and subagents (source for sync; Cursor reads from repo root `.cursor/` in product repos). See [.cursor/README.md](.cursor/README.md).
- **templates/** — Product doc templates (copied by init into product workspace); see [templates/README.md](templates/README.md)
- **tools/** — Init, upgrade, doctor, and sync scripts (no Node/Python required); see [tools/README.md](tools/README.md)
- **bootstrap/** — Single-product and portfolio scaffolds; see [bootstrap/README.md](bootstrap/README.md)
- **archive/** — Legacy or archived content (not part of the distribution)
