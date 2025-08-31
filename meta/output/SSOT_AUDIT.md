---
version: v0.1
lastReviewed: 2025-08-30
owner: backend@generative
---

**Objective**
- Produce a single deterministic Markdown audit of SSOT practices across schemas, examples, codegen, and CI.

**Constraints**
- KISS, deterministic, minimal deps; Python 3.11; JSON Schema draft 2020-12.
- Read-only scan; no DB migrations; no stdout side-effects.
- Output only to `meta/output/SSOT_AUDIT.md`.

**Phases**
- A1 — Foundations
- A2 — Validation & Normalization
- A3 — Deterministic Codegen & CI
- A4 — Naming & Docs Hygiene

**Work Items**
- C1: Single-source schema version
- C2: Typed Python dist marker
- C3: Schema lint: $id uniqueness and draft
- C4: Examples reference schemas explicitly
- C5: Deterministic codegen + CI parity
- C6: Naming & docs guardrails

**Done Definition**
- Exactly one new/updated file: `meta/SSOT_AUDIT.md`.
- Report contains frontmatter and sections in the required order.
- All checks C1–C6 include PASS/WARN/FAIL with concise evidence.
- No other files created or modified; no stdout side-effects.

**Findings**

### C1 — Single-source schema version
- Status: PASS
- Details:
  - version.json:2 → "schemaVersion": "0.7.0"
  - Occurrences of 'schemaVersion' outside `version.json` within scope: 0
  - scripts/lib/version.py:12 → `p = ROOT / "version.json"`
  - codegen/lib/version.mjs:8 → `path.join(__dirname, "..", "..", "version.json")`

### C2 — Typed Python dist marker
- Status: PASS
- Details:
  - python/src/synesthetic_schemas/py.typed:1 → present (empty file allowed)

### C3 — Schema lint: $id uniqueness and draft
- Status: PASS
- Details ($id present, 9/9):
  - jsonschema/control-bundle.schema.json:2 → "$id": "https://schemas.synesthetic.dev/0.7.0/control-bundle.schema.json"
  - jsonschema/control.schema.json:127 → "$id": "https://schemas.synesthetic.dev/0.7.0/control.schema.json"
  - jsonschema/haptic.schema.json:158 → "$id": "https://schemas.synesthetic.dev/0.7.0/haptic.schema.json"
  - jsonschema/modulation.schema.json:114 → "$id": "https://schemas.synesthetic.dev/0.7.0/modulation.schema.json"
  - jsonschema/rule-bundle.schema.json:98 → "$id": "https://schemas.synesthetic.dev/0.7.0/rule-bundle.schema.json"
  - jsonschema/rule.schema.json:2 → "$id": "https://schemas.synesthetic.dev/0.7.0/rule.schema.json"
  - jsonschema/shader.schema.json:98 → "$id": "https://schemas.synesthetic.dev/0.7.0/shader.schema.json"
  - jsonschema/synesthetic-asset.schema.json:2 → "$id": "https://schemas.synesthetic.dev/0.7.0/synesthetic-asset.schema.json"
  - jsonschema/tone.schema.json:330 → "$id": "https://schemas.synesthetic.dev/0.7.0/tone.schema.json"
- Details ($schema draft 2020-12, 9/9):
  - jsonschema/control-bundle.schema.json:3 → "$schema": "https://json-schema.org/draft/2020-12/schema"
  - jsonschema/control.schema.json:128 → "$schema": "https://json-schema.org/draft/2020-12/schema"
  - jsonschema/haptic.schema.json:159 → "$schema": "https://json-schema.org/draft/2020-12/schema"
  - jsonschema/modulation.schema.json:115 → "$schema": "https://json-schema.org/draft/2020-12/schema"
  - jsonschema/rule-bundle.schema.json:99 → "$schema": "https://json-schema.org/draft/2020-12/schema"
  - jsonschema/rule.schema.json:3 → "$schema": "https://json-schema.org/draft/2020-12/schema"
  - jsonschema/shader.schema.json:99 → "$schema": "https://json-schema.org/draft/2020-12/schema"
  - jsonschema/synesthetic-asset.schema.json:3 → "$schema": "https://json-schema.org/draft/2020-12/schema"
  - jsonschema/tone.schema.json:331 → "$schema": "https://json-schema.org/draft/2020-12/schema"
