#!/usr/bin/env python3
"""
Documentation Audit Script for Governance Compliance

Validates Markdown documentation under docs/ for:
- Complete YAML frontmatter (version, lastReviewed, owner)
- Version consistency (v0.7.3)
- Owner consistency (delk73)
- Canonical host references
- Recent lastReviewed dates

Usage:
    python3 scripts/audit_docs.py [--version VERSION] [--strict]

Arguments:
    --version VERSION: Expected version (default: 0.7.3)
    --strict: Exit on any warning

Exit codes:
    0: All docs compliant
    1: Compliance issues found
"""

import argparse
import glob
import os
import re
import sys
from datetime import datetime, timedelta

STRICT_PATHS = ["docs/schema", "docs/examples"]

def parse_frontmatter(content):
    """Parse YAML frontmatter from markdown content."""
    if not content.startswith('---\n'):
        return None

    end_idx = content.find('\n---\n', 4)
    if end_idx == -1:
        return None

    frontmatter_text = content[4:end_idx]
    frontmatter = {}

    for line in frontmatter_text.split('\n'):
        line = line.strip()
        if ':' in line:
            key, value = line.split(':', 1)
            frontmatter[key.strip()] = value.strip()

    return frontmatter

def validate_doc(filepath, expected_version, strict=False):
    """Validate a single markdown document."""
    filename = os.path.basename(filepath)
    errors = []
    warnings = []

    is_strict = any(filepath.startswith(p) for p in STRICT_PATHS)

    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        return False, [f"Error reading file: {e}"], []

    # Check frontmatter
    frontmatter = parse_frontmatter(content)
    if not frontmatter:
        errors.append("Missing or invalid YAML frontmatter")
        return False, errors, warnings

    # Check required keys
    required_keys = ['version', 'lastReviewed', 'owner']
    if is_strict:
        required_keys.append('canonicalHost')
    for key in required_keys:
        if key not in frontmatter:
            errors.append(f"Missing frontmatter key: {key}")

    if errors:
        return False, errors, warnings

    # Check version
    if frontmatter['version'] != f"v{expected_version}":
        errors.append(f"Version mismatch: expected v{expected_version}, got {frontmatter['version']}")

    # Check owner
    if frontmatter['owner'] != 'delk73':
        errors.append(f"Owner mismatch: expected delk73, got {frontmatter['owner']}")

    # Check lastReviewed date
    try:
        reviewed_date = datetime.fromisoformat(frontmatter['lastReviewed'])
        if reviewed_date < datetime.now() - timedelta(days=7):
            if strict:
                errors.append(f"lastReviewed too old: {frontmatter['lastReviewed']}")
            else:
                warnings.append(f"lastReviewed is old ({frontmatter['lastReviewed']})")
    except ValueError:
        errors.append(f"Invalid lastReviewed date format: {frontmatter['lastReviewed']}")

    # Check canonical host reference in content for strict docs
    if is_strict:
        canonical_host = f"https://delk73.github.io/synesthetic-schemas/schema/{expected_version}/"
        if canonical_host not in content:
            errors.append("Missing canonical host reference")

    return len(errors) == 0, errors, warnings

def main():
    parser = argparse.ArgumentParser(description="Audit documentation for governance compliance")
    parser.add_argument('--version', default='0.7.3', help='Expected version')
    parser.add_argument('--strict', action='store_true', help='Exit on warnings')
    args = parser.parse_args()

    doc_files = glob.glob("docs/**/*.md", recursive=True)
    if not doc_files:
        print("❌ No documentation files found in docs/")
        sys.exit(1)

    print(f"Auditing {len(doc_files)} documentation files for v{args.version} compliance...")

    all_compliant = True
    total_warnings = 0

    for doc_file in sorted(doc_files):
        filename = os.path.relpath(doc_file)
        compliant, errors, warnings = validate_doc(doc_file, args.version, args.strict)

        if errors:
            print(f"❌ {filename}")
            for error in errors:
                print(f"   - {error}")
            all_compliant = False
        else:
            print(f"✅ {filename}")

        if warnings:
            for warning in warnings:
                print(f"⚠️  {filename}: {warning}")
            total_warnings += len(warnings)

    if all_compliant:
        if total_warnings > 0:
            print(f"\n✅ All docs compliant with v{args.version} (with {total_warnings} warnings)")
        else:
            print(f"\n✅ All {len(doc_files)} docs compliant with v{args.version}")
        sys.exit(0)
    else:
        print(f"\n❌ Compliance issues found")
        sys.exit(1)

if __name__ == "__main__":
    main()