---
version: v0.0.0
lastReviewed:
owner: delk73
---


## **Overview**

This use case demonstrates how Synesthetic schemas can represent **bidirectional controls**: knobs, sliders, grids, or other inputs that both **send state into assets** and **reflect state back from assets** (via automation, external modulation, or schema-driven updates).

---

## **Problem**

Current schemas describe control mappings but do not fully enforce:

* **Bidirectionality:** updates from external systems flowing back into UI states.
* **Deterministic mappings:** reproducible translation of control gestures into uniform/parameter changes.
* **Accessibility:** controls lack haptic/audio feedback hooks.

---

## **Schema Touchpoints**

* **Control schema** → `mappings`, `curve`, `sensitivity`.
* **Haptic schema** → torque/detent feedback when crossing thresholds.
* **Shader/Tone** → controls map directly to parameters (`circle.radius`, `tone.detune`).
* **RuleBundle** → triggers actions when thresholds crossed.

---

## **Flow**

1. Control asset defines mapping: knob → shader uniform (`u_radius`).
2. User rotates knob → value update dispatched to backend.
3. Shader radius updates visually, tone detunes aurally.
4. External automation updates shader radius → knob moves physically (haptic detent / torque feedback).

---

## **Deterministic Guarantees**

* Same control bundle always maps gestures to the same parameter path.
* Bidirectional sync ensures replayable logs.
* Provenance ensures mappings are reproducible across contexts.

---

## **Next Steps**

1. Extend `control.schema.json` to clarify bidirectional expectations.
2. Add haptic wave\_ops for torque feedback.
3. Provide example JSON assets (`examples/controls/knob_circle.json`).

