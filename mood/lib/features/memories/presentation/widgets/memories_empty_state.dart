import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Artistic and calm empty state for the Memories Gallery.
class MemoriesEmptyState extends StatelessWidget {
  const MemoriesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ambient artistic glowing orb icon
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceElevated,
                border: Border.all(
                  color: AppColors.amberWarmth.withValues(alpha: 0.25),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.amberWarmth.withValues(alpha: 0.12),
                    blurRadius: 36,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.auto_awesome_mosaic_rounded,
                  color: AppColors.amberWarmth,
                  size: 38,
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Heading
            Text(
              'Your memories will live here.',
              textAlign: TextAlign.center,
              style: AppTypography.displayMedium.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 12),

            // Subtitle
            Text(
              'Capture your first day\nand turn it into a canvas.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 36),

            // Action Button
            GestureDetector(
              onTap: () => context.push('/capture'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.amberWarmth,
                      AppColors.roseDusk,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.amberWarmth.withValues(alpha: 0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.add_rounded,
                      color: AppColors.background,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Capture today',
                      style: AppTypography.label.copyWith(
                        color: AppColors.background,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
