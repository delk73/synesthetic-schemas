#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# 1) Bundle schemas locally (no network)
node "$ROOT/codegen/ts_bundle.mjs"

# 2) Generate TS from bundled schemas (examples shown for two popular tools).
# Pick ONE of these blocks and delete the other.

# ---- If you use json-schema-to-typescript (d.ts output) ----
OUT_DIR="$ROOT/typescript/src"
IN_DIR="$ROOT/typescript/tmp/bundled"

mkdir -p "$OUT_DIR"

# clean old outputs so stale files (like rule_bundle.d.ts) never linger
rm -f "$OUT_DIR"/*.d.ts "$OUT_DIR"/*.tsbuildinfo

for f in "$IN_DIR"/*.schema.json; do
  base=$(basename "$f" .schema.json)
  npx --yes json-schema-to-typescript "$f" > "$OUT_DIR/$base.d.ts"
  echo "generated: $base.d.ts"
done

# ---- OR: If you use json-schema-to-zod (runtime Zod + types) ----
# OUT_DIR="$ROOT/typescript/src"
# IN_DIR="$ROOT/typescript/tmp/bundled"
# mkdir -p "$OUT_DIR"
# for f in "$IN_DIR"/*.schema.json; do
#   base=$(basename "$f" .schema.json)
#   npx --yes json-schema-to-zod "$f" --name "$base" --output "$OUT_DIR/$base.zod.ts"
#   echo "generated: $base.zod.ts"
# done
