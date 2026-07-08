# Repository Layout

Use a small monorepo with separate areas for the web app, API, infrastructure, documentation, and GitHub automation.

## Target Structure

```text
.
|-- apps/
|   |-- web/
|   `-- api/
|-- infra/
|   `-- terraform/
|-- docs/
|-- .github/
|   |-- workflows/
|   |-- ISSUE_TEMPLATE/
|   `-- dependabot.yml
|-- package.json
|-- tsconfig.base.json
|-- README.md
`-- .gitignore
```

## Repository Areas

- `apps/web` contains the React, TypeScript, and Vite frontend.
- `apps/api` contains the Azure Functions, Node.js, and TypeScript backend API.
- `infra/terraform` contains Terraform configuration for Azure resources, environment values, and deployment outputs.
- `docs` contains planning documentation, architecture notes, ADRs, runbooks, sprint reviews, and retrospectives.
- `.github/workflows` contains pull request validation, infrastructure plan, infrastructure deployment, and application deployment workflows.
- `.github/ISSUE_TEMPLATE` contains issue templates for features, bugs, technical tasks, documentation, and research spikes.

## Workspace Commands

Use npm workspaces initially, with root commands for local development and CI:

- `npm run dev`
- `npm run build`
- `npm run lint`
- `npm run format`
- `npm run typecheck`
- `npm test`
- `npm run test:watch`

The root workspace should coordinate common tasks, while each application keeps its own package scripts for app-specific development.

