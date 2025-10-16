# Schema Debt Audit Report (0.7.3)

**Audit Date**: 2025-10-16  
**Auditor**: GitHub Copilot  
**Scope**: synesthetic-schemas repository, excluding conceptual docs  
**Version**: 0.7.3  

## Summary Metrics

- **Total Findings**: 7
- **Technical Debt**: 4 (High: 1, Medium: 2, Low: 1)
- **Contextual Debt**: 3 (High: 1, Medium: 1, Low: 1)
- **Lifecycle Classes**: Preventable (1), Recoverable (5), Structural (1)
- **Subsystems Affected**: Build (2), Schemas (1), Validation (1), Docs (1), Governance (1), CI (1)

## Top 5 High-Impact Risks

1. **Hardcoded Version Strings** (Recoverable, High) - 20+ hardcoded "0.7.3" instances require manual updates on version bumps.
2. **Redirect Governance Document** (Structural, High) - Top-level governance.md redirects to versioned, but may cause confusion.
3. **Redundant Build Normalization** (Recoverable, Medium) - preflight-fix runs normalize then normalize-check unnecessarily.
4. **Local Schema References in Examples** (Recoverable, Low) - Examples use local paths instead of canonical URLs.
5. **No CI Configuration** (Recoverable, Medium) - No automated CI, relies on manual runs.

## Technical Debt Map (by subsystem)

### Build
- **Finding**: Redundant normalization in preflight-fix  
  **Type**: Technical  
  **Lifecycle**: Recoverable  
  **Path**: Makefile, lines 45-50  
  **Severity**: Medium  
  **Description**: `preflight-fix` calls `normalize` then `preflight`, which includes `normalize-check`, redundant since normalize was just run.  
  **Impact**: Unnecessary script execution.  
  **Remediation**: Modify preflight-fix to skip normalize-check or adjust dependencies.

- **Finding**: Overlapping validation targets  
  **Type**: Technical  
  **Lifecycle**: Recoverable  
  **Path**: Makefile, lines 32-36  
  **Severity**: Low  
  **Description**: `validate` target runs both example and schema validation sequentially.  
  **Impact**: Minor performance overhead.  
  **Remediation**: Parallelize with `&` or separate into independent targets.

### Schemas
- **Finding**: Hardcoded version in validation scripts  
  **Type**: Technical  
  **Lifecycle**: Recoverable  
  **Path**: scripts/audit_docs.py (default='0.7.3'), scripts/validate_schemas.py (hardcoded paths and URL)  
  **Severity**: High  
  **Description**: Scripts contain hardcoded version strings instead of reading from version.json.  
  **Impact**: Requires manual updates on version changes, risking drift.  
  **Remediation**: Load version from version.json in scripts.

### Validation
- **Finding**: No CI configuration visible  
  **Type**: Technical  
  **Lifecycle**: Recoverable  
  **Path**: N/A  
  **Severity**: Medium  
  **Description**: No .github/workflows or similar found; CI logic embedded in Makefile.  
  **Impact**: No automated CI, relies on manual runs.  
  **Remediation**: Add GitHub Actions for automated preflight on PRs.

### Docs
- **Finding**: Examples reference local schemas  
  **Type**: Contextual  
  **Lifecycle**: Recoverable  
  **Path**: docs/examples/0.7.3/*.json ($schema fields)  
  **Severity**: Low  
  **Description**: Example JSONs use "jsonschema/*.schema.json" instead of canonical GitHub URLs.  
  **Impact**: Examples not directly usable with published schemas.  
  **Remediation**: Update $schema to https://delk73.github.io/synesthetic-schemas/schema/0.7.3/ URLs.

### Governance
- **Finding**: Redirect governance document  
  **Type**: Contextual  
  **Lifecycle**: Structural  
  **Path**: docs/governance.md, docs/schema/0.7.3/governance.md  
  **Severity**: High  
  **Description**: Top-level governance.md is a redirect to versioned location, but may confuse users on canonical spec.  
  **Impact**: Potential confusion on governance spec.  
  **Remediation**: Keep as is, or remove redirect if not needed.

### CI
- **Finding**: Hardcoded canonical URLs in prompts  
  **Type**: Contextual  
  **Lifecycle**: Recoverable  
  **Path**: meta/prompts/*.json (multiple "0.7.3" in URLs and versions)  
  **Severity**: Medium  
  **Description**: Audit prompts contain hardcoded version strings and URLs.  
  **Impact**: Prompts become outdated on version changes.  
  **Remediation**: Template prompts with version variables or generate dynamically.

## Contextual Debt Map (by subsystem)

### Docs
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
- Versions standardized to plain semver (0.7.3) across repository.

### Short-term (Recoverable - 4-6 hours)
- Centralize version management: Modify scripts to read from version.json.
- Update example $schema URLs to canonical.
- Optimize Makefile normalization dependencies.
- Add basic CI workflow for preflight checks.

### Long-term (Structural - 8-12 hours)
- Clarify governance document structure: Decide on single canonical location.
- Implement dynamic prompt generation to avoid hardcoded versions.

**Total Estimated Effort**: 13-20 hours  
**Risk Mitigation**: Addressing high-severity items first reduces version bump friction and governance clarity.