#!/usr/bin/env bash
set -euo pipefail

bash codegen/gen_py.sh
bash codegen/gen_ts.sh

# Ignore datamodel-code-generator timestamp lines (and a generic TS "Generated on" line if present)
IGNORE_PY='^\s*#\s*timestamp:'
IGNORE_TS='^\s*\*\s*Generated on:'

# Limit diff to generated dirs; ignore hunks where *all* changed lines match these regexes
if ! git diff -I "$IGNORE_PY" -I "$IGNORE_TS" -- python/src typescript/src >/dev/null; then
  echo "❌ Generated code is stale (excluding timestamp-only changes)."
  git --no-pager diff -I "$IGNORE_PY" -I "$IGNORE_TS" -- python/src typescript/src
  exit 1
fi

echo "✅ Codegen is clean (ignoring timestamps)."
