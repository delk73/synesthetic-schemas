---
version: v0.7.3
lastReviewed: 2025-10-12
owner: delk73
---

# Synesthetic Schema: Governance and Publication Specification

|                  |                                  |
| ---------------- | -------------------------------- |
| **Spec Version** | `0.7.3`                          |
| **Status**       | `STABLE`                         |
| **Owner**        | `delk73`                         |
| **Last Updated** | `2025-10-12`                     |
| **Applies To**   | `synesthetic-schemas` repository |

---

### 1 · Overview
Defines the authoritative process for **versioning**, **identifying**, and **publishing** canonical schemas for the Synesthetic ecosystem.  
Each schema must be:

* Globally addressable via a **permanent, resolvable `$id` URL**  
* Publicly accessible via **GitHub Pages**  
* Immutable once published  
* Automatically built and deployed on tagged releases  

All canonical schemas are hosted under:

```

[https://delk73.github.io/synesthetic-schemas/schema/0.7.3/{filename}](https://delk73.github.io/synesthetic-schemas/schema/0.7.3/{filename})

```

---

### 2 · Core Principles
* **Single Source of Truth (SSOT):** `jsonschema/` on `main` is the canonical editable source; `version.json` defines the live schema version.  
* **Version Immutability:** Once published (e.g., `0.7.3`), artifacts are frozen. All edits require a new version.  
* **Resolvable Identifiers:** Each `$id` must exactly match its public URL so external validators can dereference it.  
* **Automated Publication:** CI/CD builds and publishes automatically when a version tag is created.

---

### 3 · Specification

#### 3.1 Versioning
1. Canonical version stored in `version.json`.  
2. Follows **Semantic Versioning 2.0.0** (`MAJOR.MINOR.PATCH`).  
3. Increment via make bump-version VERSION=X.Y.Z

which updates `version.json` and prepares normalized outputs.

#### 3.2 Schema Identifier (`$id`)

1. `$id` is mandatory.
2. Canonical format:

   ```
   https://delk73.github.io/synesthetic-schemas/schema/0.7.3/{schema_filename}
   ```
3. Example:

   ```
   https://delk73.github.io/synesthetic-schemas/schema/0.7.3/synesthetic-asset.schema.json
   ```
4. `$id` must exactly equal the final public URL (case-sensitive).
   Validators rely on this for `$ref` resolution.

#### 3.3 Normalization Process (`./build.sh`)

1. Reads schemas from `jsonschema/` and version from `version.json`.
2. Rewrites `$id` fields to the canonical pattern.
3. Converts relative `$ref`s to absolute, versioned URLs.
4. Writes normalized artifacts to `docs/schema/0.7.3/`.
5. Artifacts in `docs/` are immutable post-build.

#### 3.4 Publication and Hosting

1. **Hosting:** GitHub Pages serves from
   `https://delk73.github.io/synesthetic-schemas/schema/0.7.3/`
2. **Directory Layout:**

   ```
   docs/
     schema/
       0.7.3/
         synesthetic-asset.schema.json
         shader.schema.json
         tone.schema.json
         ...
   ```
3. All URLs must return HTTP 200 with `Content-Type: application/json`.

#### 3.5 CI/CD Publication Workflow

1. Implemented via **GitHub Actions**.
2. Trigger: creation of a tag matching `v*.*.*`.
3. Steps:
   a. Checkout that tag.
   b. Run `./build.sh` (or `make publish-schemas`).
   c. Generate `docs/schema/0.7.3/`.
   d. Commit and push to `main`.
   e. GitHub Pages auto-deploys to `https://delk73.github.io/synesthetic-schemas/`.

#### 3.6 Baseline Corpus (v0.7.3)

Applies to:

* `synesthetic-asset.schema.json`
* `shader.schema.json`
* `tone.schema.json`
* `haptic.schema.json`
* `control.schema.json`
* `modulation.schema.json`
* `rule-bundle.schema.json`
* `rule.schema.json`
* `control-bundle.schema.json`

---

### 4 · Validation and Testing

Check all `$id`s before tagging:

```bash
make check-schema-ids
```

or manually:

```bash
BASE=https://delk73.github.io/synesthetic-schemas/schema/0.7.3
for f in docs/schema/0.7.3/*.schema.json; do
  id=$(jq -r '."$id"' "$f")
  test "$id" = "$BASE/$(basename "$f")" || { echo "X mismatch in $f"; exit 1; }
done
echo "✓ IDs verified"
```

---

### 5 · Consumer Integration Examples

**MCP Environment**

```bash
export MCP_SCHEMA_BASE_URL=https://delk73.github.io/synesthetic-schemas/schema
export MCP_SCHEMA_VERSION=0.7.3
```

**Validation**

```bash
python -m mcp validate \
  --schema https://delk73.github.io/synesthetic-schemas/schema/0.7.3/synesthetic-asset.schema.json \
  --example tests/examples/asset_valid_0.7.3.json
```

---

## Crosswalk Compliance Docs

The following documents cite external sources with version metadata and link back to this governance specification:

- [Cross-Walk: Synesthetic & Embodied AI Interfaces](../concepts/crosswalk_perception_interfaces.md)
- [Applied Crosswalk: Physical Atari](../concepts/applied_crosswalk_phy_atari.md)