# Schema Evaluation Report - 20251003

## 1. Summary of Repo Schemas

This document provides a snapshot of the JSON schemas present in the repository as of 2025-10-03. It is a descriptive inventory of the schemas and their fields, intended as a baseline for future audits and evolution tracking.

## 2. Schema Inventory

| Schema                | Top-Level Fields                                                                                                                            |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `synesthetic-asset`   | `name`, `description`, `meta_info`, `control`, `haptic`, `modulation`, `modulations`, `rule_bundle`, `shader`, `tone`, `created_at`, `updated_at` |
| `control-bundle`      | `name`, `description`, `meta_info`, `control_parameters`                                                                                    |
| `control`             | `parameter`, `label`, `type`, `unit`, `default`, `mappings`, `min`, `max`, `step`, `options`, `smoothingTime`                                 |
| `haptic`              | `name`, `description`, `meta_info`, `device`, `input_parameters`                                                                            |
| `modulation`          | `name`, `description`, `meta_info`, `modulations`                                                                                           |
| `rule-bundle`         | `name`, `description`, `meta_info`, `rules`, `id`, `created_at`, `updated_at`                                                               |
| `rule`                | `id`, `expr`, `trigger`, `effects`, `target`, `execution`                                                                                   |
| `shader`              | `name`, `description`, `meta_info`, `fragment_shader`, `vertex_shader`, `uniforms`, `input_parameters`                                       |
| `tone`                | `name`, `description`, `meta_info`, `synth`, `effects`, `parts`, `patterns`, `input_parameters`                                             |

## 3. Component Inventories

### `control-bundle.schema.json`

-   **`name`** (string, required)
-   **`control_parameters`** (array, required)
-   `description` (string, nullable)
-   `meta_info` (object, nullable)

### `control.schema.json`

-   **`parameter`** (string, required)
-   **`label`** (string, required)
-   **`type`** (string, required)
-   **`unit`** (string, required)
-   **`default`** (any, required)
-   **`mappings`** (array, required)
-   `min` (number, nullable)
-   `max` (number, nullable)
-   `step` (number, nullable)
-   `options` (array, nullable)
-   `smoothingTime` (number)

### `haptic.schema.json`

-   **`name`** (string, required)
-   **`device`** (object, required)
-   **`input_parameters`** (array, required)
-   `description` (string, nullable)
-   `meta_info` (object, nullable)

### `modulation.schema.json`

-   **`name`** (string, required)
-   **`modulations`** (array, required)
-   `description` (string, nullable)
-   `meta_info` (object, nullable)

### `rule-bundle.schema.json`

-   **`name`** (string, required)
-   **`rules`** (array, required)
-   `description` (string, nullable)
-   `meta_info` (object)
-   `id` (integer, nullable)
-   `created_at` (string, nullable)
-   `updated_at` (string, nullable)

### `rule.schema.json`

-   **`id`** (string, required)
-   `expr` (string/object, nullable)
-   `trigger` (object, nullable)
-   `effects` (array, nullable)
-   `target` (string, nullable)
-   `execution` (string, nullable)

### `shader.schema.json`

-   **`name`** (string, required)
-   **`fragment_shader`** (string, required)
-   **`vertex_shader`** (string, required)
-   `description` (string, nullable)
-   `meta_info` (object, nullable)
-   `uniforms` (array, nullable)
-   `input_parameters` (array, nullable)

### `tone.schema.json`

-   **`name`** (string, required)
-   **`synth`** (object, required)
-   `description` (string, nullable)
-   `meta_info` (object, nullable)
-   `effects` (array, nullable)
-   `parts` (array, nullable)
-   `patterns` (array, nullable)
-   `input_parameters` (array)

## 4. Top-Level Asset Composition (`synesthetic-asset.schema.json`)

The `synesthetic-asset` is the top-level schema that composes the other schemas to form a complete synesthetic experience.

-   **`name`** (string, required): The name of the asset.
-   `description` (string, nullable): A description of the asset.
-   `meta_info` (object, nullable): Metadata about the asset.
-   `control` (object, nullable): A reference to a `control-bundle.schema.json`.
-   `haptic` (object, nullable): A reference to a `haptic.schema.json`.
-   `modulation` (object, nullable): A reference to a `modulation.schema.json`.
-   `modulations` (array, nullable): An array of modulation items.
-   `rule_bundle` (object): A reference to a `rule-bundle.schema.json`.
-   `shader` (object, nullable): A reference to a `shader.schema.json`.
-   `tone` (object, nullable): A reference to a `tone.schema.json`.
-   `created_at` (string, readonly): The creation timestamp of the asset.
-   `updated_at` (string, readonly): The last update timestamp of the asset.
