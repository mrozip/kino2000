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

