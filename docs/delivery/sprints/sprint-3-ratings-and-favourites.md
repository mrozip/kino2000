# Sprint 3 - Ratings and Favourites

## Goal

Allow authenticated users to rate movies and add them to favourites.

## Features

- Add rating API endpoints
- Allow integer ratings from 1 to 10
- Allow ratings to be updated
- Allow ratings to be removed
- Add favourite API endpoints
- Allow favourites to be added and removed
- Store ratings and favourites against the authenticated user
- Store a small movie metadata snapshot with each activity record
- Display the current user's rating on movie pages
- Display the current favourite state on movie pages
- Show sign-in prompts to unauthenticated users
- Display ratings on the profile page
- Display favourites on the profile page
- Link profile entries back to movie pages
- Add integration tests for ratings and favourites

## Example API Endpoints

```http
PUT    /api/me/movies/:imdbId/rating
DELETE /api/me/movies/:imdbId/rating
PUT    /api/me/movies/:imdbId/favourite
DELETE /api/me/movies/:imdbId/favourite
```

## Acceptance Criteria

- Only authenticated users can rate or favourite movies.
- Ratings accept integers from 1 to 10.
- Submitting another rating updates the existing rating.
- Removing a rating does not remove favourite state.
- Removing a favourite does not remove rating state.
- Favourite actions are idempotent.
- The user ID is taken from the validated access token.
- Ratings and favourites appear on the user's profile.
- Profile entries link to their related movie pages.
- Cross-user access is rejected.
- Core rating and favourite flows are covered by integration tests.

