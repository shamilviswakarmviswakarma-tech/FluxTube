import 'package:flutter/material.dart';

import '../../app/theme/nova_theme.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 18),
            const Text(
              'Library',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your saved videos and learning space',
              style: TextStyle(color: NovaColors.secondaryText),
            ),
            const Spacer(),
            const Center(
              child: Icon(
                Icons.video_library_rounded,
                size: 54,
                color: NovaColors.bright,
              ),
            ),
            const SizedBox(height: 14),
            const Center(
              child: Text(
                'Your playlists, history and bookmarks will appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(color: NovaColors.muted),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
