import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Available primary moods for the daily capture flow.
/// Each mood carries emotional visual identity and color tones.
enum MoodType {
  happy(
    label: 'Happy',
    tagline: 'Warm, joyful, content',
    primaryColor: AppColors.amberWarmth,
    secondaryColor: Color(0xFFF9D08B),
    icon: Icons.wb_sunny_rounded,
  ),
  calm(
    label: 'Calm',
    tagline: 'Serene, centered, still',
    primaryColor: AppColors.sageSerenity,
    secondaryColor: Color(0xFFA5C5B5),
    icon: Icons.spa_rounded,
  ),
  excited(
    label: 'Excited',
    tagline: 'Electric, enthusiastic, alive',
    primaryColor: Color(0xFFFF9F68),
    secondaryColor: Color(0xFFFF6B6B),
    icon: Icons.bolt_rounded,
  ),
  loved(
    label: 'Loved',
    tagline: 'Connected, cherished, soft',
    primaryColor: AppColors.roseDusk,
    secondaryColor: Color(0xFFF0ACB1),
    icon: Icons.favorite_rounded,
  ),
  okay(
    label: 'Okay',
    tagline: 'Balanced, neutral, steady',
    primaryColor: Color(0xFF9EA3B0),
    secondaryColor: Color(0xFFCCD0DC),
    icon: Icons.waves_rounded,
  ),
  sad(
    label: 'Sad',
    tagline: 'Tender, heavy, quiet',
    primaryColor: AppColors.mistBlue,
    secondaryColor: Color(0xFF5D7BAF),
    icon: Icons.water_drop_rounded,
  ),
  anxious(
    label: 'Anxious',
    tagline: 'Restless, racing, overwhelmed',
    primaryColor: Color(0xFFE2847A),
    secondaryColor: Color(0xFFB85950),
    icon: Icons.grain_rounded,
  ),
  angry(
    label: 'Angry',
    tagline: 'Frustrated, burning, tense',
    primaryColor: Color(0xFFE76F51),
    secondaryColor: Color(0xFFD62828),
    icon: Icons.local_fire_department_rounded,
  ),
  tired(
    label: 'Tired',
    tagline: 'Drained, weary, slow',
    primaryColor: AppColors.violetTwilight,
    secondaryColor: Color(0xFF7E6F96),
    icon: Icons.nightlight_round,
  ),
  lonely(
    label: 'Lonely',
    tagline: 'Distant, yearning, solo',
    primaryColor: Color(0xFF7A8B99),
    secondaryColor: Color(0xFF485866),
    icon: Icons.cloud_outlined,
  );

  final String label;
  final String tagline;
  final Color primaryColor;
  final Color secondaryColor;
  final IconData icon;

  const MoodType({
    required this.label,
    required this.tagline,
    required this.primaryColor,
    required this.secondaryColor,
    required this.icon,
  });
}
