import 'package:flutter/material.dart';

import '../../app/theme/nova_theme.dart';

class NovaExploreScreen extends StatefulWidget {
  const NovaExploreScreen({
    super.key,
    this.onCategorySelected,
    this.onTopicSelected,
    this.onVideoTap,
  });

  final ValueChanged<String>? onCategorySelected;
  final ValueChanged<String>? onTopicSelected;
  final ValueChanged<String>? onVideoTap;

  static const _categories = [
    _ExploreCategory('Technology', Icons.memory_rounded, Color(0xFF1677FF)),
    _ExploreCategory('Learning', Icons.school_rounded, Color(0xFF22C55E)),
    _ExploreCategory('Music', Icons.music_note_rounded, Color(0xFFE879F9)),
    _ExploreCategory('Gaming', Icons.sports_esports_rounded, Color(0xFFF59E0B)),
    _ExploreCategory('Science', Icons.science_rounded, Color(0xFF38BDF8)),
    _ExploreCategory('Design', Icons.brush_rounded, Color(0xFFFB7185)),
    _ExploreCategory('Business', Icons.insights_rounded, Color(0xFFA78BFA)),
    _ExploreCategory('Travel', Icons.explore_rounded, Color(0xFF2DD4BF)),
  ];

  static const _topics = [
    'Artificial intelligence',
    'Space exploration',
    'Personal finance',
    'Cinematic storytelling',
    'Productivity',
    'Mobile photography',
  ];

  static const _collections = [
    _ExploreCollection(
      id: 'future-tech',
      eyebrow: 'FUTURE & INNOVATION',
      title: 'Ideas shaping tomorrow',
      subtitle: 'Explore technology, AI and the next big breakthroughs.',
      icon: Icons.auto_awesome_rounded,
      colors: [Color(0xFF102A56), Color(0xFF1677FF)],
      count: '24 videos',
    ),
    _ExploreCollection(
      id: 'deep-learning',
      eyebrow: 'LEARN SOMETHING NEW',
      title: 'Make curiosity a habit',
      subtitle: 'Clear explainers and thoughtful lessons across subjects.',
      icon: Icons.lightbulb_rounded,
      colors: [Color(0xFF164B42), Color(0xFF159B83)],
      count: '18 videos',
    ),
    _ExploreCollection(
      id: 'creative-studio',
      eyebrow: 'CREATE & DESIGN',
      title: 'The creative process',
      subtitle: 'Visual ideas, filmmaking and practical design inspiration.',
      icon: Icons.movie_filter_rounded,
      colors: [Color(0xFF512B56), Color(0xFFB45A9A)],
      count: '16 videos',
    ),
  ];

  @override
  State<NovaExploreScreen> createState() => _NovaExploreScreenState();
}

