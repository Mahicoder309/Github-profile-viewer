# Testing Guide - GitHub Profile Viewer

## Test Scenarios

This guide provides comprehensive test scenarios to validate all features of the GitHub Profile Viewer app.

## Test Users

### Valid Test Users

| Username | Profile Type | Expected Repos | Features |
|----------|--------------|-----------------|----------|
| `torvalds` | Individual | ~2 | Minimal profile |
| `google` | Organization | 1000+ | Large profile |
| `microsoft` | Organization | 500+ | Many repos |
| `facebook` | Organization | 100+ | Medium profile |
| `gvanrossum` | Individual | ~5 | Creator of Python |
| `brendangregg` | Individual | 50+ | Performance tools |
| `evanwonder` | Individual | ~1 | Minimal repos |

## Test Case Categories

### TC1: Basic Search Functionality

#### TC1.1: Valid User Search
```
Steps:
1. Open app
2. Enter username: "torvalds"
3. Press Enter

Expected Result:
- Profile card appears
- Avatar loads correctly
- Username: torvalds
- Full name displays
- Stats show (repos, followers, following)
- Repositories list appears
```

#### TC1.2: Search Different Valid Users
```
Steps:
1. Enter username: "google"
2. Press Enter
3. Wait for loading

Expected Result:
- Organization profile displays
- Multiple repositories listed (1000+)
- All stats populated correctly
```

#### TC1.3: Invalid Username
```
Steps:
1. Enter username: "xyz123notarealuser"
2. Press Enter

Expected Result:
- Error message appears: "User not found"
- No profile card displayed
- Empty state message shows
```

#### TC1.4: Empty Search
```
Steps:
1. Leave search box empty
2. Press Enter

Expected Result:
- No action taken
- Empty state remains
```

### TC2: User Profile Display

#### TC2.1: Profile Card Elements
```
Steps:
1. Search for valid user (e.g., "torvalds")
2. Observe profile card

Expected Result:
- Circular avatar image loads
- Username (@login) displays
- Full name displays
- Follower/Following/Repository counts show
- Stats are clickable (optional)
- View on GitHub button present
```

#### TC2.2: Profile Information
```
Steps:
1. Search "google"
2. Check profile details

Expected Result:
- Company information visible
- Location displayed (if available)
- Bio/description shown (if available)
- Website link present (if available)
```

#### TC2.3: Missing Profile Info
```
Steps:
1. Search "torvalds" (minimal profile)
2. Check for empty fields

Expected Result:
- Empty fields gracefully hidden
- No placeholder text for missing data
- Layout remains clean
```

### TC3: Repository Listing

#### TC3.1: Repository Cards Display
```
Steps:
1. Search "google"
2. Scroll repository list

Expected Result:
- Each repo shows name, description
- Language badge visible
- Star count displayed
- Fork count displayed
- Issues count displayed
- Cards are tappable
```

#### TC3.2: Repository Scrolling
```
Steps:
1. Search "microsoft"
2. Scroll to bottom of list
3. Continue scrolling

Expected Result:
- Smooth scrolling performance
- All repositories visible
- No lag or stuttering
```

#### TC3.3: No Repositories
```
Steps:
1. Search user with 0 public repos
2. Observe repository section

Expected Result:
- "No public repositories found" message
- No error displayed
- App handles gracefully
```

#### TC3.4: Open Repository
```
Steps:
1. Search "google"
2. Tap on any repository card

Expected Result:
- Browser/GitHub app opens
- Correct repository URL opens
- Returns to app properly
```

### TC4: Language Statistics

#### TC4.1: Language Display
```
Steps:
1. Search "google"
2. Look for language statistics

Expected Result:
- Section titled "Language Statistics"
- Multiple language chips displayed
- Each shows language name and count
- Languages properly counted
```

#### TC4.2: Language Accuracy
```
Steps:
1. Search user with known languages
2. Check language count

Expected Result:
- Counts match actual repositories
- All languages represented
- No duplicate languages
```

### TC5: Rate Limiting

#### TC5.1: Rate Limit Banner Display
```
Steps:
1. Open app
2. Perform search

Expected Result:
- Banner appears at top
- Shows "API Rate Limit"
- Displays remaining requests
- Shows total limit (60 or 5000)
```

#### TC5.2: Rate Limit Low Warning
```
Steps:
1. Make many rapid searches
2. Get remaining count below 10

Expected Result:
- Banner shows warning
- Clear message about low limit
- User advised to wait
```

#### TC5.3: Rate Limit Exceeded
```
Steps:
1. Make 60+ searches rapidly (no token)
2. Attempt one more search

Expected Result:
- Error: "Rate limit exceeded"
- Banner turns red
- Reset time displayed
- User instructed to try later
```

### TC6: Error Handling

#### TC6.1: Network Error
```
Steps:
1. Turn off internet
2. Attempt search

Expected Result:
- Network error message
- User advised to check connection
- App doesn't crash
- Graceful error display
```

#### TC6.2: Request Timeout
```
Steps:
1. Use very slow network
2. Search user

Expected Result:
- After 10 seconds, timeout error
- User can retry
- App responsive
```

#### TC6.3: Server Error
```
Steps:
1. GitHub API temporarily down
2. Attempt search

Expected Result:
- Server error message
- Appropriate error code shown
- User can retry
```

