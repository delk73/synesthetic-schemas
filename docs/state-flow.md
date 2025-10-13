---
version: v0.7.3
lastReviewed: 2025-10-12
owner: delk73
---

# Synesthetic Schemas: Expected State & Flow

## 1. Golden Sources & Artifacts
- **Editable source:** `jsonschema/*.schema.json` (only place to hand-edit schema definitions).
- **Published artifacts:** `docs/schema/0.7.3/*.schema.json` (generated, immutable per release).
- **Version pin:** `version.json` (`schemaVersion` key) drives `$id` rewriting and publish paths.
- **Generated SDKs:** `python/src/synesthetic_schemas/` and `typescript/src/` are disposable build outputs; regenerate as needed.
- **Examples:** `examples/` must validate against the live version and represent canonical round-trips.

## 2. Environments & Tooling
- Run all work inside `nix develop`; it supplies Poetry, Node, and exact tooling.
- After entering the shell, run once per checkout:
  ```bash
  poetry install
  npm install
  ```
- Commands inside the repo assume `poetry run` context or the Nix shell; avoid running with system Python/Node.

## 3. Day-to-Day Schema Loop
1. Edit schemas in `jsonschema/`.
2. `make normalize` (rewrites `$id` / `$ref`, syncs to `docs/schema/<version>/`).
3. `./build.sh` when you need fresh codegen + validation (requires Nix + Poetry).
4. `./preflight.sh` for the read-only CI parity check (normalizes in `--check` mode, lints, validates examples).
5. Fix drift until `git status` is clean apart from intentional schema edits.

### Expected Clean State After Preflight
- No diff between `jsonschema/` and `docs/schema/0.7.3/` other than generated `$id` alignment.
- `codegen-check` passes (Python/TypeScript outputs match deterministic generation).
- `.cache/last_preflight.txt` updates timestamp (informational, keep committed if policy requires).

## 4. Release & Publication Flow
1. Confirm main is stable; run `./preflight.sh`.
2. Bump version when schema changes require it:
   ```bash
   make bump-version VERSION=X.Y.Z
   ```
   This updates `version.json`, front matter in docs, normalizes schemas, and copies them to `docs/schema/<version>/`.
3. Tag release (`git tag vX.Y.Z && git push --tags`); GitHub Actions builds and publishes `docs/` to Pages.
4. Once a version is published, treat `docs/schema/<version>/` as immutable. Hotfix = new version.

## 5. Audit & Governance Checks
- **Schema audit prompts:** Run sequentially from `meta/prompts/` using `python -m codex audit --prompt ...` (see README audit order). Each step must emit non-empty artifacts in `meta/output/`.
- **Governance compliance:** `docs/governance.md` is the source of record; keep metadata blocks (version, lastReviewed, owner) aligned with `version.json`.
- **$id enforcement:** `make check-schema-ids` ensures all published schemas use the canonical host (`https://delk73.github.io/synesthetic-schemas/schema/<version>/`).

## 6. Repository Hygiene Expectations
- **Tracked outputs:** Generated directories (`python/src/...`, `typescript/src/...`, `docs/schema/<version>/`) remain in Git but should only change via official build steps.
- **Ephemeral caches:** `.cache/`, `meta/output/`, and `typescript/tmp/` may change locally; only commit when governance or audit artefacts are required.
- **No stray virtualenv/node binaries:** `checkbloat` target verifies nothing like `.venv/` or `node_modules/` is accidentally tracked.

## 7. Troubleshooting & Resets
- **Schema drift:** Re-run `make normalize` or `make preflight-fix` to rewrite canonical outputs.
- **Misaligned codegen:** Run `./build.sh` or individual targets (`make codegen-py`, `make codegen-ts`, `make codegen-check`).
- **Hard reset (keep git history):**
  ```bash
  exit            # leave nix shell
  rm -rf .venv/ node_modules/ .cache/ meta/output/ \
         python/src/synesthetic_schemas/ typescript/src/ typescript/tmp/
  nix develop     # re-enter environment
  poetry install
  npm install
  ```
- **Preflight timestamp issues:** Delete `.cache/last_preflight.txt` and rerun `./preflight.sh`.

## 8. When Opening a PR
- Include the latest `./preflight.sh` run (timestamp file helps reviewers).
- Attach relevant audit outputs from `meta/output/` when governance changes occurred.
- Note any intentional divergence in generated artifacts so reviewers know what to expect.
