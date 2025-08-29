#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Helpers ---------------------------------------------------------------
run_py () {
  # Prefer Poetry inside the conda env 'schemas311' if available; then Poetry; then conda; else system python.
  if command -v conda >/dev/null 2>&1 && conda env list | grep -qE '^\s*schemas311\s'; then
    if command -v poetry >/dev/null 2>&1; then
      ( cd "$ROOT" && conda run -n schemas311 poetry run python "$@" )
    else
      conda run -n schemas311 python "$@"
    fi
  elif command -v poetry >/dev/null 2>&1; then
    ( cd "$ROOT" && poetry run python "$@" )
  else
    python "$@"
  fi
}

# --- 1) Normalize schemas (idempotent) ------------------------------------
echo "◼︎ Normalizing JSON Schemas…"
run_py "$ROOT/scripts/normalize_schemas.py"

# --- 2) Regenerate code ----------------------------------------------------
echo "◼︎ Generating Python models…"
if command -v poetry >/dev/null 2>&1; then
  if command -v conda >/dev/null 2>&1 && conda env list | grep -qE '^\s*schemas311\s'; then
    (
      cd "$ROOT" && conda run -n schemas311 poetry run bash "$ROOT/codegen/gen_py.sh"
    )
  else
    (
      cd "$ROOT" && poetry run bash "$ROOT/codegen/gen_py.sh"
    )
  fi
else
  bash "$ROOT/codegen/gen_py.sh"
fi

echo "◼︎ Generating TypeScript types…"
bash "$ROOT/codegen/gen_ts.sh"

# --- 3) Validate examples with generated models ---------------------------
echo "◼︎ Validating examples/ against schemas and Pydantic models…"
PYTHONPATH="$ROOT/python/src" run_py "$ROOT/scripts/validate_examples.py"

echo "✅ All checks passed."
