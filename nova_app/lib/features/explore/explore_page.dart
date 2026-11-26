import 'package:flutter/material.dart';

import '../../app/theme/nova_theme.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

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
              'Explore',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 8),
            Text(
              'Discover something worth your time',
              style: TextStyle(color: NovaColors.secondaryText),
            ),
            Spacer(),
            Center(
              child: Icon(
                Icons.explore_rounded,
                size: 54,
                color: NovaColors.bright,
              ),
            ),
            SizedBox(height: 14),
            Center(
              child: Text(
                'Explore recommendations are being connected.',
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
