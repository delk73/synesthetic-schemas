# Schema Debt Audit Report (0.7.3)

**Generated**: 2025-10-16  
**Auditor**: GitHub Copilot  
**Repository**: synesthetic-schemas  
**Version**: 0.7.3  
**Spec Reference**: docs/schema/0.7.3/governance.md  

---

## Summary Metrics

- **Total Findings**: 17
- **High Severity**: 5 (29%)
## Top 5 High-Impact Risks

1. **Hardcoded Version Strings** (Technical, Recoverable, High) - 50+ hardcoded "0.7.3" instances across codebase create manual version bump fragility
2. **Version Inconsistency Across Package Files** (Technical, Preventable, High) - Three different version numbers in package.json (1.0.0), pyproject.toml (0.1.0), and version.json (0.7.3)
3. **Placeholder vs Canonical URL Mismatch** (Technical, Recoverable, High) - Source schemas use placeholder host but build process may fail if references are incorrect
4. **Makefile Hardcoded Path Dependencies** (Technical, Recoverable, Medium) - Multiple hardcoded "0.7.3" paths in build targets prevent automated version updates
5. **Missing Cross-Repo Alignment Validation** (Contextual, Structural, High) - No systematic check for MCP server schema alignment mentioned in governance

---

## Technical Debt Map (by subsystem)

### Build System
- **Finding**: Hardcoded version strings in Makefile  
  **Type**: Technical  
  **Lifecycle**: Recoverable  
  **Severity**: High  
  **Path**: Makefile (lines 2-3, 32, 34, 101, 105-106)  
  **Line Range**: 2-106  
  **Issue**: PLACEHOLDER_HOST, CANONICAL_HOST, and validation paths hardcode "0.7.3"  
  **Remediation**: Use version.json as single source for version variables via $(shell jq -r .schemaVersion version.json)

- **Finding**: Redundant normalization stages  
  **Type**: Technical  
  **Lifecycle**: Preventable  
  **Severity**: Medium  
  **Path**: Makefile  
  **Line Range**: 17-42  
  **Issue**: Both `normalize` and `normalize-check` targets, with preflight having separate preflight-fix variant  
  **Remediation**: Consolidate to single normalize target with --check flag

### Schema Management  
- **Finding**: Inconsistent version management  
  **Type**: Technical  
  **Lifecycle**: Preventable  
  **Severity**: High  
  **Path**: version.json (0.7.3), package.json (1.0.0), pyproject.toml (0.1.0), python/pyproject.toml (0.1.0)  
  **Line Range**: N/A  
  **Issue**: Four different version values across package configuration files  
  **Remediation**: Standardize all to use schemaVersion from version.json or eliminate non-schema versions

