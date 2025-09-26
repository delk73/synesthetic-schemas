---
version: v0.4.0
lastReviewed: 2025-09-26
owner: delk73
---

# Schema Evolution: Operator & Library Integration

---

## Purpose

Introduce structured operator libraries and cross-modal injection paths into the unified schemas.  
This evolution strengthens implicit/smooth representation, enables operator-based RuleBundles, and supports accessible multimodal mappings without grid artifacts.

---

## Proposed Enhancements

### Shader Operator Composability

- Add optional `operators` array alongside `fragment_src`.
- Example:
  ```json
  {
    "type": "circle",
    "params": { "center": [0.5, 0.5], "radius": 0.25 },
    "provenance": { "lib_id": "primitives.circle", "version": "0.1.0", "seed": 42 }
  }
  ```


* Preserves GLSL fallback while enabling generator-injected parametric ops.

### Universal Library References

* Extend `shader_lib_id` pattern to tone, haptic, modulation, and rule\_bundle schemas.
* Allows reuse of external operator catalogs (YAML/JSON).

### Hierarchical / Recursive Structures

* Support nested `ops_chain` fields across shader, tone, haptic.
* Enables recursive/emergent structures (e.g., fractal ripples).

### Residual / Emergence Metadata

* Add `emergence_meta` to `synesthetic_asset`.
* Example:

  ```json
  {
    "instability_params": { "activator_rate": 0.2, "inhibitor_rate": 0.05 },
    "residuals": { "fit_error": 0.03 }
  }
  ```
* Captures mismatches or adaptive insights for Labs critique.

### RuleBundle Operator Model

* Expand beyond grid-based triggers.
* Example:

  ```json
  { "trigger": "sdf_distance < 0.1", "action": "inject_op: bleb" }
  ```

### Implicit Waves for Haptic & Tone

* Add `wave_ops` arrays (sine, envelope, decay, etc.).
* Promotes smooth, function-based mappings over discrete parts.

### Accessibility Hooks

* Require `alt_mappings` in operators.
* Ensures haptic/audio fallbacks are defined at schema level.

### Provenance & Versioning

* Mandate `{lib_id, version, injection_seed}` in each operator.
* Increment `x-schema-version` to flag operator-enabled schemas.

### Cross-Modal Wiring

* Strengthen relational links: operators can be modulation targets
  (e.g., ripple amplitude ↔ haptic frequency).

### Validation for Emergence

* Add schema constraints for instability params (e.g., activator/inhibitor ranges).
* MCP can pre-flight emergent setups and catch grid-taint early.

---

## Next Steps

1. Prototype `operators` in `defs/shader.json` and `wave_ops` in `defs/tone.json`.
2. Define provisional operator library format under `ops/primitives/*.json`.
3. Add example assets to `examples/operators/*.json`.
4. Extend MCP validation harness to test recursive operator injection.
