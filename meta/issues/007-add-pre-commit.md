# Add pre-commit hooks

- Motivation: Provide fast local feedback and reduce CI churn.
- Scope: Add `pre-commit` config for formatting and optional checks.

## Tasks
- Add `.pre-commit-config.yaml` with:
  - `ruff` format (and optionally lint)
  - (optional) a hook that runs the normalizer in `--check` mode
- Document installation/usage in `README.md`.

## Acceptance Criteria
- `pre-commit run -a` passes locally.
- Formatting and basic checks run automatically on commits.

