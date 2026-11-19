import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../home/presentation/widgets/mood_log_card.dart';
import '../../../onboarding/presentation/theme/onboarding_colors.dart';

/// Card 3: Average Daily Mood (Mon - Sun vertical rounded bars with mood face Y-axis).
class AverageDailyMoodCard extends StatelessWidget {
  final List<Color> paletteColors;

  const AverageDailyMoodCard({
    super.key,
    required this.paletteColors,
  });

  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _levels = [2, 3, 2, 0, 1, 3, 4];
  static const _heights = [0.56, 0.74, 0.52, 0.14, 0.34, 0.76, 0.94];

  @override
  Widget build(BuildContext context) {
    return _InsightsWhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Average Daily Mood',
            style: AppTypography.titleLarge.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: OnboardingColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 174,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Y-axis Mood Faces
                Padding(
                  padding: const EdgeInsets.only(bottom: 22),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [4, 3, 2, 1, 0].map((level) {
                      return HomeMoodFace(
                        color: paletteColors[level],
                        moodLevel: level,
                        size: 22,
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 12),

                // 7 Bars (Mon..Sun)
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final barAreaH = constraints.maxHeight - 24;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(_days.length, (i) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 22,
                                height: (barAreaH * _heights[i]).clamp(14.0, barAreaH),
                                decoration: BoxDecoration(
                                  color: paletteColors[_levels[i]],
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(11),
                                    bottom: Radius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _days[i],
                                style: AppTypography.label.copyWith(
                                  fontSize: 11,
                                  color: OnboardingColors.textLight,
                                ),
                              ),
                            ],
                          );
                        }),
                      );
                    },
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

/// Card 4: Mood Stability (64 / 100 circular score ring + wave sparkline).
class MoodStabilityCard extends StatelessWidget {
  final int score;

  const MoodStabilityCard({
    super.key,
    this.score = 64,
  });

