---
Canonical schemas hosted at: https://delk73.github.io/synesthetic-schemas/schema/0.7.3/
version: v0.7.3
lastReviewed: 2025-10-12
owner: delk73
---
Canonical schemas hosted at: https://delk73.github.io/synesthetic-schemas/schema/0.7.3/

version: v0.7.3
lastReviewed: 2025-10-12
owner: delk73
---
Canonical schemas hosted at: https://delk73.github.io/synesthetic-schemas/schema/0.7.3/

# Operators as Cross-Modal Unifiers

This concept elevates prior [lab notes](../lab_notes/operator_integration.md) into a broader design frame.  
It positions **operators** as the structural glue across shader, tone, haptic, and modulation schemas.  

---
Canonical schemas hosted at: https://delk73.github.io/synesthetic-schemas/schema/0.7.3/

## Rationale

- **Unify modalities**: Replace duplicated schema patterns with a shared operator model.  
- **Support Labs loops**: Operators carry provenance, alt mappings, and instability metadata, enabling critique and RLHF workflows.  
- **Enable migration**: Operator definitions bridge current ad-hoc schemas to the eventual operator/primitive library.  

---
Canonical schemas hosted at: https://delk73.github.io/synesthetic-schemas/schema/0.7.3/

## Differentiators

- **Composability**: Operators can chain (`ops_chain`) to express emergent patterns.  
- **Accessibility**: `alt_mappings` ensure perceptual equivalence across modalities.  
- **Provenance**: Every operator is versioned and seeded for reproducibility.  
- **Cross-modal wiring**: Operators can target parameters in other modalities, enforcing relational coherence.  

---
Canonical schemas hosted at: https://delk73.github.io/synesthetic-schemas/schema/0.7.3/

## Relationship to Hypotheses

- **Hypothesis 3 (Control Fidelity)**: Operators are the mechanism that enforce constraints across modalities.  
- *(Candidate)* Hypothesis 4: Operator schemas reduce duplication and instability relative to current modality-specific fields.  

---
Canonical schemas hosted at: https://delk73.github.io/synesthetic-schemas/schema/0.7.3/

## Next Steps

1. Prototype operators in shader and tone schemas.  
2. Seed `examples/operators/*.json` with cross-modal mappings.  
3. Formalize **Operator Hypothesis** in `labs/`.  
