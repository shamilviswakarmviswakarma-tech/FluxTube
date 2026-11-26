import 'package:flutter/material.dart';

import '../../app/theme/nova_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: const Text(
              'NovaTube',
              style:
                  TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.5),
            ),
            actions: [
              IconButton(
                tooltip: 'Notifications',
                onPressed: () {},
                icon: const Icon(Icons.notifications_none_rounded),
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Watch. Learn. Create.',
                    style: TextStyle(
                      color: NovaColors.secondaryText,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Your next discovery',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    height: 190,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [NovaColors.elevated, NovaColors.deepNavy],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: NovaColors.border),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.play_circle_outline_rounded,
                        size: 58,
                        color: NovaColors.bright,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Made for your curiosity',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your personalized video experience is taking shape.',
                    style: TextStyle(color: NovaColors.secondaryText),
                  ),
                  const SizedBox(height: 20),
                  const _FeatureTile(
                    icon: Icons.auto_awesome,
                    title: 'AI Studio',
                    subtitle:
                        'Turn available transcripts into summaries and notes.',
                  ),
                  const SizedBox(height: 12),
                  const _FeatureTile(
                    icon: Icons.bookmark_outline_rounded,
                    title: 'Your Library',
                    subtitle:
                        'Keep videos, playlists, bookmarks and learning notes together.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NovaColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: NovaColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: NovaColors.bright, size: 26),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
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
        ],
      ),
    );
  }
}
