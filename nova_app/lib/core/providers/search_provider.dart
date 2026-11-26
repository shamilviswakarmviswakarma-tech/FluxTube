import '../media/media_item.dart';
import '../paging/page_cursor.dart';
import 'provider_result.dart';

abstract interface class SearchProvider {
  String get id;
  Future<ProviderResult<MediaItem>> search({
    required String query,
    PageCursor? page,
  });
}
