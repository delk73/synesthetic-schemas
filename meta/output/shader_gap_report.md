# Shader Inline Support Gap Report (Vertex/Fragment/Compute)

Objective: Interrogate synesthetic-schemas for gaps preventing full inline shader support across vertex, fragment, and compute stages (transparency-first, Option A).

- Style: KISS, deterministic, minimal deps
- Schema draft: 2020-12
- SSOT: jsonschema/*.schema.json defines all shader payloads
- Transparency: shader block must support vertex, fragment, and compute

## Current Inventory (evidence)

- Schema: `jsonschema/shader.schema.json:1` — contains `vertex_shader` and `fragment_shader` strings; both are required unconditionally; no `type`/discriminator; no compute fields; no dispatch, no outputs.
- Types: `typescript/src/shader.d.ts:1` — generated from the same schema; no `type` field; no compute-related fields; `stage` on uniforms is an unconstrained `string`.
- Example: `examples/Shader_Example.json:1` — fragment/vertex present; no compute example present.
- Docs: `README.md:97` — mentions shader fields `vertex_shader` and `fragment_shader`; no compute shader usage guidance; no dedicated `docs/shaders.md` present.

## Desired State (target)

- `shader.type` enum supports `vertex`, `fragment`, and `compute`.
- `shader.schema.json` defines `vertex_shader`, `fragment_shader`, and `compute_shader` GLSL source fields.
- `dispatch` object with integer `x`, `y`, `z` (≥ 1) for compute.
- `outputs[]` describes texture/buffer targets with `name`, `kind`, and optional `format` (compute only).
- `input_parameters` and `uniforms` reusable across all stages; `uniform.stage` enum recognizes `vertex`, `fragment`, `compute`.
- Canonical examples cover vertex+fragment (existing), vertex-only minimal, and compute.
- Docs updated with schema fields and usage examples for all stages.
- Gap interrogation report exists under `meta/output/`.

## Gap Analysis

S1 — No shader type discriminator / enum
- Evidence: No `type` or `shaderType` field in `jsonschema/shader.schema.json:1`.
- Impact: Cannot express stage intent (vertex/fragment/compute) nor validate conditional requirements.
- Touches: `jsonschema/shader.schema.json` (add `type` enum: `["vertex", "fragment", "compute"]`).

S2 — Missing `compute_shader` GLSL source field
- Evidence: Absent from `jsonschema/shader.schema.json:1` and downstream types.
- Impact: No place to carry compute source.
- Touches: `jsonschema/shader.schema.json` (add `compute_shader: string`).

S3 — Missing compute `dispatch { x, y, z }`
- Evidence: No `dispatch` anywhere in repo for shader payloads.
- Impact: Cannot validate workgroup invocation dimensions required to run compute.
- Touches: `jsonschema/shader.schema.json` (add `dispatch` with integer `x|y|z`, `minimum: 1`, defaults 1; `additionalProperties: false`).

S4 — Missing compute outputs/targets schema
- Evidence: No `outputs` or texture/buffer target definitions in `jsonschema/`; search shows none.
- Impact: Cannot declare storage textures/buffers for compute IO.
- Touches: `jsonschema/shader.schema.json` (add minimal `outputs[]` structure); future optional breakout into `texture.schema.json` if needed.

S5 — Examples omit canonical vertex-only and compute shader assets
- Evidence: `examples/Shader_Example.json:1` has fragment+vertex; no vertex-only minimal; no compute example.
- Impact: Gaps in validation coverage and discoverability.
- Touches: `examples/shaders/VertexShader_Example.json` and `examples/shaders/ComputeShader_Example.json` (new examples).

S6 — Docs lack vertex/compute schema usage
- Evidence: `README.md:97` documents only vertex/fragment fields; no compute section; no `docs/shaders.md`.
- Impact: Users lack authoritative reference for new fields and conditional requirements.
- Touches: `docs/shaders.md` (new) or a dedicated section in `README.md`.

S7 — No aggregated gap report at requested path
- Evidence: No `meta/output/shader_gap_report.md` present (only `meta/output/compute_shader_gap_report.md` exists).
- Impact: Missing audit artifact for the broader vertex/fragment/compute goal.
- Touches: `meta/output/shader_gap_report.md` (this report).

## Minimal, Backward-Compatible Schema Outline (proposed)

Note: Shown for clarity; not applied in this pass.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "additionalProperties": false,
  "properties": {
    "name": { "type": "string" },
    "description": { "type": ["string", "null"], "default": null },
    "type": { "enum": ["vertex", "fragment", "compute"], "default": "fragment" },
    "vertex_shader": { "type": "string" },
    "fragment_shader": { "type": "string" },
    "compute_shader": { "type": "string" },
    "dispatch": {
      "type": "object",
      "properties": {
        "x": { "type": "integer", "minimum": 1, "default": 1 },
        "y": { "type": "integer", "minimum": 1, "default": 1 },
        "z": { "type": "integer", "minimum": 1, "default": 1 }
      },
      "required": ["x", "y", "z"],
      "additionalProperties": false
    },
    "outputs": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "name": { "type": "string" },
          "kind": { "enum": ["texture2D", "texture3D", "storageBuffer"] },
          "format": { "type": "string" }
        },
        "required": ["name", "kind"],
        "additionalProperties": false
      }
    },
    "uniforms": { "$ref": "#/$defs/UniformDefArray" },
    "input_parameters": { "$ref": "#/$defs/InputParameterArray" }
  },
  "required": ["name", "type"],
  "allOf": [
    { "if": { "properties": { "type": { "const": "fragment" } } },
      "then": { "required": ["vertex_shader", "fragment_shader"] } },
    { "if": { "properties": { "type": { "const": "vertex" } } },
      "then": { "required": ["vertex_shader"] } },
    { "if": { "properties": { "type": { "const": "compute" } } },
      "then": { "required": ["compute_shader", "dispatch"] } }
  ],
  "$defs": {
    "InputParameterArray": { "type": ["array", "null"], "items": { "$ref": "#/$defs/InputParameter" } },
    "UniformDefArray": { "type": ["array", "null"], "items": { "$ref": "#/$defs/UniformDef" } },
    "InputParameter": { "type": "object" },
    "UniformDef": {
      "type": "object",
      "properties": {
        "name": { "type": "string" },
        "type": { "type": "string" },
        "stage": { "enum": ["vertex", "fragment", "compute"] },
        "default": {}
      },
      "required": ["name", "type", "stage", "default"],
      "additionalProperties": false
    }
  }
}
```

Rationale:
- Introduces `type` discriminator to validate stage-specific requirements, keeping existing fragment+vertex path backward compatible.
- Adds compute-specific fields without changing existing names; defaults minimize disruption.
- Reuses `input_parameters` and `uniforms` verbatim; constrains `uniform.stage` to the three recognized stages.

## Canonical Examples (target shapes)

1) Vertex-only minimal — `examples/shaders/VertexShader_Example.json`:
```json
{
  "$schemaRef": "jsonschema/shader.schema.json",
  "name": "Vertex Passthrough",
  "type": "vertex",
  "vertex_shader": "#version 300 es\nin vec3 position; void main(){ gl_Position = vec4(position, 1.0); }",
  "uniforms": null,
  "input_parameters": null
}
```

2) Fragment+Vertex (existing) — `examples/Shader_Example.json` remains valid with `type: "fragment"` implied by default or explicitly set.

3) Compute — `examples/shaders/ComputeShader_Example.json`:
```json
{
  "$schemaRef": "jsonschema/shader.schema.json",
  "name": "Compute Add 1D",
  "type": "compute",
  "compute_shader": "#version 310 es\nlayout(local_size_x = 64) in; layout(std430, binding = 0) buffer InOut { float data[]; }; void main() { uint i = gl_GlobalInvocationID.x; data[i] += 1.0; }",
  "dispatch": { "x": 256, "y": 1, "z": 1 },
  "outputs": [ { "name": "data", "kind": "storageBuffer", "format": "f32" } ],
  "uniforms": null,
  "input_parameters": null
}
```

## Implementation Steps (toward done definition)

1) Update schema: add `type`, `compute_shader`, `dispatch`, and optional `outputs` with conditional requirements in `jsonschema/shader.schema.json`.
2) Constrain `uniform.stage` to enum `["vertex", "fragment", "compute"]`.
3) Regenerate types: run codegen to refresh `typescript/src/shader.d.ts` and Python models.
4) Add examples: `examples/shaders/VertexShader_Example.json` and `examples/shaders/ComputeShader_Example.json`.
5) Docs: add `docs/shaders.md` with field descriptions and the examples above.
6) Validate examples: run `./build.sh` and existing validation scripts.

## Acceptance Checklist

- [ ] `shader.type` enum validates `vertex`, `fragment`, and `compute`.
- [ ] `shader.schema.json` defines `vertex_shader`, `fragment_shader`, and `compute_shader`.
- [ ] Compute `dispatch` and `outputs` schema support exists.
- [ ] `input_parameters`/`uniforms` validated across all stages; `uniform.stage` enum constrained.
- [ ] Canonical vertex, fragment, and compute shader examples pass schema validation.
- [ ] Docs updated with schema details and usage examples for all stages.
- [x] Gap interrogation report exists under `meta/output/shader_gap_report.md`.

