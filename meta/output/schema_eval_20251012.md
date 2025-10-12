# Schema Evaluation (v0.7.3)

## Summary of schema evaluation

Evaluated 9 JSON schema files under docs/schema/0.7.3/ for version 0.7.3. Schemas define structures for synesthetic assets and their components including shader, tone, haptic, modulation, rule-bundle, control-bundle, control, rule, and synesthetic-asset. 15 example JSON files are present under examples/, demonstrating usage of the schemas with top-level keys listed.

## Schema inventory table

| Schema | Field Count |
|--------|-------------|
| synesthetic-asset | 12 |
| control-bundle | 4 |
| control | 11 |
| haptic | 5 |
| modulation | 4 |
| rule-bundle | 7 |
| rule | 6 |
| shader | 7 |
| tone | 8 |

## Component inventories

### Shader
- description: anyOf(string, null), default null
- fragment_shader: string
- input_parameters: array of InputParameter or null
  - InputParameter:
    - name: string
    - parameter: string
    - path: string
    - type: string
    - default: number
    - min: number
    - max: number
    - smoothingTime: number or null, default null
    - step: number or null, default null
- meta_info: object or null
- name: string
- uniforms: array of UniformDef or null
  - UniformDef:
    - name: string
    - type: string
    - stage: string
    - default: any
- vertex_shader: string

### Tone
- description: anyOf(string, null), default null
- effects: array of ToneEffect or null
  - ToneEffect:
    - type: string
    - options: object
    - order: integer
- input_parameters: array of ToneParameter
  - ToneParameter:
    - name: string
    - path: string
    - type: string
    - default: any
    - max: any or null, default null
    - min: any or null, default null
    - options: array of string or null, default null
    - parameter: string or null, default null
    - smoothingTime: number or null, default null
    - unit: string or null, default null
- meta_info: ToneMetaInfo or object or null, default null
  - ToneMetaInfo:
    - category: string
    - tags: array of string
    - complexity: string
- name: string
- parts: array of TonePart or null
  - TonePart:
    - id: string
    - pattern: string
    - start: string
    - duration: string
    - loop: boolean or null, default null
- patterns: array of TonePattern or null
  - TonePattern:
    - id: string
    - type: string
    - options: object
- synth: ToneSynth
  - ToneSynth:
    - type: SynthType
      - SynthType: enum ["Tone.Synth", "Tone.PolySynth", "Tone.MonoSynth", "Tone.FMSynth", "Tone.AMSynth", "Tone.DuoSynth", "Tone.MembraneSynth", "Tone.MetalSynth", "Tone.PluckSynth"]
    - options: ToneSynthOptions or object
      - ToneSynthOptions:
        - oscillator: object
        - envelope: object
        - volume: number or object
        - filter: object or null, default null
        - filterEnvelope: object or null, default null
        - portamento: number or object or null, default null

### Haptic
- description: anyOf(string, null), default null
- device: DeviceConfig
  - DeviceConfig:
    - type: string
    - options: object with additional properties DeviceOptionValue
      - DeviceOptionValue:
        - value: number
        - unit: string
- input_parameters: array of HapticParameter
  - HapticParameter:
    - name: string
    - parameter: string
    - path: string
    - type: string
    - unit: string
    - default: any
    - max: number or null, default null
    - min: number or null, default null
    - options: array of string or null, default null
    - smoothingTime: number or null, default null
    - step: number or null, default null
- meta_info: object or null
- name: string

### Modulation
- description: anyOf(string, null), default null
- meta_info: object or null
- modulations: array of ModulationItem
  - ModulationItem:
    - id: string
    - target: string
    - type: enum ["additive", "multiplicative"]
    - waveform: enum ["sine", "triangle", "square", "sawtooth"]
    - frequency: number
    - amplitude: number
    - offset: number
    - phase: number
    - max: number or null, default null
    - min: number or null, default null
    - scale: number, default 1
    - scaleProfile: enum ["linear", "exponential", "logarithmic", "sine", "cosine"]
- name: string

