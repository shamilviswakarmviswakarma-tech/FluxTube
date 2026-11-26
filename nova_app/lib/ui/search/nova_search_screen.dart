import 'package:flutter/material.dart';

import '../../app/theme/nova_theme.dart';

class NovaSearchScreen extends StatefulWidget {
  const NovaSearchScreen({super.key, this.onVideoTap});

  final ValueChanged<String>? onVideoTap;

  @override
  State<NovaSearchScreen> createState() => _NovaSearchScreenState();
}

class _NovaSearchScreenState extends State<NovaSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _query = '';
  String _filter = 'All';
  bool _showSuggestions = false;
  bool _filtersExpanded = false;
  String _sort = 'Relevance';
  String _duration = 'Any duration';
  final List<String> _recentSearches = [];

  static const _filters = ['All', 'Videos', 'Channels', 'Playlists'];
  static const _suggestions = [
    'Flutter app development',
    'Artificial intelligence',
    'Learn English speaking',
    'Space documentaries',
    'Cinematic video editing',
  ];

  static const _results = [
    _SearchResult(
      id: 'flutter-ui',
      title: 'Build a beautiful Flutter app from scratch',
      channel: 'Code with Arjun',
      meta: '184K views • 3 days ago',
      duration: '22:18',
      category: 'DEVELOPMENT',
      colors: [Color(0xFF123C70), Color(0xFF1677FF)],
      icon: Icons.code_rounded,
      kind: 'Videos',
    ),
    _SearchResult(
      id: 'ai-explained',
      title: 'Artificial Intelligence explained simply',
      channel: 'The Learning Lab',
      meta: '1.2M views • 1 week ago',
      duration: '16:42',
      category: 'LEARNING',
      colors: [Color(0xFF3B286B), Color(0xFF9865D8)],
      icon: Icons.psychology_alt_rounded,
      kind: 'Videos',
    ),
    _SearchResult(
      id: 'english',
      title: 'Speak English confidently: daily practice',
      channel: 'Everyday English',
      meta: '92K views • 2 weeks ago',
      duration: '12:06',
      category: 'LANGUAGE',
      colors: [Color(0xFF145448), Color(0xFF28A58A)],
      icon: Icons.record_voice_over_rounded,
      kind: 'Videos',
    ),
    _SearchResult(
      id: 'space',
      title: 'Space Explained',
      channel: 'Orbit Stories',
      meta: 'Verified creator • 840K subscribers',
      duration: '',
      category: 'CHANNEL',
      colors: [Color(0xFF183B57), Color(0xFF287A9B)],
      icon: Icons.public_rounded,
      kind: 'Channels',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit(String value) {
    final query = value.trim();
    if (query.isEmpty) return;
    setState(() {
      _recentSearches.remove(query);
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 5) _recentSearches.removeLast();
      _query = query;
      _controller.text = query;
      _showSuggestions = false;
      _focusNode.unfocus();
    });
  }

  void _clear() {
    _controller.clear();
    setState(() {
      _query = '';
      _showSuggestions = false;
    });
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 700;
        final horizontal = wide ? 32.0 : 18.0;
        final visibleResults = _results.where((item) {
          final matchesFilter = _filter == 'All' || item.kind == _filter;
          final q = _query.toLowerCase();
          final matchesQuery = q.isEmpty ||
              item.title.toLowerCase().contains(q) ||
              item.channel.toLowerCase().contains(q) ||
              item.category.toLowerCase().contains(q);
          final minutes = _durationMinutes(item.duration);
          final matchesDuration = switch (_duration) {
            'Under 4 min' => minutes != null && minutes < 4,
            '4–20 min' => minutes != null && minutes >= 4 && minutes <= 20,
            'Over 20 min' => minutes != null && minutes > 20,
            _ => true,
          };
          return matchesFilter && matchesQuery && matchesDuration;
        }).toList()
          ..sort((a, b) {
            switch (_sort) {
              case 'Title A–Z':
                return a.title.compareTo(b.title);
              case 'Shortest':
                return (_durationMinutes(a.duration) ?? 0)
                    .compareTo(_durationMinutes(b.duration) ?? 0);
              case 'Longest':
                return (_durationMinutes(b.duration) ?? 0)
                    .compareTo(_durationMinutes(a.duration) ?? 0);
              default:
                return 0;
            }
          });

        return SafeArea(
          child: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(horizontal, 20, horizontal, 10),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Search',
                        style: TextStyle(
                          fontSize: 29,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.8,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Find videos, creators and ideas',
                        style: TextStyle(color: NovaColors.secondaryText),
                      ),
                      const SizedBox(height: 20),
                      _SearchField(
                        controller: _controller,
                        focusNode: _focusNode,
                        onChanged: (value) => setState(() {
                          _showSuggestions = value.trim().isNotEmpty;
                          _query = '';
                        }),
                        onSubmitted: _submit,
                        onClear: _clear,
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 42,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _filters.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final item = _filters[index];
                            final selected = _filter == item;
                            return ChoiceChip(
                              label: Text(item),
                              selected: selected,
                              onSelected: (_) => setState(() => _filter = item),
                              showCheckmark: false,
                              selectedColor: NovaColors.primary,
                              backgroundColor: NovaColors.surface,
                              side: BorderSide(
                                color: selected
                                    ? NovaColors.primary
                                    : NovaColors.border,
                              ),
                              labelStyle: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : NovaColors.secondaryText,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          },
                        ),
                      ),
                      if (_showSuggestions && _controller.text.isNotEmpty)
                        _SuggestionPanel(
                          query: _controller.text,
                          onSelected: _submit,
                        )
                      else if (_query.isEmpty) ...[
                        const SizedBox(height: 26),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Trending searches',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => setState(() {
                                _controller.clear();
                                _query = '';
                              }),
                              child: const Text('Clear'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ..._suggestions.map(
                          (item) => _TrendingSearchTile(
                            title: item,
                            onTap: () => _submit(item),
                          ),
                        ),
                        const SizedBox(height: 18),
                        _RecentSearchCard(onSelect: _submit),
                      ],
                      if (_query.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Results for “$_query”',
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            IconButton(
                              tooltip: 'More filters',
                              onPressed: () => setState(
                                () => _filtersExpanded = !_filtersExpanded,
                              ),
                              icon: Icon(
                                _filtersExpanded
                                    ? Icons.tune_rounded
                                    : Icons.filter_list_rounded,
                                color: NovaColors.bright,
                              ),
                            ),
                          ],
                        ),
                        if (_filtersExpanded)
                          _AdvancedFilters(
                            sort: _sort,
                            duration: _duration,
                            onSortChanged: (value) =>
                                setState(() => _sort = value),
                            onDurationChanged: (value) =>
                                setState(() => _duration = value),
                          ),
                        const SizedBox(height: 8),
                        if (visibleResults.isEmpty)
                          const _EmptyResults()
                        else
                          _SearchResults(
                            results: visibleResults,
                            wide: wide,
                            onVideoTap: widget.onVideoTap,
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        hintText: 'Search NovaTube',
        prefixIcon: const Icon(Icons.search_rounded, color: NovaColors.bright),
        suffixIcon: IconButton(
          tooltip: 'Clear search',
          onPressed: onClear,
          icon: const Icon(Icons.close_rounded),
        ),
        filled: true,
        fillColor: NovaColors.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: NovaColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: NovaColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: NovaColors.primary, width: 1.4),
        ),
      ),
    );
  }
}

