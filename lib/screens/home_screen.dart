import 'package:flutter/material.dart' hide SearchBar;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:github_profile_viewer/services/index.dart';
import 'package:github_profile_viewer/widgets/search_bar.dart';
import 'package:github_profile_viewer/widgets/user_profile_card.dart';
import 'package:github_profile_viewer/widgets/repository_card.dart';
import 'package:github_profile_viewer/widgets/rate_limit_banner.dart';
import 'package:github_profile_viewer/widgets/repository_summary_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;
  String? _selectedRepoForAnalysis;
  
  // Pagination support for future implementation
  // int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Load more repositories when reaching bottom
      _loadMoreRepositories();
    }
  }

  Future<void> _loadMoreRepositories() async {
    final provider = context.read<GithubProvider>();
    if (provider.currentUser != null) {
      // This could be enhanced with pagination
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub Profile Viewer'),
        elevation: 2,
        centerTitle: true,
      ),
      body: Consumer<GithubProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Rate limit banner
                RateLimitBanner(rateLimit: provider.rateLimit),

                // Search bar
                SearchBar(
                  onSearch: (username) {
                    provider.searchUser(username);
                  },
                  isLoading: provider.isLoading,
                ),

                // Error message
                if (provider.error != null)
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            provider.error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Loading indicator
                if (provider.isLoading && provider.currentUser == null)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),

                // User profile
                if (provider.currentUser != null) ...[
                  UserProfileCard(
                    user: provider.currentUser!,
                    onUrlLaunch: () =>
                        _launchUrl(provider.currentUser!.profileUrl),
                  ),
                  const SizedBox(height: 16),

                  // Language statistics
                  if (provider.languageStats.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Language Statistics',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: provider.languageStats.entries
                                .map(
                                  (entry) => Chip(
                                    label: Text(
                                        '${entry.key} (${entry.value})'),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Repositories section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Public Repositories (${provider.repositories.length})',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (provider.repositories.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Text(
                          'No public repositories found',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.repositories.length,
                      itemBuilder: (context, index) {
                        final repo = provider.repositories[index];
                        return Column(
                          children: [
                            RepositoryCard(
                              repository: repo,
                              onTap: () => _launchUrl(repo.url),
                            ),
                            // AI Analysis Button
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: SizedBox(
                                width: double.infinity,
                                child: TextButton.icon(
                                  onPressed: provider.analyzingRepository == repo.name
                                      ? null
                                      : () {
                                          setState(() {
                                            _selectedRepoForAnalysis = repo.name;
                                          });
                                          provider.analyzeRepository(
                                            provider.currentUser!.login,
                                            repo.name,
                                          );
                                        },
                                  icon: const Icon(Icons.auto_awesome),
                                  label: provider.analyzingRepository == repo.name
                                      ? const Text('Analyzing...')
                                      : provider.repositorySummaries
                                              .containsKey(repo.name)
                                          ? const Text('View AI Analysis')
                                          : const Text('Get AI Analysis'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.amber,
                                  ),
                                ),
                              ),
                            ),
                            // Show summary if analyzed
                            if (_selectedRepoForAnalysis == repo.name)
                              RepositorySummaryCard(
                                repositoryName: repo.name,
                                summary: provider.repositorySummaries[repo.name] ?? '',
                                isLoading: provider.analyzingRepository == repo.name,
                                onRefresh: () {
                                  provider.repositorySummaries.remove(repo.name);
                                  provider.analyzeRepository(
                                    provider.currentUser!.login,
                                    repo.name,
                                  );
                                },
                              ),
                          ],
                        );
                      },
                    ),
                  const SizedBox(height: 32),
                ],

                // Empty state
                if (!provider.isLoading && provider.currentUser == null)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Search for a GitHub user',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
