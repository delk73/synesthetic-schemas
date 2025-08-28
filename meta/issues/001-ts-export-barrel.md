# TS export barrel (missing index.d.ts)

- Motivation: `typescript/package.json` exports `./src/index.d.ts` but it doesn’t exist, breaking consumers importing from the package root.
- Scope: Generate an index barrel or change export to explicit files.

## Tasks
- Update `codegen/gen_ts.sh` to emit `typescript/src/index.d.ts` that re-exports all generated declarations.
- Alternatively update `typescript/package.json` to export concrete files instead of an index.
- Run `./test.sh` to verify TypeScript generation.

## Acceptance Criteria
- Consumers can `import` types from the package root without missing-file errors.
- `./test.sh` completes without errors.

## Notes
- Keep the solution simple—prefer generated index from the codegen script.

