#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

STAMP="$(date +%Y%m%d-%H%M%S)"
OUT="dist/unshot-replit-${STAMP}.zip"
LATEST="dist/unshot-replit-latest.zip"

mkdir -p dist

zip -r "$OUT" \
  ios web shared docs tests README.md .gitignore \
  -x "*/__pycache__/*" "*.pyc" "*/.next/*" "*/node_modules/*" "*.DS_Store" >/dev/null

cp "$OUT" "$LATEST"

echo "$OUT"
echo "$LATEST"
