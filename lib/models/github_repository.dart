class GithubRepository {
  final int id;
  final String name;
  final String description;
  final String url;
  final String language;
  final int stars;
  final int forks;
  final int openIssues;
  final DateTime createdAt;
  final DateTime updatedAt;

  GithubRepository({
    required this.id,
    required this.name,
    required this.description,
    required this.url,
    required this.language,
    required this.stars,
    required this.forks,
    required this.openIssues,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GithubRepository.fromJson(Map<String, dynamic> json) {
    return GithubRepository(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? 'No description',
      url: json['html_url'] as String? ?? '',
      language: json['language'] as String? ?? 'Unknown',
      stars: json['stargazers_count'] as int? ?? 0,
      forks: json['forks_count'] as int? ?? 0,
      openIssues: json['open_issues_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'html_url': url,
    'language': language,
    'stargazers_count': stars,
    'forks_count': forks,
    'open_issues_count': openIssues,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
