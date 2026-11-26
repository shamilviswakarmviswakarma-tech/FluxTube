import 'package:flutter/material.dart';

import '../../app/theme/nova_theme.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 18),
            Text('$title', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            const Text('$subtitle', style: TextStyle(color: NovaColors.secondaryText)),
            const Spacer(),
            Center(child: Icon($icon, size: 54, color: NovaColors.bright)),
            const SizedBox(height: 14),
            const Center(
              child: Text(
                'This NovaTube section is being built.',
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
