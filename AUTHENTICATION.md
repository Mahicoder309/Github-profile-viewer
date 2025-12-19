# GitHub Authentication & Tokens Guide

## Getting Higher API Rate Limits

By default, GitHub allows 60 API requests per hour for unauthenticated requests. To increase this to 5,000 requests per hour, you need to authenticate using a Personal Access Token.

## Creating a GitHub Personal Access Token

### Step 1: Navigate to GitHub Settings
1. Go to https://github.com/settings/tokens/new
2. Or manually: GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)

### Step 2: Create Token
1. Click "Generate new token"
2. Choose "Generate new token (classic)" for simpler setup

### Step 3: Configure Token
- **Token name**: `github-profile-viewer` (or your preference)
- **Expiration**: 90 days (or your preference)
- **Scopes**: Select only `public_repo`
  - This allows reading public repository data only
  - No write permissions

### Step 4: Generate and Copy
1. Click "Generate token"
2. **IMPORTANT**: Copy the token immediately - you won't see it again!
3. Keep it safe - never share publicly

## Using Token in the App

### Option 1: Direct Token (Development)

Edit `lib/main.dart`:

```dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GithubProvider(
            apiService: GithubApiService(
              token: 'ghp_YOUR_TOKEN_HERE', // Replace with your token
            ),
          ),
        ),
      ],
      child: MaterialApp(
        // ... rest of your code
      ),
    );
  }
}
```

### Option 2: Environment Variables (Recommended)

1. Create `.env` file in project root:
```
GITHUB_TOKEN=ghp_YOUR_TOKEN_HERE
```

2. Add to `.gitignore`:
```
.env
.env.local
```

3. Install `flutter_dotenv`:
```yaml
# In pubspec.yaml
dependencies:
  flutter_dotenv: ^5.1.0
```

4. Update `lib/main.dart`:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final token = dotenv.env['GITHUB_TOKEN'];
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GithubProvider(
            apiService: GithubApiService(token: token),
          ),
        ),
      ],
      // ... rest of your code
    );
  }
}
```

### Option 3: Secure Storage (Production)

For production apps, use `flutter_secure_storage`:

```yaml
# In pubspec.yaml
dependencies:
  flutter_secure_storage: ^9.0.0
```

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

Future<void> main() async {
  final token = await storage.read(key: 'github_token');
  
  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;
  
  const MyApp({this.token, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GithubProvider(
            apiService: GithubApiService(token: token),
          ),
        ),
      ],
      // ... rest of your code
    );
  }
}
```

## Token Security Best Practices

### ✅ DO:
- Rotate tokens regularly (every 90 days recommended)
- Use minimal scopes (only `public_repo`)
- Keep tokens in `.env` files (add to `.gitignore`)
- Use secure storage in production apps
- Revoke tokens when no longer needed

### ❌ DON'T:
- Commit tokens to Git repository
- Share tokens with anyone
- Use tokens in frontend code (web browsers)
- Use tokens in public GitHub repositories
- Hardcode tokens permanently in apps

## Revoking Tokens

If a token is compromised:

1. Go to https://github.com/settings/tokens
2. Find the token in the list
3. Click "Delete"
4. Generate a new token if needed

## Testing Token

### Via API Call:
```bash
curl -H "Authorization: token YOUR_TOKEN" \
  https://api.github.com/user
```

### Via Dart:
```dart
import 'package:http/http.dart' as http;

Future<void> testToken(String token) async {
  final response = await http.get(
    Uri.parse('https://api.github.com/user'),
    headers: {'Authorization': 'token $token'},
  );
  
  if (response.statusCode == 200) {
    print('Token is valid!');
  } else {
    print('Token is invalid or expired');
  }
}
```

## Rate Limit Comparison

| Feature | Anonymous | Authenticated |
|---------|-----------|---------------|
| Requests/hour | 60 | 5,000 |
| User searches | Limited | Extensive |
| Repository searches | Limited | Extensive |
| API calls total/day | 1,440 | 120,000 |
| Best for | Testing | Production |

## Multiple Tokens

You can create multiple tokens for different purposes:
- One for development
- One for production
- One for CI/CD pipelines
- One for testing

Just revoke and recreate them as needed.

## Troubleshooting

### Token Not Working
- Verify token hasn't expired (GitHub shows expiration date)
- Check token format starts with `ghp_`
- Ensure `.gitignore` includes `.env`
- Try regenerating a new token

### Token Leaked?
- Delete immediately from https://github.com/settings/tokens
- Generate new token
- Update your app
- Redeploy

### Still Getting Rate Limited
- Verify token is being passed correctly
- Check response headers: `X-RateLimit-Limit`
- Should show `5000` if authenticated
- Check `X-RateLimit-Remaining` for current usage

## Example: Complete Setup

1. **Generate token** at https://github.com/settings/tokens/new
   - Scopes: `public_repo`
   - Expiration: 90 days

2. **Create .env file**:
   ```
   GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxx
   ```

3. **Add to .gitignore**:
   ```
   .env
   ```

4. **Update pubspec.yaml**:
   ```yaml
   dependencies:
     flutter_dotenv: ^5.1.0
   ```

5. **Update main.dart**:
   ```dart
   import 'package:flutter_dotenv/flutter_dotenv.dart';
   
   Future<void> main() async {
     await dotenv.load();
     runApp(const MyApp());
   }
   ```

6. **Run**:
   ```bash
   flutter pub get
   flutter run
   ```

## Links

- [Create GitHub Token](https://github.com/settings/tokens/new)
- [GitHub Authentication Docs](https://docs.github.com/en/authentication)
- [API Rate Limiting](https://docs.github.com/en/rest/rate-limit)
- [Personal Access Tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)

---

**Security Note**: Tokens are sensitive credentials. Treat them like passwords and keep them secure!
