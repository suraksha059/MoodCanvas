import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../capture/domain/daily_entry.dart';
import '../../../capture/domain/energy_level.dart';
import '../../../capture/domain/mood_type.dart';

/// Artistic gallery card representing a single daily emotional memory.
/// Uses varied aspect ratios and static canvas rendering for fluid 60/120fps scrolling.
class MemoryGalleryCard extends StatelessWidget {
  final DailyEntry entry;
  final int index;

  const MemoryGalleryCard({
    super.key,
    required this.entry,
    required this.index,
  });

  MoodType _parseMood(String moodName) {
    return MoodType.values.firstWhere(
      (m) =>
          m.label.toLowerCase() == moodName.toLowerCase() ||
          m.name.toLowerCase() == moodName.toLowerCase(),
      orElse: () => MoodType.calm,
    );
  }

  EnergyLevel _parseEnergy(String energyName) {
    return EnergyLevel.values.firstWhere(
      (e) =>
          e.label.toLowerCase() == energyName.toLowerCase() ||
          e.name.toLowerCase() == energyName.toLowerCase(),
      orElse: () => EnergyLevel.balanced,
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final entryDate = DateTime(dt.year, dt.month, dt.day);

    if (entryDate == today) return 'Today';
    if (entryDate == today.subtract(const Duration(days: 1))) return 'Yesterday';

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}';
  }

  /// Calculates a height variation for the masonry effect.
  double _getHeaderHeight() {
    final pattern = index % 3;
    if (pattern == 0) return 130.0;
    if (pattern == 1) return 115.0;
    return 145.0;
  }

  @override
  Widget build(BuildContext context) {
    final moodEnum = _parseMood(entry.mood);
    final energyEnum = _parseEnergy(entry.energy);
    final headerHeight = _getHeaderHeight();

    return GestureDetector(
      onTap: () => context.push('/memories/${entry.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.borderSubtle,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Elegant serene header with ambient mood glow
            Container(
              width: double.infinity,
              height: headerHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    moodEnum.primaryColor.withValues(alpha: 0.28),
                    moodEnum.primaryColor.withValues(alpha: 0.08),
                    AppColors.surfaceElevated,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Center ambient glow orb with mood icon
                  Center(
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: moodEnum.primaryColor.withValues(alpha: 0.2),
                        border: Border.all(
                          color: moodEnum.primaryColor.withValues(alpha: 0.45),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: moodEnum.primaryColor.withValues(alpha: 0.3),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: Icon(
                        entry.afterMood != null
                            ? Icons.auto_awesome_rounded
                            : Icons.spa_rounded,
                        color: moodEnum.primaryColor,
                        size: 26,
                      ),
                    ),
                  ),

                  // Top Floating Date & Journal badge
                  Positioned(
                    top: 10,
                    left: 10,
                    right: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.15),
                            ),
                          ),
                          child: Text(
                            _formatDate(entry.date),
                            style: AppTypography.label.copyWith(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (entry.journal.trim().isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.55),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.15),
                              ),
                            ),
                            child: const Icon(
                              Icons.format_quote_rounded,
                              color: AppColors.amberWarmth,
                              size: 13,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Metadata info container
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mood Label & Intensity
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: moodEnum.primaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: moodEnum.primaryColor.withValues(alpha: 0.6),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          entry.mood,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${entry.moodIntensity}/10',
                        style: AppTypography.label.copyWith(
                          color: AppColors.textTertiary,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Small metadata: Energy & Activities
                  Row(
                    children: [
                      // Energy indicator
                      Icon(
                        Icons.bolt_rounded,
                        size: 13,
                        color: energyEnum.accentColor,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        entry.energy,
                        style: AppTypography.label.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),

                      if (entry.activities.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            entry.activities.first +
                                (entry.activities.length > 1
                                    ? ' +${entry.activities.length - 1}'
                                    : ''),
                            style: AppTypography.label.copyWith(
                              color: AppColors.textTertiary,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),

                  if (entry.needed != null || entry.afterMood != null) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.amberWarmth.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        entry.afterMood != null
                            ? 'Shifted → ${entry.afterMood}'
                            : 'Needed: ${entry.needed}',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
