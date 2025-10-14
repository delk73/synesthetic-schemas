## Repository State Summary
| Check | Status | Evidence |
| Schema sources isolated | PASS | `jsonschema/synesthetic-asset.schema.json:2` keeps placeholder host `https://schemas.synesthetic.dev/0.7.3/…`. |
| Published artifacts canonical | PASS | `docs/schema/0.7.3/synesthetic-asset.schema.json:2` uses canonical host `https://delk73.github.io/…`. |
| Governance automation present | WARN | `Makefile:14-42` exposes normalize, preflight, publish, and codegen targets but depends on Poetry/Nix availability. |

## Schema Source vs Published Artifact Boundary
| Item | Status | Evidence |
| Placeholder host retained in sources | PASS | Cross-schema refs stay on the placeholder host (e.g. `jsonschema/synesthetic-asset.schema.json:9`). |
| Published host canonicalized | PASS | Canonical host propagated to published refs (e.g. `docs/schema/0.7.3/synesthetic-asset.schema.json:9`). |
| Drift limited to host substitution | PASS | Representative fields match between source and published copies (e.g. `jsonschema/synesthetic-asset.schema.json:4` vs `docs/schema/0.7.3/synesthetic-asset.schema.json:4`). |

## Version and Canonical Host Verification
| Item | Status | Evidence |
| version.json schemaVersion | PASS | `version.json:2` pins `"schemaVersion": "0.7.3"`. |
| Published `$id` accuracy | PASS | `$id` aligns with canonical host (`docs/schema/0.7.3/control-bundle.schema.json:2`). |
| Published `$ref` canonicality | PASS | Cross-schema refs use canonical URLs (`docs/schema/0.7.3/synesthetic-asset.schema.json:9`). |

## Makefile Entrypoint Integrity
| Item | Status | Evidence |
| Required targets present | PASS | `Makefile:14-42` defines normalize, preflight, preflight-fix, publish-schemas, codegen-check, and check-schema-ids. |
| publish-schemas host rewrite coverage | PASS | `Makefile:76-102` blocks relative refs and rewrites placeholder hosts before publishing. |
| Code generation guardrails | PASS | `Makefile:31-36` couples codegen-check and strict example validation. |

## Preflight & Build Determinism
| Item | Status | Evidence |
| preflight coverage | PASS | `preflight.sh:9-24` runs normalize-check, schema-lint, codegen-check (gated), and validation. |
| build script alignment | PASS | `build.sh:7-37` enforces Nix + Poetry context and limits actions to generation/validation. |
| Ephemeral path hygiene | FAIL | `meta/output/flow_audit_latest.md` remains tracked despite the spec marking `meta/output/` as ephemeral. |

## Example Corpus Consistency
| Observation | Status | Evidence |
| Examples reference placeholder schemas | PASS | `examples/SynestheticAsset_Example1.json:2` points to `jsonschema/synesthetic-asset.schema.json`. |
| Validation tooling aligned | PASS | `Makefile:34-36` exercises `scripts/validate_examples.py --strict` over `examples/`. |

## Detected Divergences
| Issue | Severity | Evidence |
| `meta/output/` directory tracked in Git | HIGH | `meta/output/flow_audit_latest.md` present in version control despite ephemeral requirement. |

## Remediation Actions
| Priority | Action | Owner | Notes |
| HIGH | Move `meta/output/` outputs to an untracked location (update ignore rules and unstage current files). | Schema WG | Keeps ephemeral audit artifacts out of version control per flow spec. |
