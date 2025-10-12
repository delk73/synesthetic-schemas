# Schema Audit (v0.7.3 Governance Alignment)

## Summary of audit state

Schema audit completed for version 0.7.3 on 2025-10-12. Audited 9 published schemas against governance.md rules and schema_eval_latest.json baseline. All 169 fields present with no missing or divergent fields detected. However, all schemas have non-canonical $id fields, failing governance compliance.

## Schema coverage table

| Schema | Present | Missing | Divergent |
|--------|---------|---------|-----------|
| synesthetic-asset | 12 | 0 | 0 |
| control-bundle | 4 | 0 | 0 |
| control | 27 | 0 | 0 |
| haptic | 21 | 0 | 0 |
| modulation | 17 | 0 | 0 |
| rule-bundle | 15 | 0 | 0 |
| rule | 7 | 0 | 0 |
| shader | 21 | 0 | 0 |
| tone | 45 | 0 | 0 |

## Per-component audits

### Shader Component Audit
- description: Present
- fragment_shader: Present
- input_parameters: Present
- meta_info: Present
- name: Present
- uniforms: Present
- vertex_shader: Present

### Tone Component Audit
- description: Present
- effects: Present
- input_parameters: Present
- meta_info: Present
- name: Present
- parts: Present
- patterns: Present
- synth: Present

### Haptic Component Audit
- description: Present
- device: Present
- input_parameters: Present
- meta_info: Present
- name: Present

### Modulation Component Audit
- description: Present
- meta_info: Present
- modulations: Present
- name: Present

### RuleBundle Component Audit
- created_at: Present
- description: Present
- id: Present
- meta_info: Present
- name: Present
- rules: Present
- updated_at: Present

### Control Component Audit
- default: Present
- label: Present
- mappings: Present
- max: Present
- min: Present
- options: Present
- parameter: Present
- smoothingTime: Present
- step: Present
- type: Present
- unit: Present

### Asset Component Audit
- control: Present
- created_at: Present
- description: Present
- haptic: Present
- meta_info: Present
- modulation: Present
- modulations: Present
- name: Present
- rule_bundle: Present
- shader: Present
- tone: Present
- updated_at: Present

## Detected divergences

No field-level divergences detected. All baseline fields present in schemas.

## Governance compliance

- **ID Compliance:** Failed - All 9 schemas have incorrect $id. Expected: https://delk73.github.io/synesthetic-schemas/schema/0.7.3/{filename}. Actual: https://schemas.synesthetic.dev/0.7.3/{filename}.
- **Version Compliance:** Passed - version.json shows 0.7.3, matches governance.md.
- **Structure Compliance:** Passed - All schemas follow required JSON Schema Draft 2020-12 structure.

## Recommendations for patch planning

1. Run `./build.sh` to normalize all $id fields to canonical URLs.
2. Verify $id correction with `make check-schema-ids`.
3. Re-run audit to confirm compliance.
4. Commit and tag normalized schemas for publication.
