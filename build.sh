#!/usr/bin/env bash
set -euo pipefail

# This script validates the environment and builds the project artifacts.
# It requires that dependencies have been installed manually first.

# 1. Ensure we are in the correct Nix environment.
if [ -z "${IN_NIX_SHELL:-}" ]; then
  echo "Error: This script must be run inside the Nix shell." >&2
  echo "Please run 'nix develop' first." >&2
  exit 1
fi

ROOT="$(cd "$(dirname "${B_SOURCE[0]}")" && pwd)"
cd "$ROOT"

# 2. Validate that dependencies have been installed.
echo "--> Step 1 of 4: Validating that dependencies are installed..."

# Check for Python dependencies by trying to import a key package.
if ! poetry run python -c "import datamodel_code_generator" &> /dev/null; then
  echo "Error: Python dependencies are not installed." >&2
  echo "Please run the following command manually:" >&2
  echo "" >&2
  echo "  poetry install" >&2
  echo "" >&2
  exit 1
fi

# Check for Node.js dependencies by looking for the node_modules directory.
if [ ! -d "node_modules" ]; then
  echo "Error: Node.js dependencies are not installed." >&2
  echo "Please run the following command manually:" >&2
  echo "" >&2
  echo "  npm install" >&2
  echo "" >&2
  exit 1
fi

echo "Dependencies verified."

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