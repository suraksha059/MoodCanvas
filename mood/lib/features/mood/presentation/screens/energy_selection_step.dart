import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../capture/domain/energy_level.dart';
import '../../../capture/presentation/providers/daily_capture_provider.dart';

/// Step 2 of Daily Capture: Energy Level Selection.
class EnergySelectionStep extends ConsumerWidget {
  const EnergySelectionStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final captureState = ref.watch(dailyCaptureProvider);
    final notifier = ref.read(dailyCaptureProvider.notifier);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How was your energy today?',
            style: AppTypography.displayLarge.copyWith(
              fontSize: 26,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Notice the physical and mental vitality you felt throughout the day.',
            style: AppTypography.bodyLarge,
          ),

          const SizedBox(height: 28),

          // 5 Visual Energy Cards
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: EnergyLevel.values.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final level = EnergyLevel.values[index];
              final isSelected = captureState.energy == level;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  color: isSelected
                      ? level.accentColor.withValues(alpha: 0.16)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isSelected
                        ? level.accentColor
                        : AppColors.borderSubtle,
                    width: isSelected ? 1.8 : 1.0,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: level.accentColor.withValues(alpha: 0.25),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => notifier.setEnergy(level),
                    borderRadius: BorderRadius.circular(22),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                      child: Row(
                        children: [
                          // Visual segmented energy bars
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(5, (barIdx) {
                              final isFilled = barIdx < level.bars;
                              return Container(
                                width: 5,
                                height: 16.0 + (barIdx * 4.0),
                                margin: const EdgeInsets.only(right: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: isFilled
                                      ? (isSelected ? level.accentColor : AppColors.textSecondary)
                                      : AppColors.surfaceElevated,
                                ),
                              );
                            }),
                          ),

                          const SizedBox(width: 18),

                          // Text info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  level.label,
                                  style: AppTypography.displayMedium.copyWith(
                                    fontSize: 16,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                    color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  level.description,
                                  style: AppTypography.label.copyWith(
                                    fontSize: 12,
                                    color: isSelected ? level.accentColor : AppColors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Radio dot
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? level.accentColor : AppColors.textTertiary,
                                width: 2,
                              ),
                              color: isSelected ? level.accentColor : Colors.transparent,
                            ),
                            child: isSelected
                                ? const Icon(Icons.check, size: 12, color: AppColors.background)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
