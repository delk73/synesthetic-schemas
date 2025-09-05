#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Poetry env bootstrap (idempotent) ------------------------------------
ensure_poetry_env () {
  if command -v poetry >/dev/null 2>&1; then
    # Ensure project-local venv with Python 3.11 exists and is installed
    if ! poetry env info -p >/dev/null 2>&1; then
      echo "◼︎ Creating local Poetry env (3.11)…"
      poetry env use 3.11 >/dev/null 2>&1 || true
      poetry install --only main --no-interaction >/dev/null
    fi
  fi
}

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
    ensure_poetry_env
    ( cd "$ROOT" && poetry run python "$@" )
  else
    python3 "$@"
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

# --- 4) Examples QC (reports to meta/output) ------------------------------
echo "◼︎ Running examples QC (reports only; does not gate locally)…"
run_py "$ROOT/scripts/examples_qc.py" --ci || true
echo "   ↳ Wrote: meta/output/SCHEMAS_EXAMPLES_QA.{json,md} and BLESSED_EXAMPLES.json"

echo "✅ All checks completed."
