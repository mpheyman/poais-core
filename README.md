# poais-core

**poais-core** is the OS distribution of POAIS (Product Operating AI System): a structured, markdown-first operating system for product work. It is intended to be vendored into product repos via **git subtree** and is **built for use with [Cursor](https://cursor.com)** — it utilizes Cursor **commands** (e.g. `/process`, `/align`, `/status`), **rules**, **skills**, and **subagents** so that product work stays aligned and repeatable inside the editor. Every repo is a **portfolio**: products live under `products/<name>/` with a `portfolio/` folder for roll-up.

- **Human-led orchestration** — you decide; AI assists with synthesis and drafting.
- **Inputs are messy** (chat, email, meetings); **outputs are structured** (CONTEXT, PLAN, DECISIONS, STATUS, etc.).
- POAIS does **not** replace execution tools (e.g. GitLab); it is the alignment and intent layer.

## What belongs in a product repo

- Your **product workspace**: **products/** (each product has CONTEXT, PLAN, DECISIONS, STATUS, INPUTS, MEETINGS, IDEAS, FEATURES) and **portfolio/** for roll-up (PRIORITIES, STATUS).
- **poais-core** as a subtree under `poais/` (rules, commands, skills, subagents, templates, tools)
- A **synced** `.cursor/` at repo root (from `poais/.cursor/` via the sync script) so Cursor sees POAIS commands

## Setup

Get POAIS into your project in this order. POAIS Cursor commands are only available after POAIS is in the repo (step 3).

1. **Set up your local project folder** — Create a folder for your portfolio (e.g. `Matthew-Heyman-Portfolio`) and run `git init`, or clone an existing repo. This folder will eventually contain `poais/`, `products/`, and `portfolio/`.

2. **Make at least one commit** — Required for `git subtree add`. If the repo is empty, create a minimal README and commit:  
   `echo "# myportfolio" > README.md` then `git add README.md` and `git commit -m "Initial commit"`.

3. **Run the CLI to add POAIS** — From the project folder (repo root), run the one-liner for your OS. This adds poais-core as a subtree under `poais/`, syncs `.cursor/`, and scaffolds `products/` and `portfolio/`.

   **Mac/Linux / Git Bash:**

   ```bash
   curl -fsSL https://raw.githubusercontent.com/mpheyman/poais-core/main/tools/poais-init.sh | bash -s -- https://github.com/mpheyman/poais-core.git
   ```

   **Windows PowerShell:**

   ```powershell
   $env:POAIS_CORE_REPO_URL = 'https://github.com/mpheyman/poais-core.git'; irm https://raw.githubusercontent.com/mpheyman/poais-core/main/tools/poais-init.ps1 | iex
   ```

   Optional product names (default is product-a, product-b): Mac/Linux append ` widget api` (or your names) after the URL; Windows run `poais\tools\poais-init.ps1 -ProductNames name1,name2` from repo root after the one-liner.  
   *(Replace `mpheyman` with your GitHub org or fork if needed.)*

**After setup:** Open this repo in Cursor. To use POAIS, see [GETTING_STARTED.md](GETTING_STARTED.md). You can also run **`/setup-poais`** in Cursor for a guided next-step menu (only after POAIS is already in the repo).

**More:** Re-scaffold (with `poais/` already present), upgrade, or diagnose: see [tools/README.md](tools/README.md).

## Versioning and upgrading

poais-core uses **Semantic Versioning**. The current release is in [VERSION](VERSION).

**For product repos (vendored users):**

- **Check which version you have:** `cat poais/VERSION`
- **Upgrade to latest:** Commit or stash changes (clean working tree required), then either run **`/upgrade-poais`** in Cursor (Agent mode) or from repo root: `bash poais/tools/poais-upgrade.sh` (Mac/Linux) or `powershell -ExecutionPolicy Bypass -File poais\tools\poais-upgrade.ps1` (Windows). This pulls the latest poais-core and re-syncs `.cursor/`.
- Compare with [CHANGELOG](CHANGELOG.md) to see what's new.

**In the poais-core repo:** Before every push to main we promote "Unreleased" to a version, update [VERSION](VERSION), and commit. Run **`/release`** (or `/release 0.2.0`) in Cursor to do this; see [.cursor/commands/release.md](.cursor/commands/release.md).

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
| [bootstrap/README.md](bootstrap/README.md) | Portfolio scaffold (products/ and portfolio/) |
| [bootstrap/portfolio-repo-skeleton/](bootstrap/portfolio-repo-skeleton/) | Portfolio workspace scaffold |
| [templates/README.md](templates/README.md) | Product doc templates (copied by init) |

## Repo layout (this distribution)

- **VERSION** — Single line: current release (e.g. `0.1.0`); used to detect drift in product repos
- **CHANGELOG.md** — Release history; "Unreleased" is promoted to a version before each push to main
- **.cursor/** — Cursor rules, commands, skills, and subagents (source for sync; Cursor reads from repo root `.cursor/` in product repos). See [.cursor/README.md](.cursor/README.md).
- **templates/** — Product doc templates (copied by init into product workspace); see [templates/README.md](templates/README.md)
- **tools/** — Init, upgrade, doctor, and sync scripts (no Node/Python required); see [tools/README.md](tools/README.md)
- **bootstrap/** — Portfolio scaffold; see [bootstrap/README.md](bootstrap/README.md). Single-product scaffold archived in archive/.
- **archive/** — Legacy or archived content (not part of the distribution)
