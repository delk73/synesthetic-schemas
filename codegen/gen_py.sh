#!/usr/bin/env bash
set -euo pipefail
OUT="python/src/synesthetic_schemas"
mkdir -p "$OUT"

# generate per schema (add more lines as you stabilize components)
datamodel-codegen \
  --input jsonschema/synesthetic-asset.schema.json \
  --input-file-type jsonschema \
  --output "$OUT/asset.py" \
  --target-python-version 3.11 \
  --use-standard-collections

# optional components
for S in shader tone haptic control modulation rule-bundle rule; do
  [ -f "jsonschema/$S.schema.json" ] || continue
  datamodel-codegen \
    --input "jsonschema/$S.schema.json" \
    --input-file-type jsonschema \
    --output "$OUT/${S//-/_}.py" \
    --target-python-version 3.11 \
    --use-standard-collections
done

# minimal package glue
echo '' > "$OUT/__init__.py"
