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

### One-command initialization (recommended)

From a **brand-new product repo** with at least one initial commit (required for `git subtree`):

**Mac/Linux / Git Bash:**

```bash
curl -fsSL https://raw.githubusercontent.com/mpheyman/poais-core/main/tools/poais-init.sh | bash -s -- https://github.com/mpheyman/poais-core.git
```

**Windows PowerShell:**

```powershell
$env:POAIS_CORE_REPO_URL = 'https://github.com/mpheyman/poais-core.git'; irm https://raw.githubusercontent.com/mpheyman/poais-core/main/tools/poais-init.ps1 | iex
```

*(Replace `mpheyman` with your GitHub org or fork if using a different poais-core repo.)*

If the repo has no commits yet, create one first:

```bash
echo "# myproduct" > README.md
git add README.md
git commit -m "Initial commit"
```

Then run the one-command init above. After it completes: **open the repo in Cursor**, create e.g. `product/INPUTS/YYYY-MM-DD-notes.md`, and run **`/process product/INPUTS/<your-file>.md`**. For meeting jottings, put them in INPUTS and run **`/distill-meeting`** on that file (refines and catalogues to MEETINGS/), then **`/process`** on the MEETINGS file to update artifacts. Once setup is complete, see **[GETTING_STARTED.md](GETTING_STARTED.md)** for where to start and the expected workflow. See [.cursor/commands/README.md](.cursor/commands/README.md) for `/distill-meeting`, `/align`, `/status`.

### Initialize using local poais (legacy)

If you already have `poais/` (e.g. from a previous subtree add):

- **macOS/Linux:** `bash poais/tools/poais-init.sh https://github.com/mpheyman/poais-core.git`
- **Windows:** `powershell -ExecutionPolicy Bypass -File poais\tools\poais-init.ps1 -RepoUrl https://github.com/mpheyman/poais-core.git`

### Upgrade poais-core in an existing product repo

- Ensure your working tree is clean (commit or stash changes).
- **macOS/Linux / Git Bash:** `bash poais/tools/poais-upgrade.sh https://github.com/mpheyman/poais-core.git`  
  *(URL optional if `POAIS_LOCK.json` exists.)*
- **Windows PowerShell:** `powershell -ExecutionPolicy Bypass -File poais\tools\poais-upgrade.ps1 -RepoUrl https://github.com/mpheyman/poais-core.git`  
  *(Re-run `.cursor` sync is automatic as part of upgrade.)*

### Diagnose issues

- **macOS/Linux / Git Bash:** `bash poais/tools/poais-doctor.sh`
- **Windows PowerShell:** `powershell -ExecutionPolicy Bypass -File poais\tools\poais-doctor.ps1`

Doctor reports OK / WARN / FAIL and prints exact fix commands (sync, init, upgrade, or create missing files).

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
| [INSTALL_SUBTREE.md](INSTALL_SUBTREE.md) | Subtree add/update and mandatory `.cursor` sync |
| [tools/poais-init.sh](tools/poais-init.sh) | Init script (macOS/Linux/Git Bash) |
| [tools/poais-init.ps1](tools/poais-init.ps1) | Init script (Windows PowerShell) |
| [tools/poais-upgrade.sh](tools/poais-upgrade.sh) | Upgrade script (macOS/Linux/Git Bash) |
| [tools/poais-upgrade.ps1](tools/poais-upgrade.ps1) | Upgrade script (Windows PowerShell) |
| [tools/poais-doctor.sh](tools/poais-doctor.sh) | Diagnostics (macOS/Linux/Git Bash) |
| [tools/poais-doctor.ps1](tools/poais-doctor.ps1) | Diagnostics (Windows PowerShell) |
| [tools/sync-cursor-runtime.sh](tools/sync-cursor-runtime.sh) | Sync script (macOS/Linux/Git Bash) |
| [tools/sync-cursor-runtime.ps1](tools/sync-cursor-runtime.ps1) | Sync script (Windows PowerShell) |
| [.cursor/commands/README.md](.cursor/commands/README.md) | POAIS command reference |
| [bootstrap/single-product-repo-skeleton/](bootstrap/single-product-repo-skeleton/) | Single-product workspace scaffold |

## Repo layout (this distribution)

- **VERSION** — Single line: current release (e.g. `0.1.0`); used to detect drift in product repos
- **CHANGELOG.md** — Release history; "Unreleased" is promoted to a version before each push to main
- **.cursor/** — Rules, commands, skills, subagents (source for sync; Cursor reads from repo root `.cursor/` in product repos)
- **templates/** — Product/feature/meeting doc templates
- **tools/** — Init, upgrade, doctor, and sync scripts (no Node/Python required)
- **bootstrap/** — Single-product scaffold to copy into new repos
- **archive/** — Legacy or archived content (not part of the distribution)
