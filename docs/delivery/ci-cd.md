# CI/CD

Use GitHub Actions for application, infrastructure, and security validation.

GitHub Actions should authenticate to Azure using OpenID Connect rather than stored Azure client secrets.

## Pull Request CI

Pull requests should run:

- Dependency installation
- Formatting checks
- ESLint
- TypeScript validation
- Unit tests
- Front-end build
- API build
- Terraform formatting
- Terraform validation
- Dependency review
- Security scanning

## Infrastructure Checks

Infrastructure validation should include:

- `terraform fmt -check`
- `terraform validate`
- Terraform plan generation
- TFLint
- Checkov or Trivy configuration scanning

## Delivery Workflows

Use GitHub Actions for:

- Formatting checks
- Linting
- TypeScript validation
- Unit tests
- Application builds
- Terraform formatting
- Terraform validation
- Terraform plans
- Infrastructure deployment
- Application deployment
- Security and dependency checks

Main branch deployment expectations are described in [deployment](../operations/deployment.md).

