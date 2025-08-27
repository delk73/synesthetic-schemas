#!/usr/bin/env bash
set -euo pipefail

PY="$(command -v python || command -v python3)"
OUT="python/src/synesthetic_schemas"
mkdir -p "$OUT"

gen() {
  local IN="$1"
  local OUTFILE="$2"
  "$PY" -m datamodel_code_generator \
    --output-model-type pydantic_v2.BaseModel \
    --input "$IN" \
    --input-file-type jsonschema \
    --output "$OUTFILE" \
    --target-python-version 3.11 \
    --use-standard-collections \
    --formatters black isort
}

gen jsonschema/synesthetic-asset.schema.json "$OUT/asset.py"

for S in shader tone haptic control modulation rule-bundle rule; do
  [ -f "jsonschema/$S.schema.json" ] || continue
  gen "jsonschema/$S.schema.json" "$OUT/${S//-/_}.py"
done

: > "$OUT/__init__.py"
