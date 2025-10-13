## Summary of repository operational compliance
| Check | Status | Notes |
| Schema source isolation | PASS | `jsonschema/*.schema.json` retain placeholder host `https://schemas.synesthetic.dev/0.7.3/` (e.g. jsonschema/rule.schema.json:2) and no alternate hosts were detected. |
| Published canonical references | FAIL | docs/schema/0.7.3/synesthetic-asset.schema.json:76 and docs/schema/0.7.3/synesthetic-asset.schema.json:88 still reference `modulation.schema.json` without the canonical host, breaching the published-artifact rule. |
| Automation entrypoints available | WARN | build.sh:7-37 and preflight.sh:9-30 cover the required phases, but runtime verification was deferred because `poetry` is absent in the sandbox (`poetry run python --version` → command not found). |

## Editable vs generated schema boundary check
| Item | Status | Notes |
| jsonschema host placeholders | PASS | Placeholder host `https://schemas.synesthetic.dev/0.7.3/` is present across sources (e.g. jsonschema/control.schema.json:127) and no canonical hosts appear in jsonschema/. |
| Published $id host | PASS | `$id` fields in docs/schema/0.7.3/*.schema.json point to `https://delk73.github.io/synesthetic-schemas/schema/0.7.3/{file}` (e.g. docs/schema/0.7.3/control.schema.json:127). |
| Published $ref canonicalization | FAIL | Relative references remain in docs/schema/0.7.3/synesthetic-asset.schema.json:76 and :88; they should be rewritten to the canonical host during publication. |
| Docs vs sources drift | WARN | Content matches after host normalization except for an extra trailing newline in docs/schema/0.7.3/tone.schema.json versus jsonschema/tone.schema.json. |

## Version.json alignment and $id verification
| Item | Status | Notes |
| version.json schemaVersion | PASS | version.json:2 pins `schemaVersion` to "0.7.3" as required. |
| Canonical ID/ref validation | FAIL | `python3 scripts/validate_schemas.py` flags the relative `$ref` entries yet still exits 0 because refs_valid is not propagated to all_valid (scripts/validate_schemas.py:69-96), leaving the check ineffective. |

## Makefile and build target presence check
| Item | Status | Notes |
| Required targets | PASS | normalize (Makefile:13-17), preflight-fix (Makefile:41-44), codegen-check (Makefile:28-29), check-schema-ids (Makefile:95-96), and publish-schemas (Makefile:71-92) are defined. |
| publish-schemas canonicalization | FAIL | The jq transformation in Makefile:84-87 only rewrites absolute placeholder hosts, so relative `$ref` values survive and leak into docs/schema/0.7.3. |

## Preflight reproducibility and CI parity validation
| Item | Status | Notes |
| Coverage of required phases | PASS | preflight.sh:9-23 runs normalize-check, schema-lint, codegen-check (unless skipped), and example validation via `poetry run make`. |
| Ephemeral artifacts | PASS | preflight.sh:27-30 writes `.cache/last_preflight.txt`, respecting the directive that .cache/ remain ephemeral. |
| Local execution | WARN | Could not execute preflight because `poetry` is unavailable in the sandbox; CI parity assumes nix/poetry availability. |

## Example validation results
| Command | Status | Notes |
| `python3 scripts/validate_examples.py --strict --dir examples` | PASS | 15 example files validated and round-tripped without diffs. |

## Detected drifts or missing targets
| Issue | Severity | Evidence |
| Published schema retains relative `$ref` | HIGH | docs/schema/0.7.3/synesthetic-asset.schema.json:76 and :88 reference `modulation.schema.json` without canonical host. |
| `publish-schemas` misses relative `$ref` | HIGH | Makefile:84-87 rewrites only absolute placeholder hosts, enabling the above drift. |
| Canonical validation script silent on failures | MEDIUM | scripts/validate_schemas.py:69-96 logs violations but returns success because refs_valid never affects all_valid. |
| Trailing newline mismatch | LOW | docs/schema/0.7.3/tone.schema.json retains an extra newline compared to jsonschema/tone.schema.json. |

## Remediation actions
| Severity | Action | Owner | Notes |
| HIGH | Update publish-schemas (and any normalization step) to rewrite relative `$ref` values to the canonical host so docs/schema/0.7.3 stays compliant. | Schema WG | Confirm via `python3 scripts/validate_schemas.py` once fixed. |
| HIGH | Re-run publication after fixing canonicalization to regenerate docs/schema/0.7.3/synesthetic-asset.schema.json with absolute `$ref`s. | Schema WG | Ensure no additional drift remains (watch for trailing newline). |
| MEDIUM | Modify scripts/validate_schemas.py to propagate refs_valid into all_valid so non-canonical `$ref` values fail CI. | Tooling | Add a regression test covering relative references. |
| LOW | Align formatting between jsonschema/tone.schema.json and docs/schema/0.7.3/tone.schema.json to avoid spurious diffs. | Schema WG | Optional once higher-severity issues are resolved. |
