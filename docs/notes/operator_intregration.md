---
version: v0.4.1
lastReviewed: 2025-09-27
owner: delk73
---

# Lab Note: Operator & Library Integration

---

## Purpose

Document tactical enhancements for making the current modality schemas (`shader`, `tone`, `haptic`, `modulation`) more operator-aware during the **bridge phase**.  

These changes are not the final SSOT (that role belongs to the operator/primitive library). Instead, they make the bridge schemas expressive enough for Labs prototyping, RLHF critique, and MCP validation without prematurely collapsing into the full library design.

---

## Why This Matters

- **Operators unify modalities:** Shader, tone, and haptic schemas all duplicate similar patterns. By injecting operators directly, we can test unified workflows now, while still keeping modality buckets for clarity.
- **Supports Labs loops:** Operators carry provenance, alt mappings, and instability metadata that Labs critics can use to surface emergent patterns.
- **Enables smooth migration:** Enhancements here mirror the fields and references that will exist in the eventual operator/primitive library. This avoids dead ends.

---

## Proposed Enhancements

### 1. Shader Operator Composability
- Add an `operators[]` array alongside existing `fragment_src`.
- Purpose: preserves GLSL fallback **and** allows operator-based shader definition.
- Example:

  **Before (fragment only):**
  ```json
  { "fragment_src": "void main() { ... }" }
````

**After (operator-aware):**

```json
{
  "fragment_src": "void main() { ... }",
  "operators": [
    {
      "type": "circle",
      "params": { "center": [0.5, 0.5], "radius": 0.25 },
      "provenance": { "lib_id": "primitives.circle", "version": "0.1.0", "seed": 42 }
    }
  ]
}
```

---

### 2. Universal Library References

* Extend `*_lib_id` pattern across all schemas (shader, tone, haptic, modulation, rule_bundle).
* Purpose: ensures a consistent reference path to the operator/primitive library.
* Example:

  ```json
  { "tone_lib_id": "primitives.sine:0.1.0", "params": { "frequency": 440 } }
  ```

---

### 3. Recursive Structures (`ops_chain`)

* Allow `ops_chain[]` fields in any modality.
* Purpose: support emergent or fractal composition (operators feeding into operators).
* Example:

  ```json
  {
    "ops_chain": [
      { "type": "noise", "params": { "scale": 0.2 } },
      { "type": "blend", "params": { "weight": 0.5 } }
    ]
  }
  ```

---

### 4. Residual / Emergence Metadata

* Add `emergence_meta` block at asset level.
* Purpose: capture instability parameters and residuals for Labs analysis.
* Example:

  ```json
  {
    "instability_params": { "activator_rate": 0.2, "inhibitor_rate": 0.05 },
    "residuals": { "fit_error": 0.03 }
  }
  ```

---

### 5. RuleBundle Operator Model

* Allow operator-based triggers and actions, not just grid-based ones.
* Purpose: move closer to symbolic conditions without DSL yet.
* Example:

  ```json
  { "trigger": "sdf_distance < 0.1", "action": "inject_op: bleb" }
  ```

---

### 6. Implicit Waves (Tone + Haptic)

* Introduce `wave_ops[]` arrays for function-based signals.
* Purpose: unify tone envelopes and haptic oscillations as operator sequences.
* Example:

  ```json
  {
    "wave_ops": [
      { "type": "adsr", "params": { "attack": 0.1, "decay": 0.2, "sustain": 0.7, "release": 0.3 } }
    ]
  }
  ```

---

### 7. Accessibility Hooks

* Require `alt_mappings` in every operator.
* Purpose: enforce cross-modal fallbacks.
* Example:

  ```json
  {
    "type": "circle",
    "params": { "radius": 0.25 },
    "alt_mappings": {
      "haptic": { "pattern": "pulse", "intensity": "radius * 0.5" },
      "audio": { "waveform": "sine", "frequency": "radius * 220" }
    }
  }
  ```

---

### 8. Provenance & Versioning

* Mandate `{lib_id, version, injection_seed}` in all operators.
* Purpose: guarantee reproducibility and linkage back to library definitions.

---

### 9. Cross-Modal Wiring

* Allow operators to target other modalities (e.g., modulation drives haptic intensity).
* Purpose: validate relational wiring early in JSON form.
* Example:

  ```json
  { "modulate": { "source": "sine.lfo1", "target": "circle.radius" } }
  ```

---

### 10. Validation for Emergence

* Add schema constraints for instability ranges.
* Use MCP validation harness to test emergent setups and prevent invalid configs.

---

## Next Steps

1. Prototype `operators[]` in `shader.json` and `wave_ops[]` in `tone.json`.
2. Define provisional operator JSON files under `ops/primitives/*.json`.
3. Seed `examples/operators/*.json` with inline and reference examples.
4. Extend MCP validation harness to check:

   * Provenance fields present.
   * Alt mappings included.
   * Recursive ops and emergence_meta do not break constraints.

```