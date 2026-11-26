import 'package:flutter/material.dart';

import '../../app/theme/nova_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
              'Profile',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 8),
            Text(
              'Personalize your NovaTube experience',
              style: TextStyle(color: NovaColors.secondaryText),
            ),
            Spacer(),
            Center(
              child: Icon(
                Icons.account_circle_outlined,
                size: 54,
                color: NovaColors.bright,
              ),
            ),
            SizedBox(height: 14),
            Center(
              child: Text(
                'Profile preferences are coming soon.',
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
