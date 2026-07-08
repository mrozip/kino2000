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

## Production Deployment

Production should be introduced only after the core movie-tracking functionality is stable.

Production deployment should require:

- A release tag or manual release workflow
- A protected GitHub environment
- Manual approval
- Deployment concurrency controls
- Deployment smoke tests
- Documented rollback steps
