# Unify codegen diff scripts and document usage

-- Motivation: Two similar scripts exist: `scripts/diff_codegen.sh` and `scripts/ensure_codegen_clean.sh`. Consolidation reduces confusion.
-- Scope: Choose one path and document usage; wire into CI.

## Tasks
- Keep a single canonical script; have the other call it or remove it.
- Update README to point to the canonical script.
- Ensure CI (see CI issue) uses the canonical script.

## Acceptance Criteria
- One documented entrypoint for codegen diff checks; CI uses it.

