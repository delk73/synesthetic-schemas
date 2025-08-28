# Synesthetic Schemas

**Single Source of Truth (SSOT)** for Synesthetic asset and component schemas.

---

## Purpose

This repo holds **canonical JSON Schemas** describing Synesthetic assets and components:

- `synesthetic-asset`
- `shader`
- `tone`
- `haptic`
- `control`
- `modulation`
- `rule-bundle`

Schemas are exported from the backend Pydantic models, then normalized here for
long-term stability. These schemas are the **authoritative source** for:

- **Backend** (FastAPI / Pydantic) model generation
- **Frontend** (TypeScript / Zod) type generation
- **RLHF pipelines** for validation and training

---

## IDs vs Canonical Schema

- Canonical schemas **do not include database IDs** (`*_id`).  
  They describe **portable asset documents** only.  

- **API routes** may wrap canonical assets in an envelope that adds an `id`
  (database primary key or UUID). This `id` is part of the API response contract,
  not the canonical schema.

- **Clients**:
  - Use canonical schemas to validate and construct assets.  
  - Handle IDs only when interacting with API responses.  
  - Never require IDs inside the nested asset itself.

👉 **Schemas define the structure of assets; APIs can layer IDs on top.**

---

## Layout

```

jsonschema/         # Canonical JSON Schemas (normalized, versioned)
examples/           # Example assets used for validation and round-trip testing
python/             # Generated Python models (Pydantic v2)
typescript/         # Generated TypeScript/Zod types
scripts/            # Normalization, validation, codegen helpers
codegen/            # Codegen entrypoints for Python & TypeScript
test.sh             # End-to-end pipeline: normalize → codegen → validate examples

````

---

## Workflow

1. **Normalize schemas**  
   ```bash
   python scripts/normalize_schemas.py
````

2. **Regenerate models**

   ```bash
   bash codegen/gen_py.sh
   bash codegen/gen_ts.sh
   ```

3. **Validate examples**

   ```bash
   ./test.sh
   ```

---

## Codegen

Install once:

```bash
pipx install datamodel-code-generator
# or: python -m pip install datamodel-code-generator
```

Generate code:

```bash
bash codegen/gen_py.sh
bash codegen/gen_ts.sh
```

---

## Status

* ✅ Canonical schemas exported & normalized
* ✅ Examples validated against schemas and generated models
* 🔄 Ongoing cleanup of schema/example mismatches

---

## Open GitHub Issues

To open the prepared set of issues for improving this repo:

- Install and authenticate GitHub CLI: `gh auth login`
- Run the helper script:
  - `./scripts/create_issues.sh`
  - Use `DRY_RUN=1 ./scripts/create_issues.sh` to preview without creating.

Issue drafts live in `meta/issues/*.md`. Edit them before creating if desired.
