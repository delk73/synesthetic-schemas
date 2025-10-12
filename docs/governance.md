# Synesthetic Schema: Governance and Publication Specification

| | |
|---|---|
| **Spec Version** | `1.0.0` |
| **Status** | `PROPOSED` |
| **Owner** | `delk73` |
| **Last Updated** | `2025-10-12` |
| **Applies To** | `synesthetic-schemas` repository |

### 1. Overview

This document defines the rules for versioning, identifying, and publishing canonical schemas for the Synesthetic ecosystem. Its primary goal is to ensure that every schema is uniquely identified by a **globally resolvable URL**, making the schema corpus portable, auditable, and easy to consume by any standard tooling.

This specification formalizes the move from using non-resolvable URIs for schema `$id`s to using live, public URLs hosted via GitHub Pages.

### 2. Core Principles

*   **Single Source of Truth (SSOT):** The `jsonschema/` directory on the `main` branch is the canonical source for schema development. The `version.json` file is the definitive source for the current schema version.
*   **Version Immutability:** Once a schema version is published (e.g., `0.7.3`), its artifacts are frozen. Any changes require a new version number. Published schemas at a specific version URL MUST NOT change.
*   **Resolvable Identifiers:** Every schema's `$id` MUST be a functional, public URL that resolves to the raw JSON schema file. This enables true portability and decouples consumers from the repository's internal structure.
*   **Automated Publication:** The process of versioning, normalizing, and publishing schemas MUST be an automated CI/CD process triggered by a git tag, ensuring consistency and eliminating manual error.

### 3. Specification

#### 3.1. Versioning

1.  The canonical schema version for the repository is defined exclusively in the `version.json` file in the repository root.
2.  The version number MUST follow Semantic Versioning 2.0.0 (`MAJOR.MINOR.PATCH`).
3.  Incrementing the version is done via the `make bump-version VERSION=X.Y.Z` command, which updates `version.json` and triggers the normalization process.

#### 3.2. Schema Identifier (`$id`)

1.  The `$id` field within each canonical JSON Schema is mandatory.
2.  The `$id` field MUST follow the canonical format:
    `https://schemas.synesthetic.dev/{version}/{schema_filename}`
3.  **Example:** For version `0.7.3`, the `synesthetic-asset.schema.json` file MUST have the following `$id`:
    `https://schemas.synesthetic.dev/0.7.3/synesthetic-asset.schema.json`
4.  This URL MUST resolve via HTTPS to the raw, normalized JSON schema file.

#### 3.3. Normalization Process (`./build.sh`)

1.  A "normalization" process is required before publication. This process is orchestrated by `./build.sh` or an equivalent script.
2.  The script reads the source schemas from `jsonschema/` and the version from `version.json`.
3.  It programmatically sets or overwrites the `$id` of each schema to conform to the format specified in **Section 3.2**.
4.  It may perform other tasks like bundling or resolving local `$ref`s to be absolute, versioned URLs.
5.  The output of this process is a set of "publication-ready" schema artifacts.

#### 3.4. Publication and Hosting

1.  Schemas WILL be hosted publicly using **GitHub Pages**.
2.  The publication source WILL be a dedicated branch named `gh-pages`. This branch will contain only the static schema files organized by version.
3.  The directory structure on the `gh-pages` branch MUST be:
    ```
    /
    ├── 0.7.3/
    │   ├── synesthetic-asset.schema.json
    │   └── shader.schema.json
    │   └── ...
    ├── 0.7.4/
    │   ├── synesthetic-asset.schema.json
    │   └── ...
    └── index.html (optional landing page)
    ```
4.  A custom domain (`schemas.synesthetic.dev`) WILL be configured to point to the GitHub Pages site (`delk73.github.io/synesthetic-schemas`).

#### 3.5. CI/CD Publication Workflow

1.  The publication workflow SHALL be implemented as a GitHub Action.
2.  The workflow is triggered automatically **only upon the creation of a git tag** that follows a version pattern (e.g., `v*.*.*`). Pushing to `main` will run checks but will not publish.
3.  The CI job will:
    a. Check out the repository at the specified tag.
    b. Run the normalization and build process (`./build.sh`).
    c. Create a new directory named after the version tag (e.g., `0.7.3`).
    d. Copy the normalized schema artifacts into this new directory.
    e. Check out the `gh-pages` branch.
    f. Copy the versioned directory into the root of the `gh-pages` branch.
    g. Commit and push the changes to the `gh-pages` branch, triggering the deployment.

#### 3.6. Baseline Schema Corpus (Established at v0.7.3)

This list represents the initial set of schemas that this governance process was applied to. The rules in this document apply to all schemas in the `jsonschema/` directory for all subsequent versions.

*   `synesthetic-asset.schema.json`
*   `shader.schema.json`
*   `tone.schema.json`
*   `haptic.schema.json`
*   `control.schema.json`
*   `modulation.schema.json`
*   `rule-bundle.schema.json`