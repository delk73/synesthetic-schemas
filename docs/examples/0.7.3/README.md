---
version: v0.7.3
lastReviewed: 2025-10-12
owner: delk73
---

# Synesthetic EXAMPLES

This directory contains reference assets that demonstrate how to use the canonical schemas (version 0.7.3).  
Each JSON file includes a `$schema` so it can be validated directly against the SSOT at https://delk73.github.io/synesthetic-schemas/schema/0.7.3/.

---

## Index

### Component Examples
- **`Control-Bundle_Example.json`** — Example control bundle with parameters.
- **`Haptic_Example.json`** — Haptic device configuration with input parameters.
- **`Rule-Bundle_Example.json`** — Rule bundle with effects and triggers.
- **`Shader_Example.json`** — Shader with fragment/vertex code and uniforms.
- **`Tone_Example.json`** — Tone synthesis configuration with effects and patterns.

### SynestheticAsset Examples
- **`SynestheticAsset_Example1.json`** — Basic asset with control, haptic, modulation, rule_bundle, shader, tone.
- **`SynestheticAsset_Example2.json`** — Asset example 2.
- **`SynestheticAsset_Example3.json`** — Asset example 3.
- **`SynestheticAsset_Example4.json`** — Asset example 4.
- **`SynestheticAsset_Example5.json`** — Asset example 5.
- **`SynestheticAsset_Example6.json`** — Asset example 6.
- **`SynestheticAsset_Example7.json`** — Asset example 7.
- **`SynestheticAsset_Example8.json`** — Asset example 8.
- **`SynestheticAsset_Example9.json`** — Asset example 9.
- **`SynestheticAsset_ExampleDS.json`** — Dual-sphere asset example.

---

## Purpose

The `EXAMPLES/` directory ensures:  
- Each schema has at least one validating example.  
- Examples demonstrate real-world cross-modal mappings (visual/audio/haptic).  
- Round-trip validation (`validate`) confirms that examples load, parse, and re-emit without drift.  

Use these examples as a **starting point** for creating new assets, or as a reference when extending schemas.