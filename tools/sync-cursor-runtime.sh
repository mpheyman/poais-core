#!/usr/bin/env bash
# Sync Cursor runtime from poais/.cursor to repo root .cursor/
# Run from product repo root after git subtree add/pull of poais-core.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
POAIS_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE_CURSOR="${POAIS_ROOT}/.cursor"

if [[ ! -d "$SOURCE_CURSOR" ]]; then
  echo "ERROR: poais/.cursor not found at $SOURCE_CURSOR. Run this from a product repo root after adding poais-core via subtree (prefix=poais)." >&2
  exit 1
fi

# Product repo root = parent of poais/
REPO_ROOT="$(cd "$POAIS_ROOT/.." && pwd)"
TARGET_CURSOR="${REPO_ROOT}/.cursor"

rm -rf "$TARGET_CURSOR"
cp -R "$SOURCE_CURSOR" "$TARGET_CURSOR"
echo "SUCCESS: .cursor/ synced from poais/.cursor to repo root."
