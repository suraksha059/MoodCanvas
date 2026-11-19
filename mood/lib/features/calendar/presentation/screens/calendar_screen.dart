import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../capture/domain/daily_entry.dart';
import '../../../capture/presentation/providers/entry_repository_provider.dart';
import '../../../home/presentation/widgets/mood_log_card.dart';
import '../../../onboarding/presentation/providers/account_setup_provider.dart';
import '../../../onboarding/presentation/theme/onboarding_colors.dart';
import '../../../onboarding/presentation/widgets/mood_sticker_logo.dart';
import '../widgets/calendar_monthly_view.dart';
import '../widgets/calendar_year_pixels_view.dart';
import 'calendar_mood_detail_screen.dart';

/// Light-theme Calendar tab matching 53_Light through 57_Light_calendar
/// with Monthly mood-face grid, Mood Details sheet, and Year in Pixels view.
class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  int _tabIndex = 0; // 0 = Monthly, 1 = Year in Pixels
  int _selectedYear = 2024;
  int _selectedMonth = 12; // December 2024 matching mockup

  static const _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  // Showcase moods for December 2024 (days 1..22) matching 53_Light_calendar
  static const Map<int, int> _sampleDecemberMoods = {
    1: 4, 2: 3, 3: 2, 4: 4, 5: 0, 6: 3, 7: 1,
    8: 4, 9: 2, 10: 4, 11: 3, 12: 1, 13: 4, 14: 2,
    15: 0, 16: 3, 17: 2, 18: 0, 19: 4, 20: 3, 21: 2, 22: 3,
  };

  void _previousMonth() {
    setState(() {
      if (_selectedMonth == 1) {
        _selectedMonth = 12;
        _selectedYear--;
      } else {
        _selectedMonth--;
      }
    });
  }

  void _nextMonth() {
    setState(() {
      if (_selectedMonth == 12) {
        _selectedMonth = 1;
        _selectedYear++;
      } else {
        _selectedMonth++;
      }
    });
  }

  static int _moodLevelFromString(String mood) {
    final m = mood.toLowerCase();
    if (m.contains('overwhelmed') || m.contains('angry')) return 0;
    if (m.contains('sad') ||
        m.contains('low') ||
        m.contains('anxious') ||
        m.contains('heavy')) {
      return 1;
    }
    if (m.contains('okay') || m.contains('neutral') || m.contains('tired')) {
      return 2;
    }
    if (m.contains('great') || m.contains('joy') || m.contains('excited')) {
      return 4;
    }
    return 3;
  }

  static String _moodTitleForLevel(int level) {
    switch (level) {
      case 0:
        return 'Awful';
      case 1:
        return 'Bad';
      case 2:
        return 'Okay';
      case 4:
        return 'Great';
      default:
        return 'Good';
    }
  }

  void _openDayDetails(
    BuildContext context,
    int day,
    int? moodLevel,
    DailyEntry? realEntry,
    List<Color> paletteColors,
  ) {
    if (moodLevel == null && realEntry == null) {
      context.push('/capture');
      return;
    }

    final level =
        realEntry != null ? _moodLevelFromString(realEntry.mood) : moodLevel!;
    final monthStr = _monthNames[_selectedMonth - 1];

    final HomeMoodLogItem detailItem = realEntry != null
        ? HomeMoodLogItem(
            id: realEntry.id,
            moodLevel: level,
            moodTitle: _moodTitleForLevel(level),
            timestampLabel:
                '$monthStr ${realEntry.date.day}  ·  ${realEntry.updatedAt.hour.toString().padLeft(2, '0')}:${realEntry.updatedAt.minute.toString().padLeft(2, '0')}',
            tags: realEntry.activities
                .map((a) => (emoji: '🌿', label: a))
                .toList(),
            note: realEntry.journal,
          )
        : HomeMoodLogItem(
            id: 'cal_${_selectedYear}_${_selectedMonth}_$day',
            moodLevel: level,
            moodTitle: _moodTitleForLevel(level),
            timestampLabel: 'Today, $monthStr $day  ·  20:05 PM',
            tags: const [
              (emoji: '😊', label: 'Happy'),
              (emoji: '😌', label: 'Relaxed'),
              (emoji: '✨', label: 'Inspired'),
              (emoji: '🤝', label: 'Teamwork'),
              (emoji: '📈', label: 'Promotion'),
              (emoji: '📚', label: 'Classes'),
              (emoji: '💊', label: 'Medication'),
              (emoji: '🌙', label: 'Dream'),
              (emoji: '🥗', label: 'Lunch'),
              (emoji: '🎮', label: 'Gaming'),
              (emoji: '🧑‍🤝‍🧑', label: 'Friends'),
              (emoji: '🙏', label: 'Gratitude'),
              (emoji: '📋', label: 'Planning'),
              (emoji: '🍳', label: 'Cooking'),
              (emoji: '☀️', label: 'Sunny'),
              (emoji: '🏊', label: 'Swimming'),
            ],
            note:
                'Today, I feel very good. Work, social, weather, everything was perfect.',
            audioDuration: '00:28',
            photoThumbGradients: const [
              [Color(0xFF8D6E63), Color(0xFFD7CCC8)],
              [Color(0xFF4E342E), Color(0xFFA1887F)],
              [Color(0xFF0288D1), Color(0xFF4FC3F7)],
            ],
            isSample: true,
          );

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CalendarMoodDetailScreen(
          item: detailItem,
          paletteColors: paletteColors,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final setupState = ref.watch(accountSetupProvider);
    final paletteColors = moodColorPalettes[setupState.colorPaletteIndex];
    final entries = ref.watch(allEntriesStreamProvider).value ?? const <DailyEntry>[];

    // Index real Drift entries by date
    final realByDay = <int, DailyEntry>{};
    final realByDateKey = <String, int>{};
    for (final e in entries) {
      final lvl = _moodLevelFromString(e.mood);
      realByDateKey['${e.date.year}-${e.date.month}-${e.date.day}'] = lvl;
      if (e.date.year == _selectedYear && e.date.month == _selectedMonth) {
        realByDay[e.date.day] = e;
      }
    }

    // Build displayed month map: merge sample pattern + any real entries on top
    final moodByDay = <int, int>{};
    if (_selectedYear == 2024 && _selectedMonth == 12) {
      moodByDay.addAll(_sampleDecemberMoods);
    } else {
      final daysInMonth = DateTime(_selectedYear, _selectedMonth + 1, 0).day;
      for (int d = 1; d <= daysInMonth; d++) {
        moodByDay[d] = (_selectedYear * 7 + _selectedMonth * 11 + d * 5) % 5;
      }
    }
    for (final entry in realByDay.entries) {
      moodByDay[entry.key] = _moodLevelFromString(entry.value.mood);
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F8),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Top App Bar: Sticker Logo | "Calendar" | More Menu
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 12, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const MoodStickerLogo(size: 28, inverted: false),
                    Text(
                      'Calendar',
                      style: AppTypography.titleLarge.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: OnboardingColors.textDark,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _selectedYear = 2024;
                          _selectedMonth = 12;
                        });
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

              // Segmented Toggle: Monthly | Year in Pixels
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: OnboardingColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: OnboardingColors.borderLight.withValues(alpha: 0.7),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _CalendarTabChip(
                          label: 'Monthly',
                          selected: _tabIndex == 0,
                          onTap: () => setState(() => _tabIndex = 0),
                        ),
                      ),
                      Expanded(
                        child: _CalendarTabChip(
                          label: 'Year in Pixels',
                          selected: _tabIndex == 1,
                          onTap: () => setState(() => _tabIndex = 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Active Calendar Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                  child: _tabIndex == 0
                      ? CalendarMonthlyView(
                          year: _selectedYear,
                          month: _selectedMonth,
                          moodByDay: moodByDay,
                          paletteColors: paletteColors,
                          onPreviousMonth: _previousMonth,
                          onNextMonth: _nextMonth,
                          onDayTapped: (day) => _openDayDetails(
                            context,
                            day,
                            moodByDay[day],
                            realByDay[day],
                            paletteColors,
                          ),
                        )
                      : CalendarYearPixelsView(
                          year: _selectedYear,
                          paletteColors: paletteColors,
                          moodByDateKey: realByDateKey,
                          onPreviousYear: () =>
                              setState(() => _selectedYear--),
                          onNextYear: () => setState(() => _selectedYear++),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalendarTabChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CalendarTabChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color:
              selected ? OnboardingColors.primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTypography.titleMedium.copyWith(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : OnboardingColors.textDark,
          ),
        ),
      ),
    );
  }
}
