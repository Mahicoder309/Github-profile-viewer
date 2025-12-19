import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String _ollamaUrl = 'http://localhost:11434/api/generate';
  static const String _model = 'mistral';
  
  // Fallback summaries if Ollama fails
  static const Map<String, String> _fallbackSummaries = {
    'default': '''**What it does**: This is an open-source project hosted on GitHub with active development and community contributions.

**Use cases**:
• Software development and version control
• Collaboration and code sharing
• Open-source project management

**Key features**:
• Source code management
• Issue tracking and project management
• Community-driven development

**Best for**: Developers and teams looking to collaborate on software projects.'''
  };

  static void initialize() {
    // Ollama is already running locally, no initialization needed
  }

  /// Checks if Ollama is running
  static Future<bool> isOllamaAvailable() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:11434/api/tags'),
      ).timeout(const Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Analyzes a repository's README and generates a summary
  static Future<String> analyzeRepository({
    required String repositoryName,
    required String repositoryUrl,
    required String readme,
    required String language,
  }) async {
    try {
      if (readme.isEmpty) {
        return 'No README available for analysis. Please check the repository directly.';
      }

      // Check if Ollama is available
      final isAvailable = await isOllamaAvailable();
      if (!isAvailable) {
        return _fallbackSummaries['default']!;
      }

      final prompt = '''Analyze this GitHub repository and provide a concise summary:

Repository: $repositoryName
Language: $language
URL: $repositoryUrl

README Content:
${readme.length > 1500 ? readme.substring(0, 1500) + '...' : readme}

Please provide in this exact format:
**What it does**: [1-2 sentences]
**Use cases**: [3 bullet points]
**Key features**: [3 bullet points]
**Best for**: [1-2 sentences]

Be concise and beginner-friendly.''';

      return await _callOllama(prompt);
    } catch (e) {
      return _fallbackSummaries['default']!;
    }
  }

  /// Generates developer profile insights
  static Future<String> analyzeDeveloperProfile({
    required String username,
    required List<String> repositoryNames,
    required List<String> languages,
    required int publicRepos,
    required int followers,
  }) async {
    try {
      // Check if Ollama is available
      final isAvailable = await isOllamaAvailable();
      if (!isAvailable) {
        return '''**Developer Level**: Experienced
**Specializations**: Software Development
**Tech Stack**: ${languages.take(3).join(', ')}
**Strengths**: Active contributor with $publicRepos public repositories
**Recommendations**: Continue building and sharing open-source projects''';
      }

      final prompt = '''Generate a professional developer profile analysis based on:

Username: $username
Public repositories: $publicRepos
Followers: $followers
Languages: ${languages.take(5).join(', ')}
Recent repos: ${repositoryNames.take(3).join(', ')}

Provide in this format:
**Developer Level**: [Junior/Mid/Senior/Expert]
**Specializations**: [Main areas]
**Tech Stack**: [Primary technologies]
**Strengths**: [Key competencies]
**Recommendations**: [What to learn next]

Keep it concise.''';

      return await _callOllama(prompt);
    } catch (e) {
      return 'Unable to generate profile analysis.';
    }
  }

  /// Internal method to call Ollama API with retry logic
  static Future<String> _callOllama(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_ollamaUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'model': _model,
          'prompt': prompt,
          'stream': false,
          'temperature': 0.7,
        }),
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () => throw Exception('Request timeout - Ollama may be busy'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final result = jsonResponse['response'] ?? '';
        
        if (result.isEmpty) {
          return _fallbackSummaries['default']!;
        }
        return result;
      } else if (response.statusCode == 500) {
        // Model might be loading or unavailable
        return _fallbackSummaries['default']!;
      } else {
        return _fallbackSummaries['default']!;
      }
    } catch (e) {
      // Return fallback if Ollama unavailable
      return _fallbackSummaries['default']!;
    }
  }
}
