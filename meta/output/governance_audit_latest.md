# Governance Compliance Audit (v0.7.3)

## Summary of governance compliance

Governance audit completed for version 0.7.3 on 2025-10-12. Audited 30 docs, 9 schemas, version.json, and Makefile. Frontmatter and required docs compliant. However, schema $id fields, $ref URLs, and Makefile targets are non-compliant with deprecated hosts and missing normalization.

## Schema ID and host verification

- Total schemas: 9
- Canonical $id format (https://delk73.github.io/synesthetic-schemas/schema/0.7.3/{filename}): 0/9 (all use https://schemas.synesthetic.dev/0.7.3/{filename})
- Absolute $ref URLs: 0/9 (all use relative $ref like "control-bundle.schema.json")
- Deprecated host references: 9/9 (schemas.synesthetic.dev in $id)

## Frontmatter consistency across docs

- Total docs: 30
- Complete frontmatter (version, lastReviewed, owner): 30/30
- Version v0.7.3: 30/30
- Consistent owner (delk73): 30/30

## Governance.md structural integrity

- Includes spec version 0.7.3: Yes
- Includes hosting base URL (https://delk73.github.io/synesthetic-schemas/schema/0.7.3/): Yes
- Required docs exist and non-empty: Yes (governance.md, README.md, schema_evolution.md)

## Makefile target verification

- publish-schemas target present: Yes
- check-schema-ids target present: No
- publish-schemas sets correct $id: No (sets https://raw.githubusercontent.com/delk73/synesthetic-schemas/main/docs/schema/0.7.3/{filename})

## Detected non-compliances

- Schema $id fields use deprecated host schemas.synesthetic.dev instead of delk73.github.io
- $ref URLs are relative instead of absolute canonical URLs
- Makefile publish-schemas sets $id to raw.githubusercontent.com (deprecated)
- Makefile missing check-schema-ids target
- No deprecated host references in docs: Yes (none found)

## Remediation actions

1. Update Makefile publish-schemas to set $id to https://delk73.github.io/synesthetic-schemas/schema/0.7.3/{filename}
2. Add check-schema-ids target to Makefile
3. Run build.sh or normalization script to convert relative $ref to absolute URLs
4. Re-publish schemas with corrected $id and $ref
5. Re-run audit to confirm compliance