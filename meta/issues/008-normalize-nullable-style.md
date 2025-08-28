# Normalize nullable style consistently

- Motivation: Schemas mix `anyOf: [T, null]` and `type: ["string","null"]`. Consistency improves readability and codegen diffs.
- Scope: Extend normalizer to rewrite nullability to a single style.

## Tasks
- Choose a single representation (e.g., `type: [T, "null"]`).
- Update `scripts/normalize_schemas.py` to rewrite patterns consistently (preserve semantics).
- Run on all schemas and regen code; verify no semantic change beyond formatting.

## Acceptance Criteria
- All schemas use one nullability style.
- Codegen outputs remain compatible; example validation passes.

