---
Canonical schemas hosted at: https://delk73.github.io/synesthetic-schemas/schema/0.7.3/
version: 0.7.3
lastReviewed: 2025-10-12
owner: delk73
---
Canonical schemas hosted at: https://delk73.github.io/synesthetic-schemas/schema/0.7.3/

version: 0.7.3
lastReviewed: 2025-10-12
owner: delk73
---
Canonical schemas hosted at: https://delk73.github.io/synesthetic-schemas/schema/0.7.3/

# SOTA: Perception & Interface Landscape

## Purpose
Live corpus for systems, standards, and papers relevant to **perception processing + interfaces** (not agent/world-model stacks). Keep it terse, comparable, and tied back to Synesthetic’s schema-first substrate.

## Columns
- **Name** — paper/tool/standard/benchmark  
- **Type** — Paper | Standard | Runtime | Toolkit | Benchmark | Product  
- **Year** — first public year (rough)  
- **Layer** — Tokenizer | Runtime | Interface | Haptics | Audio | Vision | Benchmark  
- **Key Idea** — one-liner  
- **Overlap w/ Synesthetic** — where it maps to shaders/tones/haptics/controls/modulations  
- **Notes/Refs** — brief evidence or TODO link

## Corpus
| Name | Type | Year | Layer | Key Idea | Overlap w/ Synesthetic | Notes/Refs |
|---|---|---:|---|---|---|---|
| **Physical Atari (Keen Tech)** | Benchmark / Platform | 2024– | Vision • Control | Camera-in, actuator-out on real consoles @ ~60 FPS | Perfect target for **SDF soft overlays + curve-fit**; homography→state→latency-comp control; logs @ 60 Hz | Link in repo README. Map to `concepts/sdf_soft_overlays.md` |
| **OpenXR** | Standard | 2019– | Interface • Haptics | Cross-vendor XR input/output API | Interfaces ↔ schema controls/haptics; map bidirectional sync | TODO refs |
| **WebGPU** | Standard/Runtime | 2023– | Runtime | Modern GPU API for browsers/native | Shader runtime baseline; determinism + footprint | TODO refs |
| **NVIDIA Holoscan** | Runtime | 2022– | Runtime • Vision | Low-latency sensor/compute pipelines | Contrast “procedural substrate” vs learned pipelines | TODO refs |
| **AToken (placeholder)** | Paper | 2025? | Tokenizer • Vision | Unified learned perceptual tokens | Contrast with **schema-tokenized manifold** | TODO refs |
| **V-JEPA / similar (placeholder)** | Paper | 2023– | Tokenizer • World Model | Predictive latent modeling | Bridge: learned→schema params | TODO refs |

## How to Use
- Add only high-leverage entries (target 15–30).  
- Keep “Overlap w/ Synesthetic” specific (which schema, which control path).  
- Update crosswalk links when an entry becomes central to positioning.
