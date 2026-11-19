import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../capture/domain/mood_type.dart';

/// Visual styling rules mapped to each primary emotional mood.
class MoodVisualSpec {
  final Color baseBackground;
  final List<Color> atmosphericGradient;
  final List<Color> paletteColors;
  final double blurIntensity;
  final bool prefersAngularShapes;

  const MoodVisualSpec({
    required this.baseBackground,
    required this.atmosphericGradient,
    required this.paletteColors,
    this.blurIntensity = 24.0,
    this.prefersAngularShapes = false,
  });
}

class MoodVisualRules {
  MoodVisualRules._();

  static MoodVisualSpec getSpec(MoodType mood) {
    switch (mood) {
      case MoodType.happy:
        return const MoodVisualSpec(
          baseBackground: Color(0xFF14120E),
          atmosphericGradient: [
            Color(0xFF2C2011),
            Color(0xFF1A130A),
            Color(0xFF0F1016),
          ],
          paletteColors: [
            AppColors.amberWarmth,
            Color(0xFFFFB74D),
            Color(0xFFFF8A65),
            Color(0xFFFFD54F),
          ],
          blurIntensity: 28.0,
        );

      case MoodType.calm:
        return const MoodVisualSpec(
          baseBackground: Color(0xFF0A1416),
          atmosphericGradient: [
            Color(0xFF122C34),
            Color(0xFF0C1C22),
            Color(0xFF071116),
          ],
          paletteColors: [
            AppColors.sageSerenity,
            Color(0xFF4DB6AC),
            Color(0xFF80DEEA),
            Color(0xFFB2DFDB),
          ],
          blurIntensity: 36.0,
        );

      case MoodType.excited:
        return const MoodVisualSpec(
          baseBackground: Color(0xFF190F0F),
          atmosphericGradient: [
            Color(0xFF331414),
            Color(0xFF220E11),
            Color(0xFF0F1016),
          ],
          paletteColors: [
            Color(0xFFFF6E40),
            Color(0xFFFFD740),
            Color(0xFFFF5252),
            Color(0xFFFFAB40),
          ],
          blurIntensity: 20.0,
          prefersAngularShapes: true,
        );

      case MoodType.loved:
        return const MoodVisualSpec(
          baseBackground: Color(0xFF160E12),
          atmosphericGradient: [
            Color(0xFF2C131F),
            Color(0xFF1C0D15),
            Color(0xFF0F1016),
          ],
          paletteColors: [
            AppColors.roseDusk,
            Color(0xFFF48FB1),
            Color(0xFFFFCCBC),
            Color(0xFFCE93D8),
          ],
          blurIntensity: 32.0,
        );

      case MoodType.okay:
        return const MoodVisualSpec(
          baseBackground: Color(0xFF11141C),
          atmosphericGradient: [
            Color(0xFF1C2234),
            Color(0xFF131726),
            Color(0xFF0C0E18),
          ],
          paletteColors: [
            Color(0xFF90A4AE),
            Color(0xFFB0BEC5),
            Color(0xFFB39DDB),
            Color(0xFF80CBC4),
          ],
          blurIntensity: 28.0,
        );

      case MoodType.sad:
        return const MoodVisualSpec(
          baseBackground: Color(0xFF0A1020),
          atmosphericGradient: [
            Color(0xFF132042),
            Color(0xFF0D162E),
            Color(0xFF070B17),
          ],
          paletteColors: [
            AppColors.mistBlue,
            Color(0xFF5C6BC0),
            Color(0xFF7986CB),
            Color(0xFF82B1FF),
          ],
          blurIntensity: 34.0,
        );

      case MoodType.anxious:
        return const MoodVisualSpec(
          baseBackground: Color(0xFF170E14),
          atmosphericGradient: [
            Color(0xFF2E1325),
            Color(0xFF1D0E1A),
            Color(0xFF0F1016),
          ],
          paletteColors: [
            Color(0xFFE57373),
            Color(0xFFBA68C8),
            Color(0xFFFF8A80),
            Color(0xFF9575CD),
          ],
          blurIntensity: 18.0,
          prefersAngularShapes: true,
        );

      case MoodType.angry:
        return const MoodVisualSpec(
          baseBackground: Color(0xFF180A0A),
          atmosphericGradient: [
            Color(0xFF381010),
            Color(0xFF260A0A),
            Color(0xFF120505),
          ],
          paletteColors: [
            Color(0xFFFF3D00),
            Color(0xFFD50000),
            Color(0xFFFF6E40),
            Color(0xFFFFAB00),
          ],
          blurIntensity: 16.0,
          prefersAngularShapes: true,
        );

      case MoodType.tired:
        return const MoodVisualSpec(
          baseBackground: Color(0xFF0E0D18),
          atmosphericGradient: [
            Color(0xFF201A36),
            Color(0xFF141024),
            Color(0xFF090712),
          ],
          paletteColors: [
            AppColors.violetTwilight,
            Color(0xFF7E57C2),
            Color(0xFF9575CD),
            Color(0xFFB39DDB),
          ],
          blurIntensity: 38.0,
        );

      case MoodType.lonely:
        return const MoodVisualSpec(
          baseBackground: Color(0xFF090D1A),
          atmosphericGradient: [
            Color(0xFF141936),
            Color(0xFF0D1226),
            Color(0xFF060914),
          ],
          paletteColors: [
            Color(0xFF7986CB),
            Color(0xFF4DD0E1),
            Color(0xFF9FA8DA),
            Color(0xFF5C6BC0),
          ],
          blurIntensity: 34.0,
        );
    }
  }
}