class _SuggestionPanel extends StatelessWidget {
  const _SuggestionPanel({required this.query, required this.onSelected});

  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final matches = _NovaSearchScreenState._suggestions
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();
    final suggestions = matches.isEmpty ? ['Search for “$query”'] : matches;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: NovaColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NovaColors.border),
      ),
      child: Column(
        children: suggestions
            .map(
              (item) => ListTile(
                dense: true,
                leading: const Icon(
                  Icons.search_rounded,
                  color: NovaColors.muted,
                ),
                title: Text(item),
                onTap: () => onSelected(
                  item.startsWith('Search for “') ? query : item,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _TrendingSearchTile extends StatelessWidget {
  const _TrendingSearchTile({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.trending_up_rounded, color: NovaColors.muted),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: const Icon(Icons.north_west_rounded, size: 17),
      onTap: onTap,
    );
  }
}

class _RecentSearchCard extends StatelessWidget {
  const _RecentSearchCard({
    required this.searches,
    required this.onSelect,
    required this.onClear,
  });

  final List<String> searches;
  final ValueChanged<String> onSelect;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NovaColors.deepNavy,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: NovaColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.history_rounded, color: NovaColors.bright, size: 25),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Recent searches',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(
                  searches.isEmpty
                      ? 'Your searches from this session appear here'
                      : searches.take(3).join('  •  '),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: NovaColors.muted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (searches.isNotEmpty)
            IconButton(
              tooltip: 'Clear recent searches',
              onPressed: onClear,
              icon: const Icon(Icons.delete_outline_rounded),
            )
          else
            IconButton(
              tooltip: 'Try a suggestion',
              onPressed: () => onSelect('Artificial intelligence'),
              icon: const Icon(Icons.arrow_forward_rounded),
            ),
        ],
      ),
    );
  }
}

