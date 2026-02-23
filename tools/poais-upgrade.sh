#!/usr/bin/env bash
# Upgrade vendored poais-core in an existing product repo. Run from product repo root.
# Usage: bash poais/tools/poais-upgrade.sh [POAIS_CORE_REPO_URL]
# URL may be omitted if POAIS_LOCK.json exists and contains poais_core_repo_url.
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || true
if [[ -z "${REPO_ROOT:-}" ]]; then
  echo "ERROR: Not in a git repository. Run this from the root of a product repo." >&2
  exit 1
fi
cd "$REPO_ROOT"

POAIS_DIR="poais"
if [[ ! -d "$POAIS_DIR" ]]; then
  echo "ERROR: ./poais not found. Run poais-init first." >&2
  echo "  bash poais/tools/poais-init.sh https://github.com/mpheyman/poais-core.git" >&2
  exit 1
fi

# Working tree must be clean (skip if no commits yet)
if git rev-parse -q HEAD >/dev/null 2>&1; then
  if ! git diff-index --quiet HEAD -- 2>/dev/null; then
    echo "ERROR: Working tree is not clean. Commit or stash changes, then run upgrade again." >&2
    exit 1
  fi
fi

POAIS_CORE_REPO_URL="${1:-}"
LOCK_FILE="POAIS_LOCK.json"
if [[ -z "$POAIS_CORE_REPO_URL" ]] && [[ -f "$LOCK_FILE" ]]; then
  if command -v jq >/dev/null 2>&1; then
    POAIS_CORE_REPO_URL="$(jq -r '.poais_core_repo_url // empty' "$LOCK_FILE")"
  else
    POAIS_CORE_REPO_URL="$(grep -o '"poais_core_repo_url"[[:space:]]*:[[:space:]]*"[^"]*"' "$LOCK_FILE" | sed 's/.*"\([^"]*\)" *$/\1/')"
  fi
fi
if [[ -z "$POAIS_CORE_REPO_URL" ]]; then
  echo "ERROR: Provide poais-core repo URL or ensure POAIS_LOCK.json contains poais_core_repo_url." >&2
  echo "  bash poais/tools/poais-upgrade.sh https://github.com/mpheyman/poais-core.git" >&2
  exit 1
fi

echo "Pulling latest poais-core..."
git subtree pull --prefix=poais "$POAIS_CORE_REPO_URL" main --squash

echo "Syncing Cursor runtime..."
bash "${POAIS_DIR}/tools/sync-cursor-runtime.sh"

POAIS_COMMIT=""
if git rev-parse HEAD:"poais" >/dev/null 2>&1; then
  POAIS_COMMIT="$(git log -1 --format=%H -- poais/ 2>/dev/null)" || true
fi
NOW="$(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -u +%Y-%m-%dT%H:%M:%S 2>/dev/null)"

if [[ -f "$LOCK_FILE" ]]; then
  TMP="$(mktemp)"
  if command -v jq >/dev/null 2>&1; then
    jq --arg commit "${POAIS_COMMIT}" --arg synced "$NOW" --arg upgraded "$NOW" \
      '.poais_core_commit = $commit | .cursor_runtime_synced_at = $synced | .upgraded_at = $upgraded' \
      "$LOCK_FILE" > "$TMP" && mv "$TMP" "$LOCK_FILE"
  else
    cat "$LOCK_FILE" | sed "s/\"poais_core_commit\": *\"[^\"]*\"/\"poais_core_commit\": \"${POAIS_COMMIT}\"/" \
      | sed "s/\"cursor_runtime_synced_at\": *\"[^\"]*\"/\"cursor_runtime_synced_at\": \"${NOW}\"/" \
      | sed '/"upgraded_at"/d' | sed "s/\"workspace_root\"/\"upgraded_at\": \"${NOW}\", \"workspace_root\"/" > "$TMP" && mv "$TMP" "$LOCK_FILE"
  fi
else
  cat <<EOF > "$LOCK_FILE"
{
  "poais_core_repo_url": "${POAIS_CORE_REPO_URL}",
  "poais_prefix": "poais",
  "poais_branch": "main",
  "poais_core_commit": "${POAIS_COMMIT}",
  "cursor_runtime_synced_at": "${NOW}",
  "upgraded_at": "${NOW}",
  "workspace_root": "product"
}
EOF
fi
# Preserve products and portfolio from existing lock (jq update above keeps all keys; sed path does not remove them)

echo ""
echo "SUCCESS: poais-core upgraded."
echo "  poais-core commit (this repo): ${POAIS_COMMIT:-unknown}"
echo ""
echo "Next: run /align product (or /align products/<name> for portfolio) in Cursor to check artifact alignment after upgrades."
echo ""
exit 0
