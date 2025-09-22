# Schema Evaluation — 20250922

## Summary of repo schemas
- `jsonschema/control-bundle.schema.json` → title `control-bundle`, version `0.7.3`, $id `https://schemas.synesthetic.dev/0.7.3/control-bundle.schema.json`; properties: control_parameters, description, meta_info, name; required: name, control_parameters
- `jsonschema/control.schema.json` → title `control`, version `0.7.3`, $id `https://schemas.synesthetic.dev/0.7.3/control.schema.json`; properties: default, label, mappings, max, min, options, parameter, smoothingTime, step, type, unit; required: parameter, label, type, unit, default, mappings
- `jsonschema/haptic.schema.json` → title `haptic`, version `0.7.3`, $id `https://schemas.synesthetic.dev/0.7.3/haptic.schema.json`; properties: description, device, input_parameters, meta_info, name; required: device, input_parameters, name
- `jsonschema/modulation.schema.json` → title `modulation`, version `0.7.3`, $id `https://schemas.synesthetic.dev/0.7.3/modulation.schema.json`; properties: description, meta_info, modulations, name; required: modulations, name
- `jsonschema/rule-bundle.schema.json` → title `rule-bundle`, version `0.7.3`, $id `https://schemas.synesthetic.dev/0.7.3/rule-bundle.schema.json`; properties: created_at, description, id, meta_info, name, rules, updated_at; required: name, rules
- `jsonschema/rule.schema.json` → title `rule`, version `0.7.3`, $id `https://schemas.synesthetic.dev/0.7.3/rule.schema.json`; properties: effects, execution, expr, id, target, trigger; required: id
- `jsonschema/shader.schema.json` → title `shader`, version `0.7.3`, $id `https://schemas.synesthetic.dev/0.7.3/shader.schema.json`; properties: description, fragment_shader, input_parameters, meta_info, name, uniforms, vertex_shader; required: fragment_shader, name, vertex_shader
- `jsonschema/synesthetic-asset.schema.json` → title `synesthetic-asset`, version `0.7.3`, $id `https://schemas.synesthetic.dev/0.7.3/synesthetic-asset.schema.json`; properties: control, created_at, description, haptic, meta_info, modulation, modulations, name, rule_bundle, shader, tone, updated_at; required: name
- `jsonschema/tone.schema.json` → title `tone`, version `0.7.3`, $id `https://schemas.synesthetic.dev/0.7.3/tone.schema.json`; properties: description, effects, input_parameters, meta_info, name, parts, patterns, synth; required: name, synth

## Schema inventory table (Schema → Fields Present)
| Schema | Fields Present |
| --- | --- |
| control-bundle | control_parameters, description, meta_info, name |
| control | default, label, mappings, max, min, options, parameter, smoothingTime, step, type, unit |
| haptic | description, device, input_parameters, meta_info, name |
| modulation | description, meta_info, modulations, name |
| rule-bundle | created_at, description, id, meta_info, name, rules, updated_at |
| rule | effects, execution, expr, id, target, trigger |
| shader | description, fragment_shader, input_parameters, meta_info, name, uniforms, vertex_shader |
| synesthetic-asset | control, created_at, description, haptic, meta_info, modulation, modulations, name, rule_bundle, shader, tone, updated_at |
| tone | description, effects, input_parameters, meta_info, name, parts, patterns, synth |

## Component inventories (Shader, Tone, Haptic, Modulation, RuleBundle, Control, Examples)
### Shader
- Source: `jsonschema/shader.schema.json` (title `shader`)
- Top-level fields: description, fragment_shader, input_parameters, meta_info, name, uniforms, vertex_shader
- Required: fragment_shader, name, vertex_shader
- `$defs/InputParameter` fields: default, max, min, name, parameter, path, smoothingTime, step, type; required: name, parameter, path, type, default, min, max
- `$defs/UniformDef` fields: default, name, stage, type; required: name, type, stage, default

### Tone
- Source: `jsonschema/tone.schema.json` (title `tone`)
- Top-level fields: description, effects, input_parameters, meta_info, name, parts, patterns, synth
- Required: name, synth
- `$defs/SynthType` fields: ∅; required: ∅
- `$defs/ToneEffect` fields: options, order, type; required: type, options, order
- `$defs/ToneMetaInfo` fields: category, complexity, tags; required: category, tags, complexity
- `$defs/ToneParameter` fields: default, max, min, name, options, parameter, path, smoothingTime, type, unit; required: name, path, type, default
- `$defs/TonePart` fields: duration, id, loop, pattern, start; required: id, pattern, start, duration
- `$defs/TonePattern` fields: id, options, type; required: id, type, options
- `$defs/ToneSynth` fields: options, type; required: type, options
- `$defs/ToneSynthOptions` fields: envelope, filter, filterEnvelope, oscillator, portamento, volume; required: oscillator, envelope, volume

