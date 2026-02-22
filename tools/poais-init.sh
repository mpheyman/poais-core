#!/usr/bin/env bash
# Initialize a product repo to use POAIS. Run from product repo root.
# Usage: bash poais/tools/poais-init.sh [POAIS_CORE_REPO_URL]
# If ./poais does not exist, URL is required.
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || true
if [[ -z "${REPO_ROOT:-}" ]]; then
  echo "ERROR: Not in a git repository. Run this from the root of a product repo." >&2
  exit 1
fi
cd "$REPO_ROOT"

POAIS_CORE_REPO_URL="${1:-}"
POAIS_DIR="poais"
SKELETON="${POAIS_DIR}/bootstrap/single-product-repo-skeleton"
TEMPLATES="${POAIS_DIR}/templates/product"
PRODUCT_DIR="product"
REQUIRED_FILES="CONTEXT.md DISCOVERY.md PLAN.md EXECUTION.md DECISIONS.md RISKS.md ROADMAP.md STATUS.md"
REQUIRED_DIRS="INPUTS MEETINGS FEATURES"

if [[ ! -d "$POAIS_DIR" ]]; then
  if [[ -z "$POAIS_CORE_REPO_URL" ]]; then
    echo "ERROR: ./poais not found. Provide the poais-core repo URL:" >&2
    echo "  bash poais/tools/poais-init.sh https://github.com/mpheyman/poais-core.git" >&2
    exit 1
  fi
  echo "Adding poais-core via subtree..."
  git subtree add --prefix=poais "$POAIS_CORE_REPO_URL" main --squash
else
  if [[ -n "$POAIS_CORE_REPO_URL" ]]; then
    echo "./poais exists; skipping subtree add. URL ignored."
  fi
fi

echo "Syncing Cursor runtime..."
bash "${POAIS_DIR}/tools/sync-cursor-runtime.sh"

if [[ ! -d "$PRODUCT_DIR" ]]; then
  echo "Creating workspace from scaffold (safe copy)..."
  for item in "${SKELETON}"/*; do
    name="$(basename "$item")"
    if [[ -e "$name" ]]; then continue; fi
    if [[ -d "$item" ]]; then
      cp -R "$item" "$name"
    else
      cp "$item" "$name"
    fi
  done
fi

mkdir -p "${PRODUCT_DIR}/INPUTS" "${PRODUCT_DIR}/MEETINGS" "${PRODUCT_DIR}/FEATURES"
for f in $REQUIRED_FILES; do
  if [[ ! -f "${PRODUCT_DIR}/${f}" ]] && [[ -f "${TEMPLATES}/${f}" ]]; then
    cp "${TEMPLATES}/${f}" "${PRODUCT_DIR}/${f}"
    echo "  Added ${PRODUCT_DIR}/${f} from template"
  fi
done

# Best-effort commit hash for poais subtree
POAIS_COMMIT=""
if git rev-parse HEAD:"poais" >/dev/null 2>&1; then
  POAIS_COMMIT="$(git log -1 --format=%H -- poais/ 2>/dev/null)" || true
fi
NOW="$(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -u +%Y-%m-%dT%H:%M:%S 2>/dev/null)"

# Use URL from lock if we don't have one (e.g. init re-run with poais already present)
if [[ -z "${POAIS_CORE_REPO_URL:-}" ]] && [[ -f "POAIS_LOCK.json" ]]; then
  if command -v jq >/dev/null 2>&1; then
    POAIS_CORE_REPO_URL="$(jq -r '.poais_core_repo_url // empty' POAIS_LOCK.json)"
  fi
fi

LOCK_FILE="POAIS_LOCK.json"
if [[ -f "$LOCK_FILE" ]]; then
  # Update existing lock (minimal merge: overwrite known fields)
  TMP="$(mktemp)"
  if command -v jq >/dev/null 2>&1; then
    jq --arg url "${POAIS_CORE_REPO_URL:-}" --arg commit "${POAIS_COMMIT}" --arg synced "$NOW" \
      '.poais_core_repo_url = (if $url != "" then $url else .poais_core_repo_url end) | .poais_core_commit = $commit | .cursor_runtime_synced_at = $synced | .installed_at = (if .installed_at then .installed_at else $synced end)' \
      "$LOCK_FILE" > "$TMP" && mv "$TMP" "$LOCK_FILE"
  else
    cat "$LOCK_FILE" | sed "s/\"poais_core_commit\": *\"[^\"]*\"/\"poais_core_commit\": \"${POAIS_COMMIT}\"/" \
      | sed "s/\"cursor_runtime_synced_at\": *\"[^\"]*\"/\"cursor_runtime_synced_at\": \"${NOW}\"/" > "$TMP" && mv "$TMP" "$LOCK_FILE"
  fi
else
  cat <<EOF > "$LOCK_FILE"
{
  "poais_core_repo_url": "${POAIS_CORE_REPO_URL:-}",
  "poais_prefix": "poais",
  "poais_branch": "main",
  "poais_core_commit": "${POAIS_COMMIT}",
  "cursor_runtime_synced_at": "${NOW}",
  "installed_at": "${NOW}",
  "workspace_root": "product"
}
EOF
fi

echo ""
echo "SUCCESS: POAIS initialized."
echo ""
echo "Next steps:"
echo "  1. Create an input file, e.g. ${PRODUCT_DIR}/INPUTS/$(date +%Y-%m-%d)-notes.md"
echo "  2. In Cursor, run: /process ${PRODUCT_DIR}/INPUTS/<your-file>.md"
echo ""
exit 0