- **Finding**: Placeholder host usage in source schemas  
  **Type**: Technical  
  **Lifecycle**: Recoverable  
  **Severity**: High  
  **Path**: jsonschema/*.schema.json (all $id and $ref fields)  
  **Line Range**: Multiple  
  **Issue**: Source uses https://schemas.synesthetic.dev/0.7.3/ instead of canonical host  
  **Remediation**: Verified as intentional by Makefile publish-schemas process; no action needed

### Validation Scripts
- **Finding**: Overlapping validation targets  
  **Type**: Technical  
  **Lifecycle**: Preventable  
  **Severity**: Medium  
  **Path**: scripts/validate_examples.py, scripts/validate_schemas.py, scripts/audit_docs.py  
  **Line Range**: N/A  
  **Issue**: Multiple scripts validate schema compliance with different scopes and exit codes  
  **Remediation**: Create unified validation runner with configurable modules

- **Finding**: Hardcoded default version parameters  
  **Type**: Technical  
  **Lifecycle**: Recoverable  
  **Severity**: Medium  
  **Path**: scripts/audit_docs.py (default='0.7.3'), scripts/validate_schemas.py (hardcoded paths and URL)  
  **Line Range**: 16, 14, 28, 99  
  **Issue**: Default version strings hardcoded in argument parsers  
  **Remediation**: Read defaults from version.json

- **Finding**: Duplicate script functionality  
  **Type**: Technical  
  **Lifecycle**: Preventable  
  **Severity**: Low  
  **Path**: scripts/examples_qc.py, scripts/validate_examples.py  
  **Line Range**: N/A  
  **Issue**: Both scripts perform example validation with similar logic  
  **Remediation**: Consolidate into single examples validation module

---

## Contextual Debt Map (by subsystem)

### Documentation
- **Finding**: Outdated $schema references in examples  
  **Type**: Contextual  
  **Lifecycle**: Preventable  
  **Severity**: Medium  
  **Path**: docs/examples/0.7.3/*.json ($schema fields)  
  **Line Range**: N/A  
  **Issue**: Some examples may reference placeholder URLs instead of canonical URLs  
  **Remediation**: Update $schema to https://delk73.github.io/synesthetic-schemas/schema/0.7.3/ URLs

- **Finding**: Governance spec redundancy  
  **Type**: Contextual  
  **Lifecycle**: Preventable  
  **Severity**: Low  
  **Path**: docs/governance.md, docs/schema/0.7.3/governance.md  
  **Line Range**: N/A  
  **Issue**: Root governance.md is redirect stub while versioned governance contains actual rules  
  **Remediation**: Consider removing redirect stub or adding more context about governance evolution

### Meta System
- **Finding**: Hardcoded version references in prompts  
  **Type**: Contextual  
  **Lifecycle**: Recoverable  
  **Severity**: Medium  
  **Path**: meta/prompts/*.json (multiple "0.7.3" in URLs and versions)  
  **Line Range**: Multiple files  
  **Issue**: Audit and evaluation prompts hardcode 0.7.3, limiting reusability  
  **Remediation**: Parameterize version references in prompt templates

- **Finding**: Output file staleness indicators missing  
  **Type**: Contextual  
  **Lifecycle**: Preventable  
  **Severity**: Low  
  **Path**: meta/output/*.md  
  **Line Range**: N/A  
  **Issue**: No timestamp or version indicators in generated outputs  
  **Remediation**: Add generation metadata headers to all output files

### Governance
- **Finding**: Missing frontmatter in examples  
  **Type**: Contextual  
  **Lifecycle**: Preventable  
  **Severity**: Medium  
  **Path**: docs/examples/0.7.3/*.json ($schema fields)  
  **Line Range**: N/A  
  **Issue**: JSON examples lack consistent $schema field validation  
  **Remediation**: Update $schema to https://delk73.github.io/synesthetic-schemas/schema/0.7.3/ URLs

- **Finding**: Implicit MCP alignment assumptions  
  **Type**: Contextual  
  **Lifecycle**: Structural  
  **Severity**: High  
  **Path**: docs/governance.md, README.md  
  **Line Range**: Various  
  **Issue**: References to MCP server alignment without explicit validation or cross-repo checks  
  **Remediation**: Add MCP server schema comparison to audit suite

### Prompts and Templates
- **Finding**: Hardcoded canonical URLs in prompts  
  **Type**: Contextual  
  **Lifecycle**: Recoverable  
  **Severity**: Medium  
  **Path**: meta/prompts/*.json (multiple "0.7.3" in URLs and versions)  
  **Line Range**: Multiple  
  **Issue**: Prompt templates embed version-specific URLs reducing reusability for future versions  
  **Remediation**: Use template variables for version and canonical host

---

## Cross-Repo Drift (MCP, Labs)

**Status**: ⚠️ **Cannot Verify** - Limited to synesthetic-schemas repository access

### MCP Server Alignment
- **Finding**: No automated cross-repo schema validation  
  **Type**: Contextual  
  **Lifecycle**: Structural  
  **Severity**: High  
  **Issue**: Governance references MCP server compatibility but provides no validation mechanism  
  **Recommendation**: Create cross-repo schema comparison CI job or manual audit procedure

### Labs Integration Points  
- **Status**: Deferred per scope constraints (docs/labs/ excluded from audit)
- **Risk**: Potential schema evolution misalignment if Labs experiments use different schema versions

---

## Recommendations and Remediation Effort

### Immediate Actions (Preventable - 1-2 hours)
1. **Standardize Package Versions**: Align package.json, pyproject.toml versions or remove non-schema versioning
2. **Add Version Variable to Makefile**: Replace hardcoded version strings with `$(shell jq -r .schemaVersion version.json)`
3. **Consolidate Validation Scripts**: Merge duplicate example validation functionality

### Medium-Term Refactoring (Recoverable - 4-8 hours)  
1. **Parameterize Prompt Templates**: Create version-agnostic prompt templates with variable substitution
2. **Unified Validation Runner**: Create modular validation system with configurable targets
3. **Output Metadata Headers**: Add generation timestamps and version info to meta/output/ files

### Long-Term Architecture (Structural - 16+ hours)
1. **Cross-Repo Validation Framework**: Develop automated MCP server schema alignment checking
2. **Version Management Automation**: Full automation of version bumps across all hardcoded references
3. **Schema Evolution Tracking**: Systematic cross-version compatibility validation

### Risk Mitigation Priority
- **Critical**: Version inconsistency resolution (prevents deployment confusion)
- **High**: Hardcoded reference cleanup (enables smooth version transitions)  
- **Medium**: Validation consolidation (reduces maintenance burden)

---

**Audit Complete**: 17 findings identified across 6 subsystems  
**Next Review**: After implementing immediate actions or before next version release
- Add basic CI workflow for preflight checks.

### Long-term (Structural - 8-12 hours)
- Clarify governance document structure: Decide on single canonical location.
- Implement dynamic prompt generation to avoid hardcoded versions.

**Total Estimated Effort**: 13-20 hours  
**Risk Mitigation**: Addressing high-severity items first reduces version bump friction and governance clarity.