import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../capture/presentation/providers/entry_repository_provider.dart';
import '../../../onboarding/presentation/providers/account_setup_provider.dart';
import '../../../onboarding/presentation/theme/onboarding_colors.dart';
import '../../../onboarding/presentation/widgets/mood_sticker_logo.dart';
import '../widgets/insights_mood_chart_card.dart';
import '../widgets/insights_mood_count_card.dart';
import '../widgets/insights_secondary_cards.dart';

/// Light-theme Insights / Stats tab matching 50_Light_insights,
/// 51_Light_insights, and 52_Light_insights.
class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setupState = ref.watch(accountSetupProvider);
    final paletteColors = moodColorPalettes[setupState.colorPaletteIndex];
    final entriesAsync = ref.watch(allEntriesStreamProvider);

    // Use real Drift counts when user has logged entries; otherwise show
    // rich showcase values matching 50-52_Light_insights.
    final entries = entriesAsync.value ?? const [];
    final lifetimeDays = entries.isEmpty ? 482 : entries.length;
    final currentStreak = entries.isEmpty ? 58 : entries.length.clamp(1, 365);
    final longestStreak = entries.isEmpty ? 65 : currentStreak;

    final moodCounts = entries.isEmpty
        ? const [60, 28, 55, 113, 86]
        : _computeMoodCounts(entries);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F8),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Top App Bar: Sticker Logo | "Insights" | More Menu
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 12, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const MoodStickerLogo(size: 28, inverted: false),
                    Text(
                      'Insights',
                      style: AppTypography.titleLarge.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: OnboardingColors.textDark,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Export insights coming soon!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        size: 24,
                        color: OnboardingColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable Analytics Feed
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 6, 20, 32),
                  children: [
                    // 1. Top 3 Streak / Lifetime Stat Cards
                    Row(
                      children: [
                        Expanded(
                          child: _TopStatCard(
                            emoji: '⚡',
                            value: '$longestStreak',
                            label: 'Longest streak',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _TopStatCard(
                            emoji: '🔥',
                            value: '$currentStreak',
                            label: 'Current streak',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _TopStatCard(
                            emoji: '📅',
                            value: '$lifetimeDays',
                            label: 'Lifetime days',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 2. Mood Chart Card (Bar / Line / Scatter toggles)
                    InsightsMoodChartCard(paletteColors: paletteColors),
                    const SizedBox(height: 16),

                    // 3. Mood Count Card (Gauge / Radar / Concentric Rings toggles)
                    InsightsMoodCountCard(
                      paletteColors: paletteColors,
                      moodCounts: moodCounts,
                    ),
                    const SizedBox(height: 16),

                    // 4. Average Daily Mood Card
                    AverageDailyMoodCard(paletteColors: paletteColors),
                    const SizedBox(height: 16),

                    // 5. Mood Stability Card
                    const MoodStabilityCard(score: 64),
                    const SizedBox(height: 16),

                    // 6. Activity Count Card
                    const ActivityCountCard(),
                    const SizedBox(height: 16),

                    // 7. Best & Worst Card
                    const BestAndWorstCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static List<int> _computeMoodCounts(List entries) {
    final counts = [0, 0, 0, 0, 0];
    for (final entry in entries) {
      final m = (entry.mood as String).toLowerCase();
      if (m.contains('overwhelmed') || m.contains('angry')) {
        counts[0]++;
      } else if (m.contains('sad') ||
          m.contains('low') ||
          m.contains('anxious') ||
          m.contains('heavy')) {
        counts[1]++;
      } else if (m.contains('okay') ||
          m.contains('neutral') ||
          m.contains('tired')) {
        counts[2]++;
      } else if (m.contains('great') ||
          m.contains('joy') ||
          m.contains('excited')) {
        counts[4]++;
      } else {
        counts[3]++;
      }
    }
    return counts;
  }
}

class _TopStatCard extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;

  const _TopStatCard({
    required this.emoji,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: OnboardingColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: OnboardingColors.borderLight.withValues(alpha: 0.7),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 5),
              Text(
                value,
                style: AppTypography.titleLarge.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: OnboardingColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.label.copyWith(
              fontSize: 11,
              color: OnboardingColors.textMuted,
              fontWeight: FontWeight.w400,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
