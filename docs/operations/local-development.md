# Local Development

## Install Dependencies

```sh
npm install
```

## Run Locally

Start the web app:

```sh
npm run dev
```

Start the API:

```sh
cp apps/api/local.settings.json.example apps/api/local.settings.json
npm run dev:api
```

## Validate Changes

```sh
npm run format
npm run lint
npm run typecheck
npm test
npm run build
npm run terraform:fmt
```
