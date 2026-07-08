# Sprint 1 - Authentication and User Profiles

## Goal

Allow users to register, sign in, sign out, and view their kino2000 profile.

## Features

- Configure Microsoft Entra External ID
- Add account registration
- Add login
- Add logout
- Preserve authentication state across page refreshes
- Add protected React routes
- Add protected API endpoints
- Validate access tokens in the API
- Automatically create an application profile on first login
- Add a private user profile page
- Add empty ratings and favourites sections
- Add authentication and profile tests

## Acceptance Criteria

- A new user can create an account.
- A registered user can log in and log out.
- Protected routes require authentication.
- Unauthenticated API requests return an appropriate error.
- The API derives the user identity from the validated token.
- Users cannot submit another user's identifier to access data.
- A profile is created only once for each authenticated user.
- The profile displays basic user information.
- Ratings and favourites sections display appropriate empty states.
- Authentication and profile behaviour is covered by automated tests.

## Deferred

- Public profiles
- Profile editing
- Avatars
- Followers
- Reviews
- Activity feeds

