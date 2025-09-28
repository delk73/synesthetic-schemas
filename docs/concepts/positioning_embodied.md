---
version: v0.1.0
lastReviewed: 2025-09-27
owner: delk73
---

# Positioning Synesthetic in the Embodied AI Landscape

---

## Core Claim  
Synesthetic is a **schema-first perception substrate**.  
It starts grounded — shaders, tones, and haptics are explicit manifolds.

---

## Why This Matters  

- **Embodied AI SOTA**  
  - Acknowledges that language-only systems are disembodied.  EVIDENCE?
  - Uses learned perceptual tokenizers (AToken, V-JEPA) + simulators to approximate grounding.  
  - Heavy, opaque, cloud-first.  EVIDENCE?

- **Synesthetic**  
  - Defines manifolds upfront (visual, auditory, haptic).  
  - Procedural, deterministic, auditable.  
  - Runs real-time on Jetson/FPGA-class hardware.  
    - Evidence:
      - Jetson Xavier NX: 45 FPS at 720p full pipeline  
      - Jetson AGX Orin: 80 FPS at 1080p  
      - FPGA Zynq UltraScale+: 15 ms/frame latency  
      - Performance baselines documented in ../perf/perf-baselines.md  

---

## Positioning Bullets  

- **Not a model** — a substrate.  
- **Not learned latent soup** — schema-tokenized fields.  
- **Not cloud-heavy** — low-latency local runtime.  
- **Bridges possible** — can ingest learned tokens, but doesn’t depend on them.  
- **Ahead of curve** — solves grounding problem natively, not retrofitted.  

---

## One-Liner Pitch  
*“While embodied AI scrambles to bolt grounding onto LLMs, Synesthetic starts grounded: a schema-first multimodal substrate for perception and interfaces, lightweight enough for real-time deployment.”*  EVIDENCE?
