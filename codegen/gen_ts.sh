#!/usr/bin/env bash
set -euo pipefail
OUT="typescript/src"
mkdir -p "$OUT"

# asset first
npx --yes json-schema-to-typescript jsonschema/synesthetic-asset.schema.json > "$OUT/asset.d.ts"

# optional components
for S in shader tone haptic control modulation rule-bundle rule; do
  [ -f "jsonschema/$S.schema.json" ] || continue
  npx --yes json-schema-to-typescript "jsonschema/$S.schema.json" > "$OUT/${S//-/_}.d.ts"
done

# barrel
cat > "$OUT/index.d.ts" <<'TS'
export * from "./asset";
export * from "./shader";
export * from "./tone";
export * from "./haptic";
export * from "./control";
export * from "./modulation";
export * from "./rule_bundle";
export * from "./rule";
TS
