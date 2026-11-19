import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Represents the user's felt energy level for the day.
enum EnergyLevel {
  veryLow(
    label: 'Very low',
    description: 'Completely depleted, resting mode',
    intensityValue: 1,
    accentColor: Color(0xFF63697E),
    bars: 1,
  ),
  low(
    label: 'Low',
    description: 'Moving slowly, quiet reserves',
    intensityValue: 2,
    accentColor: AppColors.violetTwilight,
    bars: 2,
  ),
  balanced(
    label: 'Balanced',
    description: 'Steady, grounded rhythm',
    intensityValue: 3,
    accentColor: AppColors.sageSerenity,
    bars: 3,
  ),
  high(
    label: 'High',
    description: 'Dynamic, driven, engaged',
    intensityValue: 4,
    accentColor: AppColors.amberWarmth,
    bars: 4,
  ),
  veryHigh(
    label: 'Very high',
    description: 'Overflowing, vibrant, peak power',
    intensityValue: 5,
    accentColor: Color(0xFFFF9248),
    bars: 5,
  );

  final String label;
  final String description;
  final int intensityValue;
  final Color accentColor;
  final int bars;

  const EnergyLevel({
    required this.label,
    required this.description,
    required this.intensityValue,
    required this.accentColor,
    required this.bars,
  });
}
