---
version: v0.7.3
lastReviewed: 2025-10-12
owner: delk73
---

# Synesthetic Schemas: Expected State & Flow

## 1. Golden Sources & Artifacts
- **Editable source:** `jsonschema/*.schema.json` — the *only* hand-edited schema definitions.
- **Published artifacts:** `docs/schema/0.7.3/*.schema.json` — generated and immutable per release.
- **Version pin:** `version.json` (`schemaVersion` key) drives `$id` rewriting and publish paths.
- **Generated SDKs:** `python/src/synesthetic_schemas/` and `typescript/src/` are disposable; regenerate as needed.
- **Examples:** `examples/` must validate against the live version and represent canonical round-trips.

---

## 2. Environments & Tooling
- Work inside `nix develop`; it provides Poetry, Node, and the required toolchain.
- After entering the shell, run once per checkout:
  ```bash
  poetry install
  npm install
  ```

- All `make` and script targets assume `poetry run` or Nix context.
  Avoid system Python/Node outside Nix.

---

## 3. Day-to-Day Schema Loop

1. Edit schemas in `jsonschema/`.
2. Run `make normalize` to regenerate the published schemas under `docs/schema/<version>/` with canonical `$id` and `$ref` URLs.
3. Run `./build.sh` for fresh SDK codegen and validation (requires Nix + Poetry).
4. Run `make codegen-check` to confirm deterministic outputs for Python/TypeScript.
5. Run `./preflight.sh` for a read-only CI parity check (`--check` mode, codegen-check, and example validation).
6. Fix drift until `git status` is clean except for intentional schema edits.

### Expected Clean State After Preflight

* No diff between `jsonschema/` and `docs/schema/0.7.3/` except `$id`/`$ref` host substitution.
* `codegen-check` passes deterministically.
* `.cache/last_preflight.txt` timestamp updated (informational).

---

## 3.1 Source vs Published Transformation Rules

| Directory                    | Role                          | Host Pattern                                                      | Transformation Policy                                                                       |
| ---------------------------- | ----------------------------- | ----------------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| **`jsonschema/`**            | Authoritative editable source | `https://schemas.synesthetic.dev/<version>/…`                     | Never rewritten. Placeholder host is retained. No extra metadata or transient keys allowed. |
| **`docs/schema/<version>/`** | Generated publish target      | `https://delk73.github.io/synesthetic-schemas/schema/<version>/…` | `$id`/`$ref` rewritten during `make publish-schemas`. May include governance metadata.      |
| **Diff policy**              | —                             | —                                                                 | Validation ignores host substitution differences only. All other content must be identical. |

**Invariant:** Normalization scripts must *never* alter or inject keys in `jsonschema/*.schema.json`.
Any stray key (e.g., `"d"`) is invalid and stripped during publish.

---

## 4. Release & Publication Flow

1. Confirm `main` is stable; run `./preflight.sh`.
2. Bump schema version when changes require:

   ```bash
   make bump-version VERSION=X.Y.Z
   ```

   Updates `version.json`, front matter, and copies normalized outputs to `docs/schema/<version>/`.
3. Publish schemas explicitly:

   ```bash
   make publish-schemas
   ```

   Ensures `$id`/`$ref` use the canonical GitHub Pages host.
4. Tag and push:

   ```bash
   git tag vX.Y.Z && git push --tags
   ```

   GitHub Actions builds and serves from
   `https://delk73.github.io/synesthetic-schemas/schema/<version>/`.
5. Treat `docs/schema/<version>/` as immutable post-publish.
   Any correction requires a new version.

---

## 5. Audit & Governance Checks

* **Schema audit prompts:** Run sequentially from `meta/prompts/` using
  `python -m codex audit --prompt ...`. Each must emit non-empty artifacts to `meta/output/`.
* **Governance compliance:** `docs/governance.md` defines metadata policy.
  Align `version`, `lastReviewed`, and `owner` with `version.json`.
* **$id enforcement:**
  `make check-schema-ids` verifies canonical host usage in published artifacts.
* **Cross-version validation:**

  ```bash
  poetry run python scripts/validate_schemas.py https://delk73.github.io/synesthetic-schemas/schema/<version>/
  ```

  ensures public URL consistency.

---

## 6. Repository Hygiene Expectations

* **Tracked outputs:** `python/src/...`, `typescript/src/...`, and `docs/schema/<version>/` remain in Git but change only via official build steps.
* **Ephemeral caches:** `.cache/`, `meta/output/`, `typescript/tmp/` may vary locally.
  Commit only when governance artifacts are required.
* **No binary junk:** `checkbloat` confirms `.venv/` or `node_modules/` aren’t tracked.
* **Lockfiles:** Keep `poetry.lock` and `package-lock.json` synchronized after any dependency change.

---

## 7. Troubleshooting & Resets

* **Schema drift:**
  `make normalize` or `make preflight-fix` regenerates canonical outputs.
* **Codegen mismatch:**
  `./build.sh` or `make codegen-{py,ts,check}` to resync SDKs.
* **Hard reset (non-destructive):**

  ```bash
  exit
  rm -rf .venv/ node_modules/ .cache/ meta/output/ \
         python/src/synesthetic_schemas/ typescript/src/ typescript/tmp/
  nix develop
  poetry install
  npm install
  ```
* **Preflight timestamp issues:**
  Delete `.cache/last_preflight.txt` and rerun `./preflight.sh`.

---

## 8. When Opening a PR

* Include the latest `./preflight.sh` run (timestamp file aids reviewers).
* Attach audit artifacts from `meta/output/` if governance content changed.
* Document any intended divergence in generated artifacts.

---

### Summary

* `jsonschema/` = stable authoring layer (placeholder host).
* `docs/schema/<version>/` = derived publication layer (canonical host).
* No normalization or metadata injection ever touches source schemas.
* Validation and audits permit only host substitution differences.
* `publish-schemas` performs the sole authorized rewrite for public delivery.