class _NovaExploreScreenState extends State<NovaExploreScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 760;
        final horizontalPadding = wide ? 32.0 : 18.0;
        final categoryColumns = constraints.maxWidth >= 900
            ? 4
            : constraints.maxWidth >= 520
                ? 4
                : 2;

        return CustomScrollView(
          key: const PageStorageKey('nova-explore-screen'),
          slivers: [
            SliverAppBar(
              pinned: true,
              titleSpacing: horizontalPadding,
              title: const Text(
                'Explore',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              actions: [
                IconButton(
                  tooltip: 'Explore topics',
                  onPressed: () =>
                      widget.onTopicSelected?.call('Explore topics'),
                  icon: const Icon(Icons.tune_rounded),
                ),
                SizedBox(width: horizontalPadding - 8),
              ],
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                  horizontalPadding, 12, horizontalPadding, 32),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const Text(
                    'Find your next rabbit hole.',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.7),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'Fresh ideas, useful skills and stories worth exploring.',
                    style:
                        TextStyle(color: NovaColors.secondaryText, height: 1.4),
                  ),
                  const SizedBox(height: 24),
                  const _SectionTitle(
                    title: 'Browse categories',
                    subtitle: 'Pick a subject to get started',
                  ),
                  const SizedBox(height: 14),
                  GridView.builder(
                    itemCount: NovaExploreScreen._categories.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: categoryColumns,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      mainAxisExtent: 76,
                    ),
                    itemBuilder: (context, index) {
                      final category = NovaExploreScreen._categories[index];
                      final selected = _selectedCategory == category.label;
                      return _CategoryTile(
                        category: category,
                        selected: selected,
                        onTap: () {
                          setState(() {
                            _selectedCategory =
                                selected ? 'All' : category.label;
                          });
                          widget.onCategorySelected?.call(
                            selected ? 'All' : category.label,
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 28),
                  _SectionTitle(
                    title: 'Curated for curious minds',
                    subtitle: 'Hand-picked paths through interesting subjects',
                    trailing: 'View all',
                    onTrailingTap: () =>
                        widget.onTopicSelected?.call('Curated collections'),
                  ),
                  const SizedBox(height: 14),
                  ...NovaExploreScreen._collections.map(
                    (collection) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _CollectionCard(
                        collection: collection,
                        compact: !wide,
                        onTap: () =>
                            widget.onTopicSelected?.call(collection.title),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _SectionTitle(
                    title: 'Trending topics',
                    subtitle: 'What people are exploring',
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 9,
                    runSpacing: 9,
                    children: NovaExploreScreen._topics.map((topic) {
                      return ActionChip(
                        avatar: const Icon(Icons.trending_up_rounded, size: 16),
                        label: Text(topic),
                        onPressed: () => widget.onTopicSelected?.call(topic),
                        backgroundColor: NovaColors.surface,
                        side: const BorderSide(color: NovaColors.border),
                        labelStyle: const TextStyle(
                          color: NovaColors.secondaryText,
                          fontWeight: FontWeight.w500,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),
                  const _SectionTitle(
                    title: 'Explore by mood',
                    subtitle: 'Choose the kind of watch you want',
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 104,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _MoodCard(
                          label: 'Get inspired',
                          detail: 'Fresh perspectives',
                          icon: Icons.bolt_rounded,
                          color: NovaColors.primary,
                          onTap: () =>
                              widget.onTopicSelected?.call('Get inspired'),
                        ),
                        _MoodCard(
                          label: 'Go deeper',
                          detail: 'Understand more',
                          icon: Icons.travel_explore_rounded,
                          color: const Color(0xFF159B83),
                          onTap: () =>
                              widget.onTopicSelected?.call('Go deeper'),
                        ),
                        _MoodCard(
                          label: 'Create more',
                          detail: 'Ideas into action',
                          icon: Icons.draw_rounded,
                          color: const Color(0xFFB45A9A),
                          onTap: () =>
                              widget.onTopicSelected?.call('Create more'),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ExploreCategory {
  const _ExploreCategory(this.label, this.icon, this.color);

  final String label;
  final IconData icon;
  final Color color;
}

class _ExploreCollection {
  const _ExploreCollection({
    required this.id,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
    required this.count,
  });

  final String id;
  final String eyebrow;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;
  final String count;
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTrailingTap,
  });

  final String title;
  final String subtitle;
  final String? trailing;
  final VoidCallback? onTrailingTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style:
                      const TextStyle(color: NovaColors.muted, fontSize: 12)),
            ],
          ),
        ),
        if (trailing != null)
          TextButton(
            onPressed: onTrailingTap,
            child: Text(trailing!,
                style: const TextStyle(color: NovaColors.bright)),
          ),
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final _ExploreCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? NovaColors.primary.withValues(alpha: 0.16)
          : NovaColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? category.color.withValues(alpha: 0.8)
                  : NovaColors.border,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(category.icon, color: category.color, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  category.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  const _CollectionCard({
    required this.collection,
    required this.compact,
    required this.onTap,
  });

  final _ExploreCollection collection;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: NovaColors.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          constraints: const BoxConstraints(minHeight: 154),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: NovaColors.border),
            gradient: LinearGradient(
              colors: [
                collection.colors.first.withValues(alpha: 0.36),
                NovaColors.surface,
              ],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(17, 17, 8, 17),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        collection.eyebrow,
                        style: TextStyle(
                          color: collection.colors.last,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        collection.title,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        collection.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: NovaColors.secondaryText,
                            fontSize: 11,
                            height: 1.35),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        collection.count,
                        style: const TextStyle(
                            color: NovaColors.muted, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: compact ? 3 : 2,
                child: Center(
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: collection.colors),
                      boxShadow: [
                        BoxShadow(
                          color: collection.colors.last.withValues(alpha: 0.22),
                          blurRadius: 24,
                        ),
                      ],
                    ),
                    child: Icon(collection.icon, size: 34, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoodCard extends StatelessWidget {
  const _MoodCard({
    required this.label,
    required this.detail,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final String detail;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Material(
        color: NovaColors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 178,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: NovaColors.border),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 26),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(detail,
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
    );
  }
}
