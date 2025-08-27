#!/usr/bin/env bash
set -euo pipefail

# regenerate both code paths
bash codegen/gen_py.sh
bash codegen/gen_ts.sh

# check for uncommitted changes
if ! git diff --quiet; then
  echo "❌ Generated code is stale. Run codegen and commit the changes."
  git --no-pager diff --stat
  exit 1
fi

echo "✅ Codegen is clean: no diffs."
