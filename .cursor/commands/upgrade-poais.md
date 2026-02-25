# Command: /upgrade-poais

## Syntax

```
/upgrade-poais
```

No arguments. The agent runs the upgrade from the product repo root.

## Purpose

Upgrade the vendored poais-core in this product repo to the latest from the remote: pull the latest subtree and re-sync root `.cursor/` so the PM gets new commands, rules, skills, and subagents. The agent can run the upgrade script for the user so they don't have to run it in a terminal.

## When to use

- The PM wants to get the latest POAIS updates after new releases have been pushed to the poais-core repo.
- Run in the **product repo** (the repo that has `poais/` as a subtree). Do not use in the poais-core repo itself.

## Pre-checks (agent must verify before running)

1. **Repo root:** Run `git rev-parse --show-toplevel`. If it fails, say this does not appear to be a git repository and they should run the command from their product repo root.
2. **poais/ exists:** If `poais/` (or `./poais`) does not exist at repo root, say POAIS is not installed here; they should run `/setup-poais` first.
3. **Clean working tree:** Run `git status` or `git diff-index HEAD --`. If there are uncommitted changes, say: "Your working tree has uncommitted changes. The upgrade script requires a clean tree. Commit or stash your changes, then run `/upgrade-poais` again." Do not run the upgrade until the tree is clean.

## Behavior

1. Run the pre-checks above. If any fail, stop and report; do not run the upgrade.
2. **Optional confirm:** "I'll run the POAIS upgrade: pull latest poais-core into `poais/` and sync `.cursor/`. Ready?" If the user wants to proceed without confirmation, the command spec allows running directly after pre-checks.
3. **Resolve repo root:** All commands run from `git rev-parse --show-toplevel`.
4. **Run the upgrade script:**
   - **Mac/Linux / Git Bash:** From repo root: `bash poais/tools/poais-upgrade.sh`. The script reads the repo URL from POAIS_LOCK.json if present; no need to pass it unless the user wants a different URL.
   - **Windows PowerShell:** From repo root: `powershell -ExecutionPolicy Bypass -File poais\tools\poais-upgrade.ps1`. Same: URL from lock unless user specifies.
   - If the agent cannot run the script (e.g. network permission denied for subtree pull), output the exact command for the user to run from repo root for their OS, and say they can run `/upgrade-poais` again after.
5. **Report result:** On success, say upgrade completed and mention the new commit hash if available (script prints it). Suggest: "Run `/align products/<name>` or `/status portfolio` to check artifact alignment after the upgrade." On failure, report the error and the manual command.

## Output format

- **Success:** Short message that poais-core was upgraded; poais-core commit (if available); suggestion to run /align or /status.
- **Failure:** Clear reason (not a git repo, no poais/, dirty tree, or script error) and the exact command they can run manually for their OS.

## Guardrails

- Do not run the upgrade if the working tree is not clean; the script will fail and may leave the repo in an unclear state.
- Run all commands from the product repo root. If the workspace is not the repo root, either run from repo root if you can resolve it, or give the user the exact command to run from repo root.
- If the user says they're on Windows, use the PowerShell form when generating or running the command.
- This command is for **product repos** that vendor poais-core. It is not for the poais-core repo itself (where `/release` is used).
