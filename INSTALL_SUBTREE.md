# Installing and updating poais-core via git subtree

Use these steps in a **product repo**. Repo: **https://github.com/mpheyman/poais-core**

## Golden path: init once, upgrade as needed

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

**Requirement:** The repo must have at least one commit. If not:

```bash
echo "# myproduct" > README.md
git add README.md
git commit -m "Initial commit"
```

Then run the one-command init. **After init:** open the repo in Cursor and run e.g. `/process product/INPUTS/YYYY-MM-DD-notes.md`.

### Initialize using local poais (legacy)

If you already have `poais/` in the repo:

- **macOS/Linux:** `bash poais/tools/poais-init.sh https://github.com/mpheyman/poais-core.git`
- **Windows:** `powershell -ExecutionPolicy Bypass -File poais\tools\poais-init.ps1 -RepoUrl https://github.com/mpheyman/poais-core.git`

### Upgrade poais-core in an existing product repo

- Ensure working tree is clean (commit or stash).
- **macOS/Linux / Git Bash:** `bash poais/tools/poais-upgrade.sh https://github.com/mpheyman/poais-core.git`  
  *(URL optional if `POAIS_LOCK.json` exists.)*
- **Windows PowerShell:** `powershell -ExecutionPolicy Bypass -File poais\tools\poais-upgrade.ps1 -RepoUrl https://github.com/mpheyman/poais-core.git`

Upgrade runs `git subtree pull` and re-syncs `.cursor/` automatically. It does not overwrite your `product/` artifacts.

### Diagnose issues

- **macOS/Linux / Git Bash:** `bash poais/tools/poais-doctor.sh`
- **Windows PowerShell:** `powershell -ExecutionPolicy Bypass -File poais\tools\poais-doctor.ps1`

Doctor checks: git repo, `poais/`, `poais/.cursor`, root `.cursor/`, `product/`, required dirs (INPUTS, MEETINGS, FEATURES), required files, `POAIS_LOCK.json`. It prints OK/WARN/FAIL and exact fix commands.

---

## Manual steps (legacy)

If you prefer not to use the scripts:

| Step | Command / action |
|------|------------------|
| Add poais-core | `git subtree add --prefix=poais https://github.com/mpheyman/poais-core.git main --squash` |
| Copy workspace scaffold | `cp -R poais/bootstrap/single-product-repo-skeleton/* .` |
| Sync .cursor to root | `bash poais/tools/sync-cursor-runtime.sh` (or `.ps1` on Windows) |
| Update poais-core | `git subtree pull --prefix=poais https://github.com/mpheyman/poais-core.git main --squash` then re-run sync script |

Cursor commands take paths under `product/` (e.g. `/process product/INPUTS/YYYY-MM-DD-<slug>.md`, `/align product`, `/status product 2026-02-22`). For `/process`, missing paths are created (parent dir and file); the user can paste content in chat or into the new file and rerun.
