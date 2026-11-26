import '../media/media_item.dart';
import '../paging/page_cursor.dart';
import 'provider_result.dart';
import 'search_provider.dart';

/// Uses one explicitly selected provider. It does not silently fan out requests
/// to multiple services; fallback policy belongs to the caller.
class ProviderCoordinator {
  ProviderCoordinator({required List<SearchProvider> providers})
      : _providers = {for (final provider in providers) provider.id: provider};

  final Map<String, SearchProvider> _providers;

  List<String> get availableProviderIds =>
      _providers.keys.toList(growable: false);

  Future<ProviderResult<MediaItem>> search({
    required String providerId,
    required String query,
    PageCursor? page,
  }) {
    final provider = _providers[providerId];
    if (provider == null) {
      throw ProviderFailure(
        provider: providerId,
        kind: ProviderFailureKind.unavailable,
        message: 'Selected search provider is not configured.',
      );
    }
    return provider.search(query: query, page: page);
  }
}