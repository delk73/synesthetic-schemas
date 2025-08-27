#!/usr/bin/env node
// Bundle all jsonschema/*.schema.json locally, remapping the $id domain to files.
import fs from 'node:fs';
import path from 'node:path';
import $RefParser from '@apidevtools/json-schema-ref-parser';

const ROOT = path.resolve(path.dirname(new URL(import.meta.url).pathname), '..');
const IN_DIR = path.join(ROOT, 'jsonschema');
const OUT_DIR = path.join(ROOT, 'typescript', 'tmp', 'bundled');
const BASE = 'https://schemas.synesthetic.dev/0.1.0/';

fs.mkdirSync(OUT_DIR, { recursive: true });

// Custom resolver: redirect our $id URLs to local files
const resolver = {
  order: 1,
  canRead: (file) => typeof file.url === 'string' && file.url.startsWith(BASE),
  read: (file) => {
    const filename = file.url.slice(BASE.length); // e.g. "rule-bundle.schema.json"
    const p = path.join(IN_DIR, filename);
    return fs.readFileSync(p, 'utf8');
  },
};

const files = fs.readdirSync(IN_DIR).filter(f => f.endsWith('.schema.json'));

for (const f of files) {
  const inPath = path.join(IN_DIR, f);
  const outPath = path.join(OUT_DIR, f);
  const schema = JSON.parse(fs.readFileSync(inPath, 'utf8'));

  const bundled = await $RefParser.bundle(schema, {
    resolve: {
      file: true,
      http: { disabled: true },  // hard-disable network
      custom: resolver,          // map our BASE to local files
    },
    dereference: { circular: 'ignore' },
  });

  fs.writeFileSync(outPath, JSON.stringify(bundled, null, 2) + '\n');
  console.log(`bundled: ${f} → ${path.relative(ROOT, outPath)}`);
}
