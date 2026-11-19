import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/models/micro_action.dart';
import '../../../capture/presentation/providers/daily_capture_provider.dart';

/// Step 1: "What do you need right now?"
/// Identifies core human need to recommend a realistic micro-action.
class NeedSelectionStep extends ConsumerWidget {
  const NeedSelectionStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final captureState = ref.watch(dailyCaptureProvider);
    final notifier = ref.read(dailyCaptureProvider.notifier);
    final selectedNeed = captureState.need;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Header
          Text(
            'What would help right now?',
            style: AppTypography.displayLarge.copyWith(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryOf(context),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'We don’t need to fix everything. Just pick what would give you a little relief.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondaryOf(context),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),

          // Needs List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: NeedType.values.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final need = NeedType.values[index];
              final isSelected = selectedNeed == need;

              return InkWell(
                onTap: () => notifier.setNeed(need),
                borderRadius: BorderRadius.circular(18),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.amberWarmth.withValues(alpha: 0.15)
                        : AppColors.surfaceOf(context),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.amberWarmth
                          : AppColors.borderSubtleOf(context),
                      width: isSelected ? 1.8 : 1.0,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.amberWarmth.withValues(alpha: 0.2),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? AppColors.amberWarmth.withValues(alpha: 0.25)
                              : AppColors.surfaceElevatedOf(context),
                        ),
                        child: Icon(
                          need.icon,
                          color: isSelected
                              ? AppColors.amberWarmth
                              : AppColors.textSecondaryOf(context),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              need.label,
                              style: AppTypography.displayMedium.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppColors.amberWarmth
                                    : AppColors.textPrimaryOf(context),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              need.description,
                              style: AppTypography.bodyMedium.copyWith(
                                fontSize: 12,
                                color: AppColors.textSecondaryOf(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.amberWarmth,
                          size: 22,
                        ),
                    ],
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
