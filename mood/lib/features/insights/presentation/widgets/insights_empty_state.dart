import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Calm empty state shown when not enough data exists to calculate patterns.
class InsightsEmptyState extends StatelessWidget {
  const InsightsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.amberWarmth.withValues(alpha: 0.12),
              border: Border.all(
                color: AppColors.amberWarmth.withValues(alpha: 0.25),
              ),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.amberWarmth,
              size: 28,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Capture a few more days\nto discover your patterns.',
            textAlign: TextAlign.center,
            style: AppTypography.displayMedium.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your emotional rhythms and energy trends will reveal themselves as you create canvases.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.push('/capture'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.amberWarmth,
              side: const BorderSide(color: AppColors.amberWarmth),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: Text(
              'Capture today',
              style: AppTypography.label.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.amberWarmth,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
