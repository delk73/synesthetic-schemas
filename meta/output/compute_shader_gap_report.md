# Compute Shader Support Gap Report (Transparency-First)

Objective: Interrogate synesthetic-schemas for gaps preventing transparent inline support of compute shaders inside the shader block (Option A, transparency-first).

- Style: KISS, deterministic, minimal deps
- Schema draft: 2020-12
- SSOT: jsonschema/*.schema.json defines all shader payload structure
- Transparency: shader block must support fragment and compute

## Current Inventory (evidence)

- Schema: `jsonschema/shader.schema.json:1` — has `fragment_shader` and `vertex_shader` only; no stage/type discriminator; no compute fields; no `dispatch`; no `outputs`.
- Types: `typescript/src/shader.d.ts:1` and `python/src/synesthetic_schemas/shader.py:1` — reflect the schema; no compute-related fields present.
- Examples: `examples/Shader_Example.json:1` and `examples/SynestheticAsset_Example*.json:1` — cover fragment+vertex only; no compute examples.
- Asset schema: `jsonschema/synesthetic-asset.schema.json:1` — references `shader.schema.json` (0.7.3); will accept compute once shader schema supports it; no extra constraints.
- Docs: `README.md:160` — describes shader with `vertex_shader` and `fragment_shader`; no compute usage; no `docs/shaders.md` present.

## Desired State (summarized)

- `shader.type` enum supports `fragment` and `compute`.
- `compute_shader` GLSL source field defined when type is `compute`.
- `dispatch` object with integer `x`, `y`, `z` (≥ 1).
- `outputs[]` describes buffer/texture targets with `name`, `kind`, optional `format`.
- `input_parameters` and `uniforms` reusable across fragment and compute.
- Asset schema validates compute assets via updated shader schema reference.
- Canonical examples: compute shader and a synesthetic asset using it.
- Docs updated with compute fields and usage.
- This human-readable report under `meta/output/`.

## Gap Analysis (S1–S9)

- S1 — Shader type enum lacks `compute`
  - Evidence: No `type`/`shaderType` field in `jsonschema/shader.schema.json:1`.
  - Impact: Cannot express stage; cannot validate conditional fields for compute.
  - Touches: `jsonschema/shader.schema.json` (add `type` enum: `["fragment", "compute"]`).

- S2 — `compute_shader` field missing
  - Evidence: Absent from `jsonschema/shader.schema.json:1`.
  - Impact: No place to carry GLSL compute source.
  - Touches: `jsonschema/shader.schema.json` (add `compute_shader: string`, required when `type == "compute"`).

- S3 — No schema for dispatch dimensions
  - Evidence: No `dispatch` in `jsonschema/shader.schema.json:1`.
  - Impact: Cannot validate workgroup sizes required to run compute.
  - Touches: `jsonschema/shader.schema.json` (add `dispatch` object with integer `x|y|z` ≥ 1; defaults 1; `additionalProperties: false`).

- S4 — No schema for compute outputs (textures/buffers)
  - Evidence: No `outputs` in `jsonschema/shader.schema.json:1`; no texture/buffer schema in `jsonschema/`.
  - Impact: Cannot declare storage textures/buffers for compute IO.
  - Touches: `jsonschema/shader.schema.json` (add minimal `outputs[]` with `name`, `kind` in `["texture2D","texture3D","storageBuffer"]`, optional `format`).

- S5 — Asset schema does not validate compute shaders yet
  - Evidence: `jsonschema/synesthetic-asset.schema.json:1` references `shader.schema.json@0.7.3` which lacks compute.
  - Impact: Compute assets cannot validate until shader schema updates (and `$id`/version bump reflected here).
  - Touches: `jsonschema/shader.schema.json` (update, bump `$id`), `jsonschema/synesthetic-asset.schema.json` (update reference to new shader version or local ref).

- S6 — No canonical compute shader example asset (shader-only)
  - Evidence: `examples/` has no compute shader JSON.
  - Impact: No validation target; low discoverability.
  - Touches: `examples/shaders/ComputeShader_Example.json` (add canonical minimal example).

- S7 — No canonical synesthetic asset including a compute shader
  - Evidence: `examples/SynestheticAsset_Example*.json` are fragment/vertex only.
  - Impact: No end-to-end example combining compute shader within an asset.
  - Touches: `examples/SynestheticAsset_Compute.json` (add asset embedding the compute shader example).

- S8 — Docs omit compute shader usage
  - Evidence: `README.md:160` has no compute docs; `docs/` has QA only.
  - Impact: Users lack guidance on fields, constraints, and usage.
  - Touches: `docs/shaders.md` (new) or a README section documenting compute fields and examples.

- S9 — No aggregated compute gap report
  - Evidence: This file now serves as the requested report.
  - Impact: Previously missing; now addressed.
  - Touches: `meta/output/compute_shader_gap_report.md` (this report).

## Minimal, Backward-Compatible Schema Outline (proposed)

Note: For clarity only; not applied in this pass.

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
    { "if": { "properties": { "type": { "const": "fragment" } } },
      "then": { "required": ["vertex_shader", "fragment_shader"] } },
    { "if": { "properties": { "type": { "const": "compute" } } },
      "then": { "required": ["compute_shader", "dispatch"] } }
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
- Add `type` discriminator to validate stage-specific requirements while preserving current fragment path.
- Introduce compute-specific fields without breaking existing assets.
- Keep `input_parameters` and `uniforms` reusable across stages.

## Canonical Examples (target shapes)

- Shader-only compute — `examples/shaders/ComputeShader_Example.json`:
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

- Synesthetic asset including compute — `examples/SynestheticAsset_Compute.json`:
```json
{
  "$schema": "jsonschema/synesthetic-asset.schema.json",
  "name": "Compute Asset",
  "shader": { /* reference or inline of the compute shader example above */ }
}
```

## Implementation Steps (toward done definition)

1) Update shader schema: add `type`, `compute_shader`, `dispatch`, and optional `outputs` (conditional requirements) in `jsonschema/shader.schema.json`; bump `$id` version.
2) Update asset schema reference: point `jsonschema/synesthetic-asset.schema.json` to the updated shader schema `$id`.
3) Regenerate types: refresh `typescript/src/shader.d.ts` and `python/src/synesthetic_schemas/shader.py`.
4) Add examples: `examples/shaders/ComputeShader_Example.json` and `examples/SynestheticAsset_Compute.json`.
5) Docs: add `docs/shaders.md` or README section covering compute fields with examples.
6) Validate examples: run repo validation scripts.

## Acceptance Checklist (done definition)

- [ ] `shader.type` enum supports `fragment` and `compute`.
- [ ] `shader.schema.json` defines `compute_shader`, `dispatch`, and `outputs`.
- [ ] `input_parameters`/`uniforms` validated for compute stage (shared across stages).
- [ ] `synesthetic-asset.schema.json` validates assets with compute shader blocks.
- [ ] Canonical compute shader example validates successfully.
- [ ] Canonical synesthetic asset with compute validates successfully.
- [ ] Docs updated with schema fields and usage examples.
- [x] Gap interrogation report exists under `meta/output/compute_shader_gap_report.md`.
