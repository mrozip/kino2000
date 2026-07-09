# kino2000 API

Azure Functions TypeScript API for sprint 0.

The Sprint 0 API exposes the placeholder health function and is included in root workspace validation and API packaging.

## Local Settings

Copy `local.settings.json.example` to `local.settings.json` for local function execution.

## Commands

```sh
npm run dev:api
npm run test --workspace @kino2000/api
npm run typecheck --workspace @kino2000/api
npm run build --workspace @kino2000/api
npm run package:api
```

Equivalent workspace-only commands:

```sh
npm run dev --workspace @kino2000/api
npm run test --workspace @kino2000/api
npm run build --workspace @kino2000/api
```
