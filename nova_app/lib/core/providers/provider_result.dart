import '../paging/page_cursor.dart';

class ProviderResult<T> {
  const ProviderResult({
    required this.items,
    this.nextPage,
    this.providerName,
  });

  final List<T> items;
  final PageCursor? nextPage;
  final String? providerName;

  bool get hasMore => nextPage != null;
}

enum ProviderFailureKind {
  network,
  unavailable,
  rateLimited,
  restricted,
  parse,
  unsupported,
  unknown,
}

class ProviderFailure implements Exception {
  const ProviderFailure({
    required this.provider,
    required this.kind,
    required this.message,
    this.retryable = false,
  });

  final String provider;
  final ProviderFailureKind kind;
  final String message;
  final bool retryable;

  @override
  String toString() => 'ProviderFailure($provider, $kind): $message';
}
