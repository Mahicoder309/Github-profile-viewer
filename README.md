# GitHub Profile Viewer 🚀

A beautiful Flutter mobile application that allows users to search for any GitHub username and view their profile details and public repositories using the GitHub REST API.

## Features ✨

- **Search GitHub Users**: Quickly search for any GitHub user by username
- **Profile Details**: View comprehensive user profile information including:
  - Avatar and name
  - Bio, location, and company
  - Follower/Following counts
  - Public repositories count
  - Account creation date
- **Repository Listing**: Browse all public repositories with:
  - Repository name and description
  - Primary programming language
  - Star count, forks, and open issues
  - Quick links to GitHub repository
- **Language Statistics**: See a breakdown of programming languages used
- **Rate Limit Handling**: Displays current API rate limit status
- **Error Handling**: Comprehensive error messages for network issues, rate limits, and user not found
- **Responsive Design**: Beautiful Material 3 UI with light/dark mode support
- **URL Launching**: Open GitHub profiles and repositories directly from the app

## Project Structure 📁

```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── github_user.dart     # GitHub user model
│   ├── github_repository.dart # Repository model
│   ├── rate_limit_info.dart # Rate limit model
│   └── index.dart           # Models barrel export
├── services/
│   ├── github_api_service.dart   # GitHub REST API service
│   ├── github_provider.dart      # State management provider
│   └── index.dart               # Services barrel export
├── screens/
│   ├── home_screen.dart    # Main home screen
│   └── index.dart          # Screens barrel export
└── widgets/
    ├── search_bar.dart           # Search input widget
    ├── user_profile_card.dart    # User profile display
    ├── repository_card.dart      # Repository list item
    ├── rate_limit_banner.dart    # Rate limit indicator
    └── index.dart               # Widgets barrel export
```

## Dependencies 📦

- **http**: HTTP client for API requests
- **provider**: State management solution
- **cached_network_image**: Efficient image loading and caching
- **url_launcher**: Open URLs in browser or GitHub app
- **intl**: Internationalization and date formatting

## Getting Started 🛠️

### Prerequisites

- Flutter SDK 3.0.0 or higher
- Dart SDK (included with Flutter)
- Android Studio, Xcode, or preferred IDE

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd github_profile_viewer
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Optional: Using GitHub Personal Access Token

For higher API rate limits (5,000 requests/hour instead of 60), you can use a GitHub Personal Access Token:

1. Go to [GitHub Settings → Developer settings → Personal access tokens](https://github.com/settings/tokens)
2. Create a new token with `public_repo` scope
3. In `lib/main.dart`, uncomment and update:
   ```dart
   apiService: GithubApiService(token: 'your_github_token_here'),
   ```

## API Details 📡

### GitHub REST API Endpoints

The app uses the following GitHub REST API endpoints:

- **Search User**: `GET /users/{username}`
  - Get public profile information for a user
  
- **List Repositories**: `GET /users/{username}/repos`
  - Get list of public repositories
  - Supports pagination with `page` and `per_page` parameters
  - Sorted by update date (most recent first)

### Rate Limiting

The app automatically handles GitHub API rate limits:

- **Anonymous**: 60 requests/hour
- **Authenticated**: 5,000 requests/hour

Rate limit information is displayed in the UI with:
- Current remaining requests
- Rate limit reset time
- Warning when limit is exceeded

### Request Headers

All requests include proper headers:
- `Accept: application/vnd.github.v3+json` - API version
- `User-Agent: GithubProfileViewer/1.0` - App identification
- `Authorization: token <YOUR_TOKEN>` - (Optional) GitHub token for higher limits

### Error Handling

The app gracefully handles various error scenarios:

- **User Not Found (404)**: Displays "User not found" message
- **Rate Limited (403)**: Shows rate limit exceeded with reset information
- **Network Errors**: Displays network connectivity errors
- **Timeout (10s)**: Request timeout handling
- **Server Errors (5xx)**: Generic error messages

## Features in Detail 🎯

### Search Functionality
- Real-time search with loading indicator
- Enter username and press Enter or use submit button
- Clear button for quick search reset
- Disabled state while loading

### User Profile Display
- Circular avatar with network image caching
- Full name and GitHub handle
- Bio and location information
- Company and website links
- Stats: Repositories, Followers, Following
- Direct link to GitHub profile

### Repository Browser
- Scrollable list of public repositories
- Repository metadata:
  - Name with GitHub link
  - Description (truncated to 2 lines)
  - Primary programming language (color-coded)
  - Star count
  - Fork count
  - Open issues count
- Tap to open repository on GitHub

### Language Statistics
- Breakdown of programming languages used across repositories
- Count of repositories per language
- Visual display with chips

## Troubleshooting 🔧

### Rate Limit Exceeded
- Wait for the rate limit to reset (typically 1 hour)
- Use a GitHub Personal Access Token for higher limits
- Check the rate limit banner for reset time

### Image Loading Issues
- Check internet connectivity
- The app uses cached network image for efficient loading
- Images are cached after first load

### Search Not Working
- Verify the username is correct
- Check GitHub user exists at https://github.com/[username]
- Check your internet connection
- Verify GitHub API is accessible

### Build Issues on Different Platforms

**iOS:**
```bash
flutter clean
cd ios
rm -rf Pods
rm Podfile.lock
cd ..
flutter pub get
flutter run
```

**Android:**
```bash
flutter clean
flutter pub get
flutter run
```

## Development 💻

### Building for Release

**Android:**
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

### Adding GitHub Token Support

To support token-based authentication:

1. Add a settings screen
2. Store token securely using `flutter_secure_storage`
3. Pass token to `GithubApiService` during initialization

## API Documentation References 📚

- [GitHub REST API Documentation](https://docs.github.com/en/rest)
- [GitHub Users API](https://docs.github.com/en/rest/users/users)
- [GitHub Repositories API](https://docs.github.com/en/rest/repos)
- [GitHub Rate Limiting](https://docs.github.com/en/rest/rate-limit)

## Performance Optimization 🚄

- **Image Caching**: Network images are cached locally
- **Lazy Loading**: Repositories loaded on-demand
- **Provider Pattern**: Efficient state management
- **Rate Limit Awareness**: Minimizes unnecessary API calls

## Future Enhancements 🔮

- User authentication with OAuth
- Starred repositories view
- User followers/following browser
- Repository search and filtering
- Gist viewing
- Issues and pull requests viewer
- Contribution graph visualization
- Offline support with local caching
- Dark mode refinements
- Widget customization options

## Security Considerations 🔒

- Never commit GitHub tokens to version control
- Use environment variables or secure storage for tokens
- The app only requests public data
- All API calls use HTTPS
- No sensitive data is stored locally

## Contributing 🤝

Contributions are welcome! Please feel free to submit a Pull Request.

## License 📄

This project is open source and available under the MIT License.

## Support 💬

For issues or questions:
- Open an issue on GitHub
- Check existing issues for solutions
- Refer to Flutter and GitHub API documentation

## Acknowledgments 🙏

- Built with [Flutter](https://flutter.dev)
- Uses [GitHub REST API](https://docs.github.com/en/rest)
- Icons from Flutter Material Icons
- Theme inspiration from Material Design 3

---

**Happy coding!** 🎉
