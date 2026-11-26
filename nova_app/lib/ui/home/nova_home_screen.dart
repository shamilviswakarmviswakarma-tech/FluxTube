import 'package:flutter/material.dart';

import '../../app/theme/nova_theme.dart';

class NovaHomeScreen extends StatelessWidget {
  const NovaHomeScreen({
    super.key,
    this.onVideoTap,
    this.onSeeAll,
  });

  final ValueChanged<String>? onVideoTap;
  final VoidCallback? onSeeAll;

  static const _categories = [
    'For you',
    'Technology',
    'Music',
    'Gaming',
    'Learning',
    'Live',
  ];

  static const _videos = [
    _HomeVideo(
      id: 'future-ai',
      title: 'How AI is changing the way we learn',
      channel: 'The Learning Lab',
      views: '248K views',
      age: '2 days ago',
      duration: '18:42',
      category: 'LEARNING',
      colors: [Color(0xFF153B68), Color(0xFF1677FF)],
      icon: Icons.psychology_alt_rounded,
    ),
    _HomeVideo(
      id: 'cinematic-world',
      title: 'Inside the art of cinematic world building',
      channel: 'Frame by Frame',
      views: '82K views',
      age: '5 days ago',
      duration: '24:10',
      category: 'CREATIVE',
      colors: [Color(0xFF633B82), Color(0xFFCA6D8D)],
      icon: Icons.movie_creation_outlined,
    ),
    _HomeVideo(
      id: 'space',
      title: 'A journey through the deepest parts of space',
      channel: 'Orbit Stories',
      views: '1.2M views',
      age: '1 week ago',
      duration: '32:08',
      category: 'SCIENCE',
      colors: [Color(0xFF102A43), Color(0xFF287A9B)],
      icon: Icons.public_rounded,
    ),
    _HomeVideo(
      id: 'design',
      title: 'Design systems that make products feel effortless',
      channel: 'Build Better',
      views: '64K views',
      age: '3 days ago',
      duration: '14:36',
      category: 'DESIGN',
      colors: [Color(0xFF744B20), Color(0xFFD99A43)],
      icon: Icons.auto_awesome_mosaic_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 760;
        final horizontalPadding = wide ? 32.0 : 18.0;

        return CustomScrollView(
          key: const PageStorageKey('nova-home-feed'),
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: true,
              titleSpacing: horizontalPadding,
              title: const _NovaWordmark(),
              actions: [
                IconButton(
                  tooltip: 'Cast',
                  onPressed: () {},
                  icon: const Icon(Icons.cast_rounded),
                ),
                IconButton(
                  tooltip: 'Notifications',
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none_rounded),
                ),
                const SizedBox(width: 8),
              ],
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                14,
                horizontalPadding,
                28,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const Text(
                    'Watch. Learn. Create.',
                    style: TextStyle(
                      color: NovaColors.secondaryText,
                      fontSize: 13,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _CategoryRail(categories: _categories),
                  const SizedBox(height: 24),
                  _SectionHeading(
                    title: 'Your next discovery',
                    subtitle: 'A little inspiration for today',
                  ),
                  const SizedBox(height: 14),
                  _FeaturedCard(
                    wide: wide,
                    onTap: () => onVideoTap?.call('future-ai'),
                  ),
                  const SizedBox(height: 28),
                  _SectionHeading(
                    title: 'Recommended for you',
                    subtitle: 'Picked to match your curiosity',
                    actionLabel: 'See all',
                    onAction: onSeeAll,
                  ),
                  const SizedBox(height: 14),
                  _VideoGrid(
                    videos: _videos,
                    wide: wide,
                    onTap: (id) => onVideoTap?.call(id),
                  ),
                  const SizedBox(height: 28),
                  _SectionHeading(
                    title: 'Keep learning',
                    subtitle: 'Short ideas. Big possibilities.',
                  ),
                  const SizedBox(height: 14),
                  const _LearningBanner(),
                ]),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _NovaWordmark extends StatelessWidget {
  const _NovaWordmark();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: NovaColors.primary,
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(
            Icons.play_arrow_rounded,
            color: Colors.white,
            size: 23,
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'NovaTube',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.7,
          ),
        ),
      ],
    );
  }
}

