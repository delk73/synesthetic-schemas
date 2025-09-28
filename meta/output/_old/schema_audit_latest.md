## Summary of audit state
- Baseline `meta/output/schema_eval_latest.json` loaded (date 20250922)
- Spec `docs/schema_refined.md` missing; comparison blocked
- Field categorization deferred until spec restored

## Audit coverage table (Schema → Present → Missing → Divergent)
| Schema | Present | Missing | Divergent |
| --- | --- | --- | --- |
| Shader | n/a (spec missing) | n/a (spec missing) | n/a (spec missing) |
| Tone | n/a (spec missing) | n/a (spec missing) | n/a (spec missing) |
| Haptic | n/a (spec missing) | n/a (spec missing) | n/a (spec missing) |
| Modulation | n/a (spec missing) | n/a (spec missing) | n/a (spec missing) |
| RuleBundle | n/a (spec missing) | n/a (spec missing) | n/a (spec missing) |
| Control | n/a (spec missing) | n/a (spec missing) | n/a (spec missing) |
| Asset | n/a (spec missing) | n/a (spec missing) | n/a (spec missing) |
| Examples | n/a (spec missing) | n/a (spec missing) | n/a (spec missing) |

## Component audits (Shader, Tone, Haptic, Modulation, RuleBundle, Control, Asset, Examples)
### Shader
- Baseline fields: description, fragment_shader, input_parameters, meta_info, name, uniforms, vertex_shader
- Baseline required: fragment_shader, name, vertex_shader
- Status: Blocked; spec file absent

### Tone
- Baseline fields: description, effects, input_parameters, meta_info, name, parts, patterns, synth
- Baseline required: name, synth
- Status: Blocked; spec file absent

### Haptic
- Baseline fields: description, device, input_parameters, meta_info, name
- Baseline required: device, input_parameters, name
- Status: Blocked; spec file absent

### Modulation
- Baseline fields: description, meta_info, modulations, name
- Baseline required: modulations, name
- Status: Blocked; spec file absent

### RuleBundle
- Baseline fields: created_at, description, id, meta_info, name, rules, updated_at
- Baseline required: name, rules
- Status: Blocked; spec file absent

### Control
- Baseline fields: default, label, mappings, max, min, options, parameter, smoothingTime, step, type, unit
- Baseline required: parameter, label, type, unit, default, mappings
- Status: Blocked; spec file absent

### Asset
- Baseline fields: control, created_at, description, haptic, meta_info, modulation, modulations, name, rule_bundle, shader, tone, updated_at
- Baseline required: name
- Status: Blocked; spec file absent

### Examples
- Baseline inventory covers: Control-Bundle_Example.json, Haptic_Example.json, Rule-Bundle_Example.json, Shader_Example.json, SynestheticAsset_Example1-9.json, SynestheticAsset_ExampleDS.json, Tone_Example.json
- Status: Blocked; spec file absent

## Detected divergences (bullets)
- None; divergence detection blocked by missing spec

## Recommendations for patch planning
- Restore or provide `docs/schema_refined.md` so audit can compute Present/Missing/Divergent sets
- Once spec is available, rerun audit and validate component alignments
