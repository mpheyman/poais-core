# Installing and updating poais-core via git subtree

Use these steps in a **product repo** to add or update poais-core. Replace `<POAIS_CORE_REPO_URL>` with the actual repo URL (e.g. `https://github.com/yourorg/poais-core.git` or `git@github.com:yourorg/poais-core.git`).

## Initial add

From your product repo root:

```bash
git subtree add --prefix=poais <POAIS_CORE_REPO_URL> main --squash
```

This creates a `poais/` directory containing the poais-core files (including `poais/.cursor/`, `poais/tools/`, `poais/templates/`, etc.).

## Sync Cursor runtime (mandatory)

Cursor only reads `.cursor/` at the **repository root**. Because poais-core lives under `poais/`, you must copy `poais/.cursor/` to the root `.cursor/` after every add or pull. Use the provided scripts:

**macOS / Linux / Git Bash:**

```bash
bash poais/tools/sync-cursor-runtime.sh
```

**Windows PowerShell:**

```powershell
powershell -ExecutionPolicy Bypass -File poais\tools\sync-cursor-runtime.ps1
```

Run from the **product repo root**. The script verifies `poais/.cursor` exists, then replaces the root `.cursor/` with the contents of `poais/.cursor/`.

- Treat root `.cursor/` as **generated/runtime** in product repos. Do not hand-edit it unless you are intentionally customizing; re-run the sync script after a subtree pull to restore the canonical set.
- If you customize root `.cursor/`, be aware that the next sync will overwrite it.

## Updating poais-core later

From your product repo root:

```bash
git subtree pull --prefix=poais <POAIS_CORE_REPO_URL> main --squash
```

Then run the sync script again (same as above) so root `.cursor/` matches the updated poais-core.

## Summary

| Step | Command / action |
|------|------------------|
| Add poais-core | `git subtree add --prefix=poais <POAIS_CORE_REPO_URL> main --squash` |
| Sync .cursor to root | `bash poais/tools/sync-cursor-runtime.sh` (or `.ps1` on Windows) |
| Update poais-core | `git subtree pull --prefix=poais <POAIS_CORE_REPO_URL> main --squash` then re-run sync script |
