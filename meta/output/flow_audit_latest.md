## Repository State Summary
| Check | Status | Evidence |
| --- | --- | --- |
| Schema sources keep placeholder host | PASS | `jsonschema/control-bundle.schema.json:2` sets `$id` to `https://schemas.synesthetic.dev/0.7.3/control-bundle.schema.json`. |
| Published artifacts use canonical host | PASS | `docs/schema/0.7.3/control-bundle.schema.json:2` rewrites `$id` to `https://delk73.github.io/synesthetic-schemas/schema/0.7.3/control-bundle.schema.json`. |
| Active version pinned to 0.7.3 | PASS | `version.json:2` stores `"schemaVersion": "0.7.3"`. |

## Schema Source vs Published Artifact Boundary
| Item | Status | Evidence |
| --- | --- | --- |
| Placeholder host retained in source refs | PASS | `jsonschema/synesthetic-asset.schema.json:9` references `https://schemas.synesthetic.dev/0.7.3/control-bundle.schema.json`. |
| Canonical host propagated in published refs | PASS | `docs/schema/0.7.3/synesthetic-asset.schema.json:9` references `https://delk73.github.io/synesthetic-schemas/schema/0.7.3/control-bundle.schema.json`. |
| Drift limited to host substitution | WARN | Source files lack trailing newlines (`jsonschema/synesthetic-asset.schema.json:162`, `jsonschema/tone.schema.json:469`) so the published copies diverge beyond host rewrites (`docs/schema/0.7.3/synesthetic-asset.schema.json:162`, `docs/schema/0.7.3/tone.schema.json:469`). |

## Version and Canonical Host Verification
| Item | Status | Evidence |
| --- | --- | --- |
| version.json matches release tag | PASS | `version.json:2` equals `"0.7.3"`. |
| Source `$id` values use placeholder domain | PASS | `jsonschema/control-bundle.schema.json:2` anchors to the placeholder host. |
| Published `$id` values align with canonical path | PASS | `docs/schema/0.7.3/control-bundle.schema.json:2` matches the GitHub Pages host. |
| Published `$ref` values are canonical | PASS | `docs/schema/0.7.3/synesthetic-asset.schema.json:9` links to the canonical control bundle. |

## Makefile Entrypoint Integrity
| Item | Status | Evidence |
| --- | --- | --- |
| Required governance targets defined | PASS | `Makefile:14-47` includes normalize, preflight, preflight-fix, publish-schemas, codegen-check, and check-schema-ids. |
| publish-schemas enforces host rewrite safety | PASS | `Makefile:76-102` blocks relative `$ref` values and performs placeholder → canonical substitution. |
| check-schema-ids verifies canonical host usage | PASS | `Makefile:104-106` greps published artifacts for non-canonical `$id` entries. |
| Code generation cleanliness enforced | PASS | `scripts/ensure_codegen_clean.sh:1-23` regenerates SDKs and restores timestamp-only noise. |

## Preflight & Build Determinism
| Item | Status | Evidence |
| --- | --- | --- |
| preflight orchestrates required checks | PASS | `preflight.sh:9-24` runs normalize-check, schema-lint, codegen-check, and example validation via Poetry. |
| preflight writes only ignored artifacts | PASS | `.gitignore:2-18` ignores `.cache/` and `typescript/tmp/`, covering the timestamp drop from `preflight.sh:27-30`. |
| build script guardrails | PASS | `build.sh:7-37` enforces Nix shell, validates the Poetry environment, and limits work to generation plus validation. |

## Example Corpus Consistency
| Observation | Status | Evidence |
| --- | --- | --- |
| Examples reference source schemas via relative `$schema` | WARN | `examples/Control-Bundle_Example.json:2` points to `jsonschema/control-bundle.schema.json` while `examples/README.md:10` claims validation against the canonical host. |
| Strict validation wiring present | PASS | `Makefile:34-35` routes `make validate` through `scripts/validate_examples.py --strict --dir examples`. |
| Audit run avoided executing validation commands | N/A | Flow objective prohibits runtime validation during this assessment. |

## Detected Divergences
| Issue | Severity | Evidence |
| --- | --- | --- |
| Normalization script rewrites `jsonschema/` despite spec prohibition | HIGH | `scripts/normalize_schemas.py:259-313` overwrites source files, and `Makefile:16-18` invokes it without `--check`. |
| Source schemas missing trailing newline cause non-host drift | MEDIUM | `jsonschema/synesthetic-asset.schema.json:162` and `jsonschema/tone.schema.json:469` lack final newlines compared with `docs/schema/0.7.3/synesthetic-asset.schema.json:162` and `docs/schema/0.7.3/tone.schema.json:469`. |
| Examples contradict canonical-host guidance | LOW | `examples/README.md:10` promises canonical URLs, yet `examples/Control-Bundle_Example.json:2` retains a repo-relative `$schema`. |

## Remediation Actions
| Priority | Action | Owner | Notes |
| --- | --- | --- | --- |
| High | Update `scripts/normalize_schemas.py` (or the governing spec) so normalization no longer mutates `jsonschema/*.schema.json`, keeping compliance with the no-modification rule. | Schema WG | Consider making `make normalize` a check-only gate or redirecting rewrites into a staging directory before publication. |
| Medium | Add trailing newlines to `jsonschema/synesthetic-asset.schema.json` and `jsonschema/tone.schema.json`, then re-run `make publish-schemas` to eliminate non-host drift. | Schema WG | Restores byte-identical parity aside from host substitution. |
| Low | Align example metadata with README guidance by pointing `$schema` to the canonical host or revising the documentation. | Docs WG | Keeps developer expectations consistent with the published artifacts. |
