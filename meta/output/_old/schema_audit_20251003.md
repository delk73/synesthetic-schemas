# Schema Audit Report - 20251003

## 1. Summary of Audit State

This audit compares the baseline schema version `0.7.3` against the new specification for version `0.7.4` as defined in `docs/schema_evolution.md`. The goal is to identify discrepancies and provide actionable recommendations for patching the schemas.

-   **Baseline Version**: `0.7.3`
-   **Target Version**: `0.7.4`
-   **Audit Date**: 2025-10-03

## 2. Audit Coverage

| Schema                | Present | Missing | Divergent |
| --------------------- | ------- | ------- | --------- |
| `synesthetic-asset`   | 11      | 6       | 1         |
| `control-bundle`      | 4       | 0       | 0         |
| `control`             | 11      | 0       | 0         |
| `haptic`              | 5       | 0       | 0         |
| `modulation`          | 4       | 0       | 0         |
| `rule-bundle`         | 7       | 0       | 0         |
| `rule`                | 6       | 0       | 0         |
| `shader`              | 7       | 0       | 0         |
| `tone`                | 8       | 0       | 0         |
| **Total**             | **63**  | **6**   | **1**     |


## 3. Component Audits

### `synesthetic-asset`
- **Present**: `control`, `created_at`, `description`, `haptic`, `meta_info`, `modulation`, `modulations`, `rule_bundle`, `shader`, `tone`, `updated_at`
- **Missing**: `asset_id`, `prompt`, `timestamp`, `seed`, `parameter_index`, `provenance`
- **Divergent**: The `name` field is no longer required at the asset root.

### Other Schemas
The schemas `control-bundle`, `control`, `haptic`, `modulation`, `rule-bundle`, `rule`, `shader`, and `tone` have all their fields marked as **Present**. The `schema_evolution.md` document mentions some fields as "added" for `shader`, `tone`, and `haptic`, but these fields were already present in the baseline. This might indicate a change in their properties (e.g., becoming required) which is not explicitly stated in the changelog.

## 4. Detected Divergences

-   **`synesthetic-asset`**: The `name` field is no longer required. It is being replaced by `meta_info.title`.

## 5. Recommendations for Patch Planning

Based on this audit, the following actions are recommended to upgrade the schemas from `v0.7.3` to `v0.7.4`:

1.  **For `synesthetic-asset.schema.json`:**
    *   Add the following optional fields: `asset_id`, `prompt`, `timestamp`, `seed`, `parameter_index`, `provenance`.
    *   Remove `name` from the `required` array.
    *   Add a new `provenance.schema.json` to define the structure of the `provenance` field.

2.  **For `shader.schema.json`, `tone.schema.json`, `haptic.schema.json`:**
    *   Verify if the properties of `name`, `description`, and `input_parameters` need to be updated (e.g., changed from optional to required), as the evolution log is ambiguous.

3.  **For `tone.schema.json`:**
    *   Verify if the properties of the `effects` array need to be updated.

4.  **General:**
    *   Update the `$id` and `x-schema-version` fields in all schema files to `0.7.4`.
    *   Create a new `provenance.schema.json` file.