class _AdvancedFilters extends StatelessWidget {
  const _AdvancedFilters({
    required this.sort,
    required this.duration,
    required this.onSortChanged,
    required this.onDurationChanged,
  });

  final String sort;
  final String duration;
  final ValueChanged<String> onSortChanged;
  final ValueChanged<String> onDurationChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: NovaColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NovaColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sort by', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['Relevance', 'Title A–Z', 'Shortest', 'Longest']
                .map(
                  (value) => ChoiceChip(
                    label: Text(value),
                    selected: sort == value,
                    onSelected: (_) => onSortChanged(value),
                    showCheckmark: false,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          const Text('Duration', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['Any duration', 'Under 4 min', '4–20 min', 'Over 20 min']
                .map(
                  (value) => ChoiceChip(
                    label: Text(value),
                    selected: duration == value,
                    onSelected: (_) => onDurationChanged(value),
                    showCheckmark: false,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({
    required this.results,
    required this.wide,
    required this.onVideoTap,
  });

  final List<_SearchResult> results;
  final bool wide;
  final ValueChanged<String>? onVideoTap;

  @override
  Widget build(BuildContext context) {
    if (wide) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: results.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.72,
        ),
        itemBuilder: (context, index) => _ResultCard(
          item: results[index],
          onTap: () => onVideoTap?.call(results[index].id),
        ),
      );
    }
    return Column(
      children: results
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _ResultCard(
                item: item,
                onTap: () => onVideoTap?.call(item.id),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.item, required this.onTap});

  final _SearchResult item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: AspectRatio(
              aspectRatio: 16 / 10,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: item.colors),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(item.icon, size: 38, color: Colors.white70),
                    ),
                    Positioned(
                      left: 8,
                      top: 8,
                      child: Text(
                        item.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (item.duration.isNotEmpty)
                      Positioned(
                        right: 7,
                        bottom: 7,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 3,
                            ),
                            child: Text(
                              item.duration,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.channel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: NovaColors.secondaryText,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.meta,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: NovaColors.muted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            tooltip: 'More options',
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded, size: 19),
          ),
        ],
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 48, color: NovaColors.muted),
          SizedBox(height: 12),
          Text(
            'No matching preview results',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 5),
          Text(
            'Try another search or change the filters.',
            style: TextStyle(color: NovaColors.muted, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

int? _durationMinutes(String duration) {
  if (duration.isEmpty) return null;
  final parts = duration.split(':');
  if (parts.length != 2) return null;
  return int.tryParse(parts.first);
}

class _SearchResult {
  const _SearchResult({
    required this.id,
    required this.title,
    required this.channel,
    required this.meta,
    required this.duration,
    required this.category,
    required this.colors,
    required this.icon,
    required this.kind,
  });

  final String id;
  final String title;
  final String channel;
  final String meta;
  final String duration;
  final String category;
  final List<Color> colors;
  final IconData icon;
  final String kind;
}
