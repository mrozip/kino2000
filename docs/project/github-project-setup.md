# GitHub Project Setup

Use GitHub Issues and a repository project as the source of truth for sprint execution.

## Issue Templates

This repository includes issue forms for:

- Feature
- Bug
- Technical task
- Documentation
- Research spike

## Project

Use the GitHub Project named `kino2000 Delivery`:

- `https://github.com/users/mrozip/projects/2`

Recommended fields:

- `Status`
- `Sprint`
- `Priority`
- `Type`
- `Area`
- `Estimate`
- `Environment`

Recommended status values:

- `Backlog`
- `Ready`
- `In progress`
- `In review`
- `Done`

Recommended sprint value for this setup work:

- `Sprint 0`

## Initial Views

Create these views:

- `Board by status`, grouped by `Status`
- `Sprint 0`, filtered to `Sprint: Sprint 0`
- `By area`, grouped by `Area`

## Automation

Configure project workflows so newly added issues enter `Backlog`. Pull requests should be linked to issues and moved to `In review` during review.

## Current Setup Status

Sprint 0 has configured:

- Issue forms for the recommended issue types
- Labels for feature, bug, technical task, documentation, research, Sprint 0, CI/CD, infrastructure, API, and front end work
- The `kino2000 Delivery` project
- Project fields for status, sprint, priority, type, area, estimate, and environment
- Four initial Sprint 0 issues added to the project with metadata

The setup script is idempotent and can be rerun if labels, fields, or initial issues need to be repaired. Authenticate the GitHub CLI with repository and project scopes first:

```sh
gh auth login
gh auth refresh -s project
npm run github:setup
```

The script configures labels, creates or reuses the project, creates the recommended fields, links the repository, creates initial Sprint 0 issues, adds them to the project, and sets Sprint 0 metadata fields on those issues.
