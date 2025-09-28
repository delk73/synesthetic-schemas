---
version: 0.7.3
lastReviewed: 2025-09-26
owner: delk73
---

## **Overview**

This use case tests how a single **field operator** (e.g., ripple, circle, wave) can be expressed simultaneously across **visual, auditory, and haptic channels**.

---

## **Problem**

Current schemas handle shaders, tones, and haptics independently, but lack:

* **Alt-mappings:** explicit cross-modal equivalences.
* **Wave\_ops:** parametric functions for audio/haptic representations.
* **Accessibility enforcement:** ensuring every visual op has auditory/haptic analogs.

---

## **Schema Touchpoints**

* **Shader schema** → `operators` array for fields (circle, ripple).
* **Tone schema** → `wave_ops` for audio equivalents (sine, envelope).
* **Haptic schema** → `wave_ops` for tactile equivalents (pulse, decay).
* **SynestheticAsset** → `alt_mappings` field to bind them together.

---

## **Flow**

1. Ripple operator defined in shader.
2. Alt mappings specify tone sine-LFO + haptic vibration.
3. When ripple oscillates visually, sound and touch sync deterministically.

---

## **Deterministic Guarantees**

* Same operator + mappings always yield identical multimodal fields.
* Provenance ensures mapping library versions are fixed.
* Accessibility ensured: no visual op without tone/haptic fallback.

---

## **Live Example**

The following examples illustrate components of a perceptual field:

*   `examples/Shader_Example.json`: Defines a visual field operator.
*   `examples/Tone_Example.json`: Defines an auditory component.
*   `examples/Haptic_Example.json`: Defines a haptic component.
*   `examples/SynestheticAsset_Example1.json`: Binds these components together into a single, multimodal asset.

## **Schema Evolution Tie-in**

This use case is a primary driver for the following schema features:

*   **`synesthetic-asset.schema.json`**: The need to express cross-modal fields led directly to the `alt_mappings` field, which allows for the explicit linking of visual, auditory, and haptic operators. This is the core of the "perceptual field" concept.
*   **`tone.schema.json` and `haptic.schema.json`**: The introduction of `wave_ops` (waveform operations) provides a parametric way to define auditory and haptic representations that are equivalent to visual shader operators. This moves beyond static sound/haptic clips to dynamic, procedural effects.
*   **`shader.schema.json`**: The `operators` array was formalized to ensure that visual fields are composed of discrete, addressable components that can be targeted by `alt_mappings`.