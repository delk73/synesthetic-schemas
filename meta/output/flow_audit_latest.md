## Repository State Summary
| Check | Status | Evidence |
| Schema sources isolated | PASS | `jsonschema/*.schema.json` keep placeholder host `https://schemas.synesthetic.dev/0.7.3/` (e.g. jsonschema/rule.schema.json:2) with no canonical leaks. |
| Published artifacts canonical | FAIL | `docs/schema/0.7.3/synesthetic-asset.schema.json:76` and `:88` retain relative `$ref` entries (`modulation.schema.json*`). |
| Governance automation present | WARN | `Makefile` provides normalize, preflight, preflight-fix, publish-schemas, codegen-check, and check-schema-ids (Makefile:13-96); runtime determinism depends on external Poetry/Nix availability. |

## Schema Source vs Published Artifact Boundary
| Item | Status | Evidence |
| Placeholder host retained in sources | PASS | Source schemas consistently use `https://schemas.synesthetic.dev/0.7.3/` (e.g. jsonschema/control.schema.json:127). |
| Published host canonicalized | FAIL | Relative `$ref` values persist in `docs/schema/0.7.3/synesthetic-asset.schema.json:76` and `:88`, violating the canonical host requirement. |
| Drift limited to host substitution | WARN | `docs/schema/0.7.3/tone.schema.json` includes an extra trailing newline absent from the source counterpart, otherwise content matches after host normalization. |

## Version and Canonical Host Verification
| Item | Status | Evidence |
| version.json schemaVersion | PASS | `version.json:2` sets `"schemaVersion": "0.7.3"`. |
| Published `$id` accuracy | PASS | `$id` fields align with canonical URLs, e.g. `docs/schema/0.7.3/control.schema.json:127`. |
| Published `$ref` canonicality | FAIL | Relative references in `synesthetic-asset.schema.json` break the canonical URL rule. |

## Makefile Entrypoint Integrity
| Item | Status | Evidence |
| Required targets present | PASS | `normalize`, `preflight`, `preflight-fix`, `publish-schemas`, `codegen-check`, `check-schema-ids` declared in Makefile:13-96. |
| publish-schemas host rewrite scope | FAIL | Transformation in Makefile:84-87 only rewrites absolute placeholder hosts, allowing relative `$ref`s to leak through. |

## Preflight & Build Determinism
| Item | Status | Evidence |
| preflight coverage | PASS | `preflight.sh:9-23` orchestrates normalize-check, schema-lint, codegen-check (gated), and validation without mutating sources. |
| build script alignment | PASS | `build.sh:7-37` enforces Nix+Poetry context, regenerates SDKs, and confines artifacts to generated directories. |
| Ephemeral path hygiene | PASS | `.cache/` usage limited to timestamp marker (`preflight.sh:27-30`); `meta/output/` designated for audit artifacts; no tracked content in `typescript/tmp/`. |

## Example Corpus Consistency
| Observation | Status | Evidence |
| Examples aligned with schemas | PASS | Example set under `examples/` corresponds to available schemas; validation tooling (`scripts/validate_examples.py`) targets these paths without requiring manual edits. |

## Detected Divergences
| Issue | Severity | Evidence |
| Published schema retains relative `$ref` entries | HIGH | `docs/schema/0.7.3/synesthetic-asset.schema.json:76` (`modulation.schema.json`) and `:88` (`modulation.schema.json#/$defs/ModulationItem`). |
| publish-schemas target misses relative refs | HIGH | Makefile:84-87 rewrites only absolute placeholder host values, leaving relative `$ref`s untouched. |
| Trailing newline mismatch in tone schema | LOW | `docs/schema/0.7.3/tone.schema.json` diverges from `jsonschema/tone.schema.json` by a terminal newline. |

## Remediation Actions
| Priority | Action | Owner | Notes |
| HIGH | Extend publish-schemas (and related normalization) to rewrite relative `$ref`s to the canonical host before copying into docs artifacts. | Schema WG | Re-run publication after adjustment. |
| HIGH | Regenerate `docs/schema/0.7.3/synesthetic-asset.schema.json` to ensure all `$ref`s use `https://delk73.github.io/...`. | Schema WG | Verify via static inspection post-publish. |
| MEDIUM | Harden validation tooling so non-canonical `$ref`s fail audits instead of logging only. | Tooling | Update `scripts/validate_schemas.py` to propagate `$ref` failures. |
| LOW | Normalize newline formatting between source and published `tone.schema.json`. | Schema WG | Optional once higher-risk items addressed. |
