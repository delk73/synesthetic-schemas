#!/usr/bin/env bash
set -euo pipefail

# This script validates the environment and builds the project artifacts.
# It's designed to be the one-stop-shop for developers.

# Ensure we are running inside the Nix development shell.
# The 'IN_NIX_SHELL' variable is set by default in nix-shell/nix develop.
if [ -z "${IN_NIX_SHELL:-}" ]; then
  echo "✖ This script must be run inside the Nix shell." >&2
  echo "  Please run 'nix develop' first, then re-run this script." >&2
  exit 1
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

# --- 1) Ensure Dependencies are Installed (Idempotent) -------------------
echo "◼︎ Verifying and installing Python & Node.js dependencies..."

# Poetry will check the lock file and only install what's missing.
# The --no-root flag is good practice for library projects.
poetry install --no-root

# Detect package manager and install Node deps.
if [ -f "yarn.lock" ]; then
    yarn install
elif [ -f "package-lock.json" ]; then
    npm ci # 'ci' is faster and stricter for CI/automation
else
    npm install
fi

# --- 2) Normalize schemas (Idempotent) -----------------------------------
echo "◼︎ Normalizing JSON Schemas…"
poetry run python "$ROOT/scripts/normalize_schemas.py"

# --- 3) Regenerate code ----------------------------------------------------
echo "◼︎ Generating Python models…"
poetry run bash "$ROOT/codegen/gen_py.sh"

echo "◼︎ Generating TypeScript types…"
bash "$ROOT/codegen/gen_ts.sh" # This is fine now, we've confirmed we are in Nix.

# --- 4) Validate examples with generated models ---------------------------
echo "◼︎ Validating examples/ against schemas and Pydantic models…"
# PYTHONPATH is not needed because 'poetry install' makes the 'src' dir available.
poetry run python "$ROOT/scripts/validate_examples.py"

# --- 5) Examples QC (reports to meta/output) ------------------------------
echo "◼︎ Running examples QC (reports only; does not gate locally)…"
poetry run python "$ROOT/scripts/examples_qc.py" --ci || true
echo "   ↳ Wrote: meta/output/SCHEMAS_EXAMPLES_QA.{json,md} and BLESSED_EXAMPLES.json"

echo ""
echo "✅ All checks, installations, and builds completed successfully."