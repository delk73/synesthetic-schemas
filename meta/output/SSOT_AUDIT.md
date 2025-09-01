# SSOT Audit Report

- Objective: Audit the SSOT repository to produce a deterministic Markdown report confirming adherence to foundational, validation, codegen, and hygiene standards.
- Constraints:
  - no_db_migrations: True
  - output: Markdown only; write to meta/output/SSOT_AUDIT.md; do not print to stdout
  - python: 3.11
  - schema_draft: 2020-12
  - style: KISS, deterministic, minimal deps

## A1 — Foundations

### C1: Centralized schema version — PASS

- Found schemaVersion in version.json: 0.7.3
- Python helper references version.json: scripts/lib/version.py
- TS helper references version.json: codegen/lib/version.mjs
- Checks: Confirm `version.json` contains the `schemaVersion` key.; Verify all other code references this single source for the version.
- Acceptance: The `schemaVersion` is defined exclusively in `version.json`.; All helper scripts in Python and TS correctly read from this file.

### C2: Python type distribution — PASS

- Present: python/src/synesthetic_schemas/py.typed
- Checks: Verify the `py.typed` marker file is present in the Python source directory.
- Acceptance: The Python package is configured to correctly export inline types for tools like mypy.

## A2 — Validation & Normalization

### C3: Schema structural integrity — PASS

- 9 schemas OK; all unique $id and correct draft
- Checks: Confirm every schema file contains a unique, non-empty `$id`.; Confirm every schema file specifies `$schema` as 'https://json-schema.org/draft/2020-12/schema'.
- Acceptance: All schemas are uniquely identified and use the correct draft.; All schema `$id` values are unique across the project.

### C4: Example to schema linkage — PASS

- 14 examples OK
- Checks: Confirm every example JSON file contains a top-level `"$schemaRef"` key pointing to a valid schema.
- Acceptance: All examples pass strict validation against their linked schemas.

## A3 — Deterministic Codegen & CI

### C5: Codegen and CI parity — PASS

- TS codegen uses repo-local json2ts (node_modules/.bin)
- Python codegen uses datamodel-code-generator (CLI or module)
- ensure_codegen_clean.sh fails on real diffs
- CI executes the same preflight.sh as local
- Checks: Confirm codegen scripts use project-local dependencies.; Verify `ensure_codegen_clean.sh` exits with a non-zero code on diffs.; Confirm the CI workflow executes the same `preflight.sh` script used for local validation.
- Acceptance: Codegen on a clean tree produces a zero-change diff.; Local and CI validation workflows execute identical steps.

## A4 — Naming & Docs Hygiene

### C6: Naming and documentation clarity — PASS

- README describes preflight and versioning workflows
- CONTRIBUTING mentions contributor workflows
- Checks: Verify `$defs` keys use canonical `PascalCase` names.; Verify top-level schema `title` matches the kebab-case filename stem (e.g., `synesthetic-asset`).; Verify each schema `$id` ends with the schema filename (e.g., `.../synesthetic-asset.schema.json`).; Confirm that reusable object structures are defined within a schema's `$defs` section (manual spot-check acceptable).; Verify that `README.md` and `CONTRIBUTING.md` describe the preflight and versioning workflows.; Optional: Manual/External — consider Spectral for extended style rules.
- Acceptance: `$defs` names are PascalCase across schemas.; Top-level titles match file stem (kebab-case).; Each `$id` ends with its schema filename.; Reusable schema objects are defined centrally within `$defs`.; Contributor docs provide clear guidance for essential workflows.

## Done Definition

- The audit report is successfully generated at `meta/SSOT_AUDIT.md`.
- Every schema contains a unique `$id` and declares the target JSON Schema draft.
- Every example is valid and correctly linked to its schema via `$schemaRef`.
- The codebase is in a clean state, proven by a passing codegen drift check.
- Local preflight execution mirrors the passing CI workflow, ensuring parity.
