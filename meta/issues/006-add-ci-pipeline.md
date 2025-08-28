# Add CI: normalize → codegen → diff → validate

- Motivation: Prevent drift and catch schema/example breakage automatically.
- Scope: GitHub Actions workflow to run the end-to-end checks.

## Tasks
- Create `.github/workflows/ci.yml` that runs:
  - `python scripts/normalize_schemas.py`
  - `bash codegen/gen_py.sh`
  - `bash codegen/gen_ts.sh`
  - `scripts/ensure_codegen_clean.sh` (or `scripts/diff_codegen.sh`)
  - `PYTHONPATH=python/src python scripts/validate_examples.py`
- Set up Python and Node with caching where helpful.

## Acceptance Criteria
- CI fails on stale codegen, schema normalization issues, or example validation errors.

