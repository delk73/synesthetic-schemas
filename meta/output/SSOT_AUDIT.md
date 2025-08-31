---
version: v0.1
lastReviewed: 2025-08-31
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
  - References outside `version.json` read the canonical file (no duplicated constants):
    - scripts/lib/version.py:14 → loads version.json
    - codegen/lib/version.mjs:12 → reads version.json
    - scripts/bump_version.py:19,23 → reads/writes version.json

### C2 — Typed Python dist marker
- Status: PASS
- Details:
  - python/src/synesthetic_schemas/py.typed → present (empty file)
  - codegen/gen_py.sh ensures `py.typed` is recreated after codegen

### C3 — Schema lint: $id uniqueness and draft
- Status: PASS
- Details ($id present, all schemas):
  - jsonschema/control-bundle.schema.json → $id present
  - jsonschema/control.schema.json → $id present
  - jsonschema/haptic.schema.json → $id present
  - jsonschema/modulation.schema.json → $id present
  - jsonschema/rule-bundle.schema.json → $id present
  - jsonschema/rule.schema.json → $id present
  - jsonschema/shader.schema.json → $id present
  - jsonschema/synesthetic-asset.schema.json → $id present
  - jsonschema/tone.schema.json → $id present
- Details ($schema draft 2020-12, all schemas): confirmed `https://json-schema.org/draft/2020-12/schema`
- Duplicate $id values: none detected

### C4 — Examples reference schemas explicitly
- Status: PASS
- Details ($schemaRef present for examples/*.json):
  - examples/Control-Bundle_Example.json → jsonschema/control-bundle.schema.json
  - examples/Haptic_Example.json → jsonschema/haptic.schema.json
  - examples/Rule-Bundle_Example.json → jsonschema/rule-bundle.schema.json
  - examples/Shader_Example.json → jsonschema/shader.schema.json
  - examples/Tone_Example.json → jsonschema/tone.schema.json
  - examples/SynestheticAsset_Example1..9.json → jsonschema/synesthetic-asset.schema.json

### C5 — Deterministic codegen + CI parity
- Status: PASS
- Details:
  - codegen/gen_ts.sh → bundles with repo-local tooling; uses `$ROOT/node_modules/.bin/json2ts`
  - scripts/ensure_codegen_clean.sh:11 → `git diff --exit-code -I <timestamp regexes> -- python/src typescript/src` (fails on real diffs)
  - Makefile: defines `preflight` as `normalize-check schema-lint codegen-check validate`
  - preflight.sh: runs `make codegen-check` and `make validate` (parity with Makefile)
  - .github/workflows/ci.yml: runs `bash ./preflight.sh` (CI parity confirmed)

### C6 — Naming & docs guardrails
- Status: PASS
- Details:
  - Canonical names enforced in validator mappings: `RuleBundle`, `ControlBundle`, `Control`, `Rule`, `Modulation` (no dual-class hedges)
  - jsonschema/rule.schema.json → title "Rule" (was "RuleSchema")
  - jsonschema/rule-bundle.schema.json → title "RuleBundle"; `$defs` key renamed to `Rule` and `$ref` updated
  - scripts/validate_examples.py → no `RuleBundleSchema|ControlParameter|ControlBundleSchema` tokens
  - CONTRIBUTING.md documents naming conventions and preflight/version workflows

---
PASS summary: C1, C2, C3, C4, C5, C6
WARN summary: (none)
FAIL summary: (none)

