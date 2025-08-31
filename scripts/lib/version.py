from __future__ import annotations

import json
import pathlib

# Repo root
ROOT = pathlib.Path(__file__).resolve().parents[2]


def schema_version() -> str:
    """Return the canonical schema version from version.json."""
    p = ROOT / "version.json"
    data = json.loads(p.read_text())
    v = data.get("schemaVersion")
    if not isinstance(v, str) or not v:
        raise RuntimeError("version.json missing 'schemaVersion' string")
    return v

