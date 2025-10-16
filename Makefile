SHELL := /bin/bash
PLACEHOLDER_HOST := https://schemas.synesthetic.dev/0.7.3
CANONICAL_HOST   := https://delk73.github.io/synesthetic-schemas/schema/0.7.3


# Require Poetry-managed Python for reproducibility
ifeq (,$(shell command -v poetry 2>/dev/null))
$(error Poetry is required. Install Poetry or run 'nix develop')
endif

PY := poetry run python
SH := poetry run bash

.PHONY: schema-lint normalize normalize-check codegen-py codegen-ts codegen-check validate preflight preflight-fix bump-version audit checkbloat check-schema-ids validate-schemas audit-docs audit-docs

normalize:
	@$(PY) scripts/normalize_schemas.py

normalize-check:
	@$(PY) scripts/normalize_schemas.py --check

schema-lint:
	@$(PY) scripts/schema_lint.py

codegen-py:
	@$(SH) codegen/gen_py.sh

codegen-ts:
	@$(SH) codegen/gen_ts.sh

validate:
	@PYTHONPATH=python/src $(PY) scripts/validate_examples.py --strict --dir docs/examples/0.7.3
	@echo 'Running schema validation...'
	$(PY) scripts/validate_schemas.py https://delk73.github.io/synesthetic-schemas/schema/0.7.3/

preflight: normalize-check schema-lint codegen-check validate
	@echo "preflight OK"

# Preflight that also writes normalization first (auto-fix drift)
preflight-fix:
	@$(MAKE) normalize
	@$(MAKE) preflight

# Bump schema version and normalize schemas
# Usage: make bump-version VERSION=0.7.4
bump-version:
	@if [[ -z "$(VERSION)" ]]; then echo "Usage: make bump-version VERSION=X.Y.Z" >&2; exit 2; fi
	@$(PY) scripts/bump_version.py --set "$(VERSION)"
	@$(PY) scripts/update_docs_frontmatter.py --version "$(VERSION)"
	@$(MAKE) normalize
	@$(MAKE) publish-schemas
	@git add docs/schema
	@git commit -m "publish schemas for $(VERSION)" || true
	@git push

audit:
	@$(PY) scripts/ssot_audit.py --spec meta/prompts/ssot.audit.json

checkbloat:
	@echo "🔍 Checking repo for bloat (venv, node_modules, caches)..."
	@if git ls-files | grep -E '(\.venv|node_modules|\.cache|__pycache__|\.pytest_cache|\.mypy_cache|\.ruff_cache)' >/dev/null; then \
		echo "❌ Found tracked junk files!"; \
		git ls-files | grep -E '(\.venv|node_modules|\.cache|__pycache__|\.pytest_cache|\.mypy_cache|\.ruff_cache)'; \
		exit 1; \
	else \
		echo "✅ No tracked junk files found."; \
	fi

# Publish schemas to docs/schema/<version> for GitHub Pages
# Publish schemas to docs/schema/<version> for GitHub Pages
publish-schemas:
	@set -euo pipefail; \
	\
	echo "--> Validating source schemas for illegal relative refs..."; \
	if grep -rP '"$$ref":\s*"(?!#|https://)' jsonschema/; then \
		echo "❌ ERROR: Found illegal relative $$ref in jsonschema/ sources." >&2; \
		echo "   All external refs must use the placeholder host '$(PLACEHOLDER_HOST)'." >&2; \
		exit 1; \
	fi; \
	echo "    ✓ Sources are clean."; \
	\
	ver=$$(jq -r '.schemaVersion // empty' version.json); \
	if [[ -z "$$ver" ]]; then \
	  echo "❌ version.json missing 'schemaVersion' key" >&2; exit 1; \
	fi; \
	dest="docs/schema/$$ver"; \
	echo "📦 Publishing schemas for version $$ver → $$dest"; \
	mkdir -p "$$dest"; \
	for f in jsonschema/*.schema.json; do \
	  name=$$(basename "$$f"); \
	  jq \
	     --arg placeholder "$(PLACEHOLDER_HOST)" \
	     --arg canonical "$(CANONICAL_HOST)" \
	     'walk(if type == "object" and has("$$ref") then .["$$ref"] |= sub($$placeholder; $$canonical) else . end) | .["$$id"] |= sub($$placeholder; $$canonical)' \
	     "$$f" > "$$dest/$$name"; \
	  echo "    ✓ Published $$name"; \
	done

# Check schema $id fields for canonical host
check-schema-ids:
	@grep -R --include='*.schema.json' -n '\\"\\$id\\"' docs/schema/0.7.3 | grep -v 'https://delk73.github.io/synesthetic-schemas/schema/0.7.3/' && echo '❌ Non-canonical $id found' || echo '✅ All schema IDs canonical'

# Audit documentation for governance compliance
audit-docs:
	@echo 'Auditing documentation for 0.7.3...'
	$(PY) scripts/audit_docs.py --version 0.7.3 --strict




