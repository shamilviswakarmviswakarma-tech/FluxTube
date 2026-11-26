import 'package:flutter/material.dart';

import '../../app/theme/nova_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
              'Profile',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Personalize your NovaTube experience',
              style: TextStyle(color: NovaColors.secondaryText),
            ),
            const Spacer(),
            const Center(
              child: Icon(
                Icons.account_circle_outlined,
                size: 54,
                color: NovaColors.bright,
              ),
            ),
            const SizedBox(height: 14),
            const Center(
              child: Text(
                'Profile preferences are coming soon.',
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
