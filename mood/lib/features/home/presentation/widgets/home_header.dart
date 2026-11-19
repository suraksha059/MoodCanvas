import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../profile/presentation/providers/profile_providers.dart';

/// Calm, personal header for the MoodCanvas home screen.
class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final greeting = _getGreeting();
    final userName = ref.watch(userNameProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gentle date indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceGlass : const Color(0xFFEBE8E1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.borderSubtleOf(context)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.amberWarmth,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Today',
                      style: AppTypography.label.copyWith(
                        color: AppColors.textSecondaryOf(context),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Calendar / Gallery shortcut icon
              IconButton(
                icon: Icon(
                  Icons.auto_awesome_mosaic_outlined,
                  color: AppColors.textTertiaryOf(context),
                  size: 20,
                ),
                onPressed: () => context.go('/memories'),
                tooltip: 'Memories Gallery',
                splashRadius: 20,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Main Greeting with live user name
          Text(
            '$greeting, $userName',
            style: AppTypography.displayMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryOf(context),
            ),
          ),

          const SizedBox(height: 6),

          // Thoughtful prompt
          Text(
            'How did today feel?',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondaryOf(context),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

