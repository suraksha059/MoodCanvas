import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../home/presentation/widgets/mood_log_card.dart';
import '../../../onboarding/presentation/theme/onboarding_colors.dart';

/// Monthly mood-face calendar grid matching 53_Light_calendar.
class CalendarMonthlyView extends StatelessWidget {
  final int year;
  final int month; // 1..12
  final Map<int, int> moodByDay; // day (1..31) -> moodLevel (0..4)
  final List<Color> paletteColors;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final ValueChanged<int> onDayTapped;

  const CalendarMonthlyView({
    super.key,
    required this.year,
    required this.month,
    required this.moodByDay,
    required this.paletteColors,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onDayTapped,
  });

  static const _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final leadingBlanks = firstOfMonth.weekday - 1; // Mon=1 -> 0
    final prevMonthDays = DateTime(year, month, 0).day;

    final totalCells = ((leadingBlanks + daysInMonth + 6) ~/ 7) * 7;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
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
          // Month Navigation Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onPreviousMonth,
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  size: 22,
                  color: OnboardingColors.textDark,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
              Text(
                '${_monthNames[month - 1]}, $year',
                style: AppTypography.titleMedium.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: OnboardingColors.textDark,
                ),
              ),
              IconButton(
                onPressed: onNextMonth,
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
          const SizedBox(height: 14),

          // Weekday Labels
          Row(
            children: _weekdays.map((day) {
              return Expanded(
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: AppTypography.label.copyWith(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: OnboardingColors.textMuted,
                    letterSpacing: 0,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // 7-Column Calendar Mood Face Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: totalCells,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 12,
              crossAxisSpacing: 4,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (context, index) {
              final dayOffset = index - leadingBlanks + 1;

              // Previous month overflow day
              if (dayOffset < 1) {
                final overflowDay = prevMonthDays + dayOffset;
                final sampleMood = (overflowDay * 3 + month) % 5;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Opacity(
                      opacity: 0.85,
                      child: HomeMoodFace(
                        color: paletteColors[sampleMood],
                        moodLevel: sampleMood,
                        size: 34,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$overflowDay',
                      style: AppTypography.label.copyWith(
                        fontSize: 10.5,
                        color: OnboardingColors.textLight,
                      ),
                    ),
                  ],
                );
              }

              // Next month overflow day
              if (dayOffset > daysInMonth) {
                final nextDay = dayOffset - daysInMonth;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _EmptyMoodFaceOutline(size: 34),
                    const SizedBox(height: 4),
                    Text(
                      '$nextDay',
                      style: AppTypography.label.copyWith(
                        fontSize: 10.5,
                        color: OnboardingColors.textLight.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                );
              }

              // Current month day
              final moodLevel = moodByDay[dayOffset];
              final hasMood = moodLevel != null;

              return GestureDetector(
                onTap: () => onDayTapped(dayOffset),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasMood)
                      HomeMoodFace(
                        color: paletteColors[moodLevel],
                        moodLevel: moodLevel,
                        size: 34,
                      )
                    else
                      const _EmptyMoodFaceOutline(size: 34),
                    const SizedBox(height: 4),
                    Text(
                      '$dayOffset',
                      style: AppTypography.label.copyWith(
                        fontSize: 10.5,
                        fontWeight:
                            hasMood ? FontWeight.w600 : FontWeight.w400,
                        color: hasMood
                            ? OnboardingColors.textDark
                            : OnboardingColors.textLight,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Helper Caption
          Text(
            'Tap mood to see more details',
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

/// Faint light-gray outlined empty smiley face for unlogged/future calendar dates.
class _EmptyMoodFaceOutline extends StatelessWidget {
  final double size;

  const _EmptyMoodFaceOutline({this.size = 34});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const CustomPaint(painter: _EmptyMoodFacePainter()),
    );
  }
}

class _EmptyMoodFacePainter extends CustomPainter {
  const _EmptyMoodFacePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 1;
    const strokeColor = Color(0xFFE0E3E7);

    canvas.drawCircle(
      center,
      r,
      Paint()
        ..color = strokeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..isAntiAlias = true,
    );

    final eyePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx - r * 0.28, center.dy - r * 0.14),
      r * 0.09,
      eyePaint,
    );
    canvas.drawCircle(
      Offset(center.dx + r * 0.28, center.dy - r * 0.14),
      r * 0.09,
      eyePaint,
    );

    final smile = Path()
      ..moveTo(center.dx - r * 0.26, center.dy + r * 0.18)
      ..quadraticBezierTo(
        center.dx,
        center.dy + r * 0.36,
        center.dx + r * 0.26,
        center.dy + r * 0.18,
      );
    canvas.drawPath(
      smile,
      Paint()
        ..color = strokeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
