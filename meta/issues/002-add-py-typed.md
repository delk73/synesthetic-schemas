# Add py.typed for Python package

- Motivation: `python/pyproject.toml` declares `py.typed`, but the file is missing. Downstream type checkers won’t treat the package as typed.
- Scope: Add the marker file and ensure it’s included in builds.

## Tasks
- Create `python/src/synesthetic_schemas/py.typed` (empty file).
- Optionally verify sdist/wheel include the file (if/when publishing).

## Acceptance Criteria
- Installing the package makes type information available to mypy/pyright.

