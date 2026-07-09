# Infrastructure

Use Terraform to provision Azure resources for the development environment.

## Initial Azure Resources

Initial Terraform-managed resources will include:

- Resource group
- Azure Static Web App
- Azure Functions resources where required
- Azure Cosmos DB account
- Cosmos DB database and containers
- Application Insights
- Log Analytics workspace
- Azure role assignments
- Required application configuration

Terraform state must be stored remotely in an Azure Storage account and must never be committed to the repository.

## Terraform Configuration

Non-sensitive Terraform values may be stored in version-controlled environment files.

Example:

```hcl
application_name = "kino2000"
environment      = "dev"
location         = "uksouth"
cosmos_database  = "kino2000"
```

The following must not be committed:

- Terraform state
- OMDb API keys
- Azure credentials
- Access tokens
- Cosmos DB keys
- Client secrets

Use managed identities, role assignments, GitHub environments, and OpenID Connect wherever possible.

## Remote State Bootstrap

Remote state is bootstrapped from `infra/terraform/bootstrap`. Copy `terraform.tfvars.example`, choose a globally unique storage account name, then apply the bootstrap root once.

The development environment in `infra/terraform/environments/dev` uses the `azurerm` backend. Initialise it with the storage account and container produced by the bootstrap root. State files and local variable files must remain outside version control.

The Azure Functions hosting resources can be disabled with `provision_api = false` when a development subscription does not have App Service quota. The API source remains part of the workspace and CI build either way.

## Current Development Resources

Sprint 0 has provisioned:

- Remote state resource group: `rg-kino2000-tfstate`
- Remote state storage account: `stkino2000tfstate001`
- Remote state container: `tfstate`
- Development resource group: `rg-kino2000-dev`
- Static Web App: `stapp-kino2000-dev-001`
- Static Web App host: `kind-moss-0b251d90f.7.azurestaticapps.net`
- Cosmos DB account: `cosmos-kino2000-dev`
- Cosmos DB database: `kino2000`
- Cosmos DB containers: `movies`, `users`
- Function storage account: `stkino2000dev001`
- Storage static website host: `https://stkino2000dev001.z33.web.core.windows.net/`
- Log Analytics workspace: `log-kino2000-dev`
- Application Insights component: `appi-kino2000-dev`

The Static Web App has been provisioned, but content deployment still depends on GitHub Actions or an explicitly approved local Static Web Apps deployment-token flow. The storage static website endpoint currently serves the sprint 0 placeholder homepage without a Static Web Apps deployment token.
