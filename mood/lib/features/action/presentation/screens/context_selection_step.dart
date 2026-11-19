import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/models/micro_action.dart';
import '../../../capture/presentation/providers/daily_capture_provider.dart';

/// Step 2: "What is your context right now?"
/// Lightweight question to make recommendations feasible in the moment.
class ContextSelectionStep extends ConsumerWidget {
  const ContextSelectionStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final captureState = ref.watch(dailyCaptureProvider);
    final notifier = ref.read(dailyCaptureProvider.notifier);
    final selectedTime = captureState.contextTime ?? ContextTime.tenMin;
    final selectedLocation = captureState.contextLocation ?? ContextLocation.home;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Header
          Text(
            'What is your context?',
            style: AppTypography.displayLarge.copyWith(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryOf(context),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Only what helps make the action realistic right now.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondaryOf(context),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 28),

          // 1. Time Available
          Row(
            children: [
              const Icon(Icons.timer_outlined, size: 20, color: AppColors.amberWarmth),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'How much time do you have?',
                  style: AppTypography.displayMedium.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryOf(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Row(
            children: ContextTime.values.map((t) {
              final isSelected = selectedTime == t;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: InkWell(
                    onTap: () => notifier.setContextTime(t),
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.amberWarmth.withValues(alpha: 0.18)
                            : AppColors.surfaceOf(context),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.amberWarmth
                              : AppColors.borderSubtleOf(context),
                          width: isSelected ? 1.8 : 1.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          t.label,
                          style: AppTypography.label.copyWith(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected
                                ? AppColors.amberWarmth
                                : AppColors.textPrimaryOf(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 32),

          // 2. Location
          Row(
            children: [
              const Icon(Icons.place_outlined, size: 20, color: AppColors.roseDusk),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Where are you right now?',
                  style: AppTypography.displayMedium.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryOf(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.2,
            ),
            itemCount: ContextLocation.values.length,
            itemBuilder: (context, index) {
              final loc = ContextLocation.values[index];
              final isSelected = selectedLocation == loc;

              return InkWell(
                onTap: () => notifier.setContextLocation(loc),
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.roseDusk.withValues(alpha: 0.18)
                        : AppColors.surfaceOf(context),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.roseDusk
                          : AppColors.borderSubtleOf(context),
                      width: isSelected ? 1.8 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        loc.icon,
                        color: isSelected
                            ? AppColors.roseDusk
                            : AppColors.textSecondaryOf(context),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          loc.label,
                          style: AppTypography.label.copyWith(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected
                                ? AppColors.roseDusk
                                : AppColors.textPrimaryOf(context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 36),

          // Gentle tip
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevatedOf(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderSubtleOf(context)),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline_rounded,
                    color: AppColors.amberWarmth, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Next, we’ll suggest one small action you can do in these few minutes.',
                    style: AppTypography.bodyMedium.copyWith(
                      fontSize: 12,
                      color: AppColors.textSecondaryOf(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
