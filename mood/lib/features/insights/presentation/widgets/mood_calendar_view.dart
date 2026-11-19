import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../capture/domain/daily_entry.dart';
import '../../../capture/domain/mood_type.dart';
import '../providers/insights_providers.dart';

/// Interactive Mood Calendar displaying days colored by primary emotional canvas.
class MoodCalendarView extends ConsumerWidget {
  const MoodCalendarView({super.key});

  static const List<String> _weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  static const List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  MoodType _parseMood(String moodName) {
    return MoodType.values.firstWhere(
      (m) =>
          m.label.toLowerCase() == moodName.toLowerCase() ||
          m.name.toLowerCase() == moodName.toLowerCase(),
      orElse: () => MoodType.calm,
    );
  }

  String _formatFullDate(DateTime day) {
    const monthsShort = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${monthsShort[day.month - 1]} ${day.day}, ${day.year}';
  }

  void _onDayTap(BuildContext context, DateTime day, DailyEntry? entry) {
    final formattedDate = _formatFullDate(day);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        if (entry != null) {
          final moodEnum = _parseMood(entry.mood);

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.borderSubtle,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Header with mini preview
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: moodEnum.primaryColor.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: moodEnum.primaryColor.withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.spa_rounded,
                          color: moodEnum.primaryColor,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              formattedDate,
                              style: AppTypography.label.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: moodEnum.primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  entry.mood,
                                  style: AppTypography.displayMedium.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Intensity: ${entry.moodIntensity}/10 • ${entry.energy}',
                              style: AppTypography.label.copyWith(
                                color: AppColors.textTertiary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Action: Open that memory
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        context.push('/memories/${entry.id}');
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: moodEnum.primaryColor,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Open that memory',
                        style: AppTypography.label.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        } else {
          // No entry for this day
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.borderSubtle,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: const Icon(
                      Icons.event_busy_rounded,
                      color: AppColors.textTertiary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    formattedDate,
                    style: AppTypography.label.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'No check-in for this day.',
                    style: AppTypography.displayMedium.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        context.push('/capture');
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.amberWarmth,
                        side: const BorderSide(color: AppColors.amberWarmth),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('Capture this day'),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewedMonth = ref.watch(calendarMonthProvider);
    final calendarMap = ref.watch(calendarEntriesMapProvider);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Days in month calculation
    final daysInMonth = DateTime(viewedMonth.year, viewedMonth.month + 1, 0).day;
    final firstWeekday = DateTime(viewedMonth.year, viewedMonth.month, 1).weekday; // 1 = Monday
    final leadingBlanks = firstWeekday - 1;

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
          // Month navigation header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_months[viewedMonth.month - 1]} ${viewedMonth.year}',
                style: AppTypography.displayMedium.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () =>
                        ref.read(calendarMonthProvider.notifier).previousMonth(),
                    icon: const Icon(Icons.chevron_left_rounded, size: 22),
                    color: AppColors.textSecondary,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: () =>
                        ref.read(calendarMonthProvider.notifier).nextMonth(),
                    icon: const Icon(Icons.chevron_right_rounded, size: 22),
                    color: AppColors.textSecondary,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Weekdays header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _weekdays.map((dayName) {
              return SizedBox(
                width: 36,
                child: Text(
                  dayName,
                  textAlign: TextAlign.center,
                  style: AppTypography.label.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),

          // Calendar Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: leadingBlanks + daysInMonth,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              if (index < leadingBlanks) {
                return const SizedBox.shrink();
              }

              final dayNum = index - leadingBlanks + 1;
              final cellDate = DateTime(viewedMonth.year, viewedMonth.month, dayNum);
              final dateStr = DailyEntry.toDateString(cellDate);
              final entry = calendarMap[dateStr];
              final isToday = cellDate.year == today.year &&
                  cellDate.month == today.month &&
                  cellDate.day == today.day;

              if (entry != null) {
                final moodEnum = _parseMood(entry.mood);

                // Emotional visual indicator: colored glowing cell
                return GestureDetector(
                  onTap: () => _onDayTap(context, cellDate, entry),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: moodEnum.primaryColor.withValues(alpha: 0.28),
                      border: Border.all(
                        color: isToday
                            ? Colors.white
                            : moodEnum.primaryColor.withValues(alpha: 0.8),
                        width: isToday ? 2.0 : 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: moodEnum.primaryColor.withValues(alpha: 0.35),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '$dayNum',
                        style: AppTypography.label.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              }

              // Empty day cell
              return GestureDetector(
                onTap: () => _onDayTap(context, cellDate, null),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: isToday
                        ? Border.all(color: AppColors.amberWarmth, width: 1.5)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '$dayNum',
                      style: AppTypography.label.copyWith(
                        color: isToday
                            ? AppColors.amberWarmth
                            : AppColors.textTertiary.withValues(alpha: 0.7),
                        fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
