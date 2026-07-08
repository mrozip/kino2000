# Sprint 2 - OMDb Search and Movie Pages

## Goal

Allow users to search for movies using the OMDb API and open dedicated movie pages.

## Features

- Create a backend OMDb API client
- Store the OMDb API key in backend configuration
- Add a movie search API endpoint
- Validate search queries
- Support result pagination
- Map OMDb responses to internal application models
- Add a search interface to the homepage
- Add loading, error, and empty-result states
- Display movie title, year, type, and poster
- Add fallback images for missing posters
- Add dedicated movie routes
- Add movie detail API endpoint
- Add dedicated movie detail pages
- Add basic request throttling or search debouncing
- Add mocked OMDb tests

## Example Routes

```text
/
/movies/:imdbId
```

## Example API Endpoints

```http
GET /api/movies/search?query=alien&page=1
GET /api/movies/:imdbId
```

## Acceptance Criteria

- Users can search for movies by title.
- Search results are returned through the kino2000 backend API.
- The browser never receives the OMDb API key.
- Search results link to dedicated movie pages.
- Refreshing a movie page does not break routing.
- Invalid movie identifiers show a not-found state.
- Upstream OMDb errors are handled consistently.
- Missing posters use a local placeholder.
- Search requests are controlled to avoid unnecessary API usage.
- OMDb responses are covered by mocked tests.

