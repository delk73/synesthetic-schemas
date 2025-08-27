# Synesthetic Schemas

**Single Source of Truth (SSOT)** for Synesthetic asset and component schemas.

## Purpose
This repo holds canonical JSON Schemas describing Synesthetic assets:
- `synesthetic-asset`
- `shader`
- `tone`
- `haptic`
- `control`
- `modulation`

Schemas are dumped from the backend Pydantic models, then normalized here for
long-term stability. These files are the authoritative source for both:

- **Backend (FastAPI / Pydantic)** model generation
- **Frontend (TypeScript / Zod)** type generation
- **RLHF pipelines** for validation and training

## Layout





## Codegen
pipx install datamodel-code-generator  # or: pip install datamodel-code-generator
bash codegen/gen_py.sh

bash codegen/gen_ts.sh
