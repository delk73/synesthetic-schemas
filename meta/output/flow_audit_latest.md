## Repository State Summary
| Check | Status | Evidence |
| --- | --- | --- |
| Placeholder host preserved in schema sources | PASS | `jsonschema/control.schema.json:127` keeps `$id` on `https://schemas.synesthetic.dev/0.7.3/...`. |
| Canonical host applied in published artifacts | PASS | `docs/schema/0.7.3/control.schema.json:127` rewrites `$id` to `https://delk73.github.io/synesthetic-schemas/schema/0.7.3/...`. |
| Version pin consistent | PASS | `version.json:2` stores `"schemaVersion": "0.7.3"`. |
| Known compliance risks documented | WARN | See Detected Divergences for newline drift and the `meta/output/` tracking policy conflict. |

## Schema Source vs Published Artifact Boundary
| Item | Status | Evidence |
| --- | --- | --- |
| Placeholder host retained in cross-schema refs | PASS | `jsonschema/synesthetic-asset.schema.json:9` references `https://schemas.synesthetic.dev/0.7.3/control-bundle.schema.json`. |
| Canonical host propagated in published refs | PASS | `docs/schema/0.7.3/synesthetic-asset.schema.json:9` references `https://delk73.github.io/synesthetic-schemas/schema/0.7.3/control-bundle.schema.json`. |
| Drift limited to host substitution | WARN | Source copies lack trailing newlines in `jsonschema/synesthetic-asset.schema.json:162` and `jsonschema/tone.schema.json:469`, while the published counterparts retain them, introducing formatting drift beyond host substitution. |

## Version and Canonical Host Verification
| Item | Status | Evidence |
| --- | --- | --- |
| version.json matches release tag | PASS | `version.json:2` equals `"0.7.3"`. |
| Source `$id` values use placeholder domain | PASS | `jsonschema/control-bundle.schema.json:2` sets `$id` to `https://schemas.synesthetic.dev/0.7.3/control-bundle.schema.json`. |
| Published `$id` values align with canonical path | PASS | `docs/schema/0.7.3/control-bundle.schema.json:2` matches the expected canonical URL. |

## Makefile Entrypoint Integrity
| Item | Status | Evidence |
| --- | --- | --- |
| Required governance targets defined | PASS | `Makefile:14-47` includes normalize, preflight, preflight-fix, publish-schemas, codegen-check, and check-schema-ids. |
| publish-schemas enforces host rewrite safety | PASS | `Makefile:76-102` blocks relative `$ref` usage and rewrites placeholder hosts via `jq`. |
| Code generation cleanliness enforced | PASS | `scripts/ensure_codegen_clean.sh:1-23` regenerates outputs and discards timestamp-only diffs. |

## Preflight & Build Determinism
| Item | Status | Evidence |
| --- | --- | --- |
| preflight orchestrates required checks | PASS | `preflight.sh:9-24` runs normalize-check, schema-lint, codegen-check, and example validation under Poetry. |
| preflight avoids tracked mutations | PASS | `.gitignore:2-18` ignores `.cache/` and `typescript/tmp/`, covering artifacts written by `preflight.sh:27-30`. |
| build script guardrails | PASS | `build.sh:7-37` enforces Nix + Poetry context and limits work to generation and validation. |

## Example Corpus Consistency
| Observation | Status | Evidence |
| --- | --- | --- |
| Examples resolve against source schemas | PASS | `examples/SynestheticAsset_Example1.json:2` references `jsonschema/synesthetic-asset.schema.json`. |
| Automated validation wiring present | PASS | `Makefile:34-41` routes `make validate` through `scripts/validate_examples.py --strict`. |
| Runtime validation during audit | N/A | Audit scope forbids executing validation commands in this run. |

## Detected Divergences
| Issue | Severity | Evidence |
| --- | --- | --- |
| Published schemas include trailing newline not in sources | MEDIUM | `jsonschema/synesthetic-asset.schema.json:162` vs `docs/schema/0.7.3/synesthetic-asset.schema.json:162`, mirrored in `jsonschema/tone.schema.json:469`. |
| `meta/output/` tracking conflicts with constraint text | HIGH | `meta/spec.schema.flow.md:105-106` mandates tracking, yet audit constraint lists `meta/output/` as ephemeral; repository currently tracks files such as `meta/output/schema_eval_latest.md:1`. |

## Remediation Actions
| Priority | Action | Owner | Notes |
| --- | --- | --- | --- |
| Medium | Add trailing newlines to `jsonschema/synesthetic-asset.schema.json` and `jsonschema/tone.schema.json`, then republish artifacts to restore host-only drift. | Schema WG | Aligns formatting so publication diffs are strictly host substitutions. |
| High | Resolve the `meta/output/` policy mismatch by updating either the constraint set or repository tracking expectations. | Governance | `meta/spec.schema.flow.md:105-106` treats the directory as persistent; clarify and document the authoritative rule. |
