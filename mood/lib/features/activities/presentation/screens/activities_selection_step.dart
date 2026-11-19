import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../capture/presentation/providers/daily_capture_provider.dart';

/// Representation of an activity category item.
class _ActivityMeta {
  final String name;
  final IconData icon;

  const _ActivityMeta(this.name, this.icon);
}

/// Step 3 of Daily Capture: Multi-select Activities.
class ActivitiesSelectionStep extends ConsumerWidget {
  const ActivitiesSelectionStep({super.key});

  static const List<_ActivityMeta> _activities = [
    _ActivityMeta('Work', Icons.work_outline_rounded),
    _ActivityMeta('Study', Icons.menu_book_rounded),
    _ActivityMeta('Family', Icons.family_restroom_rounded),
    _ActivityMeta('Friends', Icons.people_outline_rounded),
    _ActivityMeta('Travel', Icons.flight_takeoff_rounded),
    _ActivityMeta('Exercise', Icons.fitness_center_rounded),
    _ActivityMeta('Reading', Icons.auto_stories_rounded),
    _ActivityMeta('Music', Icons.music_note_rounded),
    _ActivityMeta('Gaming', Icons.sports_esports_outlined),
    _ActivityMeta('Nature', Icons.forest_outlined),
    _ActivityMeta('Food', Icons.restaurant_rounded),
    _ActivityMeta('Self-care', Icons.spa_outlined),
    _ActivityMeta('Creative', Icons.palette_outlined),
    _ActivityMeta('Shopping', Icons.shopping_bag_outlined),
    _ActivityMeta('Rest', Icons.bedtime_outlined),
  ];

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
            'What shaped your day?',
            style: AppTypography.displayLarge.copyWith(
              fontSize: 26,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select the activities or moments that stood out today. (Optional)',
            style: AppTypography.bodyLarge,
          ),

          const SizedBox(height: 24),

          // Wrap of Selectable Activity Chips
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _activities.map((item) {
              final isSelected = captureState.activities.contains(item.name);

              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.amberWarmth.withValues(alpha: 0.18)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.amberWarmth
                        : AppColors.borderSubtle,
                    width: isSelected ? 1.5 : 1.0,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.amberWarmth.withValues(alpha: 0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => notifier.toggleActivity(item.name),
                    borderRadius: BorderRadius.circular(24),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            item.icon,
                            size: 18,
                            color: isSelected
                                ? AppColors.amberWarmth
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item.name,
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: isSelected
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
