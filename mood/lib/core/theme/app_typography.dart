import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography system for MoodCanvas.
/// Harmonious pairing:
/// - Outfit: Warm, rounded, sculptural modern geometric displays for titles & emotions.
/// - Plus Jakarta Sans: Highly legible, contemporary neo-grotesque for UI & body.
/// - Newsreader: Intimate literary serif for personal journaling and reflective quotes.
class AppTypography {
  AppTypography._();

  // Headings & Emotional Displays (Outfit)
  static TextStyle get displayLarge => GoogleFonts.outfit(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        height: 1.25,
        color: AppColors.textPrimary,
      );

  static TextStyle get displayMedium => GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        height: 1.3,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleLarge => GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.35,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleMedium => GoogleFonts.outfit(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        height: 1.4,
        color: AppColors.textPrimary,
      );

  // Body & Interactive UI (Plus Jakarta Sans)
  static TextStyle get bodyLarge => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        height: 1.6,
        color: AppColors.textSecondary,
      );

  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        height: 1.5,
        color: AppColors.textSecondary,
      );

  static TextStyle get button => GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
        color: AppColors.background,
      );

  static TextStyle get label => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.6,
        color: AppColors.textTertiary,
      );

  // Reflective & Journaling / Quotes (Newsreader Editorial Serif)
  static TextStyle get journal => GoogleFonts.newsreader(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.65,
        letterSpacing: 0.15,
        color: AppColors.textPrimary,
      );

  static TextStyle get quote => GoogleFonts.newsreader(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic,
        height: 1.55,
        letterSpacing: 0.2,
        color: AppColors.textTertiary,
      );
}
