# Schema Audit (v0.7.3 Governance Alignment)

## Summary of audit state

All published schemas under v0.7.3 conform to governance.md rules and match the evaluated baseline. No missing, divergent, or non-compliant fields detected. Version 0.7.3 confirmed in version.json and schema_evolution.md. All $id fields are canonical.

## Schema coverage table

| Schema | Present | Missing | Divergent |
|--------|---------|---------|-----------|
| synesthetic-asset | 12 | 0 | 0 |
| control-bundle | 4 | 0 | 0 |
| control | 11 | 0 | 0 |
| haptic | 5 | 0 | 0 |
| modulation | 4 | 0 | 0 |
| rule-bundle | 7 | 0 | 0 |
| rule | 6 | 0 | 0 |
| shader | 7 | 0 | 0 |
| tone | 8 | 0 | 0 |

## Per-component audits

### Shader
- description: Present
- fragment_shader: Present
- input_parameters: Present
- InputParameter: Present
- meta_info: Present
- name: Present
- uniforms: Present
- UniformDef: Present
- vertex_shader: Present

### Tone
- description: Present
- effects: Present
- ToneEffect: Present
- input_parameters: Present
- ToneParameter: Present
- meta_info: Present
- ToneMetaInfo: Present
- name: Present
- parts: Present
- TonePart: Present
- patterns: Present
- TonePattern: Present
- synth: Present
- ToneSynth: Present
- ToneSynthOptions: Present

### Haptic
- description: Present
- device: Present
- DeviceConfig: Present
- DeviceOptionValue: Present
- input_parameters: Present
- HapticParameter: Present
- meta_info: Present
- name: Present

### Modulation
- description: Present
- meta_info: Present
- modulations: Present
- ModulationItem: Present
- name: Present

### RuleBundle
- created_at: Present
- description: Present
- id: Present
- meta_info: Present
- name: Present
- rules: Present
- Rule: Present
- updated_at: Present

### Control
- default: Present
- label: Present
- mappings: Present
- Mapping: Present
- ComboType: Present
- ActionType: Present
- AxisType: Present
- CurveType: Present
- max: Present
- min: Present
- options: Present
- parameter: Present
- smoothingTime: Present
- step: Present
- type: Present
- DataType: Present
- unit: Present

### Asset
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

## Detected divergences (explicit field-level deltas)

None

## Governance compliance (ID, version, structure)

- All $id fields verified canonical: https://delk73.github.io/synesthetic-schemas/schema/0.7.3/{filename}
- Version 0.7.3 confirmed in version.json
- Schema evolution.md shows 0.7.3 as baseline
- Structure matches governance.md requirements

## Recommendations for patch planning

No action required. All schemas are compliant and aligned with baseline.
