import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Reusable, calm, and emotional error view for handling failures gracefully.
class MoodErrorView extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;
  final IconData icon;

  const MoodErrorView({
    super.key,
    this.title = 'A quiet pause',
    this.message = 'We encountered a momentary issue opening your emotional archive. Take a gentle breath and try again.',
    this.onRetry,
    this.retryLabel = 'Try again',
    this.icon = Icons.spa_outlined,
  });

  /// Specialized factory for database retrieval errors.
  factory MoodErrorView.database({
    Key? key,
    VoidCallback? onRetry,
    String? message,
  }) {
    return MoodErrorView(
      key: key,
      title: 'Archive resting',
      message: message ??
          'Your local canvas storage took a moment to respond. Your memories remain safe on your device.',
      onRetry: onRetry,
      icon: Icons.storage_rounded,
    );
  }

  /// Specialized factory for general loading failures.
  factory MoodErrorView.loading({
    Key? key,
    VoidCallback? onRetry,
    String? message,
  }) {
    return MoodErrorView(
      key: key,
      title: 'Still finding your flow',
      message: message ??
          'It took longer than expected to prepare this canvas. Let’s try refreshing.',
      onRetry: onRetry,
      icon: Icons.refresh_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevatedOf(context),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.borderSubtleOf(context)),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.roseDusk.withValues(alpha: 0.15),
                  border: Border.all(
                    color: AppColors.roseDusk.withValues(alpha: 0.3),
                  ),
                ),
                child: Icon(icon, color: AppColors.roseDusk, size: 28),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTypography.displayMedium.copyWith(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryOf(context),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondaryOf(context),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: onRetry,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.surfaceOf(context),
                    foregroundColor: AppColors.textPrimaryOf(context),
                    side: BorderSide(color: AppColors.borderSubtleOf(context)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: Text(
                    retryLabel,
                    style: AppTypography.label.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
