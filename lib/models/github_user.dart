class GithubUser {
  final String login;
  final int id;
  final String avatarUrl;
  final String profileUrl;
  final String name;
  final String? bio;
  final String? location;
  final String? company;
  final String? blog;
  final int publicRepos;
  final int followers;
  final int following;
  final DateTime createdAt;
  final DateTime updatedAt;

  GithubUser({
    required this.login,
    required this.id,
    required this.avatarUrl,
    required this.profileUrl,
    required this.name,
    this.bio,
    this.location,
    this.company,
    this.blog,
    required this.publicRepos,
    required this.followers,
    required this.following,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GithubUser.fromJson(Map<String, dynamic> json) {
    return GithubUser(
      login: json['login'] as String? ?? '',
      id: json['id'] as int? ?? 0,
      avatarUrl: json['avatar_url'] as String? ?? '',
      profileUrl: json['html_url'] as String? ?? '',
      name: json['name'] as String? ?? json['login'] as String? ?? 'Unknown',
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      company: json['company'] as String?,
      blog: json['blog'] as String?,
      publicRepos: json['public_repos'] as int? ?? 0,
      followers: json['followers'] as int? ?? 0,
      following: json['following'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
    'login': login,
    'id': id,
    'avatar_url': avatarUrl,
    'html_url': profileUrl,
    'name': name,
    'bio': bio,
    'location': location,
    'company': company,
    'blog': blog,
    'public_repos': publicRepos,
    'followers': followers,
    'following': following,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
