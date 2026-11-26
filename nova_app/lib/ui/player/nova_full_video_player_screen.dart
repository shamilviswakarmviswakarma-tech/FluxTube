import 'package:flutter/material.dart';

import '../../app/theme/nova_theme.dart';

class NovaFullVideoPlayerScreen extends StatefulWidget {
  const NovaFullVideoPlayerScreen({
    super.key,
    required this.videoId,
    this.title = 'Now playing',
  });

  final String videoId;
  final String title;

  @override
  State<NovaFullVideoPlayerScreen> createState() =>
      _NovaFullVideoPlayerScreenState();
}

class _NovaFullVideoPlayerScreenState extends State<NovaFullVideoPlayerScreen> {
  bool _playing = true;
  bool _showControls = true;
  bool _captions = false;
  bool _locked = false;
  double _progress = 0.28;
  double _speed = 1;
  double _volume = 0.7;

  String _time(double value) {
    final seconds = (value * 1122).round();
    final minutes = seconds ~/ 60;
    return '$minutes:${(seconds % 60).toString().padLeft(2, '0')}';
  }

  void _seek(double delta) {
    setState(() => _progress = (_progress + delta).clamp(0.0, 1.0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            tooltip: 'More player options',
            onPressed: _showPlayerOptions,
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth > 700;
            final player = _playerSurface();
            if (wide) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1180),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Expanded(flex: 8, child: player),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 3,
                          child: _PlayerSidePanel(
                            captions: _captions,
                            onCaptionTap: () =>
                                setState(() => _captions = !_captions),
                            onSeek: _seek,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return Column(
              children: [
                const SizedBox(height: 18),
                player,
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: _PlayerSidePanel(
                    captions: _captions,
                    onCaptionTap: () => setState(() => _captions = !_captions),
                    onSeek: _seek,
                  ),
                ),
                const Spacer(),
                _PlaybackInfo(
                  title: widget.title,
                  videoId: widget.videoId,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _playerSurface() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: GestureDetector(
        onTap: () => setState(() => _showControls = !_showControls),
        onDoubleTapDown: (details) {
          if (_locked) return;
          final width = context.size?.width ?? 1;
          _seek(details.localPosition.dx < width / 2 ? -10 / 1122 : 10 / 1122);
        },
        onVerticalDragUpdate: (details) {
          if (_locked) return;
          final width = context.size?.width ?? 1;
          if (details.localPosition.dx > width / 2) {
            setState(() =>
                _volume = (_volume - details.delta.dy / 250).clamp(0.0, 1.0));
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF071321), Color(0xFF102C50)],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
              ),
              child: Center(
                child:
                    Icon(Icons.movie_outlined, size: 76, color: Colors.white24),
              ),
            ),
            if (_showControls)
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.58),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.68),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            if (_showControls && !_locked)
              Positioned.fill(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        tooltip: 'Player settings',
                        onPressed: _showPlayerOptions,
                        icon: const Icon(Icons.settings_rounded,
                            color: Colors.white),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          tooltip: 'Back 10 seconds',
                          onPressed: () => _seek(-10 / 1122),
                          icon: const Icon(Icons.replay_10_rounded,
                              color: Colors.white, size: 38),
                        ),
                        const SizedBox(width: 24),
                        IconButton(
                          tooltip: _playing ? 'Pause' : 'Play',
                          onPressed: () => setState(() => _playing = !_playing),
                          icon: Icon(
                            _playing
                                ? Icons.pause_circle_filled_rounded
                                : Icons.play_circle_fill_rounded,
                            color: Colors.white,
                            size: 62,
                          ),
                        ),
                        const SizedBox(width: 24),
                        IconButton(
                          tooltip: 'Forward 10 seconds',
                          onPressed: () => _seek(10 / 1122),
                          icon: const Icon(Icons.forward_10_rounded,
                              color: Colors.white, size: 38),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(_time(_progress),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 11)),
                              const Spacer(),
                              Text('18:42',
                                  style: TextStyle(
                                      color: Colors.white.withValues(alpha: .8),
                                      fontSize: 11)),
                            ],
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 3,
                              thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 5),
                            ),
                            child: Slider(
                              value: _progress,
                              onChanged: (value) =>
                                  setState(() => _progress = value),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                tooltip: 'Captions',
                                onPressed: () =>
                                    setState(() => _captions = !_captions),
                                color: _captions
                                    ? NovaColors.bright
                                    : Colors.white,
                                icon: const Icon(Icons.closed_caption_rounded),
                              ),
                              IconButton(
                                tooltip: 'Volume',
                                onPressed: () => setState(
                                    () => _volume = _volume == 0 ? .7 : 0),
                                color: Colors.white,
                                icon: Icon(_volume == 0
                                    ? Icons.volume_off_rounded
                                    : Icons.volume_up_rounded),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: _showSpeedPicker,
                                child: Text(
                                  '${_speed}x',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              IconButton(
                                tooltip: _locked
                                    ? 'Unlock controls'
                                    : 'Lock controls',
                                onPressed: () =>
                                    setState(() => _locked = !_locked),
                                color: Colors.white,
                                icon: Icon(_locked
                                    ? Icons.lock_rounded
                                    : Icons.lock_open_rounded),
                              ),
                              IconButton(
                                tooltip: 'Fullscreen',
                                onPressed: () {},
                                color: Colors.white,
                                icon: const Icon(Icons.fullscreen_rounded),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            if (_locked)
              Positioned(
                right: 12,
                top: 12,
                child: IconButton.filledTonal(
                  tooltip: 'Unlock controls',
                  onPressed: () => setState(() => _locked = false),
                  icon: const Icon(Icons.lock_rounded),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showSpeedPicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: NovaColors.surface,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Playback speed',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0]
                    .map((speed) => ChoiceChip(
                          label: Text('${speed}x'),
                          selected: _speed == speed,
                          onSelected: (_) {
                            setState(() => _speed = speed);
                            Navigator.pop(context);
                          },
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPlayerOptions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: NovaColors.surface,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.closed_caption_rounded),
              title: const Text('Captions'),
              trailing: Switch(
                value: _captions,
                onChanged: (value) {
                  setState(() => _captions = value);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.speed_rounded),
              title: const Text('Playback speed'),
              subtitle: Text('${_speed}x'),
              onTap: () {
                Navigator.pop(context);
                _showSpeedPicker();
              },
            ),
            ListTile(
              leading: const Icon(Icons.screen_rotation_rounded),
              title: const Text('Screen orientation'),
              subtitle:
                  const Text('Device orientation controls are not connected'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerSidePanel extends StatelessWidget {
  const _PlayerSidePanel({
    required this.captions,
    required this.onCaptionTap,
    required this.onSeek,
  });

  final bool captions;
  final VoidCallback onCaptionTap;
  final ValueChanged<double> onSeek;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Playback tools',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        _ToolTile(
          icon: Icons.closed_caption_rounded,
          title: 'Captions',
          subtitle: captions ? 'Enabled' : 'Off',
          onTap: onCaptionTap,
        ),
        const _ToolTile(
          icon: Icons.notes_rounded,
          title: 'Transcript',
          subtitle: 'Transcript will appear when available',
        ),
        const _ToolTile(
          icon: Icons.auto_awesome_rounded,
          title: 'AI Studio',
          subtitle: 'Summaries, notes and study tools',
        ),
        const SizedBox(height: 16),
        const Text('Quick seek', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            ActionChip(
              label: const Text('-30 sec'),
              onPressed: () => onSeek(-30 / 1122),
            ),
            ActionChip(
              label: const Text('+30 sec'),
              onPressed: () => onSeek(30 / 1122),
            ),
          ],
        ),
      ],
    );
  }
}

class _ToolTile extends StatelessWidget {
  const _ToolTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: NovaColors.bright),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle,
          style: const TextStyle(color: NovaColors.muted, fontSize: 11)),
      onTap: onTap,
    );
  }
}

class _PlaybackInfo extends StatelessWidget {
  const _PlaybackInfo({required this.title, required this.videoId});

  final String title;
  final String videoId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 5),
          Text('NovaTube preview • $videoId',
              style: const TextStyle(color: NovaColors.muted, fontSize: 12)),
        ],
      ),
    );
  }
}
