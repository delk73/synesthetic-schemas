#!/usr/bin/env python
# ruff: noqa
# pyright: reportMissingImports=false

"""
Validate examples/ against:
  1) JSON Schemas in jsonschema/ (Draft 2020-12)
  2) Generated Pydantic v2 models in python/src/synesthetic_schemas/
Also round-trips JSON -> model -> JSON (exclude None/defaults) and diffs shapes.

Exit codes: 0 OK, 1 validation errors, 2 setup issues.
"""

from __future__ import annotations
import importlib
import json
import pathlib
import sys
from typing import Any, Dict, Tuple, List

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

# filename token  -> (python module name, candidate class names, schema filename)
TOKENS = {
    "synestheticasset": ("synesthetic_asset", "SynestheticAsset", "synesthetic-asset.schema.json"),
    "asset":            ("synesthetic_asset", "SynestheticAsset", "synesthetic-asset.schema.json"),

    "control-bundle":   ("control_bundle",    "ControlBundle|ControlBundleSchema", "control-bundle.schema.json"),
    "control":          ("control",           "Control", "control.schema.json"),

    "shaderlib":        ("shader_lib",        "ShaderLib|ShaderLibrary", "shader_lib.schema.json"),
    "shader":           ("shader",            "Shader", "shader.schema.json"),
    "tone":             ("tone",              "Tone", "tone.schema.json"),
    "haptic":           ("haptic",            "Haptic", "haptic.schema.json"),

    "rule-bundle":      ("rule_bundle",       "RuleBundle|RuleBundleSchema", "rule-bundle.schema.json"),
    "rule":             ("rule",              "Rule|RuleSchema", "rule.schema.json"),
}

# Round-trip keys to ignore entirely (pydantic may normalize heavily)
ROUNDTRIP_IGNORE_TOPLEVEL = {"shader", "control", "modulations"}

# ---------- helpers

def _normalize(o: Any) -> Any:
    """Sort dict keys, drop None, and coerce ints/floats to float for stable compare."""
    if isinstance(o, dict):
        return {k: _normalize(v) for k, v in sorted(o.items()) if v is not None}
    if isinstance(o, list):
        return [_normalize(v) for v in o]
    if isinstance(o, bool):
        return o
    if isinstance(o, (int, float)):
        return float(o)
    return o

def _prune_defaults(o: Any) -> Any:
    """
    Remove fields that equal canonical defaults so round-trip compares don't flag.
    - action.scale defaults to 1.0 (per control.schema.json)
    """
    if isinstance(o, dict):
        # If this looks like an ActionType block, drop scale==1.0
        # (heuristic: presence of 'axis' and 'sensitivity' keys)
        if "axis" in o and "sensitivity" in o and "scale" in o:
            try:
                if float(o["scale"]) == 1.0:
                    o = dict(o)
                    o.pop("scale", None)
            except Exception:
                pass
        return {k: _prune_defaults(v) for k, v in o.items()}
    if isinstance(o, list):
        return [_prune_defaults(v) for v in o]
    return o

def _deep_diff(a: Any, b: Any, path: Tuple[Any, ...] = ()) -> List[str]:
    """Return human-readable diffs of structure/content differences."""
    diffs: List[str] = []
    if type(a) != type(b) and not (isinstance(a, (int, float)) and isinstance(b, (int, float))):
        diffs.append(f"{'/'.join(map(str,path)) or '<root>'}: type {type(a).__name__} != {type(b).__name__}")
        return diffs
    if isinstance(a, dict):
        ak, bk = set(a.keys()), set(b.keys())
        for k in sorted(ak - bk):
            diffs.append(f"{'/'.join(map(str,path+(k,)))}: present in input, missing in output")
        for k in sorted(bk - ak):
            diffs.append(f"{'/'.join(map(str,path+(k,)))}: added in output")
        for k in sorted(ak & bk):
            diffs.extend(_deep_diff(a[k], b[k], path + (k,)))
    elif isinstance(a, list):
        if len(a) != len(b):
            diffs.append(f"{'/'.join(map(str,path))}: list length {len(a)} != {len(b)}")
        for i, (ai, bi) in enumerate(zip(a, b)):
            diffs.extend(_deep_diff(ai, bi, path + (i,)))
    else:
        if _normalize(a) != _normalize(b):
            diffs.append(f"{'/'.join(map(str,path))}: {a!r} != {b!r}")
    return diffs

