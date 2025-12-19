import 'package:flutter/material.dart';
import 'package:github_profile_viewer/models/index.dart';

class RateLimitBanner extends StatelessWidget {
  final RateLimitInfo? rateLimit;

  const RateLimitBanner({
    Key? key,
    required this.rateLimit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (rateLimit == null) return const SizedBox.shrink();

    final isLimited = rateLimit!.isLimited;
    final remaining = rateLimit!.remaining;
    final total = rateLimit!.limit;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: isLimited ? Colors.red.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
      child: Row(
        children: [
          Icon(
            isLimited ? Icons.error : Icons.info,
            color: isLimited ? Colors.red : Colors.blue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLimited ? 'Rate limit exceeded' : 'API Rate Limit',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: isLimited ? Colors.red : Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '$remaining/$total requests remaining',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
