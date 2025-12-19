import 'package:flutter/material.dart';
import 'package:github_profile_viewer/models/index.dart';

class RepositoryCard extends StatelessWidget {
  final GithubRepository repository;
  final VoidCallback onTap;

  const RepositoryCard({
    Key? key,
    required this.repository,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Repository name
              Text(
                repository.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                repository.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Language and stats row
              Row(
                children: [
                  // Language
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getLanguageColor(repository.language),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      repository.language,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Stars
                  _StatRow(
                    icon: Icons.star,
                    label: repository.stars.toString(),
                  ),
                  const SizedBox(width: 12),

                  // Forks
                  _StatRow(
                    icon: Icons.call_split,
                    label: repository.forks.toString(),
                  ),
                  const SizedBox(width: 12),

                  // Issues
                  _StatRow(
                    icon: Icons.warning_outlined,
                    label: repository.openIssues.toString(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getLanguageColor(String language) {
    const languageColors = {
      'Dart': Color(0xFF00D4FF),
      'Python': Color(0xFF3776AB),
      'JavaScript': Color(0xFFF1E05A),
      'TypeScript': Color(0xFF2B7A0B),
      'Java': Color(0xFFB07219),
      'Kotlin': Color(0xFF7F52FF),
      'Swift': Color(0xFFFA7343),
      'Go': Color(0xFF00ADD8),
      'Rust': Color(0xFFCE422B),
      'C#': Color(0xFF239120),
      'C++': Color(0xFF00599C),
    };

    return languageColors[language] ?? Colors.grey;
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatRow({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}
