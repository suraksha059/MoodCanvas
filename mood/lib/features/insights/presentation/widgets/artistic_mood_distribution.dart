import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../capture/domain/mood_type.dart';
import '../../domain/models/insights_data.dart';

/// Artistic and organic visualization of the user's emotional spectrum and mood distribution.
class ArtisticMoodDistribution extends StatelessWidget {
  final InsightsData insights;

  const ArtisticMoodDistribution({
    super.key,
    required this.insights,
  });

  MoodType _parseMood(String moodName) {
    return MoodType.values.firstWhere(
      (m) =>
          m.label.toLowerCase() == moodName.toLowerCase() ||
          m.name.toLowerCase() == moodName.toLowerCase(),
      orElse: () => MoodType.calm,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (insights.moodCounts.isEmpty) {
      return const SizedBox.shrink();
    }

    // Sort moods by frequency descending
    final sortedEntries = insights.moodCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Emotional Spectrum',
            style: AppTypography.displayMedium.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'How your feelings flowed across this period',
            style: AppTypography.label.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),

          // Continuous Organic Emotional Spectrum Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 12,
              child: Row(
                children: sortedEntries.map((entry) {
                  final percentage = insights.moodPercentages[entry.key] ?? 0.0;
                  final moodEnum = _parseMood(entry.key);

                  return Expanded(
                    flex: (percentage * 1000).toInt().clamp(1, 1000),
                    child: Container(
                      color: moodEnum.primaryColor,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Mood List with organic progress tracks
          Column(
            children: sortedEntries.map((entry) {
              final moodName = entry.key;
              final count = entry.value;
              final percentage = insights.moodPercentages[moodName] ?? 0.0;
              final moodEnum = _parseMood(moodName);

              return Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: Row(
                  children: [
                    // Mood Dot with subtle glow
                    Container(
                      width: 10,
                      height: 10,
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
                    const SizedBox(width: 10),

                    // Mood Label
                    SizedBox(
                      width: 72,
                      child: Text(
                        moodName,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    // Organic Progress Track
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          children: [
                            Container(
                              height: 7,
                              color: AppColors.surface,
                            ),
                            FractionallySizedBox(
                              widthFactor: percentage.clamp(0.02, 1.0),
                              child: Container(
                                height: 7,
                                decoration: BoxDecoration(
                                  color: moodEnum.primaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Percentage
                    Text(
                      '${(percentage * 100).round()}%',
                      style: AppTypography.label.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Count Badge
                    Text(
                      '$count',
                      style: AppTypography.label.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
