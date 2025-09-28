## Summary of documentation state
- docs/README index is stale: concept links point to `docs/`-prefixed paths and reference a missing schema narrative (`docs/README.md:L18-L33`).
- Concept coverage is uneven: several files lack YAML front matter or citations, and the only live crosswalk uses a different filename than the index (`docs/concepts/distinction.md:L1-L12`; `docs/concepts/applied_crosswalk_phy_atari.md:L1-L8`; `docs/concepts/crosswalk_perception_interfaces.md:L1-L44`).
- Use-case docs and examples README predate schemaVersion 0.7.3, leaving metadata gaps and outdated asset references (`docs/use_cases/controls.md:L1-L28`; `examples/README.md:L14-L36`).

## Top gaps & fixes
- Realign docs/README index and links to actual files and sections (`docs/README.md:L18-L33`).
- Restore schema evolution coverage by drafting `docs/schema_evolution.md` at schemaVersion 0.7.3 with version.json references (`version.json:L2`).
- Normalize front matter and remove placeholders (`docs/concepts/distinction.md:L1-L12`; `docs/concepts/positioning_embodied.md:L17-L32`).
- Refresh examples README so it enumerates current JSON assets (`examples/README.md:L14-L36`; `examples/Control-Bundle_Example.json:L1-L12`).

## Alignment with docs/README.md index
| Section | Status | Evidence |
| --- | --- | --- |
| Concepts → Tokenized Manifold | Divergent | Link includes `docs/` prefix; doc metadata still `v0.1.0` (`docs/README.md:L18-L22`; `docs/concepts/tokenized_manifold.md:L1-L4`). |
| Concepts → Crosswalk: Embodied AI Alignment | Missing | Index targets `concepts/crosswalk_embodied_ai.md`, but only `crosswalk_perception_interfaces.md` exists (`docs/README.md:L19-L24`; `docs/concepts/crosswalk_perception_interfaces.md:L1-L8`). |
| Concepts → Distinction | Divergent | Doc lacks YAML front matter and starts with draft prose (`docs/README.md:L21-L24`; `docs/concepts/distinction.md:L1-L12`). |
| Concepts → Naming Rationale | Divergent | Metadata is not in YAML and version is `v0.1.2` (`docs/README.md:L22-L25`; `docs/concepts/naming.md:L1-L12`). |
| Use Cases → Controls | Divergent | Front matter has `version: v0.0.0` and blank `lastReviewed` (`docs/README.md:L26-L28`; `docs/use_cases/controls.md:L2-L18`). |
| Use Cases → Perceptual Field | Divergent | Front matter version `v0.4.0` lags schemaVersion 0.7.3 (`docs/README.md:L27-L29`; `docs/use_cases/perceptual_field.md:L2-L18`). |
| Use Cases → Topology | Divergent | Front matter version `v0.4.0` lags schemaVersion 0.7.3 (`docs/README.md:L27-L30`; `docs/use_cases/topology.md:L2-L18`). |
| Schema & Evolution → Schema Evolution | Missing | Entry points to absent `docs/schema_evolution.md` (`docs/README.md:L30-L33`). |
| Examples → Examples README | Divergent | README still lists `asset_*` files that are not in the directory (`docs/README.md:L34-L37`; `examples/README.md:L14-L36`). |

## Concepts coverage
- `distinction.md` needs YAML front matter and removal of draft preamble to meet SSOT expectations (`docs/concepts/distinction.md:L1-L12`).
- `naming.md` requires proper front matter delimiters and schemaVersion alignment (`docs/concepts/naming.md:L1-L12`).
- `applied_crosswalk_phy_atari.md` is undocumented in the index and lacks metadata (`docs/concepts/applied_crosswalk_phy_atari.md:L1-L8`).

## Crosswalk docs
- Primary crosswalk doc (`crosswalk_perception_interfaces.md`) lacks any cited external sources or version metadata despite referencing SOTA comparisons (`docs/concepts/crosswalk_perception_interfaces.md:L22-L44`).
- `positioning_embodied.md` carries `EVIDENCE?` placeholders and dated performance claims that need sourcing (`docs/concepts/positioning_embodied.md:L17-L37`).

## Use Cases
- Controls doc needs completed front matter and current schema references (`docs/use_cases/controls.md:L2-L28`).
- Perceptual Field and Topology docs retain `v0.4.0` metadata and should reference schemaVersion 0.7.3 changes (`docs/use_cases/perceptual_field.md:L2-L24`; `docs/use_cases/topology.md:L2-L24`).

## Schema & Evolution tracking
- `docs/schema_evolution.md` is absent even though the index expects it (`docs/README.md:L30-L33`).
- version.json already advertises schemaVersion 0.7.3, so the missing doc should summarize changes and audit trail (`version.json:L2`).

