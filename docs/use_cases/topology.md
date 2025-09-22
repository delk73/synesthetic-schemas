## **Overview**

This use case draws from the *cell-sdf-topology* repo to demonstrate structured, recursive, topology-aware operators (e.g., fusion, division, ripple, bleb).

---

## **Problem**

Schemas today:

* Treat shaders as opaque GLSL strings.
* Cannot represent recursive operator chains.
* Lack fields for residuals, invariants, or topological metadata.

---

## **Schema Touchpoints**

* **Shader schema** → `operators`, `ops_chain`.
* **SynestheticAsset** → `emergence_meta` for instability params and residuals.
* **RuleBundle** → operator-driven triggers (`if fusion → inject ripple`).
* **Provenance** → `{lib_id, version, seed}` for reproducibility.

---

## **Flow**

1. Base cell operator: circle.
2. Apply division → split into two operators.
3. Apply fusion → rejoin, altering topology.
4. Residual error + topology metadata logged in `emergence_meta`.
5. Ripple effect mapped cross-modally (tone/haptic).

---

## **Deterministic Guarantees**

* Same operator chain always yields same topology evolution.
* Metadata ensures emergent instabilities reproducible.
* MCP validation enforces ranges for instability params.

---

## **Next Steps**

1. Prototype `operators`/`ops_chain` in shader schema.
2. Add residual + invariants fields to `emergence_meta`.
3. Build operator examples (`examples/topology/cell_division.json`).
