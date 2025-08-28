# Factor shared `$defs` into a common schema

- Motivation: Enums/types like `AxisType`, `CurveType`, `DataType`, and `ComboType` are duplicated across schemas.
- Scope: Create a `common.schema.json` with shared `$defs` and reference it.

## Tasks
- Add `jsonschema/common.schema.json` exporting shared definitions.
- Update other schemas to `$ref` the common defs using canonical `$id`.
- Regenerate code and validate examples.

## Acceptance Criteria
- Duplication reduced (schemas reference common defs).
- Generated Python/TypeScript still compile; end-to-end validation passes.

