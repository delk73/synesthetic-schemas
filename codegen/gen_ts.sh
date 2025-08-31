#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# 1) Bundle schemas locally (no network)
node "$ROOT/codegen/ts_bundle.mjs"

# 2) Generate TS from bundled schemas using repo-local tooling (deterministic)
OUT_DIR="$ROOT/typescript/src"
IN_DIR="$ROOT/typescript/tmp/bundled"

mkdir -p "$OUT_DIR"

# clean old outputs so stale files never linger
rm -f "$OUT_DIR"/*.d.ts "$OUT_DIR"/*.tsbuildinfo

BIN="$ROOT/node_modules/.bin/json2ts"
if [[ ! -x "$BIN" ]]; then
  echo "❌ Missing CLI: $BIN (install devDependencies)" >&2
  exit 2
fi

for f in "$IN_DIR"/*.schema.json; do
  base=$(basename "$f" .schema.json)
  "$BIN" "$f" > "$OUT_DIR/$base.d.ts"
  echo "generated: $base.d.ts"
done
