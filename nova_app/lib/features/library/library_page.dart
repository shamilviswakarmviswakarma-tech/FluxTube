import 'package:flutter/material.dart';

import '../../app/theme/nova_theme.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 18),
            Text(
              'Library',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 8),
            Text(
              'Your saved videos and learning space',
              style: TextStyle(color: NovaColors.secondaryText),
            ),
            Spacer(),
            Center(
              child: Icon(
                Icons.video_library_rounded,
                size: 54,
                color: NovaColors.bright,
              ),
            ),
            SizedBox(height: 14),
            Center(
              child: Text(
                'Your playlists, history and bookmarks will appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(color: NovaColors.muted),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}