# Centralize schema version (single source of truth)

- Motivation: The version appears in several places (`scripts/normalize_schemas.py`, `codegen/ts_bundle.mjs`, and schema `$id`s). Centralizing reduces drift.
- Scope: Introduce a top-level `VERSION` file (or small TOML) and read it where needed.

## Tasks
- Add `VERSION` at repo root (e.g., `0.1.0`).
- Update `scripts/normalize_schemas.py` and `codegen/ts_bundle.mjs` to read the version from this file.
- Optionally add a check script to ensure schema `$id` and `x-schema-version` match the central version.

## Acceptance Criteria
- Bumping a single version source updates `$id`/`x-schema-version` and bundling behavior.

