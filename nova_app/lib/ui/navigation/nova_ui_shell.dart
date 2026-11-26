import 'package:flutter/material.dart';

import '../../features/library/library_page.dart';
import '../../features/profile/profile_page.dart';
import '../search/nova_search_screen.dart';
import '../video/nova_video_details_screen.dart';
import '../explore/nova_explore_screen.dart';
import '../home/nova_home_screen.dart';
import '../../app/theme/nova_theme.dart';

class NovaUiShell extends StatefulWidget {
  const NovaUiShell({super.key});

  @override
  State<NovaUiShell> createState() => _NovaUiShellState();
}

class _NovaUiShellState extends State<NovaUiShell> {
  int _selectedIndex = 0;

  late final List<Widget> _pages = [
    NovaHomeScreen(onVideoTap: _openVideo),
    NovaExploreScreen(onVideoTap: _openVideo),
    NovaSearchScreen(onVideoTap: _openVideo),
    const LibraryPage(),
    const ProfilePage(),
  ];

  void _openVideo(String videoId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => NovaVideoDetailsScreen(
          videoId: videoId,
          onRelatedVideoTap: _openVideo,
          onPlay: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Full Video Player is the next UI step.')),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore_rounded),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_rounded),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.video_library_outlined),
            selectedIcon: Icon(Icons.video_library_rounded),
            label: 'Library',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
      backgroundColor: NovaColors.background,
    );
  }
}
