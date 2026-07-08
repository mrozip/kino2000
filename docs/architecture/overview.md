# Architecture Overview

kino2000 should remain a small, modular application that demonstrates good engineering and DevOps practices without unnecessary platform complexity.

## Front End

Use:

- React
- TypeScript
- Vite
- React Router
- Azure Static Web Apps hosting

The front end will provide:

- Authentication controls
- Movie search
- Movie detail pages
- User profiles
- Ratings and favourites
- Later social features
- Admin panel

## Authentication

Use Microsoft Entra External ID for customer authentication.

It will handle:

- Account registration
- Login
- Logout
- Password reset
- Identity tokens

The application database will store user profile and movie activity data, but it will not store passwords or manage authentication credentials directly.

## Backend API

Use Azure Functions with Node.js and TypeScript.

The API will handle:

- Protected application endpoints
- OMDb API requests
- User profile operations
- Ratings
- Favourites
- Later social functionality

The React application must not call the OMDb API directly. The backend API will act as a controlled proxy so the OMDb API key is not exposed to users.

## Database

Use Azure Cosmos DB for NoSQL.

Initial data will include:

- Application user profiles
- Movie ratings
- Favourite movies
- Cached movie metadata required for profile display

See [initial data model](data-model.md) for the first proposed documents and partitioning guidance.

