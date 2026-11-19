import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Visually captivating intensity slider (1 to 10) with dynamic mood coloration.
class IntensitySlider extends StatelessWidget {
  final int intensity;
  final Color activeColor;
  final ValueChanged<int> onChanged;

  const IntensitySlider({
    super.key,
    required this.intensity,
    required this.activeColor,
    required this.onChanged,
  });

  String _getIntensityDescription(int value) {
    if (value <= 2) return 'Subtle whisper';
    if (value <= 4) return 'Gentle presence';
    if (value <= 6) return 'Clearly felt';
    if (value <= 8) return 'Deep & resonant';
    return 'Overwhelmingly intense';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'How strongly did you feel it?',
                  style: AppTypography.displayMedium.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: activeColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: activeColor.withValues(alpha: 0.5)),
                ),
                child: Text(
                  '$intensity / 10',
                  style: AppTypography.label.copyWith(
                    color: activeColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Dynamic emotional descriptor
          Text(
            _getIntensityDescription(intensity),
            style: AppTypography.label.copyWith(
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 14),

          // Custom slider theme
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: activeColor,
              inactiveTrackColor: AppColors.surfaceElevated,
              trackHeight: 6,
              thumbColor: activeColor,
              overlayColor: activeColor.withValues(alpha: 0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            ),
            child: Slider(
              value: intensity.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (val) => onChanged(val.round()),
            ),
          ),

          // 1 --- 10 indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1 (Faint)',
                style: AppTypography.label.copyWith(
                  fontSize: 11,
                  color: AppColors.textTertiary,
                ),
              ),
              Text(
                '10 (Profound)',
                style: AppTypography.label.copyWith(
                  fontSize: 11,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
