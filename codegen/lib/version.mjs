import fs from "node:fs";
import { fileURLToPath } from "node:url";
import path from "node:path";

const __dirname = path.dirname(fileURLToPath(import.meta.url));

export function schemaVersion() {
  const p = path.join(__dirname, "..", "..", "version.json");
  const data = JSON.parse(fs.readFileSync(p, "utf8"));
  const v = data?.schemaVersion;
  if (typeof v !== "string" || !v) {
    throw new Error("version.json missing 'schemaVersion' string");
  }
  return v;
}

