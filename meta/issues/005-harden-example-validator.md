# Harden example validator: derive schema by $schema/$id

- Motivation: `scripts/validate_examples.py` uses filename tokens to pick models/schemas, which is brittle.
- Scope: Prefer `$schema` (or `$id`) in example files to select schema and corresponding Python model.

## Tasks
- Update `scripts/validate_examples.py` to read `$schema` from each example; fallback to `$id` or current token heuristic if absent.
- Map `$id` → local schema filename → python module/class (robustly), with clear fallback behavior.

## Acceptance Criteria
- Examples validate without depending on filename token conventions.
- Round-trip and error reporting continue to work.

