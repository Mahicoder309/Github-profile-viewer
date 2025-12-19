# GitHub Profile Viewer - API Documentation

## Overview

This app uses the GitHub REST API v3 to fetch public user profiles and repository information. All requests are made over HTTPS with proper error handling and rate limit management.

## Base URL

```
https://api.github.com
```

## Authentication

### Optional GitHub Personal Access Token

For higher rate limits, you can authenticate with a Personal Access Token:

```dart
GithubApiService(token: 'ghp_YOUR_TOKEN_HERE')
```

## Rate Limiting

GitHub API implements rate limiting per IP address or user:

### Rate Limits:
- **Unauthenticated**: 60 requests/hour per IP
- **Authenticated**: 5,000 requests/hour per token

### Rate Limit Headers:
- `X-RateLimit-Limit`: Total allowed requests
- `X-RateLimit-Remaining`: Requests remaining
- `X-RateLimit-Reset`: Unix timestamp of rate limit reset

## API Endpoints

### 1. Get User Profile

**Endpoint**: `GET /users/{username}`

**Description**: Fetch public profile information for a GitHub user

**Parameters**:
| Name | Type | Required | Description |
|------|------|----------|-------------|
| username | string | Yes | GitHub username to fetch |

**Response** (200 OK):
```json
{
  "login": "torvalds",
  "id": 1024454,
  "avatar_url": "https://avatars.githubusercontent.com/u/1024454?v=4",
  "html_url": "https://github.com/torvalds",
  "type": "User",
  "name": "Linus Torvalds",
  "company": null,
  "blog": "",
  "location": "Portland, Oregon",
  "bio": null,
  "public_repos": 2,
  "followers": 200000,
  "following": 0,
  "created_at": "2011-09-03T15:26:28Z",
  "updated_at": "2024-12-18T10:30:00Z"
}
```

**Error Responses**:
- `404 Not Found`: User does not exist
- `403 Forbidden`: Rate limit exceeded
- `500 Server Error`: GitHub API server error

**Dart Implementation**:
```dart
final user = await apiService.searchUser('torvalds');
print(user.name); // "Linus Torvalds"
```

### 2. List User Repositories

**Endpoint**: `GET /users/{username}/repos`

**Description**: Fetch all public repositories for a user

**Parameters**:
| Name | Type | Default | Description |
|------|------|---------|-------------|
| username | string | - | GitHub username |
| page | integer | 1 | Page number for pagination |
| per_page | integer | 30 | Repos per page (max 100) |
| sort | string | "updated" | Sort by: updated, created, pushed, full_name |
| direction | string | "desc" | Sort direction: asc, desc |

**Query Example**:
```
GET /users/torvalds/repos?page=1&per_page=30&sort=updated&direction=desc
```

**Response** (200 OK):
```json
[
  {
    "id": 1234567,
    "name": "linux",
    "full_name": "torvalds/linux",
    "description": "Linux kernel source tree",
    "html_url": "https://github.com/torvalds/linux",
    "private": false,
    "language": "C",
    "stargazers_count": 150000,
    "forks_count": 50000,
    "open_issues_count": 500,
    "created_at": "2011-09-04T00:11:24Z",
    "updated_at": "2024-12-18T10:00:00Z",
    "pushed_at": "2024-12-18T09:30:00Z"
  }
]
```

**Pagination**:
- Default: 30 repositories per page
- Maximum per_page: 100
- Example: Get page 2 with 50 items
  ```
  GET /users/{username}/repos?page=2&per_page=50
  ```

**Dart Implementation**:
```dart
final repos = await apiService.getUserRepositories('torvalds', page: 1, perPage: 30);
for (var repo in repos) {
  print('${repo.name}: ${repo.stars} stars');
}
```

## Error Handling

### API Exception Hierarchy

```dart
ApiException
├── UserNotFoundException (404)
├── RateLimitException (403)
├── NetworkException (Network errors)
├── TimeoutException (Request timeout > 10s)
└── Generic ApiException (Other errors)
```

### Error Response Examples

**404 Not Found**:
```json
{
  "message": "Not Found",
  "documentation_url": "https://docs.github.com/rest/reference/users#get-a-user"
}
```

**403 Forbidden (Rate Limit)**:
```json
{
  "message": "API rate limit exceeded",
  "documentation_url": "https://docs.github.com/rest/overview/resources-in-the-rest-api#rate-limiting"
}
```

### Error Handling Example

```dart
try {
  final user = await apiService.searchUser('username');
} on UserNotFoundException catch (e) {
  print('User not found: ${e.message}');
} on RateLimitException catch (e) {
  print('Rate limit exceeded. ${e.message}');
  print('Reset time: ${e.rateLimit?.resetTime}');
} on NetworkException catch (e) {
  print('Network error: ${e.message}');
} on TimeoutException catch (e) {
  print('Request timed out: ${e.message}');
} on ApiException catch (e) {
  print('API error: ${e.message}');
}
```

## Request Headers

All API requests include the following headers:

```
Accept: application/vnd.github.v3+json
User-Agent: GithubProfileViewer/1.0
Authorization: token <YOUR_TOKEN> (optional)
```

## Response Headers

Important response headers:

```
X-RateLimit-Limit: 60
X-RateLimit-Remaining: 45
X-RateLimit-Reset: 1608000000
Content-Type: application/json; charset=utf-8
```

