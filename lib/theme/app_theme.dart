import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.pitchPrimary,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.pitchPrimary,
      onPrimary: Colors.white,
      secondary: AppColors.gold,
      surface: Colors.white,
      outline: AppColors.chalkLine,
    );

    final textTheme = AppTextStyles.buildTextTheme(
      primaryTextColor: AppColors.pitchPrimary,
      secondaryTextColor: AppColors.inkMuted,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: const Color(0xFFF4F7F5), // Blanco verdoso muy moderno
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.pitchPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.headlineSmall?.copyWith(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 8,
        shadowColor: AppColors.pitchPrimary.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.pitchPrimary,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.05)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.pitchPrimary, width: 2),
        ),
      ),
    );
  }

  static ThemeData get dark => light;
}
