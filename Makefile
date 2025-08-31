SHELL := /bin/bash

# Detect best Python runner: conda(schemas311)+poetry > poetry > conda(schemas311) > python
PY := $(shell \
  if command -v conda >/dev/null 2>&1 && conda env list | grep -qE '^\s*schemas311\s'; then \
    if command -v poetry >/dev/null 2>&1; then \
      echo "conda run -n schemas311 poetry run python"; \
    else \
      echo "conda run -n schemas311 python"; \
    fi; \
  elif command -v poetry >/dev/null 2>&1; then \
    echo "poetry run python"; \
  else \
    echo "python3"; \
  fi)

.PHONY: schema-lint normalize normalize-check codegen-py codegen-ts codegen-check validate preflight preflight-fix bump-version

normalize:
	@$(PY) scripts/normalize_schemas.py

normalize-check:
	@$(PY) scripts/normalize_schemas.py --check

schema-lint:
	@$(PY) scripts/schema_lint.py

codegen-py:
	@if command -v conda >/dev/null 2>&1 && conda env list | grep -qE '^\s*schemas311\s' && command -v poetry >/dev/null 2>&1; then \
		conda run -n schemas311 poetry run bash codegen/gen_py.sh; \
	elif command -v poetry >/dev/null 2>&1; then \
		poetry run bash codegen/gen_py.sh; \
	else \
		bash codegen/gen_py.sh; \
	fi

codegen-ts:
	@bash codegen/gen_ts.sh

codegen-check:
	@if command -v conda >/dev/null 2>&1 && conda env list | grep -qE '^\s*schemas311\s'; then \
		conda run -n schemas311 bash scripts/ensure_codegen_clean.sh; \
	else \
		bash scripts/ensure_codegen_clean.sh; \
	fi

validate:
	@PYTHONPATH=python/src $(PY) scripts/validate_examples.py --strict --dir examples

preflight: normalize-check schema-lint codegen-check validate
	@echo "preflight OK"

# Preflight that also writes normalization first (auto-fix drift)
preflight-fix:
	@$(MAKE) normalize
	@$(MAKE) preflight

# Bump schema version and normalize schemas
# Usage: make bump-version VERSION=0.7.1
bump-version:
	@if [[ -z "$(VERSION)" ]]; then echo "Usage: make bump-version VERSION=X.Y.Z" >&2; exit 2; fi
	@$(PY) scripts/bump_version.py --set "$(VERSION)"
