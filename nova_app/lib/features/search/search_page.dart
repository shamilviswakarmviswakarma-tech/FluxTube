import 'package:flutter/material.dart';

import '../../app/theme/nova_theme.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _queryController = TextEditingController();
  String _selectedFilter = 'All';

  static const _filters = ['All', 'Videos', 'Channels', 'Playlists'];

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Search',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Find videos, creators and playlists',
              style: TextStyle(color: NovaColors.secondaryText),
            ),
            const SizedBox(height: 22),
            TextField(
              controller: _queryController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _showPendingNotice(),
              decoration: InputDecoration(
                hintText: 'Search NovaTube',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: IconButton(
                  tooltip: 'Clear search',
                  onPressed: _queryController.clear,
                  icon: const Icon(Icons.close_rounded),
                ),
                filled: true,
                fillColor: NovaColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: NovaColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: NovaColors.border),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: _filters.map((filter) {
                final selected = filter == _selectedFilter;
                return ChoiceChip(
                  label: Text(filter),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedFilter = filter),
                  selectedColor: NovaColors.primary,
                  backgroundColor: NovaColors.surface,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : NovaColors.secondaryText,
                    fontWeight: FontWeight.w600,
                  ),
                  side: const BorderSide(color: NovaColors.border),
                );
              }).toList(),
            ),
            const Spacer(),
            const Center(
              child: Column(
                children: [
                  Icon(
                    Icons.travel_explore_rounded,
                    size: 52,
                    color: NovaColors.bright,
                  ),
                  SizedBox(height: 14),
                  Text(
                    'Your next discovery starts here',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Search providers are being connected.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: NovaColors.muted),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  void _showPendingNotice() {
    if (_queryController.text.trim().isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Search service is not connected yet.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
