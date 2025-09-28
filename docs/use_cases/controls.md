---
version: 0.7.3
lastReviewed: 2025-09-28
owner: D. Elkins
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

## **Live Example**

The `examples/Control-Bundle_Example.json` asset demonstrates a simple bidirectional control mapping. It binds mouse X/Y position to `visual.px` and `visual.py` parameters, allowing a user to directly manipulate a visual shader while providing a clear schema for how the UI should reflect state changes.

## **Schema Evolution Tie-in**

This use case directly informs the evolution of the following schemas:

*   **`control.schema.json`**: The need for deterministic, bidirectional mappings drove the inclusion of the `mappings` array and the `curve` and `sensitivity` properties. This ensures that a control's behavior is explicitly defined and reproducible.
*   **`haptic.schema.json`**: The requirement for physical feedback (detents, torque) in response to state changes necessitates the development of haptic wave operations (`wave_ops`) that can be triggered by the `RuleBundle` schema.
*   **`rule-bundle.schema.json`**: To connect control inputs to haptic outputs and other actions, the rule bundle schema needs to support conditional logic based on control value thresholds, enabling complex, stateful interactions.

