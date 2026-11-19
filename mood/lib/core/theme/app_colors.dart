import 'package:flutter/material.dart';

/// Design tokens for MoodCanvas.
/// Emotionally resonant, calm, artistic, and minimalist palette.
class AppColors {
  AppColors._();

  // Backgrounds
  static const Color background = Color(0xFF0F1016);
  static const Color surface = Color(0xFF181A24);
  static const Color surfaceElevated = Color(0xFF222533);
  static const Color surfaceGlass = Color(0x1AFFFFFF);

  // Emotional & Canvas Accents
  static const Color amberWarmth = Color(0xFFE8B074);
  static const Color roseDusk = Color(0xFFDF8B88);
  static const Color sageSerenity = Color(0xFF7FA99B);
  static const Color violetTwilight = Color(0xFFA799B7);
  static const Color mistBlue = Color(0xFF86A5D9);

  // Text Colors
  static const Color textPrimary = Color(0xFFF6F5F2);
  static const Color textSecondary = Color(0xFFB0B3C1);
  static const Color textTertiary = Color(0xFF6B7082);

  // Primary Accent Gradient
  static const List<Color> canvasGradient = [
    Color(0xFFE8B074),
    Color(0xFFDF8B88),
  ];

  // Subtle Borders & Dividers
  static const Color borderSubtle = Color(0x1FFFFFFF);

  // Theme-aware Dynamic Color Resolution Helpers (locked to dark theme)
  static Color backgroundOf(BuildContext context) => background;

  static Color surfaceOf(BuildContext context) => surface;

  static Color surfaceElevatedOf(BuildContext context) => surfaceElevated;

  static Color textPrimaryOf(BuildContext context) => textPrimary;

  static Color textSecondaryOf(BuildContext context) => textSecondary;

  static Color textTertiaryOf(BuildContext context) => textTertiary;

  static Color borderSubtleOf(BuildContext context) => borderSubtle;
}