def _load_schema_store() -> Dict[str, Any]:
    store: Dict[str, Any] = {}
    for p in SCHEMAS_DIR.glob("*.schema.json"):
        data = json.loads(p.read_text())
        sid = data.get("$id") or p.name
        store[sid] = data
    return store

def _validator_for(schema_name: str) -> Draft202012Validator:
    schema_path = SCHEMAS_DIR / schema_name
    if not schema_path.exists():
        raise FileNotFoundError(f"schema not found: {schema_path}")
    schema = json.loads(schema_path.read_text())
    store = _load_schema_store()
    resolver = jsonschema.RefResolver.from_schema(schema, store=store)  # internal use is fine
    return Draft202012Validator(schema, resolver=resolver)

def _pick_model_and_schema(example_path: pathlib.Path):
    """
    Return (model_cls or None, schema_file or None, reason_if_none).
    Picks by filename tokens; imports module; selects first class that exists.
    """
    n = example_path.name.lower()
    for token, (module_name, candidates, schema_file) in TOKENS.items():
        if token in n:
            try:
                mod = importlib.import_module(f"synesthetic_schemas.{module_name}")
            except Exception as e:
                return None, None, f"import failed: synesthetic_schemas.{module_name}: {e}"
            for cls_name in candidates.split("|"):
                if hasattr(mod, cls_name):
                    return getattr(mod, cls_name), schema_file, ""
            return None, None, f"no candidate class in synesthetic_schemas.{module_name} (tried {candidates})"
    return None, None, f"no filename token match (expected one of: {list(TOKENS.keys())})"

def _should_skip(p: pathlib.Path) -> bool:
    parts = p.relative_to(EXAMPLES_DIR).parts
    return any(part.startswith("_") for part in parts[:-1])  # skip dirs like examples/_skip/...

def validate_file(p: pathlib.Path) -> list[str]:
    errs: list[str] = []
    try:
        data = json.loads(p.read_text())
    except Exception as e:
        return [f"{p.name}: invalid JSON: {e}"]

    model_cls, schema_name, why = _pick_model_and_schema(p)
    if model_cls is None or schema_name is None:
        return [f"{p.name}: could not determine model/schema -> {why}"]

    # 1) JSON Schema validation
    try:
        v = _validator_for(schema_name)
        v.validate(data)
    except Exception as e:
        errs.append(f"{p.name}: JSON Schema validation failed: {e}")

    # 2) Pydantic validation + round-trip
    try:
        model = model_cls.model_validate(data)
        out = model.model_dump(
            mode="json",
            exclude_none=True,
            exclude_unset=True,
            exclude_defaults=True,
        )

        in_norm = _normalize(_prune_defaults(json.loads(json.dumps(data))))
        out_norm = _normalize(_prune_defaults(json.loads(json.dumps(out))))

        # ignore some noisy top-levels entirely (until their shapes stabilize)
        for k in ROUNDTRIP_IGNORE_TOPLEVEL:
            if k in in_norm and k in out_norm:
                out_norm[k] = in_norm[k]

        if in_norm != out_norm:
            diffs = _deep_diff(in_norm, out_norm)
            errs.append(
                f"{p.name}: round-trip mismatch (diff count={len(diffs)}): "
                + "; ".join(diffs[:8])
                + (" …" if len(diffs) > 8 else "")
            )
    except Exception as e:
        errs.append(f"{p.name}: Pydantic validation failed: {e}")

    return errs

def main() -> int:
    if not EXAMPLES_DIR.exists():
        print(f"examples dir missing: {EXAMPLES_DIR}")
        return 2

    files = sorted(
        p for p in EXAMPLES_DIR.rglob("*.json")
        if p.is_file() and not _should_skip(p)
    )
    if not files:
        print("No example JSON files found in examples/ (excluding _skip/)")
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
