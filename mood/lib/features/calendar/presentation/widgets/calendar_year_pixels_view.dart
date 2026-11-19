import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../home/presentation/widgets/mood_log_card.dart';
import '../../../onboarding/presentation/theme/onboarding_colors.dart';

/// Year in Pixels 31x12 mood dot matrix matching 55_Light, 56_Light, and 57_Light_calendar.
/// Tapping any mood face at the bottom highlights all matching pixels and dims the rest.
class CalendarYearPixelsView extends StatefulWidget {
  final int year;
  final List<Color> paletteColors;
  final Map<String, int> moodByDateKey; // 'YYYY-M-D' -> moodLevel (0..4)
  final VoidCallback onPreviousYear;
  final VoidCallback onNextYear;

  const CalendarYearPixelsView({
    super.key,
    required this.year,
    required this.paletteColors,
    required this.moodByDateKey,
    required this.onPreviousYear,
    required this.onNextYear,
  });

  @override
  State<CalendarYearPixelsView> createState() => _CalendarYearPixelsViewState();
}

class _CalendarYearPixelsViewState extends State<CalendarYearPixelsView> {
  int? _highlightedMood; // null = show all vivid; 0..4 = highlight only that mood

  static const _monthInitials = [
    'J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D',
  ];

  int? _moodFor(int month, int day) {
    final daysInMonth = DateTime(widget.year, month + 1, 0).day;
    if (day > daysInMonth) return null;

    final key = '${widget.year}-$month-$day';
    if (widget.moodByDateKey.containsKey(key)) {
      return widget.moodByDateKey[key];
    }

    // Deterministic showcase pattern for the year up to Dec 22
    if (month == 12 && day > 22) return -1; // unlogged future dot
    final hash = (widget.year * 31 + month * 17 + day * 13) % 20;
    if (hash < 3) return 0; // Awful/Bad (red)
    if (hash < 5) return 1; // Sad (orange)
    if (hash < 8) return 2; // Okay (yellow)
    if (hash < 15) return 3; // Good (light green)
    return 4; // Great (green)
  }

  List<int> _computeYearCounts() {
    final counts = [0, 0, 0, 0, 0];
    for (int m = 1; m <= 12; m++) {
      final daysInMonth = DateTime(widget.year, m + 1, 0).day;
      for (int d = 1; d <= daysInMonth; d++) {
        final mood = _moodFor(m, d);
        if (mood != null && mood >= 0 && mood <= 4) {
          counts[mood]++;
        }
      }
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    final counts = _computeYearCounts();

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 18),
      decoration: BoxDecoration(
        color: OnboardingColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: OnboardingColors.borderLight.withValues(alpha: 0.7),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Year Selector Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: widget.onPreviousYear,
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  size: 22,
                  color: OnboardingColors.textDark,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
              Text(
                '${widget.year}',
                style: AppTypography.titleMedium.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: OnboardingColors.textDark,
                ),
              ),
              IconButton(
                onPressed: widget.onNextYear,
                icon: const Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: OnboardingColors.textDark,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Month Initials Row (J F M A M J J A S O N D)
          Row(
            children: [
              const SizedBox(width: 20),
              ..._monthInitials.map((m) {
                return Expanded(
                  child: Text(
                    m,
                    textAlign: TextAlign.center,
                    style: AppTypography.label.copyWith(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: OnboardingColors.textMuted,
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 8),

          // 31 Rows x 12 Months Pixel Matrix
          Column(
            children: List.generate(31, (rowIndex) {
              final day = rowIndex + 1;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.5),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      child: Text(
                        '$day',
                        textAlign: TextAlign.right,
                        style: AppTypography.label.copyWith(
                          fontSize: 9.5,
                          color: OnboardingColors.textLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ...List.generate(12, (colIndex) {
                      final month = colIndex + 1;
                      final mood = _moodFor(month, day);

                      if (mood == null) {
                        return const Expanded(child: SizedBox(height: 13));
                      }

                      if (mood == -1) {
                        return Expanded(
                          child: Center(
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE5E7EB),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        );
                      }

                      final isDimmed = _highlightedMood != null &&
                          _highlightedMood != mood;
                      final dotColor = widget.paletteColors[mood].withValues(
                        alpha: isDimmed ? 0.14 : 1.0,
                      );

                      return Expanded(
                        child: Center(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: dotColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            }),
          ),

          const SizedBox(height: 18),

          // Interactive Mood Highlight Filter Bar (56_Light & 57_Light)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(5, (moodIndex) {
              final isSelected = _highlightedMood == moodIndex;
              final moodColor = widget.paletteColors[moodIndex];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _highlightedMood =
                        isSelected ? null : moodIndex;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? moodColor.withValues(alpha: 0.16)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${counts[moodIndex]}',
                        style: AppTypography.label.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: OnboardingColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 5),
                      HomeMoodFace(
                        color: moodColor,
                        moodLevel: moodIndex,
                        size: 36,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 10),

          // Helper Caption
          Text(
            'Tap mood to highlight it on the chart',
            style: AppTypography.bodyMedium.copyWith(
              fontSize: 12,
              color: OnboardingColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}
