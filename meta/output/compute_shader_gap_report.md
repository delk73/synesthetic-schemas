# Compute Shader Support Gap Report (Transparency-First)

Objective: Interrogate synesthetic-schemas for gaps preventing inline compute shader support inside the shader block (Option A, transparency-first).

- Style: KISS, deterministic, minimal deps
- Schema draft: 2020-12
- SSOT: jsonschema/*.schema.json defines all shader payloads
- Transparency: shader block must support fragment and compute

## Current Inventory (evidence)

- Schema: `jsonschema/shader.schema.json:1` — contains only `fragment_shader` and `vertex_shader` strings; no shader type/stage switch; no compute fields; no dispatch, no outputs.
- Types: `typescript/src/shader.d.ts:1` and `python/src/synesthetic_schemas/shader.py:1` — generated from the same schema; no compute-related fields present.
- Example: `examples/Shader_Example.json:1` — fragment/vertex only; no compute example present.
- Docs: `README.md:1` — no compute shader usage guidance or fields documented; no `docs/` directory.

## Desired State (summarized)

- `shader.type` enum supports `fragment` and `compute`.
- `compute_shader` GLSL source field is defined when type is `compute`.
- `dispatch` workgroup dimensions schema-defined: `x`, `y`, `z`.
- `outputs[]` describes texture/buffer targets with type and format.
- `input_parameters` and `uniforms` reusable across fragment and compute.
- At least one canonical compute shader example asset.
- Docs updated with schema fields and usage example.

## Gap Analysis

S1 — Shader type/stage missing (blocks `compute`)
- Evidence: No `type` or `shaderType` field in `jsonschema/shader.schema.json:1`.
- Impact: Cannot express that a shader is compute vs fragment/vertex; conditional fields cannot be validated.
- Touches: `jsonschema/shader.schema.json` (introduce a `type` discriminator with enum `["fragment", "compute"]`).

S2 — No `compute_shader` field
- Evidence: Absent from `jsonschema/shader.schema.json:1`.
- Impact: No place to carry GLSL compute source.
- Touches: `jsonschema/shader.schema.json` (add `compute_shader` string when `type == "compute"`).

S3 — No `dispatch { x, y, z }`
- Evidence: Absent from `jsonschema/shader.schema.json:1`.
- Impact: Cannot validate workgroup dispatch parameters needed to run compute workloads.
- Touches: `jsonschema/shader.schema.json` (add `dispatch` object with integer `x|y|z` ≥ 1 and sensible defaults).

S4 — No outputs/targets schema
- Evidence: No `outputs` or related definitions across repo; no texture/buffer schemas found.
- Impact: Cannot declare storage textures/buffers for compute shader IO.
- Touches: `jsonschema/shader.schema.json` (add `outputs[]` minimal structure). Optionally a dedicated `jsonschema/texture.schema.json` in future, but not required for MVP.

S5 — No compute example asset
- Evidence: Only `examples/Shader_Example.json:1` exists; no compute example.
- Impact: No validation target; poor discoverability.
- Touches: `examples/ComputeShader_Example.json` (add canonical minimal example).

S6 — Docs omit compute usage
- Evidence: `README.md:1` lacks compute coverage; no `docs/shaders.md` present.
- Impact: Users lack guidance on fields, constraints, and example usage.
- Touches: `README.md` section or new `docs/shaders.md` describing compute fields and example.

S7 — No human-readable gap report
- Evidence: This file did not exist previously under `meta/output/`.
- Impact: No single source audit for proposed additions and rationale.
- Touches: `meta/output/compute_shader_gap_report.md` (this report).

## Minimal, Backward-Compatible Schema Outline (proposed)

Note: Shown for clarity only; not applied in this pass.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "additionalProperties": false,
  "properties": {
    "name": { "type": "string" },
    "description": { "type": ["string", "null"], "default": null },
    "type": { "enum": ["fragment", "compute"], "default": "fragment" },
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
    {
      "if": { "properties": { "type": { "const": "fragment" } } },
      "then": { "required": ["vertex_shader", "fragment_shader"] }
    },
    {
      "if": { "properties": { "type": { "const": "compute" } } },
      "then": { "required": ["compute_shader", "dispatch"], "properties": { "outputs": {} } }
    }
  ],
  "$defs": {
    "InputParameterArray": { "type": ["array", "null"], "items": { "$ref": "#/$defs/InputParameter" } },
    "UniformDefArray": { "type": ["array", "null"], "items": { "$ref": "#/$defs/UniformDef" } },
    "InputParameter": { "type": "object" },
    "UniformDef": { "type": "object" }
  }
}
```

Rationale:
- Introduces `type` discriminator to keep fragment/compute paths explicit and validate conditionally.
- Keeps existing fields stable; fragment path unchanged for backward compatibility.
- Minimal `outputs[]` sufficient for transparency-first; details can evolve later.

## Canonical Compute Example (target shape)

To be added at `examples/ComputeShader_Example.json`:

```json
{
  "$schemaRef": "jsonschema/shader.schema.json",
  "name": "Compute Add 1D",
  "type": "compute",
  "compute_shader": "#version 310 es\nlayout(local_size_x = 64) in; layout(std430, binding = 0) buffer InOut { float data[]; }; void main() { uint i = gl_GlobalInvocationID.x; data[i] += 1.0; }",
  "dispatch": { "x": 256, "y": 1, "z": 1 },
  "outputs": [
    { "name": "data", "kind": "storageBuffer", "format": "f32" }
  ],
  "uniforms": null,
  "input_parameters": null
}
```

## Implementation Steps (to reach done definition)

1) Update schema: add `type`, `compute_shader`, `dispatch`, and optional `outputs` (conditional requirements as above) in `jsonschema/shader.schema.json`.
2) Regenerate types: run codegen to refresh `typescript/src/shader.d.ts` and `python/src/synesthetic_schemas/shader.py`.
3) Add example: `examples/ComputeShader_Example.json` matching the canonical example above.
4) Docs: add a small section to `README.md` (or new `docs/shaders.md`) explaining compute fields with the example.
5) Validate examples: run existing validation scripts to ensure schema acceptance across examples.

## Acceptance Checklist (done definition)

- [ ] `shader.type` enum validates `fragment` and `compute`.
- [ ] `shader.schema.json` defines `compute_shader`, `dispatch`, and `outputs`.
- [ ] `input_parameters` / `uniforms` validated for compute stage (reused directly).
- [ ] Canonical compute shader example asset passes schema validation.
- [ ] Docs updated with schema details and usage example.
- [x] Gap interrogation report exists under `meta/output/compute_shader_gap_report.md`.

