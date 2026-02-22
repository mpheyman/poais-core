#!/usr/bin/env bash
# Diagnose POAIS installation in a product repo. Run from product repo root.
# Usage: bash poais/tools/poais-doctor.sh
# Exit 0 if all OK, 1 if any WARN or FAIL.
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || true
if [[ -z "${REPO_ROOT:-}" ]]; then
  echo "FAIL: Not in a git repository. Run from the root of a product repo." >&2
  echo "  Fix: cd to your product repo root." >&2
  exit 1
fi
cd "$REPO_ROOT"

STATUS=0
POAIS_DIR="poais"
PRODUCT_DIR="product"
REQUIRED_FILES="CONTEXT.md DISCOVERY.md PLAN.md EXECUTION.md DECISIONS.md RISKS.md ROADMAP.md STATUS.md"
REQUIRED_DIRS="INPUTS MEETINGS FEATURES"
LOCK_FILE="POAIS_LOCK.json"

check_ok()  { echo "  OK:   $1"; }
check_warn() { echo "  WARN: $1" >&2; STATUS=1; }
check_fail() { echo "  FAIL: $1" >&2; STATUS=1; }

echo "POAIS doctor (product repo root: $REPO_ROOT)"
echo ""

if [[ ! -d "$POAIS_DIR" ]]; then
  check_fail "./poais not found."
  echo "    Fix: bash poais/tools/poais-init.sh https://github.com/mpheyman/poais-core.git" >&2
  echo "    (If you don't have poais yet, download the init script from poais-core and run it with the repo URL.)" >&2
else
  check_ok "./poais exists"
fi

if [[ -d "$POAIS_DIR" ]]; then
  if [[ ! -d "${POAIS_DIR}/.cursor" ]]; then
    check_fail "./poais/.cursor not found (poais-core may be incomplete)."
  else
    check_ok "./poais/.cursor exists"
  fi
fi

if [[ ! -d ".cursor" ]]; then
  check_fail "Root .cursor/ not found. Cursor will not see POAIS commands."
  echo "    Fix: bash poais/tools/sync-cursor-runtime.sh" >&2
else
  check_ok "Root .cursor/ exists"
fi

# Optional: suggest sync if root .cursor might be stale
if [[ -d "poais/.cursor" ]] && [[ -d ".cursor" ]]; then
  if command -v diff >/dev/null 2>&1; then
    if ! diff -rq ".cursor" "poais/.cursor" >/dev/null 2>&1; then
      check_warn "Root .cursor/ differs from poais/.cursor. Sync to get latest."
      echo "    Fix: bash poais/tools/sync-cursor-runtime.sh" >&2
    fi
  fi
fi

if [[ ! -d "$PRODUCT_DIR" ]]; then
  check_fail "./product not found."
  echo "    Fix: bash poais/tools/poais-init.sh [URL]" >&2
else
  check_ok "./product exists"
fi

for d in $REQUIRED_DIRS; do
  if [[ -d "${PRODUCT_DIR}/${d}" ]]; then
    check_ok "${PRODUCT_DIR}/${d}/ exists"
  else
    check_warn "${PRODUCT_DIR}/${d}/ missing."
    echo "    Fix: mkdir -p ${PRODUCT_DIR}/${d}" >&2
  fi
done

for f in $REQUIRED_FILES; do
  if [[ -f "${PRODUCT_DIR}/${f}" ]]; then
    check_ok "${PRODUCT_DIR}/${f} exists"
  else
    check_warn "${PRODUCT_DIR}/${f} missing."
    echo "    Fix: cp poais/templates/product/${f} ${PRODUCT_DIR}/${f}" >&2
  fi
done

if [[ ! -f "$LOCK_FILE" ]]; then
  check_warn "POAIS_LOCK.json not found (run init or upgrade to create/update)."
else
  check_ok "POAIS_LOCK.json exists"
fi

echo ""
if [[ $STATUS -eq 0 ]]; then
  echo "All checks passed. You can use /process, /distill-meeting, /align, /status in Cursor."
  exit 0
else
  echo "Apply the fixes above, then re-run doctor or run:"
  echo "  bash poais/tools/poais-init.sh https://github.com/mpheyman/poais-core.git"
  echo "  bash poais/tools/poais-upgrade.sh https://github.com/mpheyman/poais-core.git"
  exit 1
fi
