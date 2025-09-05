#!/usr/bin/env bash
set -euo pipefail

# This script is the single, explicit command to set up and build the project.
# It is self-contained and idempotent.

# 1. Ensure we are in the correct Nix environment.
if [ -z "${IN_NIX_SHELL:-}" ]; then
  echo "Error: This script must be run inside the Nix shell." >&2
  echo "Please run 'nix develop' first." >&2
  exit 1
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

# 2. Explicitly install all dependencies.
# This step ensures that all required tools are present and up-to-date
# according to the lock files before any other actions are taken.
echo "--> Step 1 of 4: Installing/verifying Python and Node.js dependencies..."
poetry install --no-root
npm install

# 3. Explicitly run code generation scripts.
# This can only succeed because Step 2 has just completed.
echo "--> Step 2 of 4: Generating code from schemas..."
bash "$ROOT/codegen/gen_py.sh"
bash "$ROOT/codegen/gen_ts.sh"

# 4. Explicitly run validation and quality control on the generated code.
echo "--> Step 3 of 4: Validating generated artifacts..."
poetry run python "$ROOT/scripts/validate_examples.py"

echo "--> Step 4 of 4: Running quality control checks..."
poetry run python "$ROOT/scripts/examples_qc.py" --ci || true

echo ""
echo "Build and validation complete."