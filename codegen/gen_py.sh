#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCHEMAS_DIR="$ROOT/jsonschema"
BUNDLE_DIR="$ROOT/typescript/tmp/bundled"     # produced by ts_bundle.mjs
OUT="$ROOT/python/src/synesthetic_schemas"

# 1) Bundle all schemas (no network; uses our custom resolver)
# This uses Node.js, which is provided by the Nix shell
node "$ROOT/codegen/ts_bundle.mjs"

# 2) Clean python package dir and make it importable
rm -rf "$OUT"
mkdir -p "$OUT"
: > "$OUT/__init__.py"
: > "$OUT/py.typed"

# 3) Decide if the CLI supports the pydantic v2 flag
EXTRA_FLAGS=()
# We use 'poetry run' here to check the correct version of the tool
if poetry run datamodel-codegen --help 2>&1 | grep -q -- '--use-pydantic-v2'; then
  EXTRA_FLAGS+=(--use-pydantic-v2)
fi

COMMON_ARGS=(
  --input-file-type jsonschema
  --target-python-version 3.11
  --use-standard-collections
  --disable-timestamp
)

# 4) Generate one .py per bundled schema (hyphens → underscores)
for schema in "$BUNDLE_DIR"/*.schema.json; do
  base="$(basename "$schema")"          # e.g. synesthetic-asset.schema.json
  mod="${base%.schema.json}"            # synesthetic-asset
  mod="${mod//-/_}"                     # synesthetic_asset
  out_py="$OUT/$mod.py"

  # We prepend 'poetry run' to ensure we use the project's installed dependency,
  # not a global one. This resolves the ModuleNotFoundError.
  # The original logic to fallback from the command to the module is preserved.
  if command -v datamodel-codegen >/dev/null 2>&1; then
    poetry run datamodel-codegen "${COMMON_ARGS[@]}" "${EXTRA_FLAGS[@]}" --input "$schema" --output "$out_py"
  else
    poetry run python -m datamodel_code_generator "${COMMON_ARGS[@]}" "${EXTRA_FLAGS[@]}" --input "$schema" --output "$out_py"
  fi
  echo "generated: $(basename "$out_py")"
done

# Ensure py.typed exists for typed package distribution (keep deterministic)
: > "$OUT/py.typed"