# Docs State Snapshot (v0.7.3)

## Frontmatter Compliance

- Total docs: 30
- Complete frontmatter (version, lastReviewed, owner): 30/30
- Correct version (v0.7.3): 5/30 (governance.md, schema_evolution.md, use_cases/controls.md, use_cases/perceptual_field.md, concepts/distinction.md)
- Divergent versions: 25/30 (various old versions like v0.1.0, v0.4.0, etc.)

## Version Pinning

- Spec Version tables/references: Partially compliant - governance.md and schema_evolution.md have 0.7.3, others have old versions.
- Frontmatter versions: Only 5 correct.

## Canonical Host Usage

- Canonical URLs present: Yes (in governance.md)
- Reject patterns detected: None
- All schema URLs use https://delk73.github.io/synesthetic-schemas/schema/0.7.3/: Yes

## README Index Alignment

- docs/README.md version: v0.1.0 (divergent)
- Links to governance.md: GOVERNANCE.md (wrong case, divergent)
- References 0.7.3: No
- Canonical host: No
- Listed docs status:
  - Schema & Validation: governance.md (Present, but case wrong), schema_evolution.md (Present), hypotheses.md (Present)
  - Concepts: 7 listed, but concepts/ has 15 files - 8 missing
  - Use Cases: 3 listed, but use_cases/ has 3 files - all present
  - Examples: links to examples/README.md (Present)
  - QA: Reserved, none listed

## Schema Evolution Validation

- docs/schema_evolution.md cites version.json: Yes
- Reflects schemaVersion 0.7.3: Yes

## Examples Sanity

- examples/README.md version: v0.1.0 (divergent)
- Lists JSON assets: Lists non-existent files (asset_basic.json, etc.)
- References 0.7.3: No
- Actual examples: 16 JSON files exist, none listed correctly

## Crosswalk Compliance

- Crosswalk docs: concepts/crosswalk_perception_interfaces.md, concepts/applied_crosswalk_phy_atari.md
- Cite external sources: Yes (arxiv links)
- Version metadata: No (no paper dates/versions)
- Link to governance.md: No

## Internal Links Resolution

- Checked sample links: Resolve locally (e.g., tokenized_manifold.md exists)

## Recommendations

1. Update all frontmatter versions to v0.7.3 and lastReviewed to 2025-10-12.
2. Complete docs/README.md index with all existing docs.
3. Fix link case in docs/README.md to governance.md.
4. Update examples/README.md to list actual JSON files and version 0.7.3.
5. Add version metadata to crosswalk citations and governance.md links.
6. Normalize frontmatter owners to consistent format (e.g., delk73).