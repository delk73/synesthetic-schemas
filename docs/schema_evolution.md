---
version: v0.7.3
lastReviewed: 2025-10-12
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

## 0.7.4 (schema enrichment for Labs alignment)

### Changelog
- **Added**:
  - Top-level fields: `asset_id`, `prompt`, `timestamp`, `seed`, `parameter_index`, `provenance`.
  - Component fields: `name`, `description`, `input_parameters` allowed on `shader`, `tone`, `haptic`.
  - New `effects` array on `tone`.
  - New `modulation.schema.json` wired into `SynestheticAsset`.
  - New `provenance.schema.json` definition, referenced by asset.
- **Removed**:
  - Required `name` at asset root (replaced by `meta_info.title`).
- **Renamed**:
  - None.

### Migration
- v0.7.3 examples missing `asset_id` remain valid (field optional).
- Validator now accepts richer Labs-style assets without rejection.

### References
- [version.json](../version.json) bumped to `0.7.4`.
- Audit reports: `meta/output/schema_audit_*.md`.

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
