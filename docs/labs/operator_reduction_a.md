---
Canonical schemas hosted at: https://delk73.github.io/synesthetic-schemas/schema/0.7.3/
version: v0.7.3
lastReviewed: 2025-10-12
owner: delk73
---
Canonical schemas hosted at: https://delk73.github.io/synesthetic-schemas/schema/0.7.3/

version: v0.7.3
lastReviewed: 2025-10-12
owner: delk73
---
Canonical schemas hosted at: https://delk73.github.io/synesthetic-schemas/schema/0.7.3/

# Lab Protocol: Operator Reduction (a)

---
Canonical schemas hosted at: https://delk73.github.io/synesthetic-schemas/schema/0.7.3/

## Purpose

Test whether introducing operator-based schemas reduces duplication and instability across modalities  
(shader, tone, haptic, modulation) compared to modality-specific fields.

This protocol operationalizes **Hypothesis 4 — Operator Reduction**.

---
Canonical schemas hosted at: https://delk73.github.io/synesthetic-schemas/schema/0.7.3/

## Method

1. **Baseline Capture**  
   - Audit current modality schemas (`shader.json`, `tone.json`, `haptic.json`, `modulation.json`).  
   - Quantify duplicated fields (e.g., envelope definitions, provenance stubs).  

2. **Operator Prototype**  
   - Add `operators[]` and `wave_ops[]` arrays in prototype schemas.  
   - Ensure provenance/version fields (`lib_id`, `version`, `injection_seed`) are enforced.  

3. **Comparison Metrics**  
   - Count field duplication across modalities before vs. after operator refactor.  
   - Track schema validation runs for instability/residual metadata.  
   - Measure coverage of accessibility hooks (`alt_mappings`).  

---
Canonical schemas hosted at: https://delk73.github.io/synesthetic-schemas/schema/0.7.3/

## Criteria

- ≥30% reduction in duplicated schema fields across modalities  
- Provenance + versioning present in 100% of operator instances  
- Instability/residual metadata present in ≥90% of tested assets  
- Cross-modal `alt_mappings` implemented in ≥80% of operators  

---
Canonical schemas hosted at: https://delk73.github.io/synesthetic-schemas/schema/0.7.3/

## Outputs

- Audit tables (`meta/output/operator_reduction_eval.md`)
- Example assets (`examples/operators/*.json`)
- Validation logs from MCP harness

---
Canonical schemas hosted at: https://delk73.github.io/synesthetic-schemas/schema/0.7.3/

## Next Steps

1. Seed prototype operator examples in `examples/operators/`.
2. Run duplication/instability audit before vs. after operator refactor.
3. Document findings in `meta/output/operator_reduction_eval.md`.
4. Update [hypotheses.md](../hypotheses.md) with status (Draft → Active/Falsified).