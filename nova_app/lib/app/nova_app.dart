import 'package:flutter/material.dart';

import '../ui/navigation/nova_ui_shell.dart';
import 'theme/nova_theme.dart';

class NovaTubeApp extends StatelessWidget {
  const NovaTubeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NovaTube',
      debugShowCheckedModeBanner: false,
      theme: NovaTheme.dark(),
      darkTheme: NovaTheme.dark(),
      themeMode: ThemeMode.dark,
      home: const NovaUiShell(),
    );
  }
}
