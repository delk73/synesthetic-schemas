---
version: v0.1.0
lastReviewed: 2025-09-26
owner: delk73
---

# Synesthetic EXAMPLES

This directory contains reference assets that demonstrate how to use the canonical schemas.  
Each JSON file includes a `$schemaRef` so it can be validated directly against the SSOT.

---

## Index

### Core Asset Examples
- **`asset_basic.json`** — Minimal SynestheticAsset with default shader, tone, and haptic.  
- **`asset_nested.json`** — Demonstrates a full nested asset with all components inlined.  

### Shader
- **`shader_simple.json`** — Basic fragment shader with uniforms.  
- **`shader_with_lib.json`** — Shader referencing a shared `shader_lib`.  

### Tone
- **`tone_synth.json`** — Example using `Tone.Synth` as baseline.  
- **`tone_fm.json`** — Example FM synth with modulation.  

### Haptic
- **`haptic_basic.json`** — Simple device config with parameterized intensity/duration.  

### Control
- **`control_slider.json`** — Slider mapped to shader uniform.  
- **`control_grid.json`** — Grid controller mapping multiple tone parameters.  

### Modulation
- **`modulation_curve.json`** — Envelope-style modulation with curve fitting.  
- **`modulation_wave.json`** — Periodic modulation for oscillatory control.  

### Rule Bundle
- **`rule_bundle_basic.json`** — Small ruleset binding control → shader/tone parameters.  

---

## Purpose

The `EXAMPLES/` directory ensures:  
- Each schema has at least one validating example.  
- Examples demonstrate real-world cross-modal mappings (visual/audio/haptic).  
- Round-trip validation (`validate`) confirms that examples load, parse, and re-emit without drift.  

Use these examples as a **starting point** for creating new assets, or as a reference when extending schemas.