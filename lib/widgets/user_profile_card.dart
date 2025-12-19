import 'package:flutter/material.dart';
import 'package:github_profile_viewer/models/index.dart';

class UserProfileCard extends StatelessWidget {
  final GithubUser user;
  final VoidCallback onUrlLaunch;

  const UserProfileCard({
    Key? key,
    required this.user,
    required this.onUrlLaunch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.avatarUrl),
              ),
            ),
            const SizedBox(height: 16),

            // Name and Login
            Text(
              user.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              '@${user.login}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),

            // Bio
            if (user.bio != null && user.bio!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  user.bio!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),

            const SizedBox(height: 16),

            // Location, Company, Blog
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                if (user.location != null && user.location!.isNotEmpty)
                  _InfoChip(
                    icon: Icons.location_on,
                    label: user.location!,
                  ),
                if (user.company != null && user.company!.isNotEmpty)
                  _InfoChip(
                    icon: Icons.business,
                    label: user.company!,
                  ),
                if (user.blog != null && user.blog!.isNotEmpty)
                  _InfoChip(
                    icon: Icons.link,
                    label: 'Website',
                  ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatColumn(
                  label: 'Repos',
                  value: user.publicRepos.toString(),
                ),
                _StatColumn(
                  label: 'Followers',
                  value: user.followers.toString(),
                ),
                _StatColumn(
                  label: 'Following',
                  value: user.following.toString(),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // View Profile Button
            ElevatedButton.icon(
              onPressed: onUrlLaunch,
              icon: const Icon(Icons.open_in_new),
              label: const Text('View on GitHub'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      backgroundColor: Colors.blue.withOpacity(0.1),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;

  const _StatColumn({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }
}
