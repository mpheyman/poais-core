#!/usr/bin/env bash
# Initialize a product repo to use POAIS.
# Run from inside a product repo (any subdir); or via: curl -fsSL <RAW_URL> | bash -s -- <REPO_URL>
# Usage: bash poais-init.sh [POAIS_CORE_REPO_URL]
#        bash poais-init.sh --layout=portfolio [product-a product-b ...]
# If ./poais does not exist, repo URL is required (arg or POAIS_CORE_REPO_URL env).
set -euo pipefail

LAYOUT="single"
PRODUCT_NAMES=()
POAIS_CORE_REPO_URL="${POAIS_CORE_REPO_URL:-}"
for arg in "$@"; do
  if [[ "$arg" == "--layout=portfolio" ]] || [[ "$arg" == "--portfolio" ]]; then
    LAYOUT="portfolio"
  elif [[ "$arg" =~ ^https?:// ]]; then
    POAIS_CORE_REPO_URL="$arg"
  elif [[ "$LAYOUT" == "portfolio" ]] && [[ "$arg" != --* ]]; then
    PRODUCT_NAMES+=( "$arg" )
  fi
done
[[ -z "$POAIS_CORE_REPO_URL" ]] && [[ -n "${1:-}" ]] && [[ "${1:-}" =~ ^https?:// ]] && POAIS_CORE_REPO_URL="${1}"

echo "=== POAIS init ==="
echo ""

# Detect repo root (works when run locally or via curl | bash)
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || true
if [[ -z "${REPO_ROOT:-}" ]]; then
  echo "ERROR: Not in a git repository. Run this from inside a product repo (with at least one commit)." >&2
  echo "  Create an initial commit if needed: echo '# myproduct' > README.md && git add README.md && git commit -m 'Initial commit'" >&2
  exit 1
fi
cd "$REPO_ROOT"
echo "  Repo root: $REPO_ROOT"
echo ""

POAIS_DIR="poais"
if [[ "$LAYOUT" == "portfolio" ]]; then
  SKELETON="${POAIS_DIR}/bootstrap/portfolio-repo-skeleton"
  if [[ ${#PRODUCT_NAMES[@]} -eq 0 ]]; then
    PRODUCT_NAMES=( "product-a" "product-b" )
  fi
else
  SKELETON="${POAIS_DIR}/bootstrap/single-product-repo-skeleton"
fi
TEMPLATES="${POAIS_DIR}/templates/product"
PRODUCT_DIR="product"
REQUIRED_FILES="CONTEXT.md DISCOVERY.md PLAN.md EXECUTION.md DECISIONS.md RISKS.md ROADMAP.md STATUS.md"
REQUIRED_DIRS="INPUTS MEETINGS FEATURES IDEAS"

if [[ ! -d "$POAIS_DIR" ]]; then
  if [[ -z "$POAIS_CORE_REPO_URL" ]]; then
    echo "ERROR: ./poais not found and no repo URL given. Provide the poais-core repo URL as argument or set POAIS_CORE_REPO_URL." >&2
    echo "  Example: curl -fsSL https://raw.githubusercontent.com/mpheyman/poais-core/main/tools/poais-init.sh | bash -s -- https://github.com/mpheyman/poais-core.git" >&2
    exit 1
  fi
  echo "=== Adding poais-core via subtree ==="
  git subtree add --prefix=poais "$POAIS_CORE_REPO_URL" main --squash
  echo ""
else
  if [[ -n "$POAIS_CORE_REPO_URL" ]]; then
    echo "  ./poais exists; skipping subtree add."
  fi
fi

echo "=== Syncing Cursor runtime ==="
bash "${POAIS_DIR}/tools/sync-cursor-runtime.sh"
echo ""

if [[ "$LAYOUT" == "portfolio" ]]; then
  if [[ ! -d "products" ]] || [[ ! -d "portfolio" ]]; then
    echo "=== Scaffolding portfolio workspace (safe copy) ==="
    for item in "${SKELETON}"/*; do
      name="$(basename "$item")"
      if [[ -e "$name" ]]; then continue; fi
      if [[ -d "$item" ]]; then
        cp -R "$item" "$name"
      else
        cp "$item" "$name"
      fi
    done
    echo "  Created products/ and portfolio/ from scaffold."
    echo ""
  fi
  echo "  Ensuring required dirs and files per product..."
  for pname in "${PRODUCT_NAMES[@]}"; do
    prod_path="products/${pname}"
    mkdir -p "${prod_path}/INPUTS" "${prod_path}/MEETINGS" "${prod_path}/FEATURES" "${prod_path}/IDEAS"
    for f in $REQUIRED_FILES; do
      if [[ ! -f "${prod_path}/${f}" ]] && [[ -f "${TEMPLATES}/${f}" ]]; then
        cp "${TEMPLATES}/${f}" "${prod_path}/${f}"
        echo "  Added ${prod_path}/${f} from template"
      fi
    done
  done
  echo ""
else
  if [[ ! -d "$PRODUCT_DIR" ]]; then
    echo "=== Scaffolding product workspace (safe copy) ==="
    for item in "${SKELETON}"/*; do
      name="$(basename "$item")"
      if [[ -e "$name" ]]; then continue; fi
      if [[ -d "$item" ]]; then
        cp -R "$item" "$name"
      else
        cp "$item" "$name"
      fi
    done
    echo "  Created $PRODUCT_DIR/ from scaffold."
    echo ""
  fi
  echo "  Ensuring required dirs and files..."
  mkdir -p "${PRODUCT_DIR}/INPUTS" "${PRODUCT_DIR}/MEETINGS" "${PRODUCT_DIR}/FEATURES" "${PRODUCT_DIR}/IDEAS"
  for f in $REQUIRED_FILES; do
    if [[ ! -f "${PRODUCT_DIR}/${f}" ]] && [[ -f "${TEMPLATES}/${f}" ]]; then
      cp "${TEMPLATES}/${f}" "${PRODUCT_DIR}/${f}"
      echo "  Added ${PRODUCT_DIR}/${f} from template"
    fi
  done
  echo ""
fi

# Best-effort commit hash (subtree has no .git; use last commit that touched poais/)
POAIS_COMMIT=""
if git rev-parse HEAD:"poais" >/dev/null 2>&1; then
  POAIS_COMMIT="$(git log -1 --format=%H -- poais/ 2>/dev/null)" || true
fi
NOW="$(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -u +%Y-%m-%dT%H:%M:%S 2>/dev/null)"

# URL from lock if we don't have one (e.g. init re-run with poais already present)
if [[ -z "${POAIS_CORE_REPO_URL:-}" ]] && [[ -f "POAIS_LOCK.json" ]]; then
  if command -v jq >/dev/null 2>&1; then
    POAIS_CORE_REPO_URL="$(jq -r '.poais_core_repo_url // empty' POAIS_LOCK.json)"
  fi
fi

echo "=== Updating POAIS_LOCK.json ==="
LOCK_FILE="POAIS_LOCK.json"
if [[ "$LAYOUT" == "portfolio" ]]; then
  PRODUCTS_JSON="["
  for i in "${!PRODUCT_NAMES[@]}"; do
    [[ $i -gt 0 ]] && PRODUCTS_JSON+=","
    PRODUCTS_JSON+="\"products/${PRODUCT_NAMES[$i]}\""
  done
  PRODUCTS_JSON+="]"
fi
if [[ -f "$LOCK_FILE" ]]; then
  TMP="$(mktemp)"
  if command -v jq >/dev/null 2>&1; then
    jq --arg url "${POAIS_CORE_REPO_URL:-}" --arg commit "${POAIS_COMMIT}" --arg synced "$NOW" \
      '.poais_core_repo_url = (if $url != "" then $url else .poais_core_repo_url end) | .poais_core_commit = $commit | .cursor_runtime_synced_at = $synced | .installed_at = (if .installed_at then .installed_at else $synced end)' \
      "$LOCK_FILE" > "$TMP" && mv "$TMP" "$LOCK_FILE"
    if [[ "$LAYOUT" == "portfolio" ]]; then
      jq --argjson prods "$(echo "$PRODUCTS_JSON" | jq -c .)" '.products = $prods | .portfolio = "portfolio" | del(.workspace_root)' "$LOCK_FILE" > "$TMP" 2>/dev/null && mv "$TMP" "$LOCK_FILE" || true
    fi
  else
    cat "$LOCK_FILE" | sed "s/\"poais_core_commit\": *\"[^\"]*\"/\"poais_core_commit\": \"${POAIS_COMMIT}\"/" \
      | sed "s/\"cursor_runtime_synced_at\": *\"[^\"]*\"/\"cursor_runtime_synced_at\": \"${NOW}\"/" > "$TMP" && mv "$TMP" "$LOCK_FILE"
  fi
  echo "  Updated $LOCK_FILE"
else
  if [[ "$LAYOUT" == "portfolio" ]]; then
    if command -v jq >/dev/null 2>&1; then
      jq -n \
        --arg url "${POAIS_CORE_REPO_URL:-}" \
        --arg commit "${POAIS_COMMIT}" \
        --arg synced "$NOW" \
        --argjson prods "$(echo "$PRODUCTS_JSON" | jq -c .)" \
        '{poais_core_repo_url: $url, poais_prefix: "poais", poais_branch: "main", poais_core_commit: $commit, cursor_runtime_synced_at: $synced, installed_at: $synced, products: $prods, portfolio: "portfolio"}' \
        > "$LOCK_FILE"
    else
      cat <<EOF > "$LOCK_FILE"
{
  "poais_core_repo_url": "${POAIS_CORE_REPO_URL:-}",
  "poais_prefix": "poais",
  "poais_branch": "main",
  "poais_core_commit": "${POAIS_COMMIT}",
  "cursor_runtime_synced_at": "${NOW}",
  "installed_at": "${NOW}",
  "products": ${PRODUCTS_JSON},
  "portfolio": "portfolio"
}
EOF
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
  echo "  Created $LOCK_FILE"
fi
echo ""

echo "=== SUCCESS: POAIS initialized ==="
echo ""
echo "Next steps:"
echo "  1. Open this repo in Cursor."
if [[ "$LAYOUT" == "portfolio" ]]; then
  echo "  2. Per product: create input e.g. products/<name>/INPUTS/$(date +%Y-%m-%d)-notes.md, run /process and /align products/<name>, /status products/<name>."
  echo "  3. Run /status portfolio to write portfolio/STATUS.md roll-up."
else
  echo "  2. Create an input file, e.g.: ${PRODUCT_DIR}/INPUTS/$(date +%Y-%m-%d)-notes.md"
  echo "  3. Run: /process ${PRODUCT_DIR}/INPUTS/<your-file>.md"
fi
echo ""
exit 0
