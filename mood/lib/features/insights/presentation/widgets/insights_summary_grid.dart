import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/models/insights_data.dart';

/// Artistic 2-column metrics dashboard showing personal emotional stats.
class InsightsSummaryGrid extends StatelessWidget {
  final InsightsData insights;

  const InsightsSummaryGrid({
    super.key,
    required this.insights,
  });

  Widget _buildStatCard({
    required IconData icon,
    required Color accentColor,
    required String value,
    required String label,
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: accentColor, size: 18),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: AppTypography.label.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 11,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTypography.displayMedium.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: AppTypography.label.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dominantMoodColor =
        insights.mostCommonMoodType?.primaryColor ?? AppColors.amberWarmth;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.35,
      children: [
        // 1. Current Streak
        _buildStatCard(
          icon: Icons.local_fire_department_rounded,
          accentColor: AppColors.amberWarmth,
          value: '${insights.currentStreak} ${insights.currentStreak == 1 ? 'day' : 'days'}',
          label: 'Current streak',
          subtitle: 'Active',
        ),

        // 2. Canvases captured in period
        _buildStatCard(
          icon: Icons.palette_outlined,
          accentColor: AppColors.roseDusk,
          value: '${insights.totalCapturedDays}',
          label: 'Canvases created',
          subtitle: 'Captured',
        ),

        // 3. Most Common Mood
        _buildStatCard(
          icon: Icons.mood_rounded,
          accentColor: dominantMoodColor,
          value: insights.mostCommonMood ?? 'None',
          label: 'Dominant mood',
          subtitle: insights.mostCommonMoodCount > 0
              ? '${insights.mostCommonMoodCount} times'
              : null,
        ),

        // 4. Average Intensity
        _buildStatCard(
          icon: Icons.tune_rounded,
          accentColor: AppColors.violetTwilight,
          value: insights.totalCapturedDays > 0
              ? '${insights.averageIntensity.toStringAsFixed(1)} / 10'
              : 'N/A',
          label: 'Avg. intensity',
        ),

        // 5. Average Energy
        _buildStatCard(
          icon: Icons.bolt_rounded,
          accentColor: AppColors.amberWarmth,
          value: insights.averageEnergyLabel,
          label: 'Energy level',
          subtitle: insights.totalCapturedDays > 0
              ? '${insights.averageEnergyNumeric.toStringAsFixed(1)}/5'
              : null,
        ),

        // 6. Most Frequent Activity
        _buildStatCard(
          icon: Icons.spa_outlined,
          accentColor: AppColors.sageSerenity,
          value: insights.mostFrequentActivity ?? 'None',
          label: 'Top activity',
          subtitle: insights.mostFrequentActivityCount > 0
              ? '${insights.mostFrequentActivityCount} times'
              : null,
        ),
      ],
    );
  }
}
