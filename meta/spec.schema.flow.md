---
version: 0.7.3
lastReviewed: 2025-10-13
owner: delk73
status: internal-spec
---

# Synesthetic Schemas — Internal Specification

## 1. Purpose
Defines the canonical operational model for the Synesthetic Schema repository.  
This specification governs directory roles, schema transformation invariants, validation contracts, and publication rules.  
It is binding for all build, audit, and CI automation.

---

## 2. Directory Roles and Invariants

| Directory | Role | Mutability | Host Pattern | Enforcement |
|------------|------|-------------|---------------|--------------|
| `jsonschema/` | Authoritative editable sources | Mutable | `https://schemas.synesthetic.dev/<version>/` | Must never contain canonical host or transient metadata. |
| `docs/schema/<version>/` | Published canonical outputs | Immutable | `https://delk73.github.io/synesthetic-schemas/schema/<version>/` | Must differ from source only by host substitution. |
| `python/src/`, `typescript/src/` | Generated SDK bindings | Disposable | — | Deterministic regeneration via `build.sh`. |
| `examples/` | Validation corpus | Mutable | — | Must validate against the active schema version. |

**Invariant 2.1:** No process other than `make publish-schemas` may modify `$id` or `$ref` values.  
**Invariant 2.2:** Any key outside the schema standard (e.g. `"d"`) is invalid and removed during publication.

---

## 3. Schema Transformation Flow

| Phase | Input | Output | Constraints |
|-------|--------|---------|-------------|
| **Authoring** | `jsonschema/*.schema.json` | Same directory | Placeholder host retained. No canonical refs or metadata. |
| **Normalization** | `jsonschema/` | In-place validation only | Validates structure and step constraints; does not rewrite content. |
| **Publication** | `jsonschema/` | `docs/schema/<version>/` | Rewrites `$id` and `$ref` from placeholder host to canonical host. |
| **Validation** | `docs/schema/<version>/` | Reports / exit codes | Confirms absolute canonical URLs and host-only diffs. |
| **Codegen** | `docs/schema/<version>/` | `python/src/`, `typescript/src/` | Must be deterministic and idempotent. |

---

## 4. Host Substitution Rules

| Field | Source Host | Published Host | Rule |
|--------|--------------|----------------|------|
| `$id` | `https://schemas.synesthetic.dev/<version>/` | `https://delk73.github.io/synesthetic-schemas/schema/<version>/` | Always absolute canonical. |
| `$ref` | May be relative or placeholder-host absolute | Always rewritten to absolute canonical form | No relative paths permitted post-publication. |

**Invariant 4.1:**  
Relative `$ref` values (e.g. `"modulation.schema.json"`) are invalid in published artifacts.

---

## 5. Build Entrypoints

| Target | Function | Expected Behavior |
|---------|-----------|-------------------|
| `make normalize` | Run normalization script | Sanitize sources; no rewrite of host fields. |
| `make preflight` | Validate schemas, examples, and codegen | Must complete without drift or untracked files. |
| `make preflight-fix` | Normalize then validate | Idempotent; cleans transient diffs. |
| `make publish-schemas` | Copy and rewrite for release | Rewrites `$id` and `$ref` to canonical host. |
| `make codegen-check` | Confirm SDK determinism | Fails on non-reproducible outputs. |
| `make check-schema-ids` | Verify canonical host usage | Reports any schema missing proper host prefix. |

All Makefile targets are executed under `poetry run` or `nix develop` context.

---

## 6. Validation Contracts

| Validator | Scope | Enforcement |
|------------|--------|-------------|
| `scripts/validate_schemas.py` | `$id` and `$ref` canonicalization | Fails if any non-canonical or relative reference remains. |
| `scripts/validate_examples.py` | Example conformance | Must pass strict validation across all examples. |
| `scripts/ensure_codegen_clean.sh` | SDK reproducibility | Fails if regenerated bindings differ. |
| `preflight.sh` | Aggregate validation | Invokes normalization, schema linting, codegen check, and example validation. |

**Failure Conditions:**
- Relative `$ref` detected post-publication.
- Drift between `jsonschema/` and `docs/schema/`.
- Non-deterministic SDK generation.
- Missing or malformed `$id` host.

---

## 7. Publication Policy

1. `version.json` defines the active version (field: `schemaVersion`).
2. `make publish-schemas` generates immutable release artifacts under `docs/schema/<version>/`.
3. Only host substitutions (`$id`, `$ref`) may differ from source files.
4. Published files are immutable post-release. Corrections require a new version.
5. The canonical public URL structure is:

```

[https://delk73.github.io/synesthetic-schemas/schema/](https://delk73.github.io/synesthetic-schemas/schema/)<version>/{schema-name}.schema.json

```

---

## 8. Audit & Governance Integration

*   Schema audits are executed from `meta/prompts/` and must write to `meta/output/`.
*   **The `meta/output/` directory is considered a persistent, non-ephemeral record of repository compliance and MUST be tracked in version control.**
*   Audits verify:
    -   Host substitution integrity.
    -   Drift limits between source and docs.
    -   Presence and correctness of Makefile targets.
    -   Determinism of `build.sh` and `preflight.sh`.
*   **The `jsonschema/` directory is the authoritative source for manual edits; `docs/schema/` contains immutable, published artifacts generated from this source.**

---

## 9. Compliance Criteria

A repository state is considered **compliant** when:

1. All `$id` and `$ref` values in `docs/schema/<version>/` resolve to the canonical GitHub Pages host.
2. `jsonschema/` retains placeholder host only.
3. No transient keys or relative paths exist.
4. `make preflight` completes with no changes detected.
5. All validation scripts exit with status 0.

---

## 10. Enforcement Scope

This specification is authoritative for:
- All schema evolution and release processes.
- CI/CD pipeline validation gates.
- Governance audits and compliance reports.

Deviations require explicit version bump and revision of this document.

---

### End of Specification