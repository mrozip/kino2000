# Terraform

Terraform is split into two roots:

- `bootstrap` creates the Azure Storage account and container used for remote state.
- `environments/dev` provisions the sprint 0 development environment.

## Sprint 0 Current State

Remote state is already bootstrapped in Azure:

- Resource group: `rg-kino2000-tfstate`
- Storage account: `stkino2000tfstate001`
- Container: `tfstate`
- Development state key: `kino2000-dev.tfstate`

The development environment is provisioned with:

- Resource group: `rg-kino2000-dev`
- Static Web App: `stapp-kino2000-dev-001`
- Cosmos DB account: `cosmos-kino2000-dev`
- Cosmos DB database: `kino2000`
- Storage static website endpoint: `https://stkino2000dev001.z33.web.core.windows.net/`
- Log Analytics workspace: `log-kino2000-dev`
- Application Insights component: `appi-kino2000-dev`

Function App hosting is disabled with `provision_api = false` until App Service quota is available.

## Bootstrap Remote State

```sh
cp infra/terraform/bootstrap/terraform.tfvars.example infra/terraform/bootstrap/terraform.tfvars
terraform -chdir=infra/terraform/bootstrap init
terraform -chdir=infra/terraform/bootstrap apply
```

## Initialise Development Environment

Use the bootstrap outputs as backend configuration:

```sh
terraform -chdir=infra/terraform/environments/dev init \
  -backend-config="resource_group_name=rg-kino2000-tfstate" \
  -backend-config="storage_account_name=stkino2000tfstate001" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=kino2000-dev.tfstate" \
  -backend-config="use_azuread_auth=true"
```

Then copy `dev.tfvars.example`, adjust globally unique names, and apply:

```sh
cp infra/terraform/environments/dev/dev.tfvars.example infra/terraform/environments/dev/dev.tfvars
terraform -chdir=infra/terraform/environments/dev plan -var-file=dev.tfvars
terraform -chdir=infra/terraform/environments/dev apply -var-file=dev.tfvars
```

## Validate

```sh
npm run terraform:fmt
npm run terraform:validate
```
