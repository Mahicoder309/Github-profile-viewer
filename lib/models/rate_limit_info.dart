class RateLimitInfo {
  final int limit;
  final int remaining;
  final int reset;

  RateLimitInfo({
    required this.limit,
    required this.remaining,
    required this.reset,
  });

  factory RateLimitInfo.fromHeaders(Map<String, String> headers) {
    return RateLimitInfo(
      limit: int.tryParse(headers['x-ratelimit-limit'] ?? '60') ?? 60,
      remaining: int.tryParse(headers['x-ratelimit-remaining'] ?? '60') ?? 60,
      reset: int.tryParse(headers['x-ratelimit-reset'] ?? '0') ?? 0,
    );
  }

  DateTime get resetTime => DateTime.fromMillisecondsSinceEpoch(reset * 1000);

  bool get isLimited => remaining <= 0;
}
