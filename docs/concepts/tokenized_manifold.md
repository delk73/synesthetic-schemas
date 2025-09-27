---
version: v0.1.0
lastReviewed: 2025-09-27
owner: delk73
---

# Tokenized Manifold: Schema-First vs Learned Approaches

---

## Purpose  
Define how Synesthetic treats perception as an **explicitly tokenized manifold** — in contrast to learned tokenizers like AToken — and capture why this matters for grounding.

---

## Context  

- **Learned Tokenizers (AToken, V-JEPA, etc.)**  
  - Start with raw perceptual fields (pixels, audio frames, motion data).  
  - Train encoders to compress them into latent tokens.  
  - Manifold definition is *implicit* and *learned*.  

- **Synesthetic Substrate**  
  - Declares the manifold **upfront via schema**:  
    - Shader → visual field  
    - Tone → frequency–time auditory field  
    - Haptic → force–displacement field  
  - Tokens are the schema parameters, already discrete and interpretable.  
  - Manifold definition is *explicit* and *deterministic*.  

---

## Cross-Walk  

| Dimension        | Learned Tokenizers | Synesthetic |
|------------------|--------------------|-------------|
| Manifold         | Discovered via training | Declared in schema |
| Tokenization     | Latent, opaque codes | Schema parameters |
| Auditability     | Low (black-box latents) | High (explicit slots) |
| Footprint        | Heavy encoders, GPU/TPU | Procedural, Jetson/FPGA-class |
| Flexibility      | Retraining required | Rule-bundle reconfiguration |

---

## Differentiators  

- **Grounded from the start**: no retrofit of meaning.  
- **Deterministic**: parameters map 1:1 to perceptual effects.  
- **Lightweight**: no heavy encoders, real-time feasible.  
- **Hybrid potential**: learned tokenizers can compress raw streams into schema parameters if desired.  

---

## Next Steps  

- **Labs Mining**: identify emergent schema archetypes (shader families, modulation envelopes).  
- **Bridge Experiments**: prototype flow from AToken/V-JEPA into Synesthetic schema slots.  
- **Positioning**: frame Synesthetic as *“tokenized manifolds without black-box encoders.”*  

---
