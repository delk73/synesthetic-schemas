---
title: Field Hierarchy and Operator Families
version: 1.0-draft
lastReviewed: 2025-10-09
owner: synesthetic-core
status: conceptual
tags: [schema, field, operator, semantics, architecture]
---

# Field Hierarchy and Operator Families

## Summary
This note defines the **conceptual stack of field types** and their **operator families** within Synesthetic OS.  
It formalizes how value, change, and expectation interact across modalities and establishes a shared semantic foundation for the 1.0 schema design phase.

---

## 1 · Overview
Every element in the system—geometry, sound, haptic pattern, or predictive cue—is represented as a **field**.  
Fields differ not by data format but by *semantic role*: what kind of information they carry and how they interact.

| Layer | Carries | Coupled By | Function |
|-------|----------|------------|-----------|
| **1. Value Field** | Raw scalar potential (distance, amplitude, luminance). | **Parameter Operator** | Direct modulation of other parameters. |
| **2. Gradient Field** | Direction + rate of change (∇f). | **Flux Operator** | Interaction between field flows. |
| **3. Predictive Field** | Anticipated future change. | **Anticipatory Operator** | Forward bias or phase lead in time. |
| **4. Cognitive Field** | Expectation and correction pattern. | **Syncopation / Expectation Operator** | Temporal misalignment and resolution. |

Together these layers describe **how information moves**:  
from potential → change → expectation → interpretation.

---

## 2 · Operators as Grammar
Operators are the *verbs* connecting fields.  
They specify whether two layers **reinforce, oppose, or interfere**—the grammar of transformation.

| Operator Family | Acts On | Purpose |
|-----------------|---------|----------|
| `parameter` | scalar values | One field modulates another’s parameters. |
| `flux` | gradient vectors | Fields interact through their directional change. |
| `anticipatory` | predictive phases | Define how forward-model signals couple to current state. |
| `syncopative` | expectation windows | Organize timing of prediction error and resolution. |

Operators are composable: a flux operator can feed an anticipatory one, etc.  
This composability is what allows multimodal coherence across vision, sound, and motion.

---

## 3 · Shader vs. Schema Interpretation
In shader space, all fields are scalar functions over position (`float f(vec3 p);`).  
Gradients are *derived*.  
In schema space, these are **semantic tags**, not data types.  
They tell the system *how* to interpret a field:

| Semantic Type | Meaning | Typical Use |
|----------------|----------|--------------|
| `potential` | static distance or intensity field | Base SDF, amplitude map |
| `gradient` | directional change of a potential | Flux coupling, flow mapping |
| `predictive` | phase-advanced or delayed potential | Anticipatory control |
| `cognitive` | structured pattern of prediction error | Perceptual rhythm, syncopation |

The GPU still evaluates scalars; the schema defines *what those scalars represent*.

---

## 4 · Integration Path to v1.0
1. **Declare field signatures** – specify each field’s semantic type and operator family.  
2. **Define operator contracts** – input/output expectations, invariants, and composability rules.  
3. **Refactor schema modules** – organize under `/schemas/1.0/components/fields/` and `/operators/`.  
4. **Cross-modal alignment** – ensure that a visual SDF, an oscillator, and a haptic actuator can share the same field/ operator semantics.  

---

## 5 · Conceptual Note
Synesthetic OS treats representation as a living system.  
Value fields describe what *is*, gradient fields describe how it *changes*, predictive fields describe what it *will be*, and cognitive fields describe *how that expectation feels when it fails or resolves*.  
Operators are the couplings that keep those layers in motion.

This hierarchy closes the loop between computation and perception—  
**a process of emergence built within the process of emergence.**

---

*End of Document*
