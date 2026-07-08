# Initial Data Model

The initial Cosmos DB model should support the earliest application flows:

- Authenticated user profiles
- Ratings
- Favourites
- Movie metadata snapshots required for profile display

Passwords and authentication credentials must not be stored in Cosmos DB.

## User Profile

A user profile will be linked to the authenticated Microsoft Entra identity.

```json
{
  "id": "entra-user-id",
  "type": "user",
  "username": "example-user",
  "displayName": "Example User",
  "bio": "",
  "createdAt": "2026-07-08T10:00:00Z",
  "updatedAt": "2026-07-08T10:00:00Z"
}
```

## User Movie Activity

Ratings and favourite state should initially be stored in a single user movie activity record.

```json
{
  "id": "movie:tt0111161",
  "type": "movieActivity",
  "userId": "entra-user-id",
  "imdbId": "tt0111161",
  "title": "The Shawshank Redemption",
  "year": "1994",
  "posterUrl": "https://example.com/poster.jpg",
  "rating": 9,
  "isFavourite": true,
  "createdAt": "2026-07-08T10:00:00Z",
  "updatedAt": "2026-07-08T10:00:00Z"
}
```

The initial partition key should be based on `userId`, because the main early queries will retrieve ratings and favourites for a specific user.

## Later Data

Later data may include:

- Public profiles
- Follower relationships
- Reviews
- Activity feeds

