# Schema Evaluation (v0.7.3)

## Summary of Schema Evaluation

Schema evaluation completed for version 0.7.3 on 2025-10-12. Evaluated 9 schema files with a total of 169 fields across all schemas and definitions. Included 16 example JSON files with top-level keys documented. This snapshot serves as an immutable baseline for future schema audits.

## Schema Inventory Table

| Schema | Field Count |
|--------|-------------|
| synesthetic-asset | 12 |
| control-bundle | 4 |
| control | 27 |
| haptic | 21 |
| modulation | 17 |
| rule-bundle | 15 |
| rule | 7 |
| shader | 21 |
| tone | 45 |

## Component Inventories

### Shader Component Inventory

- description: string or null
- fragment_shader: string
- input_parameters: array of InputParameter
  - default: number
  - max: number
  - min: number
  - name: string
  - parameter: string
  - path: string
  - smoothingTime: number or null
  - step: number or null
  - type: string
- meta_info: object or null
- name: string
- uniforms: array of UniformDef
  - default: any
  - name: string
  - stage: string
  - type: string
- vertex_shader: string

### Tone Component Inventory

- description: string or null
- effects: array of ToneEffect or null
  - options: object
  - order: integer
  - type: string
- input_parameters: array of ToneParameter
  - default: any
  - max: any or null
  - min: any or null
  - name: string
  - options: array of string or null
  - parameter: string or null
  - path: string
  - smoothingTime: number or null
  - type: string
  - unit: string or null
- meta_info: ToneMetaInfo or object or null
  - category: string
  - complexity: string
  - tags: array of string
- name: string
- parts: array of TonePart or null
  - duration: string
  - id: string
  - loop: boolean or null
  - pattern: string
  - start: string
- patterns: array of TonePattern or null
  - id: string
  - options: object
  - type: string
- synth: ToneSynth or object
  - options: ToneSynthOptions or object
    - envelope: object
    - filter: object or null
    - filterEnvelope: object or null
    - oscillator: object
    - portamento: number or object or null
    - volume: number or object
  - type: SynthType (enum: Tone.Synth, Tone.PolySynth, Tone.MonoSynth, Tone.FMSynth, Tone.AMSynth, Tone.DuoSynth, Tone.MembraneSynth, Tone.MetalSynth, Tone.PluckSynth)

### Haptic Component Inventory

- description: string or null
- device: DeviceConfig
  - options: object of DeviceOptionValue
    - unit: string
    - value: number
  - type: string
- input_parameters: array of HapticParameter
  - default: any
  - max: number or null
  - min: number or null
  - name: string
  - options: array of string or null
  - parameter: string
  - path: string
  - smoothingTime: number or null
  - step: number or null
  - type: string
  - unit: string
- meta_info: object or null
- name: string

### Modulation Component Inventory

- description: string or null
- meta_info: object or null
- modulations: array of ModulationItem
  - amplitude: number
  - frequency: number
  - id: string
  - max: number or null
  - min: number or null
  - offset: number
  - phase: number
  - scale: number
  - scaleProfile: string (enum: linear, exponential, logarithmic, sine, cosine)
  - target: string
  - type: string (enum: additive, multiplicative)
  - waveform: string (enum: sine, triangle, square, sawtooth)
- name: string

### RuleBundle Component Inventory

- created_at: string (date-time) or null
- description: string or null
- id: integer or null
- meta_info: object
- name: string
- rules: array of Rule
  - effects: array of object or null
  - execution: string or null
  - expr: string or object or string (contentMediaType: application/json) or null
  - id: string
  - target: string or null
  - trigger: object or null
- updated_at: string (date-time) or null

### Control Component Inventory

- default: number or integer or boolean or string
- label: string
- mappings: array of Mapping
  - action: ActionType
    - axis: AxisType (enum: mouse.x, mouse.y, mouse.wheel)
    - curve: CurveType (enum: linear, exponential, sine, discrete)
    - scale: number
    - sensitivity: number
  - combo: ComboType
    - keys: array of string or null
    - mouseButtons: array of string or null
    - strict: boolean
    - wheel: boolean or null
- max: number or null
- min: number or null
- options: array of string or null
- parameter: string
- smoothingTime: number
- step: number or null
- type: DataType (enum: float, int, bool, string)
- unit: string

### Asset Component Inventory (SynestheticAsset)

- control: ControlBundle or null
- created_at: string (date-time), readOnly
- description: string or null
- haptic: Haptic or null
- meta_info: object or null
- modulation: Modulation or null
- modulations: array of ModulationItem or null
- name: string
- rule_bundle: RuleBundle
- shader: Shader or null
- tone: Tone or null
- updated_at: string (date-time), readOnly

## Top-level SynestheticAsset Composition (Property Hierarchy)

- control: anyOf ControlBundle, null
- created_at: string (format: date-time), readOnly
- description: anyOf string, null
- haptic: anyOf Haptic, null
- meta_info: anyOf object, null
- modulation: anyOf Modulation, null
- modulations: anyOf array of ModulationItem, null
- name: string, required
- rule_bundle: RuleBundle, required
- shader: anyOf Shader, null
- tone: anyOf Tone, null
- updated_at: string (format: date-time), readOnly

## Examples Top-Level Keys

### Control-Bundle_Example.json
- $schema
- name
- description
- meta_info
- control_parameters

### Haptic_Example.json
- $schema
- name
- description
- meta_info
- device
- input_parameters

### Rule-Bundle_Example.json
- $schema
- name
- description
- meta_info
- rules

### Shader_Example.json
- $schema
- description
- fragment_shader
- input_parameters
- meta_info
- name
- uniforms
- vertex_shader

### Tone_Example.json
- $schema
- name
- description
- meta_info
- synth
- effects
- patterns
- parts
- input_parameters

### SynestheticAsset_Example1.json
- $schema
- control
- description
- haptic
- meta_info
- modulations
- name
- rule_bundle
- shader
- tone

### SynestheticAsset_Example2.json
- $schema
- control
- description
- haptic
- meta_info
- modulations
- name
- rule_bundle
- shader
- tone

### SynestheticAsset_Example3.json
- $schema
- control
- description
- haptic
- meta_info
- modulations
- name
- rule_bundle
- shader
- tone

### SynestheticAsset_Example4.json
- $schema
- control
- description
- haptic
- meta_info
- modulations
- name
- rule_bundle
- shader
- tone

### SynestheticAsset_Example5.json
- $schema
- control
- description
- haptic
- meta_info
- modulations
- name
- rule_bundle
- shader
- tone

### SynestheticAsset_Example6.json
- $schema
- control
- description
- haptic
- meta_info
- modulations
- name
- rule_bundle
- shader
- tone

### SynestheticAsset_Example7.json
- $schema
- control
- description
- haptic
- meta_info
- modulations
- name
- rule_bundle
- shader
- tone

### SynestheticAsset_Example8.json
- $schema
- control
- description
- haptic
- meta_info
- modulations
- name
- rule_bundle
- shader
- tone

### SynestheticAsset_Example9.json
- $schema
- control
- description
- haptic
- meta_info
- modulations
- name
- rule_bundle
- shader
- tone

### SynestheticAsset_ExampleDS.json
- $schema
- control
- description
- haptic
- meta_info
- modulations
- name
- rule_bundle
- shader
- tone