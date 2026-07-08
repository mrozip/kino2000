# Security Requirements

The project should include the following security baseline:

- GitHub OIDC for Azure authentication
- No Azure client secrets stored in GitHub
- No OMDb API key exposed to the browser
- No Terraform state committed
- Dependabot enabled
- GitHub secret scanning enabled
- CodeQL enabled
- Least-privilege Azure roles
- API input validation
- User identity derived from validated access tokens
- Restricted CORS configuration
- Secure application configuration
- Basic API throttling
- Consistent error responses
- No sensitive information written to logs

The application must never log:

- Access tokens
- Authentication headers
- OMDb API keys
- Cosmos DB keys
- Azure credentials
- Full identity claims
- Sensitive application configuration