### Haptic
- Source: `jsonschema/haptic.schema.json` (title `haptic`)
- Top-level fields: description, device, input_parameters, meta_info, name
- Required: device, input_parameters, name
- `$defs/DeviceConfig` fields: options, type; required: type, options
- `$defs/DeviceOptionValue` fields: unit, value; required: value, unit
- `$defs/HapticParameter` fields: default, max, min, name, options, parameter, path, smoothingTime, step, type, unit; required: name, parameter, path, type, unit, default

### Modulation
- Source: `jsonschema/modulation.schema.json` (title `modulation`)
- Top-level fields: description, meta_info, modulations, name
- Required: modulations, name
- `$defs/ModulationItem` fields: amplitude, frequency, id, max, min, offset, phase, scale, scaleProfile, target, type, waveform; required: id, target, type, waveform, frequency, amplitude, offset, phase

### RuleBundle
- Source: `jsonschema/rule-bundle.schema.json` (title `rule-bundle`)
- Top-level fields: created_at, description, id, meta_info, name, rules, updated_at
- Required: name, rules
- `$defs/Rule` fields: effects, execution, expr, id, target, trigger; required: id

### Control
- Source: `jsonschema/control.schema.json` (title `control`)
- Top-level fields: default, label, mappings, max, min, options, parameter, smoothingTime, step, type, unit
- Required: parameter, label, type, unit, default, mappings
- `$defs/ActionType` fields: axis, curve, scale, sensitivity; required: axis, sensitivity
- `$defs/AxisType` fields: ∅; required: ∅
- `$defs/ComboType` fields: keys, mouseButtons, strict, wheel; required: ∅
- `$defs/CurveType` fields: ∅; required: ∅
- `$defs/DataType` fields: ∅; required: ∅
- `$defs/Mapping` fields: action, combo; required: combo, action

### Examples
- `examples/Control-Bundle_Example.json` → top-level fields: $schemaRef, name, description, meta_info, control_parameters
- `examples/Haptic_Example.json` → top-level fields: $schemaRef, name, description, meta_info, device, input_parameters
- `examples/Rule-Bundle_Example.json` → top-level fields: $schemaRef, name, description, meta_info, rules
- `examples/Shader_Example.json` → top-level fields: $schemaRef, description, fragment_shader, input_parameters, meta_info, name, uniforms, vertex_shader
- `examples/SynestheticAsset_Example1.json` → top-level fields: $schemaRef, control, description, haptic, meta_info, modulations, name, rule_bundle, shader, tone
- `examples/SynestheticAsset_Example2.json` → top-level fields: $schemaRef, control, description, haptic, meta_info, modulations, name, rule_bundle, shader, tone
- `examples/SynestheticAsset_Example3.json` → top-level fields: $schemaRef, control, description, haptic, meta_info, modulations, name, shader, tone
- `examples/SynestheticAsset_Example4.json` → top-level fields: $schemaRef, control, description, haptic, meta_info, modulations, name, shader, tone
- `examples/SynestheticAsset_Example5.json` → top-level fields: $schemaRef, control, description, haptic, meta_info, modulations, name, shader, tone
- `examples/SynestheticAsset_Example6.json` → top-level fields: $schemaRef, control, description, haptic, meta_info, modulations, name, rule_bundle, shader, tone
- `examples/SynestheticAsset_Example7.json` → top-level fields: $schemaRef, control, description, haptic, meta_info, modulations, name, shader, tone
- `examples/SynestheticAsset_Example8.json` → top-level fields: $schemaRef, control, description, haptic, meta_info, modulations, name, shader, tone
- `examples/SynestheticAsset_Example9.json` → top-level fields: $schemaRef, control, description, haptic, meta_info, modulations, name, rule_bundle, shader, tone
- `examples/SynestheticAsset_ExampleDS.json` → top-level fields: $schemaRef, control, description, haptic, meta_info, modulations, name, rule_bundle, shader, tone
- `examples/Tone_Example.json` → top-level fields: $schemaRef, name, description, meta_info, synth, effects, patterns, parts, input_parameters

## Top-level asset composition (synesthetic_asset.json)
- Source: `jsonschema/synesthetic-asset.schema.json`
- Fields: control, created_at, description, haptic, meta_info, modulation, modulations, name, rule_bundle, shader, tone, updated_at
- Required: name