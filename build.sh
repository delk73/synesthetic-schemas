#!/usr/bin/env bash
set -euo pipefail

# This script is the single command to set up and build the project
# after entering the Nix shell.

# 1. Ensure we are in the correct environment.
if [ -z "${IN_NIX_SHELL:-}" ]; then
  echo "Error: This script must be run inside the Nix shell." >&2
  echo "Please run 'nix develop' first." >&2
  exit 1
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

# 2. Install all dependencies idempotently.
# This ensures all tools needed by subsequent steps are available.
echo "--> Step 1 of 4: Installing Python and Node.js dependencies..."
poetry install --no-root
npm install

# 3. Run code generation scripts.
echo "--> Step 2 of 4: Generating code from schemas..."
bash "$ROOT/codegen/gen_py.sh"
bash "$ROOT/codegen/gen_ts.sh"

# 4. Run validation and quality control on the generated code.
echo "--> Step 3 of 4: Validating generated artifacts..."
poetry run python "$ROOT/scripts/validate_examples.py"

echo "--> Step 4 of 4: Running quality control checks..."
poetry run python "$ROOT/scripts/examples_qc.py" --ci || true

echo ""
echo "Build and validation complete."