# ruff: noqa
# flake8: noqa
# pylintrc: skip-file
"""
Normalize JSON Schemas in jsonschema/:
- set $schema
- set stable $id (kebab-case filename under a versioned base URL)
- set x-schema-version
- default additionalProperties: false (with per-file allowlist)
- strip noisy 'description'/'title' at root
"""

from __future__ import annotations
import json, pathlib, sys
from typing import Any

ROOT = pathlib.Path(__file__).resolve().parents[1]
SCHEMA_DIR = ROOT / "jsonschema"
BASE_URL = "https://schemas.synesthetic.dev"
VERSION = "0.1.0"

# Files that may keep additionalProperties=true at root (you can tweak)
ALLOW_ADDITIONAL_PROPS = {
    "tone.schema.json",
    "haptic.schema.json",
    # keep strict for others (asset/shader/control/modulation/rule-bundle/rule)
}

def kebab(name: str) -> str:
    return name.lower().replace(" ", "-")

def load_json(p: pathlib.Path) -> dict[str, Any]:
    return json.loads(p.read_text())

def save_json(p: pathlib.Path, data: dict[str, Any]) -> None:
    p.write_text(json.dumps(data, indent=2, sort_keys=True) + "\n")

def normalize_file(p: pathlib.Path) -> None:
    data = load_json(p)

    # header: $schema, $id, version
    data["$schema"] = "https://json-schema.org/draft/2020-12/schema"
    data["$id"] = f"{BASE_URL}/{VERSION}/{p.name}"
    data["x-schema-version"] = VERSION

    # clean noisy root fields
    data.pop("description", None)
    # keep a human title if present; otherwise set from filename
    data["title"] = data.get("title") or kebab(p.stem)

    # default strictness at root
    if p.name not in ALLOW_ADDITIONAL_PROPS:
        data["additionalProperties"] = data.get("additionalProperties", False)

    save_json(p, data)

def main() -> int:
    changed = 0
    for fp in sorted(SCHEMA_DIR.glob("*.schema.json")):
        normalize_file(fp)
        print(f"normalized: {fp.name}")
        changed += 1
    print(f"done. files: {changed}")
    return 0

if __name__ == "__main__":
    sys.exit(main())
