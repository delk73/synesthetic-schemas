---
version: v0.1.0
lastReviewed: 2025-09-29
owner: delk73
---

# Lab Protocol: Explanatory Grounding (a)

---

## Purpose

Test whether Synesthetic provides a shared perceptual substrate that reduces interpretive variance across explainees.  

This protocol operationalizes **Hypothesis 2 — Explanatory Grounding**.

---

## Method

1. **Baseline Condition**  
   - Present system state/changes using raw model outputs (no Synesthetic substrate).  
   - Collect explainee interpretations (free text or structured survey).  

2. **Synesthetic Condition**  
   - Present the same state/changes through Synesthetic multimodal substrate (shader, tone, haptic).  
   - Collect interpretations as above.  

3. **Variance Measurement**  
   - Normalize responses into comparable categories.  
   - Compute variance across explainees (with vs. without substrate).  
   - Analyze whether Synesthetic condition reduces variance.  

---

## Criteria

- Statistically significant reduction in interpretive variance (p < 0.05)  
- ≥20% decrease in variance relative to baseline condition  
- Consistent across at least 3 independent explainees  

---

## Outputs

- Interpretation datasets (`meta/output/explanatory_grounding_eval.md`)  
- Example assets used in tests (`examples/grounding/*.json`)  
- Statistical analysis scripts/logs  

---

## Next Steps

1. Define test stimuli and tasks (system state changes).  
2. Recruit/define explainee pool (≥3 participants).  
3. Collect interpretations in baseline vs. Synesthetic condition.  
4. Analyze variance reduction and document results.  
5. Update [hypotheses.md](../hypotheses.md) with status (Draft → Active/Falsified).  