## Examples directory (README + sample JSON)
- README lists legacy assets like `asset_basic.json`, but the directory now contains `SynestheticAsset_Example*.json` and bundle-specific files (`examples/README.md:L14-L36`; `examples/SynestheticAsset_Example1.json:L1-L12`).
- At least one live example carries correct `$schemaRef`, so the README should reference it to satisfy validation guidance (`examples/SynestheticAsset_Example1.json:L1-L6`).

## Consistency of front-matter
- Missing `---` delimiters and incomplete metadata across `distinction.md`, `naming.md`, and `applied_crosswalk_phy_atari.md` break the front-matter requirement (`docs/concepts/distinction.md:L1-L12`; `docs/concepts/naming.md:L1-L12`; `docs/concepts/applied_crosswalk_phy_atari.md:L1-L8`).
- Docs that do have YAML still report `version: v0.0.x–0.4.x`, failing schemaVersion alignment (`docs/concepts/tokenized_manifold.md:L1-L4`; `docs/use_cases/perceptual_field.md:L2-L6`).

## Link integrity & determinism
- Concept links in docs/README add a redundant `docs/` prefix that resolves to `docs/docs/...` and break navigation (`docs/README.md:L18-L25`).
- Examples README references files that no longer exist, so guidance is non-deterministic (`examples/README.md:L14-L36`).

## Alignment with version.json
- SchemaVersion is 0.7.3 (`version.json:L2`), yet no doc front matter reflects that value; most remain on `v0.1.x` or `v0.4.x` (`docs/concepts/tokenized_manifold.md:L1-L4`; `docs/use_cases/topology.md:L2-L6`).

## Documentation accuracy
- `positioning_embodied.md` includes unsourced performance metrics flagged with `EVIDENCE?` (`docs/concepts/positioning_embodied.md:L17-L37`).
- Crosswalk and use-case docs promise examples that the repository does not ship (`docs/concepts/applied_crosswalk_phy_atari.md:L9-L37`; `docs/use_cases/controls.md:L22-L34`).

## Detected divergences
- Index/file mismatches (concept crosswalk, schema evolution, examples assets) violate SSOT alignment (`docs/README.md:L19-L37`).
- Metadata drift (versions, owners, review dates) prevents tying docs to schemaVersion 0.7.3 (`docs/concepts/naming.md:L1-L12`; `docs/use_cases/controls.md:L2-L8`).

## Recommendations
- Rewrite docs/README index with correct relative paths, remove dead entries, and add missing concept listings (`docs/README.md:L18-L37`).
- Author `docs/schema_evolution.md` that summarizes changes up to schemaVersion 0.7.3 and cross-links version.json (`version.json:L2`).
- Add or normalize YAML front matter (version 0.7.3, lastReviewed, owner) across concepts and use cases (`docs/concepts/distinction.md:L1-L12`; `docs/use_cases/controls.md:L2-L8`).
- Update crosswalk docs with sourced citations and remove `EVIDENCE?` placeholders (`docs/concepts/positioning_embodied.md:L17-L37`; `docs/concepts/crosswalk_perception_interfaces.md:L22-L44`).
- Refresh examples README to cite current JSON assets and ensure at least one doc references a live asset (`examples/README.md:L14-L36`; `examples/Control-Bundle_Example.json:L1-L12`).

## Step-by-step cleanup sequence
1. Fix docs/README links and index entries so every row matches an existing file without the `docs/` prefix (`docs/README.md:L18-L33`).
2. Draft `docs/schema_evolution.md` for schemaVersion 0.7.3 citing version.json and recent deltas (`version.json:L2`).
3. Normalize front matter (version 0.7.3, lastReviewed, owner) across concepts and use cases, including adding YAML blocks where missing (`docs/concepts/distinction.md:L1-L12`; `docs/use_cases/topology.md:L2-L10`).
4. Update crosswalk docs with citations, remove `EVIDENCE?`, and align naming with the index (`docs/concepts/positioning_embodied.md:L17-L37`; `docs/concepts/crosswalk_perception_interfaces.md:L22-L44`).
5. Reconcile examples README with actual assets and link at least one validated JSON (`examples/README.md:L14-L36`; `examples/SynestheticAsset_Example1.json:L1-L6`).
6. Ensure docs cite live assets and schema evolution narrative references version.json to stay synchronized (`examples/README.md:L14-L36`; `version.json:L2`).
7. Run a final pass for link resolution, consistent metadata, and deterministic formatting across the docs tree (`docs/README.md:L18-L37`; `docs/concepts/naming.md:L1-L12`).
