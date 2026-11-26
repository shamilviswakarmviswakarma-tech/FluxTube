import 'package:flutter/material.dart';

import '../../app/theme/nova_theme.dart';

class NovaVideoDetailsScreen extends StatelessWidget {
  const NovaVideoDetailsScreen({
    super.key,
    required this.videoId,
    this.onPlay,
    this.onRelatedVideoTap,
  });

  final String videoId;
  final VoidCallback? onPlay;
  final ValueChanged<String>? onRelatedVideoTap;

  static const _related = [
    _RelatedVideo(
      id: 'ai-future',
      title: 'Where artificial intelligence is heading next',
      channel: 'The Learning Lab',
      duration: '12:48',
      icon: Icons.psychology_alt_rounded,
      colors: [Color(0xFF263B73), Color(0xFF1677FF)],
    ),
    _RelatedVideo(
      id: 'learn-better',
      title: 'How to learn difficult topics faster',
      channel: 'Mindful Learning',
      duration: '09:32',
      icon: Icons.lightbulb_rounded,
      colors: [Color(0xFF145447), Color(0xFF22A889)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final title = _titleFor(videoId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video details'),
        actions: [
          IconButton(
            tooltip: 'Share',
            onPressed: () {},
            icon: const Icon(Icons.share_outlined),
          ),
          IconButton(
            tooltip: 'More options',
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 760;
          final content = _detailsContent(context, title);
          if (wide) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 7, child: content),
                      const SizedBox(width: 28),
                      Expanded(
                        flex: 4,
                        child: _RelatedSection(
                          onTap: onRelatedVideoTap,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _VideoArtwork(onPlay: onPlay),
                const SizedBox(height: 18),
                _VideoHeading(title: title),
                const SizedBox(height: 16),
                const _ChannelRow(),
                const SizedBox(height: 16),
                _ActionRow(onPlay: onPlay),
                const SizedBox(height: 18),
                const _DescriptionCard(),
                const SizedBox(height: 22),
                const _ChaptersSection(),
                const SizedBox(height: 24),
                _RelatedSection(onTap: onRelatedVideoTap),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _detailsContent(BuildContext context, String title) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _VideoArtwork(onPlay: onPlay),
          const SizedBox(height: 18),
          _VideoHeading(title: title),
          const SizedBox(height: 16),
          const _ChannelRow(),
          const SizedBox(height: 16),
          _ActionRow(onPlay: onPlay),
          const SizedBox(height: 18),
          const _DescriptionCard(),
          const SizedBox(height: 22),
          const _ChaptersSection(),
        ],
      ),
    );
  }

  String _titleFor(String id) {
    switch (id) {
      case 'flutter-ui':
        return 'Build a beautiful Flutter app from scratch';
      case 'future-ai':
      case 'ai-explained':
        return 'How artificial intelligence is changing the way we learn';
      case 'cinematic-world':
        return 'Inside the art of cinematic world building';
      case 'space':
        return 'A journey through the deepest parts of space';
      case 'design':
        return 'Design systems that make products feel effortless';
      default:
        return 'Discover something worth learning today';
    }
  }
}

class _VideoArtwork extends StatelessWidget {
  const _VideoArtwork({this.onPlay});

  final VoidCallback? onPlay;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Material(
        color: NovaColors.deepNavy,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPlay,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF071B35), Color(0xFF1677FF)],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                ),
              ),
              const Center(
                child: Icon(
                  Icons.play_circle_fill_rounded,
                  color: Colors.white,
                  size: 68,
                ),
              ),
              Positioned(
                right: 12,
                bottom: 12,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.78),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Text(
                      '18:42',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VideoHeading extends StatelessWidget {
  const _VideoHeading({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 21,
            height: 1.25,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '248K views  •  2 days ago  •  #Learning #Technology',
          style: TextStyle(color: NovaColors.muted, fontSize: 12),
        ),
      ],
    );
  }
}

class _ChannelRow extends StatelessWidget {
  const _ChannelRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 23,
          backgroundColor: NovaColors.elevated,
          child: Icon(Icons.school_rounded, color: NovaColors.bright),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('The Learning Lab',
                  style: TextStyle(fontWeight: FontWeight.w800)),
              SizedBox(height: 3),
              Text('1.24M subscribers',
                  style: TextStyle(color: NovaColors.muted, fontSize: 11)),
            ],
          ),
        ),
        FilledButton(
          onPressed: () {},
          child: const Text('Subscribe'),
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({this.onPlay});

  final VoidCallback? onPlay;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 9,
      runSpacing: 9,
      children: [
        FilledButton.icon(
          onPressed: onPlay,
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text('Play video'),
        ),
        _PillAction(icon: Icons.thumb_up_alt_outlined, label: 'Like'),
        _PillAction(icon: Icons.bookmark_border_rounded, label: 'Save'),
        _PillAction(icon: Icons.download_outlined, label: 'Download'),
      ],
    );
  }
}

class _PillAction extends StatelessWidget {
  const _PillAction({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}

class _DescriptionCard extends StatelessWidget {
  const _DescriptionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NovaColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: NovaColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('About this video',
              style: TextStyle(fontWeight: FontWeight.w800)),
          SizedBox(height: 9),
          Text(
            'Explore the ideas, tools and real-world examples behind this topic. '
            'This details preview uses sample content until a video provider is connected.',
            style: TextStyle(
              color: NovaColors.secondaryText,
              height: 1.5,
              fontSize: 13,
            ),
          ),
          SizedBox(height: 12),
          Text('Show more',
              style: TextStyle(
                  color: NovaColors.bright, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _ChaptersSection extends StatelessWidget {
  const _ChaptersSection();

  static const _chapters = [
    ('00:00', 'Introduction'),
    ('02:14', 'The big idea'),
    ('07:36', 'Real-world examples'),
    ('14:20', 'What comes next'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Chapters',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        ..._chapters.map(
          (chapter) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.play_circle_outline_rounded,
                color: NovaColors.bright),
            title: Text(chapter.$2,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            trailing: Text(chapter.$1,
                style: const TextStyle(color: NovaColors.muted, fontSize: 12)),
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class _RelatedSection extends StatelessWidget {
  const _RelatedSection({this.onTap});

  final ValueChanged<String>? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Up next',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        ...NovaVideoDetailsScreen._related.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: InkWell(
              onTap: () => onTap?.call(item.id),
              borderRadius: BorderRadius.circular(14),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: item.colors),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(item.icon, color: Colors.white, size: 34),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 5),
                        Text(item.channel,
                            style: const TextStyle(
                                color: NovaColors.muted, fontSize: 10)),
                        Text(item.duration,
                            style: const TextStyle(
                                color: NovaColors.muted, fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RelatedVideo {
  const _RelatedVideo({
    required this.id,
    required this.title,
    required this.channel,
    required this.duration,
    required this.icon,
    required this.colors,
  });

  final String id;
  final String title;
  final String channel;
  final String duration;
  final IconData icon;
  final List<Color> colors;
}
