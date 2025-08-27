#!/usr/bin/env python
# ruff: noqa
from __future__ import annotations
import json, pathlib
from typing import Any, Dict

ROOT = pathlib.Path(__file__).resolve().parents[1]
SCHEMA = ROOT / "jsonschema" / "synesthetic-asset.schema.json"

REF_MAP = {
  "#/$defs/NestedShaderResponse":     "https://schemas.synesthetic.dev/0.1.0/shader.schema.json",
  "#/$defs/NestedToneResponse":       "https://schemas.synesthetic.dev/0.1.0/tone.schema.json",
  "#/$defs/NestedHapticResponse":     "https://schemas.synesthetic.dev/0.1.0/haptic.schema.json",
  "#/$defs/NestedControlResponse":    "https://schemas.synesthetic.dev/0.1.0/control.schema.json",
  "#/$defs/NestedModulationResponse": "https://schemas.synesthetic.dev/0.1.0/modulation.schema.json",
}

def walk(node: Any) -> None:
    if isinstance(node, dict):
        if "$ref" in node and node["$ref"] in REF_MAP:
            node["$ref"] = REF_MAP[node["$ref"]]
        for v in node.values():
            walk(v)
    elif isinstance(node, list):
        for v in node:
            walk(v)

def main() -> int:
    data: Dict[str, Any] = json.loads(SCHEMA.read_text())
    walk(data)
    # optional: drop now-useless $defs.*Response blocks if they exist
    defs = data.get("$defs") or data.get("definitions")
    if isinstance(defs, dict):
        for k in list(defs.keys()):
            if k.startswith("Nested") and k.endswith("Response"):
                defs.pop(k, None)
    SCHEMA.write_text(json.dumps(data, indent=2, sort_keys=True) + "\n")
    print("patched:", SCHEMA.name)
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