## Data Models

### GithubUser Model

```dart
class GithubUser {
  final String login;           // Username
  final int id;                 // User ID
  final String avatarUrl;       // Avatar URL
  final String profileUrl;      // GitHub profile URL
  final String name;            // Display name
  final String? bio;            // User bio
  final String? location;       // Location
  final String? company;        // Company
  final String? blog;           // Website
  final int publicRepos;        // Public repo count
  final int followers;          // Follower count
  final int following;          // Following count
  final DateTime createdAt;     // Account creation date
  final DateTime updatedAt;     // Last profile update
}
```

### GithubRepository Model

```dart
class GithubRepository {
  final int id;                 // Repository ID
  final String name;            // Repository name
  final String description;     // Repository description
  final String url;             // Repository URL
  final String language;        // Primary language
  final int stars;              // Star count
  final int forks;              // Fork count
  final int openIssues;         // Open issues count
  final DateTime createdAt;     // Creation date
  final DateTime updatedAt;     // Last update
}
```

### RateLimitInfo Model

```dart
class RateLimitInfo {
  final int limit;              // Total requests allowed
  final int remaining;          // Requests remaining
  final int reset;              // Reset time (Unix timestamp)
  
  DateTime get resetTime;       // Convert to DateTime
  bool get isLimited;           // Check if rate limited
}
```

## Usage Examples

### Search User and Get Repositories

```dart
final apiService = GithubApiService();

// Search user
final user = await apiService.searchUser('google');
print('User: ${user.name}');
print('Repos: ${user.publicRepos}');
print('Followers: ${user.followers}');

// Get repositories
final repos = await apiService.getUserRepositories('google', perPage: 100);
for (var repo in repos) {
  print('- ${repo.name} (${repo.language}) ⭐ ${repo.stars}');
}

// Get language statistics
final langStats = await apiService.getUserLanguageStats('google');
print('Languages: $langStats');
```

### With Provider State Management

```dart
final provider = GithubProvider();

// Search (includes loading state)
await provider.searchUser('torvalds');

// Check results
if (provider.error != null) {
  print('Error: ${provider.error}');
} else {
  print('User: ${provider.currentUser?.name}');
  print('Repos: ${provider.repositories.length}');
}

// Check rate limit
if (provider.rateLimit?.isLimited ?? false) {
  print('Rate limit exceeded!');
  print('Reset: ${provider.rateLimit?.resetTime}');
}
```

### Using GitHub Token

```dart
// Create service with token for higher rate limits
final apiService = GithubApiService(token: 'ghp_YOUR_TOKEN');

// Rest of the code is identical
final user = await apiService.searchUser('linus');
```

## API Response Time

Typical response times:
- **Get User Profile**: 200-500ms
- **List Repositories (30 items)**: 500-1000ms
- **List Repositories (100 items)**: 1000-2000ms
- **Language Statistics**: 1000-2000ms

## Best Practices

### 1. Rate Limit Management
```dart
// Check rate limit before making requests
if (apiService.lastRateLimit?.isLimited ?? false) {
  print('Rate limit exceeded. Try again later.');
  return;
}
```

### 2. Implement Caching
```dart
// Cache user data to minimize API calls
final cachedUsers = <String, GithubUser>{};

GithubUser? getUser(String username) {
  return cachedUsers[username];
}

void cacheUser(GithubUser user) {
  cachedUsers[user.login] = user;
}
```

### 3. Handle Network Errors
```dart
try {
  final user = await apiService.searchUser(username);
} catch (e) {
  if (e is NetworkException) {
    // Handle network error
  } else if (e is TimeoutException) {
    // Handle timeout
  }
  // Retry or show error to user
}
```

### 4. Pagination for Large Lists
```dart
// Load repositories in pages
List<GithubRepository> allRepos = [];
for (int page = 1; page <= 10; page++) {
  final repos = await apiService.getUserRepositories(
    username,
    page: page,
    perPage: 100,
  );
  if (repos.isEmpty) break;
  allRepos.addAll(repos);
}
```

## Troubleshooting

### Issue: "Rate limit exceeded"
- **Solution**: Wait for reset time or use authenticated token
- **Check**: `rateLimit?.resetTime`

### Issue: "User not found"
- **Solution**: Verify username spelling and case sensitivity
- **Note**: GitHub usernames are case-insensitive but URLs are case-sensitive

### Issue: Network timeout
- **Cause**: Poor internet connection or GitHub API slow
- **Solution**: Retry after a few seconds

### Issue: Empty repository list
- **Cause**: User might have no public repositories
- **Note**: Private repositories are not returned (without auth)

## References

- [GitHub REST API Documentation](https://docs.github.com/en/rest)
- [GitHub Users API](https://docs.github.com/en/rest/users/users)
- [GitHub Repositories API](https://docs.github.com/en/rest/repos/repos)
- [GitHub Rate Limiting](https://docs.github.com/en/rest/rate-limit)
- [GitHub Authentication](https://docs.github.com/en/rest/authentication)

## Rate Limit Costs

Most endpoints cost 1 request per call. Some complex queries might cost more. Check response headers for exact limit information.

## Version

- API Version: v3
- Last Updated: December 18, 2024
- Compatibility: GitHub Personal Accounts & Organizations
