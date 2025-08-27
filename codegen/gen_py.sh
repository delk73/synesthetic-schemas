#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IN_DIR="$ROOT/jsonschema"
OUT_DIR="$ROOT/python/src/synesthetic_schemas"

mkdir -p "$OUT_DIR"
find "$OUT_DIR" -maxdepth 1 -type f -name "*.py" ! -name "__init__.py" -delete || true
touch "$OUT_DIR/__init__.py"
touch "$OUT_DIR/py.typed"

python -m datamodel_code_generator \
  --input "$IN_DIR" \
  --input-file-type jsonschema \
  --output "$OUT_DIR" \
  --reuse-model \
  --collapse-root-models \
  --target-python-version 3.11 \
  --field-constraints \
  --use-union-operator \
  --disable-timestamp
