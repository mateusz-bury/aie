import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'aie_theme_extension.dart';

class AppTheme {
  static ThemeData forKeyName(String key) {
    switch (key) {
      case 'red':
        return redDark;
      case 'gray':
        return grayLight;
      case 'blue':
      default:
        return blueDark;
    }
  }

  /// Current default (blue-ish) dark theme
  static final ThemeData blueDark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      background: AppColors.background,
      surface: AppColors.surface,
    ),
    extensions: const [
      AieThemeExtension(gradientTop: AppColors.surface2, gradientBottom: AppColors.background2),
    ],
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.text,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.primary.withOpacity(0.25)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      labelStyle: const TextStyle(color: AppColors.textMuted),
      hintStyle: const TextStyle(color: AppColors.textMuted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary.withOpacity(0.18)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
      ),
      prefixIconColor: AppColors.accent,
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.primary.withOpacity(0.18),
      thickness: 1,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: AppColors.text, fontWeight: FontWeight.w700),
      titleMedium: TextStyle(color: AppColors.text, fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(color: AppColors.text),
      bodySmall: TextStyle(color: AppColors.textMuted),
    ),
  );

  /// Red gradient variant (still dark)
  static final ThemeData redDark = blueDark.copyWith(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFEF4444),
      secondary: Color(0xFFF97316),
      background: AppColors.background,
      surface: AppColors.surface,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFEF4444),
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFEF4444),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    extensions: const [
      AieThemeExtension(gradientTop: Color(0xFF3B1D2A), gradientBottom: Color(0xFF0F1115)),
    ],
  );

  /// Light gray "technical" theme (not pure white)
  static final ThemeData grayLight = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFE6E8EC),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF374151),
      secondary: Color(0xFF4B5563),
      background: Color(0xFFE6E8EC),
      surface: Color(0xFFF1F2F4),
    ),
    extensions: const [
      AieThemeExtension(gradientTop: Color(0xFFF1F2F4), gradientBottom: Color(0xFFD9DCE1)),
    ],
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Color(0xFF111827),
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFFF1F2F4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF374151),
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF374151),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF1F2F4),
      labelStyle: const TextStyle(color: Color(0xFF374151)),
      hintStyle: const TextStyle(color: Color(0xFF6B7280)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF374151), width: 1.4),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFCBD5E1),
      thickness: 1,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Color(0xFF111827), fontWeight: FontWeight.w700),
      titleMedium: TextStyle(color: Color(0xFF111827), fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(color: Color(0xFF111827)),
      bodySmall: TextStyle(color: Color(0xFF4B5563)),
    ),
  );
}
