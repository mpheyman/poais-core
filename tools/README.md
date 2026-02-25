# Tools

Scripts for initializing, upgrading, and maintaining POAIS in a product repo. No Node.js or Python required. Run from the **product repo root** (or, for remote one-liners, from a folder that will become the repo root).

## Scripts

| Script | Platform | Purpose |
|--------|----------|---------|
| [poais-init.sh](poais-init.sh) | macOS / Linux / Git Bash | Initialize a product repo: add poais-core via subtree (if missing), sync `.cursor/`, scaffold `products/` and `portfolio/`. |
| [poais-init.ps1](poais-init.ps1) | Windows PowerShell | Same as poais-init.sh for Windows. |
| [poais-upgrade.sh](poais-upgrade.sh) | macOS / Linux / Git Bash | Upgrade poais-core (subtree pull) and re-sync `.cursor/`. |
| [poais-upgrade.ps1](poais-upgrade.ps1) | Windows PowerShell | Same as poais-upgrade.sh for Windows. |
| [poais-doctor.sh](poais-doctor.sh) | macOS / Linux / Git Bash | Diagnose: git repo, poais/, .cursor sync, product paths, required dirs/files. Prints OK/WARN/FAIL and fix commands. |
| [poais-doctor.ps1](poais-doctor.ps1) | Windows PowerShell | Same as poais-doctor.sh for Windows. |
| [sync-cursor-runtime.sh](sync-cursor-runtime.sh) | macOS / Linux / Git Bash | Copy `poais/.cursor/` to repo root `.cursor/` so Cursor sees POAIS commands, rules, skills, subagents. |
| [sync-cursor-runtime.ps1](sync-cursor-runtime.ps1) | Windows PowerShell | Same as sync-cursor-runtime.sh for Windows. |

## When to use

- **First-time setup:** Follow the [Setup section in README.md](../README.md#setup): create project folder, make a commit, then run the init one-liner from the repo root. Do not use **`/setup-poais`** in Cursor until POAIS is already in the repo (that command is for guided next steps after init). Init adds poais (if missing), scaffolds the workspace, and syncs `.cursor/`.
- **Re-scaffold:** With `poais/` already present, run `poais-init.sh` or `poais-init.ps1` with optional product names.
- **Upgrade poais-core:** After pulling subtree updates, run poais-upgrade; it re-syncs `.cursor/` automatically.
- **Troubleshoot:** Run poais-doctor to check repo state and get exact fix commands.
- **Sync only:** If you need to refresh root `.cursor/` from `poais/.cursor/` without init or upgrade, run sync-cursor-runtime.

## Product repo requirement

The product repo must be a git repository with **at least one commit** before init (required for `git subtree add`). Create a minimal README and commit if needed.
