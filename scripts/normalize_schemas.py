# ruff: noqa
# flake8: noqa
# pylintrc: skip-file
"""
Normalize JSON Schemas in jsonschema/:
- set $schema / $id / x-schema-version
- default additionalProperties: false (with per-file allowlist)
- strip noisy root description
- strip enum defaults for optional fields, including when hidden behind $ref
"""

from __future__ import annotations
import copy, json, pathlib, sys
from typing import Any

ROOT = pathlib.Path(__file__).resolve().parents[1]
SCHEMA_DIR = ROOT / "jsonschema"
BASE_URL = "https://schemas.synesthetic.dev"
VERSION = "0.1.0"

ALLOW_ADDITIONAL_PROPS = {"tone.schema.json", "haptic.schema.json"}

def kebab(name: str) -> str:
    return name.lower().replace(" ", "-")

def load_json(p: pathlib.Path) -> dict[str, Any]:
    return json.loads(p.read_text())

def save_json(p: pathlib.Path, data: dict[str, Any]) -> None:
    p.write_text(json.dumps(data, indent=2, sort_keys=True) + "\n")

def _ref_target(root: dict[str, Any], ref: str) -> tuple[str | None, dict[str, Any] | None]:
    """Return (container_key, target_schema) for an internal $ref like '#/$defs/Name'."""
    if not ref.startswith("#/"):
        return None, None
    path = ref[2:].split("/")
    cur: Any = root
    for seg in path:
        if not isinstance(cur, dict) or seg not in cur:
            return None, None
        cur = cur[seg]
    # container key is first segment after '#/'
    return (path[0] if path else None), cur if isinstance(cur, dict) else None

def _strip_enum_default_in_place(schema: dict[str, Any]) -> bool:
    """If schema has enum+default with default ∈ enum, remove it. Returns True if changed."""
    if "enum" in schema and "default" in schema:
        try:
            if schema["default"] in schema.get("enum", []):
                schema.pop("default", None)
                return True
        except Exception:
            pass
    return False

def _recurse(root: dict[str, Any], node: Any) -> None:
    """Walk schema tree; for optional properties remove enum defaults (inline or via $ref)."""
    if not isinstance(node, dict):
        return

    local_required = set(node.get("required", []))

    # Handle object properties
    props = node.get("properties")
    if isinstance(props, dict):
        for prop_name, prop_schema in list(props.items()):
            is_optional = prop_name not in local_required
            if not isinstance(prop_schema, dict):
                continue

            if is_optional:
                # Case 1: inline enum+default
                _strip_enum_default_in_place(prop_schema)

                # Case 2: $ref to a def that has enum+default -> inline a copy WITHOUT default
                ref = prop_schema.get("$ref")
                if isinstance(ref, str):
                    container, target = _ref_target(root, ref)
                    if target and isinstance(target, dict):
                        tmp = copy.deepcopy(target)
                        if _strip_enum_default_in_place(tmp):  # only inline if we actually removed something
                            # Replace the property with the inlined schema (no default)
                            props[prop_name] = tmp
                            prop_schema = tmp  # continue recursion into the inlined schema

            # Recurse into nested structures of the property
            _recurse(root, prop_schema)

    # Recurse into common containers
    for key in ("$defs", "definitions"):
        defs = node.get(key)
        if isinstance(defs, dict):
            for v in defs.values():
                _recurse(root, v)

    items = node.get("items")
    if isinstance(items, dict):
        _recurse(root, items)
    elif isinstance(items, list):
        for it in items:
            _recurse(root, it)

    addl = node.get("additionalProperties")
    if isinstance(addl, dict):
        _recurse(root, addl)

    for key in ("allOf", "anyOf", "oneOf", "not", "if", "then", "else"):
        v = node.get(key)
        if isinstance(v, dict):
            _recurse(root, v)
        elif isinstance(v, list):
            for it in v:
                _recurse(root, it)

def normalize_file(p: pathlib.Path) -> None:
    data = load_json(p)

    # header
    data["$schema"] = "https://json-schema.org/draft/2020-12/schema"
    data["$id"] = f"{BASE_URL}/{VERSION}/{p.name}"
    data["x-schema-version"] = VERSION

    # root cosmetics/strictness
    data.pop("description", None)
    data["title"] = data.get("title") or kebab(p.stem)
    if p.name not in ALLOW_ADDITIONAL_PROPS:
        data["additionalProperties"] = data.get("additionalProperties", False)

    # strip enum defaults for optional props (including via $ref)
    _recurse(data, data)

    save_json(p, data)

def main() -> int:
    n = 0
    for fp in sorted(SCHEMA_DIR.glob("*.schema.json")):
        normalize_file(fp)
        print(f"normalized: {fp.name}")
        n += 1
    print(f"done. files: {n}")
    return 0

if __name__ == "__main__":
    sys.exit(main())