class _CategoryRail extends StatelessWidget {
  const _CategoryRail({required this.categories});

  final List<String> categories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final selected = index == 0;
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: selected ? NovaColors.primary : NovaColors.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: selected ? NovaColors.primary : NovaColors.border,
              ),
            ),
            child: Text(
              categories[index],
              style: TextStyle(
                color: selected ? Colors.white : NovaColors.secondaryText,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: NovaColors.secondaryText,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.wide, this.onTap});

  final bool wide;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: NovaColors.surface,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: wide ? 230 : 208,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF071B35),
                      Color(0xFF124B88),
                      Color(0xFF1677FF),
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                ),
              ),
              Positioned(
                right: wide ? 72 : 20,
                top: 18,
                bottom: 18,
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: wide ? 150 : 118,
                  color: Colors.white.withValues(alpha: 0.12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'EDITOR\'S PICK',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'The future of\nlearning starts now.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        height: 1.12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.7,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Explore ideas that move you forward',
                      style: TextStyle(
                        color: Color(0xFFDCEBFF),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      children: [
                        Icon(
                          Icons.play_circle_fill_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Explore featured video',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeVideo {
  const _HomeVideo({
    required this.id,
    required this.title,
    required this.channel,
    required this.views,
    required this.age,
    required this.duration,
    required this.category,
    required this.colors,
    required this.icon,
  });

  final String id;
  final String title;
  final String channel;
  final String views;
  final String age;
  final String duration;
  final String category;
  final List<Color> colors;
  final IconData icon;
}

class _VideoGrid extends StatelessWidget {
  const _VideoGrid({
    required this.videos,
    required this.wide,
    required this.onTap,
  });

  final List<_HomeVideo> videos;
  final bool wide;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final columns = wide ? 3 : 1;

    if (columns == 1) {
      return Column(
        children: videos
            .map(
              (video) => Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: _VideoCard(
                  video: video,
                  horizontal: true,
                  onTap: () => onTap(video.id),
                ),
              ),
            )
            .toList(),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: videos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 18,
        childAspectRatio: 0.92,
      ),
      itemBuilder: (context, index) {
        final video = videos[index];
        return _VideoCard(
          video: video,
          onTap: () => onTap(video.id),
        );
      },
    );
  }
}

class _VideoCard extends StatelessWidget {
  const _VideoCard({
    required this.video,
    required this.onTap,
    this.horizontal = false,
  });

  final _HomeVideo video;
  final VoidCallback onTap;
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    final thumbnail = _VideoThumbnail(video: video);

    if (horizontal) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 154, child: thumbnail),
            const SizedBox(width: 12),
            Expanded(child: _VideoMetadata(video: video)),
          ],
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          thumbnail,
          const SizedBox(height: 10),
          _VideoMetadata(video: video),
        ],
      ),
    );
  }
}

class _VideoThumbnail extends StatelessWidget {
  const _VideoThumbnail({required this.video});

  final _HomeVideo video;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: video.colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(
                video.icon,
                size: 52,
                color: Colors.white.withValues(alpha: 0.72),
              ),
            ),
            Positioned(
              left: 10,
              top: 10,
              child: Text(
                video.category,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            Positioned(
              right: 8,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.78),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  video.duration,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoMetadata extends StatelessWidget {
  const _VideoMetadata({required this.video});

  final _HomeVideo video;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 17,
          backgroundColor: NovaColors.elevated,
          child: Text(
            video.channel.substring(0, 1),
            style: const TextStyle(
              color: NovaColors.bright,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                video.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.3,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                video.channel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: NovaColors.secondaryText,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${video.views} • ${video.age}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: NovaColors.muted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 4),
        Icon(
          Icons.more_vert_rounded,
          size: 19,
          color: NovaColors.muted,
        ),
      ],
    );
  }
}

class _LearningBanner extends StatelessWidget {
  const _LearningBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: NovaColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: NovaColors.border),
      ),
      child: const Row(
        children: [
          Icon(Icons.auto_awesome, color: NovaColors.bright, size: 28),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Make every watch count',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 4),
                Text(
                  'Turn videos into notes, summaries and new ideas.',
                  style: TextStyle(
                    color: NovaColors.secondaryText,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_rounded, color: NovaColors.bright),
        ],
      ),
    );
  }
}
