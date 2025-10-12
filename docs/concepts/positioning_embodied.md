---
version: v0.7.3
lastReviewed: 2025-10-12
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
  - Acknowledges that language-only systems are disembodied (a widely recognized challenge, as discussed in sources like [Bender et al., 2021](https://dl.acm.org/doi/10.1145/3442188.3445922) on the dangers of stochastic parrots).
  - Uses learned perceptual tokenizers (AToken, V-JEPA) + simulators to approximate grounding.  
  - Explanations often treated as bolt-ons, leading to the communication gap noted by Keenan & Sokol (2023), *Mind the Gap!*.

- **Synesthetic**  
  - Defines manifolds upfront (visual, auditory, haptic).  
  - Procedural, deterministic, auditable.  
  - Runs real-time on Jetson/FPGA-class hardware.  
    - Evidence:
      - Performance baselines documented in ../perf/perf-baselines.md  

---

## Positioning Bullets  

- **Not a model** — a substrate.  
- **Not learned latent soup** — schema-tokenized fields.  
- **Not cloud-heavy** — low-latency local runtime.  
- **Bridges possible** — can ingest learned tokens, but doesn’t depend on them.  
- **Ahead of curve** — solves grounding problem natively, not retrofitted.  
- **Explanatory substrate** — communication is native, not afterthought.  

---

## One-Liner Pitch  
*“While embodied AI scrambles to bolt grounding onto LLMs, Synesthetic starts grounded: a schema-first multimodal substrate for perception and interfaces, lightweight enough for real-time deployment.”*
