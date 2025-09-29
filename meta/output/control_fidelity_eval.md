---
version: v0.1.0
lastReviewed: 2025-09-29
owner: delk73
---

# Control Fidelity Evaluation (Hypothesis 3)

---

## Summary

This file records evaluation results for **Hypothesis 3 — Control Fidelity**.  
Target: 100% constraint compliance, ≤1 frame reflection latency, zero divergence in patch lifecycle.  

---

## Test Matrix

| Control Asset | Declared Range | Step | Compliance (%) | Reflection Latency (ms) | Preview vs. Apply Divergence | Notes |
|---------------|----------------|------|----------------|--------------------------|------------------------------|-------|
| slider_gain.json | 0–1 | 0.01 | 100% | 15.8 | None | Pass |
| knob_freq.json   | 20–20000 | 10 | 100% | 16.2 | None | Borderline latency |
| …               | …          | …   | …              | …                        | …                            | …     |

---

## Findings

- **Constraint compliance**: (fill in %)  
- **Reflection latency**: (avg, p90)  
- **Divergence**: (summary of any mismatches)  

---

## Status

- [ ] Draft  
- [ ] Active  
- [ ] Falsified  
- [ ] Superseded  
