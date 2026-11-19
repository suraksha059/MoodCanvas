import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../capture/domain/daily_entry.dart';
import '../../../capture/presentation/providers/entry_repository_provider.dart';
import '../../../onboarding/presentation/providers/account_setup_provider.dart';
import '../../../onboarding/presentation/theme/onboarding_colors.dart';
import '../../../onboarding/presentation/widgets/mood_sticker_logo.dart';
import '../widgets/mood_log_card.dart';
import '../widgets/upgrade_premium_banner.dart';

/// Light-theme Home screen matching 26_Light_home.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isSearching = false;
  bool _fabMenuOpen = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showSelectDateSheet() async {
    int year = DateTime.now().year;
    int month = DateTime.now().month;
    int selectedDay = DateTime.now().day;

    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    const weekdays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final daysInMonth = DateTime(year, month + 1, 0).day;
            final leadingBlanks = DateTime(year, month, 1).weekday - 1;
            final totalCells = ((leadingBlanks + daysInMonth + 6) ~/ 7) * 7;

            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                decoration: const BoxDecoration(
                  color: OnboardingColors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.fromLTRB(22, 14, 22, 24),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Select Date',
                        style: AppTypography.titleLarge.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: OnboardingColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(color: Color(0xFFEEEEEE), height: 1),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              setModalState(() {
                                if (month == 1) {
                                  month = 12;
                                  year--;
                                } else {
                                  month--;
                                }
                                selectedDay = selectedDay.clamp(
                                    1, DateTime(year, month + 1, 0).day);
                              });
                            },
                            icon: const Icon(Icons.chevron_left_rounded,
                                color: OnboardingColors.textDark),
                          ),
                          Text(
                            '${months[month - 1]}, $year',
                            style: AppTypography.titleMedium.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: OnboardingColors.textDark,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setModalState(() {
                                if (month == 12) {
                                  month = 1;
                                  year++;
                                } else {
                                  month++;
                                }
                                selectedDay = selectedDay.clamp(
                                    1, DateTime(year, month + 1, 0).day);
                              });
                            },
                            icon: const Icon(Icons.chevron_right_rounded,
                                color: OnboardingColors.textDark),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: weekdays
                            .map((w) => Expanded(
                                  child: Text(
                                    w,
                                    textAlign: TextAlign.center,
                                    style: AppTypography.label.copyWith(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: OnboardingColors.textMuted,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 8),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: totalCells,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          childAspectRatio: 1.2,
                        ),
                        itemBuilder: (context, idx) {
                          final day = idx - leadingBlanks + 1;
                          if (day < 1 || day > daysInMonth) {
                            return const SizedBox.shrink();
                          }
                          final isSelected = day == selectedDay;
                          return GestureDetector(
                            onTap: () =>
                                setModalState(() => selectedDay = day),
                            child: Center(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 160),
                                width: 32,
                                height: 32,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? OnboardingColors.primaryGreen
                                      : Colors.transparent,
                                ),
                                child: Text(
                                  '$day',
                                  style: AppTypography.bodyMedium.copyWith(
                                    fontSize: 13,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white
                                        : OnboardingColors.textDark,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: TextButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                style: TextButton.styleFrom(
                                  backgroundColor: OnboardingColors.softGreenBg,
                                  foregroundColor:
                                      OnboardingColors.primaryGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(26),
                                  ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: AppTypography.button.copyWith(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w600,
                                    color: OnboardingColors.primaryGreen,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () => Navigator.of(ctx)
                                    .pop(DateTime(year, month, selectedDay)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      OnboardingColors.primaryGreen,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(26),
                                  ),
                                ),
                                child: Text(
                                  'Continue',
                                  style: AppTypography.button.copyWith(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (picked != null && mounted) {
      context.push('/capture', extra: {'initialDate': picked});
    }
  }

  /// Maps a persisted Drift DailyEntry into the HomeMoodLogItem card model.
  HomeMoodLogItem _mapEntryToItem(DailyEntry entry) {
    final moodLower = entry.mood.toLowerCase();
    int level = 3;
    String title = 'Good';
    if (moodLower.contains('overwhelmed') || moodLower.contains('angry')) {
      level = 0;
      title = 'Awful';
    } else if (moodLower.contains('sad') ||
        moodLower.contains('low') ||
        moodLower.contains('anxious') ||
        moodLower.contains('heavy')) {
      level = 1;
      title = 'Bad';
    } else if (moodLower.contains('okay') ||
        moodLower.contains('neutral') ||
        moodLower.contains('tired')) {
      level = 2;
      title = 'Okay';
    } else if (moodLower.contains('great') ||
        moodLower.contains('joy') ||
        moodLower.contains('excited')) {
      level = 4;
      title = 'Great';
    } else {
      level = 3;
      title = 'Good';
    }

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final dt = entry.updatedAt;
    final monthStr = months[(dt.month - 1).clamp(0, 11)];
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';

    final tags = <({String emoji, String label})>[
      for (final act in entry.activities) (emoji: _emojiForTag(act), label: act),
      if (entry.needed != null && entry.needed!.isNotEmpty)
        (emoji: '✨', label: entry.needed!),
      if (entry.actionTaken != null && entry.actionTaken!.isNotEmpty)
        (emoji: '🌿', label: entry.actionTaken!),
    ];

    return HomeMoodLogItem(
      id: entry.id,
      moodLevel: level,
      moodTitle: title,
      timestampLabel: '$monthStr ${dt.day}  ·  $hh:$mm $period',
      tags: tags,
      note: entry.journal,
      isSample: false,
    );
  }

  static String _emojiForTag(String tag) {
    final lower = tag.toLowerCase();
    if (lower.contains('calm')) return '😌';
    if (lower.contains('grateful')) return '🙏';
    if (lower.contains('work') || lower.contains('overtime')) return '⏰';
    if (lower.contains('sleep') || lower.contains('nap')) return '💤';
    if (lower.contains('walk') || lower.contains('exercise') || lower.contains('yoga')) {
      return '🧘';
    }
    if (lower.contains('read') || lower.contains('study')) return '📚';
    if (lower.contains('music')) return '🎵';
    if (lower.contains('friend') || lower.contains('family')) return '💛';
    if (lower.contains('food') || lower.contains('eat') || lower.contains('dinner')) {
      return '🥗';
    }
    return '🌿';
  }

  /// Default showcase mood logs matching 26_Light_home when the database is empty.
  static const List<HomeMoodLogItem> _sampleLogs = [
    HomeMoodLogItem(
      id: 'sample_okay',
      moodLevel: 2,
      moodTitle: 'Okay',
      timestampLabel: 'Dec 21  ·  21:24 PM',
      tags: [
        (emoji: '😌', label: 'Calm'),
        (emoji: '🙏', label: 'Grateful'),
        (emoji: '😊', label: 'Content'),
        (emoji: '⏰', label: 'Overtime'),
        (emoji: '📝', label: 'Exams'),
        (emoji: '📊', label: 'Projects'),
        (emoji: '💧', label: 'Hydration'),
        (emoji: '💤', label: 'Nap'),
        (emoji: '🍲', label: 'Dinner'),
        (emoji: '📚', label: 'Reading'),
        (emoji: '❤️', label: 'Partner'),
        (emoji: '🛋️', label: 'Therapy'),
        (emoji: '⏳', label: 'Focus Time'),
        (emoji: '🧺', label: 'Laundry'),
        (emoji: '☁️', label: 'Cloudy'),
        (emoji: '🔥', label: 'Hot'),
        (emoji: '🚴', label: 'Cycling'),
        (emoji: '🧘', label: 'Yoga'),
      ],
      note:
          'Today there was a little problem in the team, but I am good at socializing. I feel okay.',
      audioDuration: '00:35',
      photoThumbGradients: [
        [Color(0xFF455A64), Color(0xFF90A4AE)],
        [Color(0xFF8D6E63), Color(0xFFD7CCC8)],
        [Color(0xFF546E7A), Color(0xFFB0BEC5)],
        [Color(0xFF6D4C41), Color(0xFFBCAAA4)],
      ],
      isSample: true,
    ),
    HomeMoodLogItem(
      id: 'sample_good',
      moodLevel: 3,
      moodTitle: 'Good',
      timestampLabel: 'Dec 20  ·  20:46 PM',
      tags: [
        (emoji: '😎', label: 'Confident'),
        (emoji: '☀️', label: 'Energized'),
        (emoji: '😌', label: 'Calm'),
        (emoji: '🗣️', label: 'Presentation'),
        (emoji: '🤝', label: 'Meeting'),
        (emoji: '🎓', label: 'Lectures'),
        (emoji: '🥗', label: 'Healthy Eating'),
        (emoji: '💤', label: 'Nap'),
        (emoji: '🍎', label: 'Fruits'),
        (emoji: '✍️', label: 'Writing'),
        (emoji: '🧑‍🤝‍🧑', label: 'Friends'),
        (emoji: '🎯', label: 'Goal Setting'),
        (emoji: '⏳', label: 'Focus Time'),
        (emoji: '🧹', label: 'Cleaning'),
        (emoji: '🌧️', label: 'Rainy'),
        (emoji: '🧘', label: 'Yoga'),
      ],
      note:
          'Today met new colleagues and ate a healthy salad, I feel good.',
      audioDuration: '00:24',
      photoThumbGradients: [
        [Color(0xFF5C6BC0), Color(0xFF9FA8DA)],
        [Color(0xFF66BB6A), Color(0xFFA5D6A7)],
      ],
      isSample: true,
    ),
    HomeMoodLogItem(
      id: 'sample_great',
      moodLevel: 4,
      moodTitle: 'Great',
      timestampLabel: 'Dec 19  ·  20:29 PM',
      tags: [
        (emoji: '🤩', label: 'Excited'),
        (emoji: '😊', label: 'Happy'),
        (emoji: '💪', label: 'Motivated'),
        (emoji: '📈', label: 'Promotion'),
        (emoji: '📊', label: 'Projects'),
        (emoji: '🏃', label: 'Exercise'),
      ],
      note:
          'Wrapped up a major milestone and celebrated with an evening run!',
      isSample: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final setupState = ref.watch(accountSetupProvider);
    final paletteColors = moodColorPalettes[setupState.colorPaletteIndex];
    final recentEntriesAsync = ref.watch(recentEntriesStreamProvider);

    final feedItems = recentEntriesAsync.when(
      data: (entries) {
        if (entries.isEmpty) return _sampleLogs;
        return entries.map(_mapEntryToItem).toList();
      },
      loading: () => _sampleLogs,
      error: (_, _) => _sampleLogs,
    );

    final filteredItems = _searchQuery.isEmpty
        ? feedItems
        : feedItems.where((item) {
            final q = _searchQuery.toLowerCase();
            return item.moodTitle.toLowerCase().contains(q) ||
                item.note.toLowerCase().contains(q) ||
                item.tags.any((t) => t.label.toLowerCase().contains(q));
          }).toList();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F8),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: FloatingActionButton(
            onPressed: () => setState(() => _fabMenuOpen = !_fabMenuOpen),
            backgroundColor: OnboardingColors.primaryGreen,
            foregroundColor: Colors.white,
            elevation: 4,
            shape: const CircleBorder(),
            child: Icon(
              _fabMenuOpen ? Icons.close_rounded : Icons.add_rounded,
              size: 30,
            ),
          ),
        ),
        body: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: Column(
            children: [
              // Top App Bar: Sticker Logo | "Home" | Search Icon
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 12, 8),
                child: _isSearching
                    ? Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              autofocus: true,
                              onChanged: (val) =>
                                  setState(() => _searchQuery = val.trim()),
                              style: AppTypography.bodyMedium.copyWith(
                                color: OnboardingColors.textDark,
                                fontSize: 15,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search moods, tags, notes...',
                                hintStyle: AppTypography.bodyMedium.copyWith(
                                  color: OnboardingColors.textLight,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: const Icon(
                                  Icons.search_rounded,
                                  color: OnboardingColors.textMuted,
                                  size: 20,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _isSearching = false;
                                _searchQuery = '';
                                _searchController.clear();
                              });
                            },
                            icon: const Icon(
                              Icons.close_rounded,
                              color: OnboardingColors.textDark,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const MoodStickerLogo(size: 28, inverted: false),
                          Text(
                            'Home',
                            style: AppTypography.titleLarge.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: OnboardingColors.textDark,
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                setState(() => _isSearching = true),
                            icon: const Icon(
                              Icons.search_rounded,
                              size: 24,
                              color: OnboardingColors.textDark,
                            ),
                          ),
                        ],
                      ),
              ),

              // Main Scrollable Home Content
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 6, 20, 100),
                  children: [
                    // 1. Upgrade Premium Banner
                    UpgradePremiumBanner(
                      onUpgradeTap: () => context.push('/upgrade-plan'),
                    ),
                    const SizedBox(height: 16),

                    // 2. "How do you feel today?" 5-Mood Quick Check-in Card
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                      decoration: BoxDecoration(
                        color: OnboardingColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: OnboardingColors.borderLight
                              .withValues(alpha: 0.7),
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
                          Text(
                            'How do you feel today?',
                            style: AppTypography.titleMedium.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: OnboardingColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(5, (index) {
                              return GestureDetector(
                                onTap: () => context.push(
                                  '/capture',
                                  extra: {'initialMood': index},
                                ),
                                child: HomeMoodFace(
                                  color: paletteColors[index],
                                  moodLevel: index,
                                  size: 48,
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 3. Mood Log Feed Cards
                    if (filteredItems.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            'No matching mood logs found.',
                            style: AppTypography.bodyMedium.copyWith(
                              color: OnboardingColors.textMuted,
                            ),
                          ),
                        ),
                      )
                    else
                      ...filteredItems.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: MoodLogCard(
                            item: item,
                            paletteColors: paletteColors,
                            onTap: item.isSample
                                ? () => context.push('/capture')
                                : () => context.push('/memories/${item.id}'),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ],
          ),
        ),

            // Blurred FAB Action Menu Overlay (38_Light_mood tracking)
            if (_fabMenuOpen) ...[
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => setState(() => _fabMenuOpen = false),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.42),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 20,
                bottom: 84,
                child: Container(
                  width: 176,
                  decoration: BoxDecoration(
                    color: OnboardingColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.16),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() => _fabMenuOpen = false);
                          context.push('/capture');
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.wb_sunny_outlined,
                                size: 20,
                                color: OnboardingColors.textDark,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Today',
                                style: AppTypography.titleMedium.copyWith(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w600,
                                  color: OnboardingColors.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(color: Color(0xFFEEEEEE), height: 1),
                      InkWell(
                        onTap: () {
                          setState(() => _fabMenuOpen = false);
                          _showSelectDateSheet();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 19,
                                color: OnboardingColors.textDark,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Select Date',
                                style: AppTypography.titleMedium.copyWith(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w600,
                                  color: OnboardingColors.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
