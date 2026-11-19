import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../capture/domain/daily_entry.dart';
import '../../../capture/domain/mood_type.dart';
import '../../../capture/presentation/providers/entry_repository_provider.dart';

/// Horizontal section displaying recent emotional memory canvas cards.
/// Dynamically streams real saved entries from the Drift database.
class RecentMemoriesSection extends ConsumerWidget {
  const RecentMemoriesSection({super.key});

  MoodType _parseMood(String moodName) {
    return MoodType.values.firstWhere(
      (m) => m.label.toLowerCase() == moodName.toLowerCase(),
      orElse: () => MoodType.calm,
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final entryDate = DateTime(dt.year, dt.month, dt.day);

    if (entryDate == today) return 'Today';
    if (entryDate == today.subtract(const Duration(days: 1))) return 'Yesterday';

    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dt.month - 1]} ${dt.day}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentEntriesAsync = ref.watch(recentEntriesStreamProvider);
    final savedEntries = recentEntriesAsync.value ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Recent memories',
                  style: AppTypography.displayMedium.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryOf(context),
                  ),
                ),
              ),
              if (savedEntries.isNotEmpty)
                TextButton(
                  onPressed: () => context.go('/memories'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.amberWarmth,
                    padding: EdgeInsets.zero,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View all',
                        style: AppTypography.label.copyWith(
                          color: AppColors.amberWarmth,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 16,
                        color: AppColors.amberWarmth,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Horizontal Scroll: Show saved DB entries if available, otherwise empty prompt
        SizedBox(
          height: 195,
          child: savedEntries.isNotEmpty
              ? _buildSavedEntriesList(context, savedEntries)
              : _buildEmptyRecentState(context),
        ),
      ],
    );
  }

  /// Renders actual persistent entries saved to the local Drift database.
  Widget _buildSavedEntriesList(BuildContext context, List<DailyEntry> entries) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: entries.length,
      separatorBuilder: (context, index) => const SizedBox(width: 14),
      itemBuilder: (context, index) {
        final entry = entries[index];
        final moodEnum = _parseMood(entry.mood);

        return GestureDetector(
          onTap: () => context.push('/memories/${entry.id}'),
          child: Container(
            width: 146,
            decoration: BoxDecoration(
              color: AppColors.surfaceOf(context),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderSubtleOf(context)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top header: Date & mood dot
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDate(entry.date),
                      style: AppTypography.label.copyWith(
                        color: AppColors.textTertiaryOf(context),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: moodEnum.primaryColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Mood & Intensity pill
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: moodEnum.primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: moodEnum.primaryColor.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.mood,
                        style: AppTypography.displayMedium.copyWith(
                          color: AppColors.textPrimaryOf(context),
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Intensity ${entry.moodIntensity}/10',
                        style: AppTypography.label.copyWith(
                          color: moodEnum.primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Transformation / Needed note or energy
                if (entry.afterMood != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.amberWarmth.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 10,
                          color: AppColors.amberWarmth,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            entry.afterMood!,
                            style: AppTypography.label.copyWith(
                              color: AppColors.amberWarmth,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else if (entry.needed != null) ...[
                  Text(
                    'Needed: ${entry.needed}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.label.copyWith(
                      color: AppColors.textSecondaryOf(context),
                      fontSize: 10,
                    ),
                  ),
                ] else ...[
                  Text(
                    entry.energy,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.label.copyWith(
                      color: AppColors.textSecondaryOf(context),
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  /// Calm, peaceful empty state when no past entries have been captured yet.
  Widget _buildEmptyRecentState(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSubtleOf(context)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.amberWarmth.withValues(alpha: 0.12),
            ),
            child: const Icon(
              Icons.auto_awesome_outlined,
              color: AppColors.amberWarmth,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No previous canvases yet',
                  style: AppTypography.displayMedium.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryOf(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your daily emotional memories will appear here chronologically.',
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: 12,
                    color: AppColors.textSecondaryOf(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