  @override
  Widget build(BuildContext context) {
    return _InsightsWhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mood Stability',
            style: AppTypography.titleLarge.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: OnboardingColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Circular Stability Ring
              SizedBox(
                width: 88,
                height: 88,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(88, 88),
                      painter: _StabilityRingPainter(
                        progress: (score / 100).clamp(0.0, 1.0),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$score',
                          style: AppTypography.titleLarge.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: OnboardingColors.textDark,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '/ 100',
                          style: AppTypography.label.copyWith(
                            fontSize: 11,
                            color: OnboardingColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              // Wave Sparkline
              const Expanded(
                child: SizedBox(
                  height: 76,
                  child: CustomPaint(
                    painter: _StabilityWavePainter(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'The higher the score, the more stable you are.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 12,
                color: OnboardingColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StabilityRingPainter extends CustomPainter {
  final double progress;

  const _StabilityRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    const strokeW = 7.5;
    final rect = (Offset.zero & size).deflate(strokeW / 2);

    canvas.drawOval(
      rect,
      Paint()
        ..color = const Color(0xFFEEEEEE)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeW,
    );

    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..color = OnboardingColors.primaryGreen
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeW
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _StabilityRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _StabilityWavePainter extends CustomPainter {
  const _StabilityWavePainter();

  static const _pts = [
    0.15, 0.16, 0.18, 0.72, 0.28, 0.25, 0.85, 0.40, 0.35, 0.92,
    0.55, 0.45, 0.38, 0.75, 0.30, 0.58, 0.18,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final stepX = size.width / (_pts.length - 1);
    final path = Path();

    for (int i = 0; i < _pts.length; i++) {
      final x = i * stepX;
      final y = _pts[i] * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final prevX = (i - 1) * stepX;
        final prevY = _pts[i - 1] * size.height;
        final ctrlX = (prevX + x) / 2;
        path.cubicTo(ctrlX, prevY, ctrlX, y, x, y);
      }
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          colors: [
            OnboardingColors.primaryGreen.withValues(alpha: 0.22),
            OnboardingColors.primaryGreen.withValues(alpha: 0.0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Offset.zero & size),
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = OnboardingColors.primaryGreen
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Card 5: Activity Count (4-column grid of emoji icons with green count badges + Show more...).
class ActivityCountCard extends StatefulWidget {
  const ActivityCountCard({super.key});

  @override
  State<ActivityCountCard> createState() => _ActivityCountCardState();
}

class _ActivityCountCardState extends State<ActivityCountCard> {
  bool _expanded = false;

  static const _activities = [
    (emoji: '📅', label: 'Meeting', count: 175),
    (emoji: '📚', label: 'Classes', count: 168),
    (emoji: '🏋️', label: 'Exercise', count: 162),
    (emoji: '💤', label: 'Nap', count: 156),
    (emoji: '🌻', label: 'Gardening', count: 150),
    (emoji: '🍲', label: 'Dinner', count: 144),
    (emoji: '✈️', label: 'Traveling', count: 139),
    (emoji: '👨‍👩‍👧', label: 'Family', count: 135),
    (emoji: '🛁', label: 'Self-Care', count: 128),
    (emoji: '⏳', label: 'Focus Time', count: 122),
    (emoji: '☀️', label: 'Sunny', count: 118),
    (emoji: '🏃', label: 'Running', count: 112),
    (emoji: '🧘', label: 'Yoga', count: 98),
    (emoji: '🎵', label: 'Music', count: 91),
    (emoji: '📖', label: 'Reading', count: 84),
    (emoji: '☕', label: 'Coffee', count: 76),
  ];

  @override
  Widget build(BuildContext context) {
    final visible = _expanded ? _activities : _activities.take(12).toList();

    return _InsightsWhiteCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Activity Count',
                style: AppTypography.titleLarge.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: OnboardingColors.textDark,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: OnboardingColors.backgroundLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: OnboardingColors.borderLight),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'All Activities',
                      style: AppTypography.label.copyWith(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: OnboardingColors.textDark,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: OnboardingColors.textDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: visible.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 14,
              childAspectRatio: 0.92,
            ),
            itemBuilder: (context, index) {
              final item = visible[index];
              return _ActivityBadgeTile(
                emoji: item.emoji,
                label: item.label,
                count: item.count,
                badgeColor: OnboardingColors.primaryGreen,
              );
            },
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Text(
              _expanded ? 'Show less' : 'Show more...',
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: OnboardingColors.primaryGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Card 6: Best & Worst ("When you were feeling good..." & "When you were feeling down...").
class BestAndWorstCard extends StatelessWidget {
  const BestAndWorstCard({super.key});

  static const _goodItems = [
    (emoji: '🌴', label: 'Vacation', count: 12),
    (emoji: '🚌', label: 'Field Trip', count: 9),
    (emoji: '🏋️', label: 'Exercise', count: 8),
    (emoji: '💤', label: 'Nap', count: 7),
  ];

  static const _downItems = [
    (emoji: '📌', label: 'Deadline', count: 11),
    (emoji: '📝', label: 'Exams', count: 9),
    (emoji: '😣', label: 'Stress', count: 8),
    (emoji: '🌙', label: 'Late Night', count: 6),
  ];

  @override
  Widget build(BuildContext context) {
    return _InsightsWhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Best & Worst',
                style: AppTypography.titleLarge.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: OnboardingColors.textDark,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View more',
                    style: AppTypography.label.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: OnboardingColors.textMuted,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: OnboardingColors.textMuted,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Good subsection
          RichText(
            text: TextSpan(
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: OnboardingColors.textDark,
              ),
              children: const [
                TextSpan(text: 'When you were feeling '),
                TextSpan(
                  text: 'good...',
                  style: TextStyle(color: OnboardingColors.primaryGreen),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: _goodItems.map((item) {
              return Expanded(
                child: _ActivityBadgeTile(
                  emoji: item.emoji,
                  label: item.label,
                  count: item.count,
                  badgeColor: OnboardingColors.primaryGreen,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 18),

          // Down subsection
          RichText(
            text: TextSpan(
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: OnboardingColors.textDark,
              ),
              children: const [
                TextSpan(text: 'When you were feeling '),
                TextSpan(
                  text: 'down...',
                  style: TextStyle(color: OnboardingColors.moodRed),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: _downItems.map((item) {
              return Expanded(
                child: _ActivityBadgeTile(
                  emoji: item.emoji,
                  label: item.label,
                  count: item.count,
                  badgeColor: OnboardingColors.moodRed,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _ActivityBadgeTile extends StatelessWidget {
  final String emoji;
  final String label;
  final int count;
  final Color badgeColor;

  const _ActivityBadgeTile({
    required this.emoji,
    required this.label,
    required this.count,
    required this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: OnboardingColors.backgroundLight,
                shape: BoxShape.circle,
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 22)),
            ),
            Positioned(
              top: -3,
              right: -6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 1.4),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppTypography.label.copyWith(
            fontSize: 11,
            color: OnboardingColors.textDark,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

class _InsightsWhiteCard extends StatelessWidget {
  final Widget child;

  const _InsightsWhiteCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: child,
    );
  }
}
