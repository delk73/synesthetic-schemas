# Consolidate Node tooling location

- Motivation: Dev dependencies are split across root `package.json` and `typescript/package.json`. Consolidation simplifies maintenance.
- Scope: Choose a single place for Node tooling (recommend `typescript/`).

## Tasks
- Decide the single Node project location (root vs `typescript/`).
- Move dev dependencies and scripts there; remove duplicates.
- Update docs/README and scripts accordingly.

## Acceptance Criteria
- One Node project manages bundling and TS codegen. No duplicate dev deps.

