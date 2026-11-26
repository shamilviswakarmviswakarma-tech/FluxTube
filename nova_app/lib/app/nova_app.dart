import 'package:flutter/material.dart';

import 'navigation/nova_shell.dart';
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
      home: const NovaShell(),
    );
  }
}
