enum MediaKind { video, channel, playlist, live }

class MediaItem {
  const MediaItem({
    required this.id,
    required this.title,
    required this.kind,
    this.description,
    this.thumbnailUrl,
    this.channelId,
    this.channelName,
    this.duration,
    this.viewCount,
    this.publishedAt,
    this.isLive = false,
  });

  final String id;
  final String title;
  final MediaKind kind;
  final String? description;
  final Uri? thumbnailUrl;
  final String? channelId;
  final String? channelName;
  final Duration? duration;
  final int? viewCount;
  final DateTime? publishedAt;
  final bool isLive;
}
