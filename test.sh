#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Poetry env bootstrap (idempotent) ------------------------------------
ensure_poetry_env () {
  if ! command -v poetry >/dev/null 2>&1; then
    echo "✖ Poetry is required. Install Poetry or run 'nix develop' (which provides it)." >&2
    exit 3
  fi
  # Ensure project-local venv with Python 3.11 exists and is installed
  if ! poetry env info -p >/dev/null 2>&1; then
    echo "◼︎ Creating local Poetry env (3.11)…"
    poetry env use 3.11 >/dev/null 2>&1 || true
    poetry install --only main --no-interaction >/dev/null
  fi
}

# --- Helpers ---------------------------------------------------------------
run_py () {
  # Require Poetry-managed interpreter for reproducibility.
  ensure_poetry_env
  ( cd "$ROOT" && poetry run python "$@" )
}

# --- 1) Normalize schemas (idempotent) ------------------------------------
echo "◼︎ Normalizing JSON Schemas…"
run_py "$ROOT/scripts/normalize_schemas.py"

# --- 2) Regenerate code ----------------------------------------------------
echo "◼︎ Generating Python models…"
ensure_poetry_env
(
  cd "$ROOT" && poetry run bash "$ROOT/codegen/gen_py.sh"
)

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
