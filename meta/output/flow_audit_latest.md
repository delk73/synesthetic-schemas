+## Summary of repository operational compliance
+| Area | Status | Details |
+| --- | --- | --- |
+| Editable host policy | FAIL | Sources mix placeholder host with bare relative refs, and `make publish-schemas` rewrites sources to canonical host (jsonschema/synesthetic-asset.schema.json:89; Makefile:82-88). |
+| Published schema hygiene | FAIL | Docs contain disallowed `raw.githubusercontent.com` metadata (docs/schema/0.7.3/control.schema.json:241). |
+| Normalization discipline | FAIL | JSON sources already include injected `"d"` fields pointing at raw GitHub, violating “no transient keys” (jsonschema/control.schema.json:130). |
+| Tooling targets available | PASS | Required Makefile targets exist (Makefile:13-95). |
+| Validation coverage | PASS | `python3 scripts/validate_examples.py --dir examples --strict` and `python3 scripts/validate_schemas.py` succeeded. |
+| Automation env readiness | WARN | `preflight.sh` expects Poetry and `build.sh` demands an active Nix shell, so neither ran in the bare audit shell (preflight.sh:9-29; build.sh:8-37). |
+
+## Editable vs generated schema boundary check
+| Location | Expectation | Status | Notes |
+| --- | --- | --- | --- |
+| `jsonschema/` | Sole editable source using placeholder host and no transient keys | FAIL | Relative `$ref` lacks placeholder host (jsonschema/synesthetic-asset.schema.json:89) and `"d"` metadata persists (jsonschema/control.schema.json:130). |
+| `docs/schema/0.7.3/` | Immutable outputs, drift limited to host substitution | FAIL | Absolute `$ref` adds canonical host where source is relative, so drift exceeds host-only substitution (docs/schema/0.7.3/synesthetic-asset.schema.json:88). |
+| Repo root | No stray editable schemas | FAIL | `rule-bundle.schema.json` remains at root. |
+
+## Version.json alignment and $id verification
+| Item | Status | Details |
+| --- | --- | --- |
+| `version.json` schemaVersion | PASS | `schemaVersion` equals `0.7.3` (version.json:2). |
+| Published schema `$id` | PASS | `python3 scripts/validate_schemas.py` confirmed canonical IDs across docs. |
+| Source schema `$id` placeholder | PASS | `$id` values retain `https://schemas.synesthetic.dev/0.7.3/...` (jsonschema/control.schema.json:127). |
+
+## Makefile and build target presence check
+| Target | Status | Notes |
+| --- | --- | --- |
+| `normalize`, `normalize-check` | PASS | Defined and wired to normalizer (Makefile:13-17). |
+| `preflight`, `preflight-fix` | PASS | Present; `preflight-fix` chains normalization+checks (Makefile:38-44). |
+| `publish-schemas` | FAIL | Mutates source files before copying, breaching “docs-only drift” rule (Makefile:82-88). |
+| `check-schema-ids` | PASS | Greps docs for canonical IDs (Makefile:93-95). |
+| `codegen-check` | PASS | Delegates to `scripts/ensure_codegen_clean.sh` (Makefile:28-29). |
+
+## Preflight reproducibility and CI parity validation
+| Script / Check | Status | Notes |
+| --- | --- | --- |
+| `python3 scripts/normalize_schemas.py --check` | PASS | Reports all schemas normalized. |
+| `preflight.sh` | WARN | Fails immediately when Poetry absent; also writes `.cache/last_preflight.txt` (preflight.sh:9-29). |
+| `make preflight-fix` | WARN | Depends on same Poetry invocation; determinism unverified without environment. |
+| `build.sh` | WARN | Exits unless `IN_NIX_SHELL` set and Poetry venv exists; could not run in audit shell (build.sh:8-37). |
+
+## Example validation results
+| Command | Result | Notes |
+| --- | --- | --- |
+| `python3 scripts/validate_examples.py --dir examples --strict` | PASS | “15 example file(s) validated and round-tripped clean.” |
+| `python3 scripts/validate_schemas.py` | PASS | All docs schema IDs/refs canonical against Pages host. |
+
+## Detected drifts or missing targets
+| Issue | Impact | Evidence |
+| --- | --- | --- |
+| Relative refs in sources | Breaks placeholder-host guarantee and expands docs drift beyond host substitution | jsonschema/synesthetic-asset.schema.json:89 vs docs/schema/0.7.3/synesthetic-asset.schema.json:88. |
+| Publish step mutates sources | Violates separation of editable vs generated; rerunning publish rewrites jsonschema IDs | Makefile:82-88. |
+| Raw GitHub metadata | Contravenes prohibition on `raw.githubusercontent.com` in published schemas | docs/schema/0.7.3/control.schema.json:241. |
+| Injected `"d"` keys in sources | Indicates prior normalization/codegen added transient metadata | jsonschema/control.schema.json:130. |
+| Stray root schema file | Allows bypassing tooling boundary | rule-bundle.schema.json. |
+
+## Remediation actions
+| Priority | Action | Owner | Notes |
+| --- | --- | --- | --- |
+| High | Update normalizer/publish flow so jsonschema refs remain placeholder-absolute (no relative paths) and publish copies without mutating sources. | Schema WG | Consider staging docs rewrite into `docs/` using temporary copy. |
+| High | Strip all `raw.githubusercontent.com` and transient `"d"` fields from both sources and docs; enforce via lint. | Schema WG | Add check to normalization to block reintroduction. |
+| Medium | Relocate or delete root-level `rule-bundle.schema.json` so all editable schemas live under `jsonschema/`. | Schema WG | Preserve history via docs if needed. |
+| Medium | Provide documented Poetry/Nix bootstrap for `preflight.sh`/`build.sh`, or add guard messaging for contributors outside Nix. | Tooling | Enables audits without manual environment prep. |
