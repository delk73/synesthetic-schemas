# Schema Debt Audit Report (v0.7.3)

**Audit Date**: 2025-10-15  
**Auditor**: GitHub Copilot  
**Scope**: synesthetic-schemas repository, excluding conceptual docs  
**Version**: 0.7.3  

## Summary Metrics

- **Total Findings**: 7
- **Technical Debt**: 4 (High: 1, Medium: 2, Low: 1)
- **Contextual Debt**: 3 (High: 1, Medium: 1, Low: 1)
- **Lifecycle Classes**: Preventable (2), Recoverable (4), Structural (1)
- **Subsystems Affected**: Build (2), Schemas (1), Validation (1), Docs (2), Governance (1)

## Top 5 High-Impact Risks

1. **Duplicate Governance Documents** (Structural, High) - Two governance.md files exist, risking confusion on canonical spec.
2. **Hardcoded Version Strings** (Recoverable, High) - 20+ hardcoded "0.7.3" instances require manual updates on version bumps.
3. **Inconsistent Version Formats** (Preventable, Medium) - Mix of "0.7.3" and "v0.7.3" across files.
4. **Redundant Build Normalization** (Recoverable, Medium) - Multiple Makefile targets invoke normalization unnecessarily.
5. **Local Schema References in Examples** (Recoverable, Low) - Examples use local paths instead of canonical URLs.

## Technical Debt Map (by subsystem)

### Build
- **Finding**: Redundant normalization invocations in Makefile  
  **Type**: Technical  
  **Lifecycle**: Recoverable  
  **Path**: Makefile, lines 10-15, 45-50, 55-60  
  **Severity**: Medium  
  **Description**: `normalize`, `preflight-fix`, and `bump-version` all call `scripts/normalize_schemas.py`, causing unnecessary re-runs.  
  **Impact**: Increased build time and potential for inconsistent state.  
  **Remediation**: Consolidate normalization into a single dependency or use `.PHONY` guards.

- **Finding**: Overlapping validation targets  
  **Type**: Technical  
  **Lifecycle**: Recoverable  
  **Path**: Makefile, lines 32-36  
  **Severity**: Low  
  **Description**: `validate` target runs both example and schema validation sequentially.  
  **Impact**: Minor performance overhead.  
  **Remediation**: Parallelize with `&` or separate into independent targets.

### Schemas
- **Finding**: Inconsistent version string formats  
  **Type**: Technical  
  **Lifecycle**: Preventable  
  **Path**: version.json (0.7.3), docs frontmatter (v0.7.3), prompts (v0.7.3)  
  **Severity**: Medium  
  **Description**: Version represented as "0.7.3" in version.json but "v0.7.3" elsewhere.  
  **Impact**: Parsing inconsistencies and manual formatting.  
  **Remediation**: Standardize on "v{major}.{minor}.{patch}" format across all files.

### Validation
- **Finding**: Hardcoded version in validation scripts  
  **Type**: Technical  
  **Lifecycle**: Recoverable  
  **Path**: scripts/audit_docs.py (default='0.7.3'), scripts/validate_schemas.py (hardcoded URL)  
  **Severity**: High  
  **Description**: Scripts contain hardcoded version strings instead of reading from version.json.  
  **Impact**: Requires manual updates on version changes, risking drift.  
  **Remediation**: Load version from version.json in scripts.

## Contextual Debt Map (by subsystem)

### Docs
- **Finding**: Duplicate governance documents  
  **Type**: Contextual  
  **Lifecycle**: Structural  
  **Path**: docs/governance.md, docs/schema/0.7.3/governance.md  
  **Severity**: High  
  **Description**: Original governance.md copied to versioned location but both remain, unclear which is authoritative.  
  **Impact**: Confusion on governance spec and potential for outdated content.  
  **Remediation**: Deprecate docs/governance.md with redirect, make versioned file canonical.

- **Finding**: Examples reference local schemas  
  **Type**: Contextual  
  **Lifecycle**: Recoverable  
  **Path**: docs/examples/0.7.3/*.json ($schema fields)  
  **Severity**: Low  
  **Description**: Example JSONs use "jsonschema/*.schema.json" instead of canonical GitHub URLs.  
  **Impact**: Examples not directly usable with published schemas.  
  **Remediation**: Update $schema to https://delk73.github.io/synesthetic-schemas/schema/0.7.3/ URLs.

### Governance
- **Finding**: Hardcoded canonical URLs in prompts  
  **Type**: Contextual  
  **Lifecycle**: Recoverable  
  **Path**: meta/prompts/*.json (multiple "0.7.3" in URLs and versions)  
  **Severity**: Medium  
  **Description**: Audit prompts contain hardcoded version strings and URLs.  
  **Impact**: Prompts become outdated on version changes.  
  **Remediation**: Template prompts with version variables or generate dynamically.

## Cross-Repo Drift (MCP, Labs)

- **Finding**: No visible MCP or Labs integration drift  
  **Type**: N/A  
  **Description**: No cross-repo references found in audited files. MCP alignment appears maintained.  
  **Status**: Confirmed clean.

## Recommendations and Remediation Effort

### Immediate (Preventable - 1-2 hours)
- Standardize version format to "v{major}.{minor}.{patch}" in version.json and scripts.

### Short-term (Recoverable - 4-6 hours)
- Centralize version management: Modify scripts to read from version.json.
- Update example $schema URLs to canonical.
- Optimize Makefile normalization dependencies.

### Long-term (Structural - 8-12 hours)
- Resolve governance document duplication: Archive old file, update all references.
- Implement dynamic prompt generation to avoid hardcoded versions.

**Total Estimated Effort**: 13-20 hours  
**Risk Mitigation**: Addressing high-severity items first reduces version bump friction and governance clarity.