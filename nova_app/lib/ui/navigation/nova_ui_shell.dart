import 'package:flutter/material.dart';

import '../../features/library/library_page.dart';
import '../../features/profile/profile_page.dart';
import '../../features/search/search_page.dart';
import '../explore/nova_explore_screen.dart';
import '../home/nova_home_screen.dart';
import '../theme/nova_theme.dart';

class NovaUiShell extends StatefulWidget {
  const NovaUiShell({super.key});

  @override
  State<NovaUiShell> createState() => _NovaUiShellState();
}

class _NovaUiShellState extends State<NovaUiShell> {
  int _selectedIndex = 0;

  late final List<Widget> _pages = [
    const NovaHomeScreen(),
    const NovaExploreScreen(),
    const SearchPage(),
    const LibraryPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
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
