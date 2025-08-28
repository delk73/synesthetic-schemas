# Modernize jsonschema usage (migrate from RefResolver)

- Motivation: `RefResolver` is legacy in newer `jsonschema` versions; modern APIs use `referencing`.
- Scope: Tracking + migration plan; optional POC.

## Tasks
- Research a path to Draft 2020-12 with an in-memory store using modern APIs.
- Prototype a branch that replaces `RefResolver` in `scripts/validate_examples.py` and lifts the `<4.18` pin in `pyproject.toml`.
- Confirm parity on example validations and round-trip checks.

## Acceptance Criteria
- Documented migration plan; optional proof-of-parity implementation behind a flag or branch.

