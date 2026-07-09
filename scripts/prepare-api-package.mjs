import { cp, mkdir, rm } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const repoRoot = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const apiRoot = resolve(repoRoot, "apps/api");
const packageRoot = resolve(repoRoot, "artifacts/api");

await rm(packageRoot, { force: true, recursive: true });
await mkdir(packageRoot, { recursive: true });

await cp(resolve(apiRoot, "dist"), resolve(packageRoot, "dist"), { recursive: true });
await cp(resolve(apiRoot, "host.json"), resolve(packageRoot, "host.json"));
await cp(resolve(apiRoot, "package.json"), resolve(packageRoot, "package.json"));
