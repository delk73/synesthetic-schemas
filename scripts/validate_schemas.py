#!/usr/bin/env python3
"""
Schema Validation Script for Governance Compliance

Validates JSON schemas under docs/schema/0.7.3/ for:
- Canonical $id fields
- Absolute $ref URLs pointing to canonical host
- Syntactic correctness per JSON Schema Draft 2020-12

Usage:
    python3 scripts/validate_schemas.py [base_url]

Arguments:
    base_url: Canonical base URL (default: https://delk73.github.io/synesthetic-schemas/schema/0.7.3/)

Exit codes:
    0: All schemas valid
    1: Validation errors found
"""

import glob
import json
import os
import sys
from jsonschema import Draft202012Validator, ValidationError

def validate_schemas(base_url):
    schema_files = glob.glob("docs/schema/0.7.3/*.schema.json")
    if not schema_files:
        print("❌ No schema files found in docs/schema/0.7.3/")
        return False

    all_valid = True
    print(f"Validating {len(schema_files)} schemas against base URL: {base_url}")

    for schema_file in sorted(schema_files):
        filename = os.path.basename(schema_file)
        print(f"\n📄 Checking {filename}...")

        try:
            with open(schema_file, 'r') as f:
                schema = json.load(f)
        except json.JSONDecodeError as e:
            print(f"❌ JSON syntax error: {e}")
            all_valid = False
            continue

        # Check $id
        schema_id = schema.get('$id')
        if not schema_id:
            print("❌ Missing $id field")
            all_valid = False
            continue

        if not schema_id.startswith(base_url):
            print(f"❌ Non-canonical $id: {schema_id}")
            all_valid = False
            continue

        expected_id = f"{base_url}{filename}"
        if schema_id != expected_id:
            print(f"❌ $id mismatch: expected {expected_id}, got {schema_id}")
            all_valid = False
            continue

        print("✅ $id canonical")

        # Check $ref fields
        refs_valid = True
        def check_refs(obj, path=""):
            nonlocal refs_valid
            if isinstance(obj, dict):
                for key, value in obj.items():
                    if key == '$ref' and isinstance(value, str):
                        if not value.startswith(base_url) and not value.startswith('#'):
                            print(f"❌ Non-canonical $ref at {path}: {value}")
                            refs_valid = False
                    else:
                        check_refs(value, f"{path}.{key}" if path else key)
            elif isinstance(obj, list):
                for i, item in enumerate(obj):
                    check_refs(item, f"{path}[{i}]")

        check_refs(schema)
        if refs_valid:
            print("✅ All $ref canonical")

        # Validate schema syntax
        try:
            Draft202012Validator.check_schema(schema)
            print("✅ Schema syntax valid (Draft 2020-12)")
        except ValidationError as e:
            print(f"❌ Schema validation error: {e.message}")
            all_valid = False

    return all_valid

def main():
    base_url = sys.argv[1] if len(sys.argv) > 1 else "https://delk73.github.io/synesthetic-schemas/schema/0.7.3/"
    if not base_url.endswith('/'):
        base_url += '/'

    if validate_schemas(base_url):
        print("\n✅ All schemas valid")
        sys.exit(0)
    else:
        print("\n❌ Validation failed")
        sys.exit(1)

if __name__ == "__main__":
    main()