### RuleBundle
- created_at: string (date-time) or null, default null
- description: anyOf(string, null), default null
- id: integer or null, default null
- meta_info: object
- name: string
- rules: array of Rule
  - Rule:
    - id: string
    - effects: array of object or null, default null
    - execution: string or null, default null
    - expr: string or object or string (contentMediaType application/json) or null, default null
    - target: string or null, default null
    - trigger: object or null, default null
- updated_at: string (date-time) or null, default null

### Control
- default: number or integer or boolean or string
- label: string
- mappings: array of Mapping
  - Mapping:
    - combo: ComboType
      - ComboType:
        - keys: array of string or null, default null
        - mouseButtons: array of string or null, default null
        - strict: boolean, default false
        - wheel: boolean or null, default null
    - action: ActionType
      - ActionType:
        - axis: AxisType
          - AxisType: enum ["mouse.x", "mouse.y", "mouse.wheel"]
        - sensitivity: number
        - curve: CurveType
          - CurveType: enum ["linear", "exponential", "sine", "discrete"]
        - scale: number, default 1
- max: number or null, default null
- min: number or null, default null
- options: array of string or null, default null
- parameter: string
- smoothingTime: number, default 0
- step: number or null, default null
- type: DataType
  - DataType: enum ["float", "int", "bool", "string"]
- unit: string

### Asset
- control: anyOf(ref to control-bundle, null), default null
- created_at: string (date-time), readOnly
- description: anyOf(string, null), default null
- haptic: anyOf(ref to haptic, null), default null
- meta_info: anyOf(object, null), default null
- modulation: anyOf(ref to modulation, null), default null
- modulations: anyOf(array of ModulationItem, null), default null
- name: string
- rule_bundle: ref to rule-bundle
- shader: anyOf(ref to shader, null), default null
- tone: anyOf(ref to tone, null), default null
- updated_at: string (date-time), readOnly

## Top-level SynestheticAsset composition (property hierarchy)
- control: anyOf(ref to control-bundle, null), default null
- created_at: string (date-time), readOnly
- description: anyOf(string, null), default null
- haptic: anyOf(ref to haptic, null), default null
- meta_info: anyOf(object, null), default null
- modulation: anyOf(ref to modulation, null), default null
- modulations: anyOf(array of ModulationItem, null), default null
- name: string
- rule_bundle: ref to rule-bundle
- shader: anyOf(ref to shader, null), default null
- tone: anyOf(ref to tone, null), default null
- updated_at: string (date-time), readOnly

## Examples
- Control-Bundle_Example.json: $schema, control_parameters, description, meta_info, name
- Haptic_Example.json: $schema, description, device, input_parameters, meta_info, name
- Rule-Bundle_Example.json: $schema, description, meta_info, name, rules
- Shader_Example.json: $schema, description, fragment_shader, input_parameters, meta_info, name, uniforms, vertex_shader
- SynestheticAsset_Example1.json: $schema, control, description, haptic, meta_info, modulations, name, rule_bundle, shader, tone
- SynestheticAsset_Example2.json: $schema, control, description, haptic, meta_info, modulations, name, rule_bundle, shader, tone
- SynestheticAsset_Example3.json: $schema, control, description, haptic, meta_info, modulations, name, shader, tone
- SynestheticAsset_Example4.json: $schema, control, description, haptic, meta_info, modulations, name, shader, tone
- SynestheticAsset_Example5.json: $schema, control, description, haptic, meta_info, modulations, name, shader, tone
- SynestheticAsset_Example6.json: $schema, control, description, haptic, meta_info, modulations, name, rule_bundle, shader, tone
- SynestheticAsset_Example7.json: $schema, control, description, haptic, meta_info, modulations, name, shader, tone
- SynestheticAsset_Example8.json: $schema, control, description, haptic, meta_info, modulations, name, shader, tone
- SynestheticAsset_Example9.json: $schema, control, description, haptic, meta_info, modulations, name, rule_bundle, shader, tone
- SynestheticAsset_ExampleDS.json: $schema, control, description, haptic, meta_info, modulations, name, rule_bundle, shader, tone
- Tone_Example.json: $schema, description, effects, input_parameters, meta_info, name, parts, patterns, synth