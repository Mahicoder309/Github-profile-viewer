# GitHub Profile Viewer - Setup Guide

## Quick Start

### 1. Prerequisites
- Flutter 3.0.0 or higher
- Dart SDK (included with Flutter)
- Git
- Android Studio/Xcode or VS Code with Flutter extension

### 2. Installation Steps

```bash
# Navigate to project directory
cd github_profile_viewer

# Get dependencies
flutter pub get

# Run the app (choose a connected device or emulator)
flutter run
```

### 3. First Run

1. The app will open with an empty state
2. Enter any GitHub username in the search box
3. Press Enter or tap the search icon
4. The app will fetch and display the user's profile

### 4. Optional: Use GitHub Token

For higher API rate limits (5,000 vs 60 requests/hour):

1. Generate a token at https://github.com/settings/tokens/new
   - Select `public_repo` scope only
   - Copy the token

2. In `lib/main.dart`, replace:
   ```dart
   ChangeNotifierProvider(
     create: (_) => GithubProvider(),
   ),
   ```
   
   With:
   ```dart
   ChangeNotifierProvider(
     create: (_) => GithubProvider(
       apiService: GithubApiService(token: 'ghp_YOUR_TOKEN_HERE'),
     ),
   ),
   ```

3. Run the app again with `flutter run`

## Testing Different Scenarios

### Test Searches:
- Valid user: `torvalds` (Linus Torvalds)
- Valid user: `gvanrossum` (Guido van Rossum)
- Invalid user: `this_user_does_not_exist_12345`

### Expected Behaviors:

**Valid User:**
- Profile card displays
- Stats show (repos, followers, following)
- Repository list populated
- Language statistics shown

**Invalid User:**
- Error message displayed
- "User not found" message
- UI returns to empty state

**Rate Limited:**
- Banner shows "Rate limit exceeded"
- Remaining requests shown
- Reset time displayed
- Try again after rate limit reset

## Troubleshooting

### Issue: Dependencies fail to install
```bash
flutter clean
flutter pub get
```

### Issue: iOS build fails
```bash
cd ios
rm -rf Pods Podfile.lock
cd ..
flutter clean
flutter pub get
flutter run
```

### Issue: Android build fails
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: App crashes on startup
- Ensure Flutter SDK is updated: `flutter upgrade`
- Check Dart version: `dart --version`
- Run: `flutter doctor` to diagnose issues

## API Rate Limit Info

### Without Token (Anonymous):
- 60 requests per hour
- Rate limit resets every hour

### With Token:
- 5,000 requests per hour
- More reliable for frequent usage

### How to Check Rate Limit:
- Banner at top of app shows current status
- Format: "X/60 requests remaining"
- Displays when rate limit is low

## Development Tips

### Hot Reload During Development:
- Save a file and press `R` in terminal
- Changes appear instantly (most of the time)

### Hot Restart:
- Press `Shift+R` in terminal
- Full app restart (slower but more reliable)

### Debug Mode:
- Default when running `flutter run`
- Slower but with debugging tools

### Release Mode:
- `flutter run --release`
- Optimized performance
- No debugging

### Device Testing:
```bash
# List connected devices
flutter devices

# Run on specific device
flutter run -d device_id
```

## Common Test Cases

### TC1: Basic Search
1. Enter username: `google`
2. Expected: Google's profile displays with multiple repos

### TC2: User with Repositories
1. Enter username: `facebook`
2. Expected: Shows many repositories in React, JavaScript

### TC3: Invalid User
1. Enter username: `xyz123notauser`
2. Expected: Error message appears

### TC4: Network Timeout
1. Turn off internet
2. Try to search
3. Expected: Network error message

### TC5: Rate Limit Testing
1. Search same user 61 times rapidly
2. On 61st request: Rate limit message appears

## File Structure Reference

- `lib/main.dart` - App entry point
- `lib/screens/home_screen.dart` - Main UI
- `lib/services/github_api_service.dart` - API calls
- `lib/services/github_provider.dart` - State management
- `lib/models/` - Data models
- `lib/widgets/` - Reusable components
- `pubspec.yaml` - Dependencies

## Performance Notes

- First repository load: ~500-2000ms (network dependent)
- Subsequent searches: Cached images load faster
- Language stats calculated from repository list
- Scrolling is smooth with 60 FPS target

## Platform-Specific Notes

### Android
- Minimum SDK: 21
- Target SDK: 33
- Supports Android 5.0+

### iOS
- Minimum: iOS 11.0
- Target: iOS 17.0
- Requires Xcode 14+

## Next Steps

1. Explore the code structure
2. Try searching for different users
3. Test with a GitHub token for better limits
4. Customize themes in `lib/main.dart`
5. Modify UI in `lib/widgets/` and `lib/screens/`

Happy exploring! 🚀
