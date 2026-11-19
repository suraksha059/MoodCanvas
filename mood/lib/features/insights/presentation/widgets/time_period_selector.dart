import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/models/time_period.dart';
import '../providers/insights_providers.dart';

/// Segmented tab pill allowing switching between This week, This month, and All time.
class TimePeriodSelector extends ConsumerWidget {
  const TimePeriodSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(timePeriodProvider);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: TimePeriod.values.map((period) {
          final isSelected = period == current;

          return Expanded(
            child: GestureDetector(
              onTap: () =>
                  ref.read(timePeriodProvider.notifier).selectPeriod(period),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.amberWarmth.withValues(alpha: 0.18)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.amberWarmth.withValues(alpha: 0.45)
                        : Colors.transparent,
                  ),
                ),
                child: Text(
                  period.label,
                  textAlign: TextAlign.center,
                  style: AppTypography.label.copyWith(
                    color: isSelected
                        ? AppColors.amberWarmth
                        : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
