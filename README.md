# kino2000

kino2000 is an online movie database where users can log, rate, add favourites and interact with fellow users.

## Sprint 0 Status

Sprint 0 established the repository and delivery foundation:

- React, TypeScript, and Vite web app in `apps/web`
- Azure Functions TypeScript API in `apps/api`
- npm workspace commands for formatting, linting, type checking, tests, builds, and API packaging
- Pull request CI for application validation, Terraform formatting, Terraform validation, and dependency review
- Main-branch development deployment workflow using GitHub Actions and Azure OIDC
- Terraform remote state and Azure development infrastructure
- GitHub issue templates, labels, Sprint 0 issues, and the `kino2000 Delivery` project
- Deployed Sprint 0 placeholder homepage at `https://stkino2000dev001.z33.web.core.windows.net/`

The current development deployment runs in storage-only mode with `AZURE_SKIP_TERRAFORM=true`. Function App hosting remains disabled until App Service quota is available.

## Prerequisites

- Node.js 22 or newer
- npm 10 or newer
- Terraform 1.7 or newer
- Azure Functions Core Tools v4 for local API execution

## Install

```sh
npm install
```

## Local Development

Run the web app:

```sh
npm run dev
```

Run the API in a second terminal:

```sh
cp apps/api/local.settings.json.example apps/api/local.settings.json
npm run dev:api
```

## Validation

```sh
npm run format
npm run lint
npm run typecheck
npm test
npm run build
npm run package:api
npm run terraform:fmt
```

Terraform validation requires providers to be initialised in each Terraform root:

```sh
terraform -chdir=infra/terraform/bootstrap init
terraform -chdir=infra/terraform/environments/dev init -backend=false
npm run terraform:validate
```

## First Phase Workflow

Use this flow for work built on the Sprint 0 foundation:

1. Pick an issue from the `kino2000 Delivery` GitHub Project.
2. Create a branch for the issue.
3. Install dependencies with `npm install`.
4. Run the web app with `npm run dev`.
5. Run the API with `npm run dev:api` after creating `apps/api/local.settings.json`.
6. Keep app changes covered by `npm test`, `npm run typecheck`, and `npm run build`.
7. Run the full validation block above before opening a pull request.
8. Let GitHub Actions validate the pull request before merging.
9. Merge to `main` to trigger the development deployment workflow.

Sprint scope and acceptance criteria live in `docs/delivery/sprints`. Active work should be tracked in GitHub Issues and the `kino2000 Delivery` project.

## Repository Layout

- `apps/web` - React, TypeScript, and Vite placeholder front end
- `apps/api` - Azure Functions TypeScript API
- `infra/terraform` - Terraform bootstrap and development environment configuration
- `docs` - product, architecture, delivery, operations, and quality documentation
- `.github` - CI/CD workflows, Dependabot, and GitHub issue/PR templates
