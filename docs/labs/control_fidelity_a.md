---
version: v0.7.3
lastReviewed: 2025-10-12
owner: delk73
---

# Lab Protocol: Control Fidelity (a)

---

## Purpose

Test whether Synesthetic enforces declared control constraints and reflects state bidirectionally across modalities.  

This protocol operationalizes **Hypothesis 3 — Control Fidelity**.

---

## Method

1. **Constraint Audit**  
   - Identify all declared control parameters with `min`, `max`, and `step`.  
   - Collect schema definitions for sliders, knobs, and patch lifecycle endpoints.  

2. **Interaction Tests**  
   - Simulate GUI interactions (slider drag, knob rotation).  
   - Verify control values are clamped to declared constraints.  
   - Measure latency of GUI state reflection (target: ≤1 frame).  

3. **Patch Lifecycle Tests**  
   - Apply patch preview → confirm GUI reflects state.  
   - Apply patch commit → confirm backend and GUI remain consistent.  
   - Compare preview vs. applied states for divergence.  

---

## Criteria

- 100% compliance with declared `min`, `max`, `step` across all tested controls  
- GUI reflects state changes within ≤1 frame (≈16 ms at 60 fps)  
- No divergence between previewed and applied states  

---

## Outputs

- Test logs from Labs interaction harness  
- MCP validation traces (`meta/output/control_fidelity_eval.md`)  
- Example control assets (`examples/controls/*.json`)  

---

## Next Steps

1. Build control assets with strict `min/max/step` ranges.  
2. Run GUI simulation harness to capture reflection latency.  
3. Validate patch preview/apply loop for divergence.  
4. Document results in `meta/output/control_fidelity_eval.md`.  
5. Update [hypotheses.md](../hypotheses.md) with status (Draft → Active/Falsified).