- Duplicate $id values: 0 detected

### C4 — Examples reference schemas explicitly
- Status: PASS
- Details ($schemaRef present, 14/14):
  - examples/Control-Bundle_Example.json:2 → "$schemaRef": "jsonschema/control-bundle.schema.json"
  - examples/Haptic_Example.json:2 → "$schemaRef": "jsonschema/haptic.schema.json"
  - examples/Rule-Bundle_Example.json:2 → "$schemaRef": "jsonschema/rule-bundle.schema.json"
  - examples/Shader_Example.json:2 → "$schemaRef": "jsonschema/shader.schema.json"
  - examples/SynestheticAsset_Example1.json:2 → "$schemaRef": "jsonschema/synesthetic-asset.schema.json"
  - examples/SynestheticAsset_Example2.json:2 → "$schemaRef": "jsonschema/synesthetic-asset.schema.json"
  - examples/SynestheticAsset_Example3.json:2 → "$schemaRef": "jsonschema/synesthetic-asset.schema.json"
  - examples/SynestheticAsset_Example4.json:2 → "$schemaRef": "jsonschema/synesthetic-asset.schema.json"
  - examples/SynestheticAsset_Example5.json:2 → "$schemaRef": "jsonschema/synesthetic-asset.schema.json"
  - examples/SynestheticAsset_Example6.json:2 → "$schemaRef": "jsonschema/synesthetic-asset.schema.json"
  - examples/SynestheticAsset_Example7.json:2 → "$schemaRef": "jsonschema/synesthetic-asset.schema.json"
  - examples/SynestheticAsset_Example8.json:2 → "$schemaRef": "jsonschema/synesthetic-asset.schema.json"
  - examples/SynestheticAsset_Example9.json:2 → "$schemaRef": "jsonschema/synesthetic-asset.schema.json"
  - examples/Tone_Example.json:2 → "$schemaRef": "jsonschema/tone.schema.json"

### C5 — Deterministic codegen + CI parity
- Status: FAIL
- Details:
  - codegen/gen_ts.sh:7 → bundles locally via `node "$ROOT/codegen/ts_bundle.mjs"` (repo-local; no npx)
  - codegen/gen_ts.sh:18 → uses repo-local CLI `"$ROOT/node_modules/.bin/json2ts"`
  - scripts/ensure_codegen_clean.sh:11 → `git diff -I ...` (missing `--exit-code`; drift guard ineffective)
  - Makefile:50 → target `preflight: normalize-check schema-lint codegen-check validate`
  - preflight.sh:11 → `make codegen-check` (mirrors Makefile pipeline)
  - .github/workflows/ci.yml:37 → `bash ./preflight.sh` (CI parity confirmed)

### C6 — Naming & docs guardrails
- Status: WARN
- Details:
  - Dual-class tokens present:
    - jsonschema/rule-bundle.schema.json:224 → "title": "RuleBundleSchema"
    - scripts/validate_examples.py:49 → "ControlBundle|ControlBundleSchema"
    - scripts/validate_examples.py:57 → "RuleBundle|RuleBundleSchema"
    - scripts/validate_examples.py:64 → "ControlBundle|ControlBundleSchema"
    - scripts/validate_examples.py:65 → "Control|ControlParameter"
    - scripts/validate_examples.py:70 → "RuleBundle|RuleBundleSchema"
  - Repeated defs tokens: confined to `shader.schema.json` `$defs` (no cross-schema duplication)
  - Docs mention version bump and preflight:
    - CONTRIBUTING.md:34 → `make bump-version VERSION=X.Y.Z`
    - README.md:104 → `./preflight.sh`
    - README.md:65 → CI runs `./preflight.sh`

---
PASS summary: C1, C2, C3, C4
WARN summary: C6 (naming hedges present; consider standardizing names or documenting rationale)
FAIL summary: C5 (drift guard missing `git diff --exit-code`)