#### TC6.4: Invalid Username Format
```
Steps:
1. Enter special characters: "user@#$%"
2. Press Enter

Expected Result:
- Search processed as-is
- GitHub decides validity
- Error shown if invalid
```

### TC7: UI/UX

#### TC7.1: Loading State
```
Steps:
1. Search user
2. Observe loading

Expected Result:
- Loading spinner appears
- Search box disabled
- Clear loading indication
- Spinner stops when complete
```

#### TC7.2: Empty State
```
Steps:
1. Open app fresh
2. Observe initial state

Expected Result:
- Centered empty state message
- Search icon displayed
- "Search for a GitHub user" text
- Inviting appearance
```

#### TC7.3: Responsive Design
```
Steps:
1. Rotate device
2. Change window size

Expected Result:
- UI adapts properly
- All content visible
- No overflow or cut-off
- Cards reflow appropriately
```

#### TC7.4: Dark Mode
```
Steps:
1. Enable system dark mode
2. Open app

Expected Result:
- Dark theme applied
- Text readable
- Colors adjusted properly
- No harsh contrast
```

### TC8: Search Functionality

#### TC8.1: Clear Button
```
Steps:
1. Enter text in search
2. Click clear button

Expected Result:
- Text cleared
- Previous results persist
- Ready for new search
```

#### TC8.2: Enter Key Press
```
Steps:
1. Enter username
2. Press Enter key

Expected Result:
- Search initiated
- Results displayed
- No double-search
```

#### TC8.3: Search Button
```
Steps:
1. Enter username
2. Look for search action

Expected Result:
- Enter key triggers search
- Search box shows clear indication
```

#### TC8.4: Case Insensitivity
```
Steps:
1. Search "TORVALDS"
2. Search "torvalds"
3. Search "ToRVaLDs"

Expected Result:
- All return same user
- GitHub handles case-insensitivity
```

### TC9: Performance

#### TC9.1: First Load Time
```
Steps:
1. Open app fresh
2. Time to display UI

Expected Result:
- Less than 2 seconds
- Responsive feel
```

#### TC9.2: Search Response Time
```
Steps:
1. Search popular user
2. Time to results

Expected Result:
- Less than 3 seconds
- Acceptable for user
- Progress indication visible
```

#### TC9.3: Scroll Performance
```
Steps:
1. Search user with many repos
2. Rapidly scroll list

Expected Result:
- Smooth 60 FPS
- No lag
- No dropped frames
```

#### TC9.4: Image Loading
```
Steps:
1. Search users
2. Observe avatar loads

Expected Result:
- Avatar loads quickly
- Cached for repeat searches
- No loading artifacts
```

### TC10: API Integration

#### TC10.1: Correct API Endpoint
```
Steps:
1. Search user
2. Inspect network calls

Expected Result:
- Calls to api.github.com
- Correct endpoint path
- Proper headers sent
- HTTPS used
```

#### TC10.2: Response Parsing
```
Steps:
1. Search multiple users
2. Verify data accuracy

Expected Result:
- Data matches GitHub
- Numbers correct
- Dates proper format
```

#### TC10.3: Rate Limit Headers
```
Steps:
1. Search user
2. Check rate limit info

Expected Result:
- Headers read correctly
- Remaining count accurate
- Reset time correct
```

## Test Data

### Quick Test Users
```
- torvalds (Linux creator)
- gvanrossum (Python creator)
- google (Large org)
- facebook (Large org)
- microsoft (Large org)
```

### Edge Cases
```
- User with no repos: [look for recent inactive user]
- User with 1000+ repos: "google"
- User with no followers: [rare, minimal user]
- User with no bio: Most users
- User with many organizations: "google"
```

## Automated Testing (Unit Tests)

### Model Tests
```dart
test('GithubUser.fromJson parses correctly', () {
  // Test JSON parsing
});

test('GithubRepository.fromJson parses correctly', () {
  // Test JSON parsing
});
```

### API Service Tests
```dart
test('searchUser returns valid user', () async {
  // Mock HTTP and test
});

test('searchUser throws on 404', () async {
  // Test error handling
});

test('getUserRepositories paginates', () async {
  // Test pagination
});
```

### Provider Tests
```dart
test('GithubProvider updates on search', () async {
  // Test state changes
});

test('GithubProvider handles errors', () async {
  // Test error states
});
```

## Test Execution Checklist

- [ ] All TC1 tests pass
- [ ] All TC2 tests pass
- [ ] All TC3 tests pass
- [ ] All TC4 tests pass
- [ ] All TC5 tests pass
- [ ] All TC6 tests pass
- [ ] All TC7 tests pass
- [ ] All TC8 tests pass
- [ ] All TC9 tests pass
- [ ] All TC10 tests pass
- [ ] Performance acceptable
- [ ] No crashes observed
- [ ] Error messages clear
- [ ] UI responsive

## Known Limitations

- Can only view public repositories
- Cannot view private repositories (without auth)
- Cannot view user commits/activities
- Cannot view issues or pull requests
- Search is by exact username (no prefix search)

## Future Testing

- [ ] Multi-language support
- [ ] Offline mode
- [ ] User favorites
- [ ] Advanced filtering
- [ ] Contribution graphs

---

**Last Updated**: December 18, 2024
