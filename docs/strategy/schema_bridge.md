---
version: v0.7.3
lastReviewed: 2025-10-12
owner: delk73
---

# Schema Strategy: Bridge → Library

---

## Purpose

Clarify how the current modality-specific schemas (`shader`, `tone`, `haptic`, `modulation`, `control`) function as a **bridge layer**, and set direction for migrating toward a consolidated **operator/primit[text](.)ive library** that will serve as the long-term single source of truth (SSOT).

This strategy ensures the schemas remain practical for day-to-day testing and Labs work while gradually converging on a cleaner, more efficient foundation.

---

## Current State (Bridge Layer)

- **Schemas defined per modality:**
  - `shader.json`, `tone.json`, `haptic.json`, `modulation.json`, `control.json`.
- **Operators scattered and duplicated:**
  - `operators[]` in shader.
  - `wave_ops[]` in tone.
  - Similar constructs in haptic and modulation.
- **Advantages of this shape:**
  - **Human-holdable:** Each schema is explicit, easy to read and debug.
  - **Supports experimentation:** Labs workflows, RLHF loops, and patch lifecycle testing rely on this clarity.
  - **Safe to evolve quickly:** Because each modality is isolated, changes don’t risk breaking a central operator registry.
- **Limitations:**
  - Duplication across schemas makes maintenance harder.
  - Cross-modal alignment must be enforced manually.
  - The structure does not reflect the deeper unification already visible in topology research.

---

## Target State (Operator/Primitive Library)

- **Primitives = atoms**
  - Examples: `circle`, `sine`, `pulse`, `noise`.
  - Defined once with canonical parameters and required `alt_mappings`.
- **Operators = transforms**
  - Examples: `scale`, `modulate`, `blend`, `delay`.
  - Apply consistently across modalities (visual, audio, haptic).
- **Cross-modal guarantees baked in**
  - Every primitive and operator includes `alt_mappings` so assets can be rendered in alternate modalities by design.
- **Schema collapse**
  - Assets reduce to compact DAGs of `primitive + operator` references.
  - “Modulation” and “Control” become operator classes, not separate schema roots.
- **Library as SSOT**
  - The `ops/` directory becomes the canonical registry for all primitives and operators.
  - Schemas act only as authoring and interchange layers, referencing library IDs.

---

## Migration Path

| Version | Focus | Schema Shape | Notes |
|---------|-------|--------------|-------|
| **v0.4 (current)** | Bridge | Explicit modality schemas (`shader`, `tone`, `haptic`, etc.) with inline operators | Testing and Labs scaffolding. Duplication tolerated. |
| **v0.5** | Hybrid | Introduce `ops/` library (seed primitives and operators). Support dual-mode: reference (`*_lib_id`) **or** inline operator snapshot with provenance. | Validate library lookups via MCP; start cross-modal operator reus*
