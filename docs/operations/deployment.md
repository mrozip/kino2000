# Deployment

## Development Deployment

Merges to `main` should:

- Run or depend on successful CI
- Apply approved development infrastructure changes
- Build the application
- Deploy the API
- Deploy the front end
- Run smoke tests
- Publish the deployment result

The development environment is the shared Azure environment automatically deployed from the main branch.

The `Deploy development` GitHub Actions workflow uses GitHub OpenID Connect with Azure. Configure these GitHub environment or repository variables before enabling main-branch deployment:

- `AZURE_CLIENT_ID`
- `AZURE_SUBSCRIPTION_ID`
- `AZURE_TENANT_ID`
- `AZURE_LOCATION`
- `AZURE_STATIC_WEB_APP_LOCATION`
- `AZURE_STATIC_WEB_APP_NAME`
- `AZURE_FUNCTION_APP_NAME`
- `AZURE_FUNCTION_STORAGE_ACCOUNT_NAME`
- `AZURE_PROVISION_API`
- `AZURE_SKIP_TERRAFORM`
- `TF_STATE_RESOURCE_GROUP`
- `TF_STATE_STORAGE_ACCOUNT`
- `TF_STATE_CONTAINER`

The workflow can run in two modes:

- `AZURE_SKIP_TERRAFORM=true` deploys the built Vite application to the storage static website fallback without applying infrastructure changes.
- `AZURE_SKIP_TERRAFORM=false` applies Terraform from `infra/terraform/environments/dev`, deploys the Azure Functions API when `AZURE_PROVISION_API` is `true`, deploys the storage static website fallback, and deploys the built Vite application to Azure Static Web Apps.

The Static Web Apps deployment token is read from Azure during the workflow after OIDC login and is not stored in the repository.

## Development Values

The current development environment uses:

- `AZURE_CLIENT_ID`: `d80ecfd9-ea65-4275-807e-a742b2e5475d`
- `AZURE_SUBSCRIPTION_ID`: `7c918719-8448-462f-b028-43909442ec10`
- `AZURE_TENANT_ID`: `6446b407-d1cd-4e2c-884c-68b249f41f3c`
- `AZURE_LOCATION`: `uksouth`
- `AZURE_STATIC_WEB_APP_LOCATION`: `eastus2`
- `AZURE_STATIC_WEB_APP_NAME`: `stapp-kino2000-dev-001`
- `AZURE_FUNCTION_APP_NAME`: `func-kino2000-dev-001`
- `AZURE_FUNCTION_STORAGE_ACCOUNT_NAME`: `stkino2000dev001`
- `AZURE_PROVISION_API`: `false`
- `AZURE_SKIP_TERRAFORM`: `true`
- `TF_STATE_RESOURCE_GROUP`: `rg-kino2000-tfstate`
- `TF_STATE_STORAGE_ACCOUNT`: `stkino2000tfstate001`
- `TF_STATE_CONTAINER`: `tfstate`

The Azure app registration `kino2000-github-actions` has federated credentials for:

- `repo:mrozip/kino2000:ref:refs/heads/main`
- `repo:mrozip/kino2000:environment:development`

The current storage-only mode requires the variables above and `Storage Blob Data Contributor` on the development storage account.

Before enabling Terraform and Static Web Apps deployment by setting `AZURE_SKIP_TERRAFORM=false`, grant the service principal access to:

- The development resource group, so Terraform can update resources and read the Static Web Apps deployment token.
- The Terraform state storage account with `Storage Blob Data Contributor`.
- The development storage account with `Storage Blob Data Contributor`, so the storage static website fallback can upload built assets.

Function App hosting is disabled until the subscription has App Service quota available.

The placeholder homepage can also be deployed to the storage static website fallback:

```sh
npm run build
az storage blob upload-batch \
  --account-name stkino2000dev001 \
  --auth-mode login \
  --destination '$web' \
  --overwrite \
  --source apps/web/dist
```

## Production Deployment

Production should be introduced only after the core movie-tracking functionality is stable.

Production deployment should require:

- A release tag or manual release workflow
- A protected GitHub environment
- Manual approval
- Deployment concurrency controls
- Deployment smoke tests
- Documented rollback steps
