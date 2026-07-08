# Testing Strategy

## Front End

Use:

- Vitest
- React Testing Library
- Mock Service Worker
- Playwright for later end-to-end tests

Prioritise tests for:

- Protected routes
- Login states
- Search states
- Movie page rendering
- Rating interactions
- Favourite interactions
- Profile rendering

## API

Use:

- Unit tests for services
- Validation tests
- Mocked OMDb responses
- Authentication middleware tests
- Repository tests
- Integration tests for ratings and favourites

## Terraform

Use:

- `terraform fmt -check`
- `terraform validate`
- TFLint
- Checkov or Trivy configuration scanning
- Terraform plan review

