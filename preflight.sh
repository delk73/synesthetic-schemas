#!/usr/bin/env bash
set -euo pipefail

echo "◼︎ normalize --check"
make normalize-check

echo "◼︎ schema-lint"
make schema-lint

echo "◼︎ ensure codegen clean"
if [[ -n "${SKIP_CODEGEN_CHECK:-}" ]]; then
  echo "(skipped by CI paths filter)"
else
  make codegen-check
fi

echo "◼︎ validate examples"
make validate

echo "✅ preflight OK"

# Record last successful preflight timestamp for quick visibility
mkdir -p .cache
date -u +"%Y-%m-%dT%H:%M:%SZ" > .cache/last_preflight.txt
echo "Stamped: $(cat .cache/last_preflight.txt) -> .cache/last_preflight.txt"
