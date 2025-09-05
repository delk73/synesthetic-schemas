#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Poetry env bootstrap (idempotent) ------------------------------------
ensure_poetry_env () {
  if ! command -v poetry >/dev/null 2>&1; then
    echo "✖ Poetry is required. Install Poetry or run 'nix develop' (which provides it)." >&2
    exit 3
  fi
  # Force-bind this project to a Python 3.11 interpreter every time (idempotent)
  if command -v python3.11 >/dev/null 2>&1; then
    PY311_PATH="$(command -v python3.11)"
  elif command -v python3 >/dev/null 2>&1 && python3 -c 'import sys; print(sys.version_info[:2]==(3,11))' | grep -q True; then
    PY311_PATH="$(command -v python3)"
  else
    echo "✖ Python 3.11 not found on PATH. Install it or run 'nix develop'." >&2
    exit 3
  fi
  echo "◼︎ Ensuring Poetry uses Python: $PY311_PATH"
  if ! poetry env use "$PY311_PATH" >/dev/null 2>&1; then
    echo "✖ Failed to select Python 3.11 at $PY311_PATH for Poetry env." >&2
    exit 3
  fi
}

# Verify key deps exist; if not, instruct user to install once explicitly.
require_python_deps () {
  if ! ( cd "$ROOT" && poetry run python - <<'PY' 2>/dev/null
import sys
import jsonschema  # validate schema
import pydantic    # validate codegen deps present
print('OK')
PY
  ) >/dev/null; then
    echo "✖ Missing Python dependencies in the Poetry env." >&2
    echo "  Run once: 'poetry install' (inside nix develop if you use it)." >&2
    exit 3
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
require_python_deps
run_py "$ROOT/scripts/examples_qc.py" --ci || true
echo "   ↳ Wrote: meta/output/SCHEMAS_EXAMPLES_QA.{json,md} and BLESSED_EXAMPLES.json"

echo "✅ All checks completed."
