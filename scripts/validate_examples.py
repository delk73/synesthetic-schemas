#!/usr/bin/env python
# ruff: noqa
# pyright: reportMissingImports=false

"""
Validate examples/ against:
  1) JSON Schemas in jsonschema/ (Draft 2020-12)
  2) Generated Pydantic v2 models in python/src/synesthetic_schemas/

Also round-trips JSON -> model -> JSON (exclude None) and reports small diffs.

Exit codes: 0 OK, 1 validation errors, 2 setup issues.
"""

from __future__ import annotations

import importlib
import json
import pathlib
import sys
from pprint import pformat
from typing import Any, Dict, Tuple, Type

# --- repo dirs
ROOT = pathlib.Path(__file__).resolve().parents[1]
SCHEMAS_DIR = ROOT / "jsonschema"
EXAMPLES_DIR = ROOT / "examples"
PY_SRC = ROOT / "python" / "src"

# Make generated package importable without install
if str(PY_SRC) not in sys.path:
    sys.path.insert(0, str(PY_SRC))

# JSON Schema validator
import jsonschema
from jsonschema.validators import Draft202012Validator

# Skip any examples placed under this folder
SKIP_SUBDIR = EXAMPLES_DIR / "_skip"

# filename token  -> (python module name, candidate class names, schema filename)
# (Order matters; longer/more specific tokens should be checked first)
TOKENS: Dict[str, Tuple[str, str, str]] = {
    # asset
    "synestheticasset": ("synesthetic_asset", "SynestheticAsset", "synesthetic-asset.schema.json"),
    "asset":            ("synesthetic_asset", "SynestheticAsset", "synesthetic-asset.schema.json"),
    # control
    "control-bundle":   ("control_bundle",    "ControlBundle|ControlBundleSchema", "control-bundle.schema.json"),
    "control":          ("control",           "Control", "control.schema.json"),
    # components
    "shaderlib":        ("shader_lib",        "ShaderLib|ShaderLibrary", "shader_lib.schema.json"),
    "shader":           ("shader",            "Shader", "shader.schema.json"),
    "tone":             ("tone",              "Tone", "tone.schema.json"),
    "haptic":           ("haptic",            "Haptic", "haptic.schema.json"),
    # rules
    "rule-bundle":      ("rule_bundle",       "RuleBundle|RuleBundleSchema", "rule-bundle.schema.json"),
    "rule":             ("rule",              "Rule|RuleSchema", "rule.schema.json"),
}


def _normalize(o: Any) -> Any:
    """Sort keys, drop None, and coerce ints/floats so 1 == 1.0."""
    if isinstance(o, dict):
        return {k: _normalize(v) for k, v in sorted(o.items()) if v is not None}
    if isinstance(o, list):
        return [_normalize(v) for v in o]
    if isinstance(o, bool):  # bool is a subclass of int; keep as-is
        return o
    if isinstance(o, (int, float)):
        return float(o)
    return o


def _load_schema_store() -> Dict[str, Any]:
    """Build a resolver store keyed by $id (or filename as a fallback)."""
    store: Dict[str, Any] = {}
    for p in SCHEMAS_DIR.glob("*.schema.json"):
        data = json.loads(p.read_text())
        sid = data.get("$id") or p.name
        store[sid] = data
        # Also allow bare filename lookups for convenience
        store[p.name] = data
    return store


def _validator_for(schema_name: str) -> Draft202012Validator:
    schema_path = SCHEMAS_DIR / schema_name
    if not schema_path.exists():
        raise FileNotFoundError(f"schema not found: {schema_path}")
    schema = json.loads(schema_path.read_text())
    store = _load_schema_store()
    # Deprecation is fine here; jsonschema.RefResolver works for local bundling.
    resolver = jsonschema.RefResolver.from_schema(schema, store=store)  # internal use ok
    return Draft202012Validator(schema, resolver=resolver)


def _pick_model_and_schema(example_path: pathlib.Path) -> Tuple[Type | None, str | None, str]:
    """
    Return (model_cls or None, schema_file or None, reason_if_none).
    Chooses by filename tokens and imports the module, selecting the first
    class that exists from the candidate list.
    """
    n = example_path.name.lower()

    # Prefer longest tokens first to avoid substring collisions (e.g., "control-bundle" vs "control")
    for token in sorted(TOKENS.keys(), key=len, reverse=True):
        if token in n:
            module_name, candidates, schema_file = TOKENS[token]
            try:
                mod = importlib.import_module(f"synesthetic_schemas.{module_name}")
            except Exception as e:
                return None, None, f"import failed: synesthetic_schemas.{module_name}: {e}"
            for cls_name in candidates.split("|"):
                if hasattr(mod, cls_name):
                    return getattr(mod, cls_name), schema_file, ""
            return None, None, f"no candidate class in synesthetic_schemas.{module_name} (tried {candidates})"

    return None, None, f"no filename token match (expected one of: {list(TOKENS.keys())})"


def _top_level_diff(a: Any, b: Any) -> Dict[str, Any]:
    """Small, helpful diff for top-level keys only."""
    A = _normalize(a)
    B = _normalize(b)
    if not isinstance(A, dict) or not isinstance(B, dict):
        return {"note": "non-dict at root after normalize"}
    ka, kb = set(A.keys()), set(B.keys())
    changed = sorted(k for k in ka & kb if _normalize(A[k]) != _normalize(B[k]))
    return {
        "only_in_input": sorted(ka - kb),
        "only_in_output": sorted(kb - ka),
        "changed_keys": changed[:8],  # keep it compact
    }


def validate_file(p: pathlib.Path) -> list[str]:
    errs: list[str] = []

    # Skip files under examples/_skip
    try:
        if SKIP_SUBDIR in p.parents:
            return errs
    except Exception:
        pass

    # Load JSON
    try:
        data = json.loads(p.read_text())
    except Exception as e:
        return [f"{p.name}: invalid JSON: {e}"]

    # Pick model & schema
    model_cls, schema_name, why = _pick_model_and_schema(p)
    if model_cls is None or schema_name is None:
        return [f"{p.name}: could not determine model/schema -> {why}"]

    # JSON Schema validation
    try:
        v = _validator_for(schema_name)
        v.validate(data)
    except Exception as e:
        errs.append(f"{p.name}: JSON Schema validation failed: {e}")

    # Pydantic validation + round-trip
    try:
        model = model_cls.model_validate(data)
        out = model.model_dump(mode="json", exclude_none=True)
        if _normalize(data) != _normalize(out):
            diff = _top_level_diff(data, out)
            errs.append(f"{p.name}: round-trip mismatch (diff={pformat(diff)})")
    except Exception as e:
        errs.append(f"{p.name}: Pydantic validation failed: {e}")

    return errs


def main() -> int:
    if not EXAMPLES_DIR.exists():
        print(f"examples dir missing: {EXAMPLES_DIR}")
        return 2

    # All *.json under examples/, excluding examples/_skip/**
    files = []
    for f in EXAMPLES_DIR.rglob("*.json"):
        if SKIP_SUBDIR in f.parents:
            continue
        files.append(f)
    files = sorted(files)

    if not files:
        print("No example JSON files found in examples/")
        return 2

    all_errs: list[str] = []
    for f in files:
        all_errs += validate_file(f)

    if all_errs:
        for e in all_errs:
            print(e)
        print(f"❌ {len(all_errs)} issue(s) across {len(files)} file(s).")
        return 1

    print(f"✅ {len(files)} example file(s) validated and round-tripped clean.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
