import 'package:flutter/material.dart';

abstract final class NovaColors {
  static const background = Color(0xFF000000);
  static const deepNavy = Color(0xFF080D18);
  static const surface = Color(0xFF111722);
  static const elevated = Color(0xFF182233);
  static const primary = Color(0xFF1677FF);
  static const bright = Color(0xFF54B5FF);
  static const text = Color(0xFFFFFFFF);
  static const secondaryText = Color(0xFF9BA8BB);
  static const muted = Color(0xFF64748B);
  static const border = Color(0xFF263247);
  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);
}

abstract final class NovaTheme {
  static ThemeData dark() {
    const scheme = ColorScheme.dark(
      primary: NovaColors.primary,
      secondary: NovaColors.bright,
      surface: NovaColors.surface,
      error: NovaColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: NovaColors.text,
      onError: Colors.white,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: NovaColors.background,
      colorScheme: scheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: NovaColors.background,
        foregroundColor: NovaColors.text,
        elevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: NovaColors.deepNavy,
        indicatorColor: NovaColors.primary.withValues(alpha: 0.22),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            color: selected ? NovaColors.bright : NovaColors.muted,
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          );
        }),
      ),
      cardTheme: CardThemeData(
        color: NovaColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: NovaColors.border),
        ),
      ),
      dividerColor: NovaColors.border,
    );
  }
}
