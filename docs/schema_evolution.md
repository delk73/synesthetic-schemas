---
version: 0.7.3
lastReviewed: 2025-09-28
owner: delk73
---

# Schema Evolution

Canonical provenance of schema changes.  
Anchored at [version.json](../version.json).

---


## Scope

This document tracks **what changed** in the schema corpus (versioned provenance).  
For falsifiable claims about **what must be validated or tested** on top of the schema,  
see [Hypotheses](hypotheses.md).


## 0.7.3 (baseline)

- Baseline established at schemaVersion **0.7.3**.  
- All prior deltas considered legacy; tracking begins here.  

### Changelog
- **Added**: Schema corpus frozen at 0.7.3; no new fields beyond this baseline snapshot.  
- **Removed**: None — baseline initialization.  
- **Renamed**: None — baseline initialization.  

### References
- [Schema inventory snapshot](../meta/output/schema_eval_latest.md)  
- [version.json](../version.json)  

---

## v1.0 (planned)

Operator-centric rewrite scoped to SDFK. Collapses modality silos into unified operator graphs.  

### Changelog
- **Added**:  
  - New primitive type: **curve operator** (envelope, oscillator/LFO, cadence, mapping).  
  - Cadence formalized as distribution of intervals.  
- **Removed**:  
  - Direct modality-silo definitions (`shader`, `tone`, `haptic`, `modulation`) as first-class schema roots.  
- **Renamed**:  
  - Modality components → operator graphs with explicit domain/codomain pairs.  

### Migration
- Adapters required for v0.7.x assets → v1.0 operator graph form.  
- Round-trip and lint rules preserved.  

### Evolution Path
- **v1.0 (SDFK)**: Operator-centric rewrite scoped to shaders, tones, haptics, and cadence.  
- **vNext (extr 1.0)**: Potential general-purpose lift of operator substrate beyond Synesthetic (e.g., robotics, simulation, scheduling).  
