import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:github_profile_viewer/models/index.dart';

class GithubApiService {
  static const String _baseUrl = 'https://api.github.com';
  final String? _token;
  
  RateLimitInfo? _lastRateLimit;

  GithubApiService({String? token}) : _token = token;

  RateLimitInfo? get lastRateLimit => _lastRateLimit;

  Map<String, String> get _headers {
    final headers = {
      'Accept': 'application/vnd.github.v3+json',
      'User-Agent': 'GithubProfileViewer/1.0',
    };
    
    if (_token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'token $_token';
    }
    
    return headers;
  }

  void _updateRateLimit(http.Response response) {
    _lastRateLimit = RateLimitInfo.fromHeaders(response.headers);
  }

  Future<GithubUser?> searchUser(String username) async {
    if (username.isEmpty) {
      throw ArgumentError('Username cannot be empty');
    }

    try {
      final url = Uri.parse('$_baseUrl/users/$username');
      final response = await http.get(url, headers: _headers).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Request timed out'),
      );

      _updateRateLimit(response);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return GithubUser.fromJson(json);
      } else if (response.statusCode == 404) {
        throw UserNotFoundException('User "$username" not found');
      } else if (response.statusCode == 403) {
        throw RateLimitException(
          'Rate limit exceeded. Remaining: ${_lastRateLimit?.remaining ?? 0}',
          _lastRateLimit,
        );
      } else {
        throw ApiException('Failed to fetch user: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<GithubRepository>> getUserRepositories(
    String username, {
    int page = 1,
    int perPage = 30,
  }) async {
    if (username.isEmpty) {
      throw ArgumentError('Username cannot be empty');
    }

    try {
      final url = Uri.parse('$_baseUrl/users/$username/repos').replace(
        queryParameters: {
          'page': page.toString(),
          'per_page': perPage.toString(),
          'sort': 'updated',
          'direction': 'desc',
        },
      );

      final response = await http.get(url, headers: _headers).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Request timed out'),
      );

      _updateRateLimit(response);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List<dynamic>;
        return json
            .map((item) => GithubRepository.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 404) {
        return [];
      } else if (response.statusCode == 403) {
        throw RateLimitException(
          'Rate limit exceeded. Remaining: ${_lastRateLimit?.remaining ?? 0}',
          _lastRateLimit,
        );
      } else {
        throw ApiException('Failed to fetch repositories: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, int>> getUserLanguageStats(String username) async {
    if (username.isEmpty) {
      throw ArgumentError('Username cannot be empty');
    }

    try {
      final repos = await getUserRepositories(username, perPage: 100);
      final languageStats = <String, int>{};

      for (final repo in repos) {
        if (repo.language.isNotEmpty && repo.language != 'Unknown') {
          languageStats[repo.language] = (languageStats[repo.language] ?? 0) + 1;
        }
      }

      return languageStats;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getRepositoryReadme(String owner, String repo) async {
    try {
      final url = Uri.parse('$_baseUrl/repos/$owner/$repo/readme');
      final response = await http.get(
        url,
        headers: {..._headers, 'Accept': 'application/vnd.github.v3.raw'},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Request timed out'),
      );

      _updateRateLimit(response);

      if (response.statusCode == 200) {
        return response.body;
      } else if (response.statusCode == 404) {
        return ''; // No README available
      } else {
        throw ApiException('Failed to fetch README: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }
}

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}

class UserNotFoundException extends ApiException {
  UserNotFoundException(String message) : super(message);
}

class RateLimitException extends ApiException {
  final RateLimitInfo? rateLimit;

  RateLimitException(String message, this.rateLimit) : super(message);
}

class NetworkException extends ApiException {
  NetworkException(String message) : super(message);
}

class TimeoutException extends ApiException {
  TimeoutException(String message) : super(message);
}

class SocketException extends ApiException {
  SocketException(String message) : super(message);
}
