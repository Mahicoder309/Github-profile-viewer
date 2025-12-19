import 'package:flutter/material.dart';
import 'package:github_profile_viewer/services/github_api_service.dart';
import 'package:github_profile_viewer/services/ai_service.dart';
import 'package:github_profile_viewer/models/index.dart';

class GithubProvider extends ChangeNotifier {
  final GithubApiService _apiService;

  GithubProvider({GithubApiService? apiService})
      : _apiService = apiService ?? GithubApiService() {
    AIService.initialize();
  }

  GithubUser? _currentUser;
  List<GithubRepository> _repositories = [];
  Map<String, int> _languageStats = {};
  bool _isLoading = false;
  String? _error;
  Map<String, String> _repositorySummaries = {}; // Store summaries by repo name
  String? _analyzingRepository;

  // Getters
  GithubUser? get currentUser => _currentUser;
  List<GithubRepository> get repositories => _repositories;
  Map<String, int> get languageStats => _languageStats;
  bool get isLoading => _isLoading;
  String? get error => _error;
  RateLimitInfo? get rateLimit => _apiService.lastRateLimit;
  Map<String, String> get repositorySummaries => _repositorySummaries;
  String? get analyzingRepository => _analyzingRepository;

  Future<void> searchUser(String username) async {
    _isLoading = true;
    _error = null;
    _currentUser = null;
    _repositories = [];
    _languageStats = {};
    notifyListeners();

    try {
      _currentUser = await _apiService.searchUser(username);
      await _fetchRepositoriesAndStats(username);
      notifyListeners();
    } on UserNotFoundException {
      _error = 'User not found: $username';
      notifyListeners();
    } on RateLimitException {
      _error = 'Rate limit exceeded. Please try again later.\n';
      notifyListeners();
    } on NetworkException {
      _error = 'Network error';
      notifyListeners();
    } on TimeoutException {
      _error = 'Request timed out. Please try again.';
      notifyListeners();
    } on ApiException catch (e) {
      _error = 'Error: ${e.message}';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchRepositoriesAndStats(String username) async {
    try {
      _repositories = await _apiService.getUserRepositories(username, perPage: 100);
      _languageStats = await _apiService.getUserLanguageStats(username);
    } catch (e) {
      _error = 'Could not fetch repositories: $e';
    }
  }

  void clearSearch() {
    _currentUser = null;
    _repositories = [];
    _languageStats = {};
    _error = null;
    _repositorySummaries = {};
    _analyzingRepository = null;
    notifyListeners();
  }

  Future<void> analyzeRepository(String owner, String repoName) async {
    if (_repositorySummaries.containsKey(repoName)) {
      return; // Already analyzed
    }

    _analyzingRepository = repoName;
    notifyListeners();

    try {
      // Fetch README
      final readme = await _apiService.getRepositoryReadme(owner, repoName);
      
      // Find repo to get language and URL
      final repo = _repositories.firstWhere(
        (r) => r.name == repoName,
        orElse: () => GithubRepository(
          id: 0,
          name: repoName,
          url: '',
          description: '',
          stars: 0,
          forks: 0,
          openIssues: 0,
          language: 'Unknown',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      // Generate AI summary
      final summary = await AIService.analyzeRepository(
        repositoryName: repoName,
        repositoryUrl: repo.url,
        readme: readme,
        language: repo.language,
      );

      _repositorySummaries[repoName] = summary;
    } catch (e) {
      _repositorySummaries[repoName] = 'Error analyzing repository: $e';
    } finally {
      _analyzingRepository = null;
      notifyListeners();
    }
  }

  void setApiToken(String token) {
    // This would require reinitializing the service
    // For now, users can provide token during initialization
  }
}
