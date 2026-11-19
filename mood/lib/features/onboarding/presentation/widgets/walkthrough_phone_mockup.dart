import 'package:flutter/material.dart';
import '../theme/onboarding_colors.dart';
import 'mood_sticker_logo.dart';

/// Realistic iPhone device frame showcasing the 3 app preview screens
/// for the walkthrough onboarding pages.
class WalkthroughPhoneMockup extends StatelessWidget {
  final int pageIndex;

  const WalkthroughPhoneMockup({
    super.key,
    required this.pageIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 248,
      decoration: BoxDecoration(
        color: OnboardingColors.deviceBezel,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(38)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(9, 9, 9, 0),
      child: Container(
        decoration: const BoxDecoration(
          color: OnboardingColors.backgroundLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _MiniStatusBar(),
            if (pageIndex == 0)
              const _HomePreviewContent()
            else if (pageIndex == 1)
              const _InsightsPreviewContent()
            else
              const _AchievementsPreviewContent(),
          ],
        ),
      ),
    );
  }
}

/// Top iPhone status bar with time, Dynamic Island, and tiny status icons.
class _MiniStatusBar extends StatelessWidget {
  const _MiniStatusBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: OnboardingColors.white,
      padding: const EdgeInsets.fromLTRB(16, 7, 14, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '9:41',
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: OnboardingColors.textDark,
              letterSpacing: -0.2,
            ),
          ),
          Container(
            width: 58,
            height: 15,
            decoration: BoxDecoration(
              color: OnboardingColors.deviceBezel,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.signal_cellular_alt, size: 9, color: OnboardingColors.textDark),
              SizedBox(width: 2),
              Icon(Icons.wifi, size: 9, color: OnboardingColors.textDark),
              SizedBox(width: 2),
              Icon(Icons.battery_full, size: 10, color: OnboardingColors.textDark),
            ],
          ),
        ],
      ),
    );
  }
}

/// Page 1 Mockup: Home screen with Upgrade banner, mood check-in row, and log card.
class _HomePreviewContent extends StatelessWidget {
  const _HomePreviewContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: OnboardingColors.backgroundLight,
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mini AppBar
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MoodStickerLogo(size: 16),
              Text(
                'Home',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: OnboardingColors.textDark,
                ),
              ),
              Icon(Icons.search_rounded, size: 15, color: OnboardingColors.textDark),
            ],
          ),
          const SizedBox(height: 10),

          // Green Premium Banner Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7CB342), Color(0xFF8BC34A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Upgrade Premium!',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Enjoy all the benefits',
                        style: TextStyle(
                          fontSize: 7.5,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Upgrade',
                          style: TextStyle(
                            fontSize: 7.5,
                            fontWeight: FontWeight.w700,
                            color: OnboardingColors.primaryGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.workspace_premium_rounded,
                    color: OnboardingColors.goldCrown,
                    size: 26,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // "How do you feel today?" Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: OnboardingColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: OnboardingColors.borderLight.withValues(alpha: 0.6)),
            ),
            child: const Column(
              children: [
                Text(
                  'How do you feel today?',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: OnboardingColors.textDark,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _MiniMoodFace(color: OnboardingColors.moodRed, mood: 0, size: 28),
                    _MiniMoodFace(color: OnboardingColors.moodOrange, mood: 1, size: 28),
                    _MiniMoodFace(color: OnboardingColors.moodYellow, mood: 2, size: 28),
                    _MiniMoodFace(color: OnboardingColors.moodLightGreen, mood: 3, size: 28),
                    _MiniMoodFace(color: OnboardingColors.moodGreen, mood: 4, size: 28),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Sample Mood Log Card ("Okay")
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: OnboardingColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: OnboardingColors.borderLight.withValues(alpha: 0.6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    _MiniMoodFace(color: OnboardingColors.moodYellow, mood: 2, size: 28),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Okay',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: OnboardingColors.textDark,
                            ),
                          ),
                          Text(
                            'Dec 22 · 11:24 PM',
                            style: TextStyle(
                              fontSize: 7,
                              color: OnboardingColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.share_outlined, size: 11, color: OnboardingColors.textMuted),
                    SizedBox(width: 4),
                    Icon(Icons.more_vert, size: 11, color: OnboardingColors.textMuted),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: const [
                    _MiniActivityChip(label: 'Calm', dotColor: OnboardingColors.moodYellow),
                    _MiniActivityChip(label: 'Grateful', dotColor: OnboardingColors.moodLightGreen),
                    _MiniActivityChip(label: 'Content', dotColor: OnboardingColors.moodOrange),
                    _MiniActivityChip(label: 'Overtime', dotColor: OnboardingColors.badgeBlue),
                    _MiniActivityChip(label: 'Exams', dotColor: OnboardingColors.moodRed),
                    _MiniActivityChip(label: 'Projects', dotColor: OnboardingColors.badgePurple),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Page 2 Mockup: Insights screen with streak stats and colorful mood bar chart.
class _InsightsPreviewContent extends StatelessWidget {
  const _InsightsPreviewContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: OnboardingColors.backgroundLight,
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mini AppBar
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MoodStickerLogo(size: 16),
              Text(
                'Insights',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: OnboardingColors.textDark,
                ),
              ),
              Icon(Icons.more_vert, size: 15, color: OnboardingColors.textDark),
            ],
          ),
          const SizedBox(height: 10),

          // 3 Stat Cards Row
          const Row(
            children: [
              Expanded(
                child: _MiniStatCard(
                  icon: Icons.bolt_rounded,
                  iconColor: OnboardingColors.moodOrange,
                  value: '65',
                  label: 'Longest streak',
                ),
              ),
              SizedBox(width: 6),
              Expanded(
                child: _MiniStatCard(
                  icon: Icons.local_fire_department_rounded,
                  iconColor: OnboardingColors.moodRed,
                  value: '58',
                  label: 'Current streak',
                ),
              ),
              SizedBox(width: 6),
              Expanded(
                child: _MiniStatCard(
                  icon: Icons.calendar_today_rounded,
                  iconColor: OnboardingColors.moodRed,
                  value: '482',
                  label: 'Lifetime logs',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Mood Chart Card
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: OnboardingColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: OnboardingColors.borderLight.withValues(alpha: 0.6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Chart Title + Mini Toggle Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mood Chart',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: OnboardingColors.textDark,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: OnboardingColors.primaryGreen,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(Icons.bar_chart_rounded, size: 10, color: Colors.white),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.show_chart_rounded, size: 11, color: OnboardingColors.textLight),
                        const SizedBox(width: 4),
                        const Icon(Icons.grid_view_rounded, size: 10, color: OnboardingColors.textLight),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Period Segmented Tabs
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: OnboardingColors.backgroundLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 3.5),
                          decoration: BoxDecoration(
                            color: OnboardingColors.primaryGreen,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            'Weekly',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 7.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Monthly',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 7.5, color: OnboardingColors.textMuted),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Yearly',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 7.5, color: OnboardingColors.textMuted),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Lifetime',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 7.5, color: OnboardingColors.textMuted),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7),

                // Date Range Selector
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.chevron_left, size: 12, color: OnboardingColors.textMuted),
                    Text(
                      'Dec 16 - Dec 22, 2024',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: OnboardingColors.textDark,
                      ),
                    ),
                    Icon(Icons.chevron_right, size: 12, color: OnboardingColors.textMuted),
                  ],
                ),
                const SizedBox(height: 10),

                // Bar Chart with Mood Y-Axis
                SizedBox(
                  height: 106,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Y-axis Mood Faces
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _MiniMoodFace(color: OnboardingColors.moodGreen, mood: 4, size: 14),
                          _MiniMoodFace(color: OnboardingColors.moodLightGreen, mood: 3, size: 14),
                          _MiniMoodFace(color: OnboardingColors.moodYellow, mood: 2, size: 14),
                          _MiniMoodFace(color: OnboardingColors.moodOrange, mood: 1, size: 14),
                          _MiniMoodFace(color: OnboardingColors.moodRed, mood: 0, size: 14),
                        ],
                      ),
                      const SizedBox(width: 8),
                      // 7 Vertical Mood Bars
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            _MiniChartBar(height: 70, color: OnboardingColors.moodLightGreen),
                            _MiniChartBar(height: 44, color: OnboardingColors.moodOrange, highlighted: true),
                            _MiniChartBar(height: 22, color: OnboardingColors.moodRed),
                            _MiniChartBar(height: 94, color: OnboardingColors.moodGreen),
                            _MiniChartBar(height: 82, color: OnboardingColors.moodLightGreen),
                            _MiniChartBar(height: 60, color: OnboardingColors.moodYellow),
                            _MiniChartBar(height: 90, color: OnboardingColors.moodGreen),
                          ],
                        ),
                      ),
                    ],
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

/// Page 3 Mockup: Achievements screen with 3x3 circular badge grid.
class _AchievementsPreviewContent extends StatelessWidget {
  const _AchievementsPreviewContent();

  @override
  Widget build(BuildContext context) {
    const badges = [
      (icon: Icons.star_rounded, color: OnboardingColors.primaryGreen, label: 'Shining Star', unlocked: true),
      (icon: Icons.workspace_premium_rounded, color: Color(0xFFD1D5DB), label: 'Mood Master', unlocked: false),
      (icon: Icons.military_tech_rounded, color: OnboardingColors.badgePurple, label: 'Consistent Logger', unlocked: true),
      (icon: Icons.spa_rounded, color: Color(0xFFD1D5DB), label: 'Zen Seeker', unlocked: false),
      (icon: Icons.gavel_rounded, color: OnboardingColors.badgeBlue, label: 'Persistent Performer', unlocked: true),
      (icon: Icons.wb_sunny_rounded, color: Color(0xFFD1D5DB), label: 'Early Bird', unlocked: false),
      (icon: Icons.nightlight_round, color: OnboardingColors.badgeOrange, label: 'Night Owl', unlocked: true),
      (icon: Icons.search_rounded, color: Color(0xFFD1D5DB), label: 'Insight Seeker', unlocked: false),
      (icon: Icons.eco_rounded, color: OnboardingColors.primaryGreen, label: 'Wellness Warrior', unlocked: true),
    ];

    return Container(
      color: OnboardingColors.white,
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mini AppBar
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.arrow_back_rounded, size: 14, color: OnboardingColors.textDark),
              Text(
                'Achievements',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: OnboardingColors.textDark,
                ),
              ),
              SizedBox(width: 14),
            ],
          ),
          const SizedBox(height: 12),

          // 3x3 Badge Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: badges.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 10,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, index) {
              final badge = badges[index];
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: badge.unlocked
                          ? badge.color.withValues(alpha: 0.14)
                          : const Color(0xFFF3F4F6),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: badge.color,
                      ),
                      child: Icon(
                        badge.icon,
                        size: 20,
                        color: badge.unlocked ? Colors.white : Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    badge.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 6.5,
                      fontWeight: FontWeight.w500,
                      color: OnboardingColors.textMuted,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _MiniStatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
      decoration: BoxDecoration(
        color: OnboardingColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: OnboardingColors.borderLight.withValues(alpha: 0.6)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 11, color: iconColor),
              const SizedBox(width: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: OnboardingColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 6.2,
              color: OnboardingColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniChartBar extends StatelessWidget {
  final double height;
  final Color color;
  final bool highlighted;

  const _MiniChartBar({
    required this.height,
    required this.color,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (highlighted) ...[
          const _MiniMoodFace(color: OnboardingColors.moodOrange, mood: 1, size: 14),
          const SizedBox(height: 2),
        ],
        Container(
          width: 12,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
        ),
      ],
    );
  }
}

class _MiniActivityChip extends StatelessWidget {
  final String label;
  final Color dotColor;

  const _MiniActivityChip({
    required this.label,
    required this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: OnboardingColors.backgroundLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: OnboardingColors.borderLight.withValues(alpha: 0.7)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize: 6.8,
              fontWeight: FontWeight.w500,
              color: OnboardingColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom-painted expressive mood emoji circle matching the walkthrough mockup.
class _MiniMoodFace extends StatelessWidget {
  final Color color;
  final int mood; // 0 = angry/bad, 1 = sad, 2 = neutral, 3 = happy, 4 = great
  final double size;

  const _MiniMoodFace({
    required this.color,
    required this.mood,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _MiniMoodFacePainter(color: color, mood: mood),
      ),
    );
  }
}

class _MiniMoodFacePainter extends CustomPainter {
  final Color color;
  final int mood;

  _MiniMoodFacePainter({required this.color, required this.mood});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Face circle
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = color
        ..isAntiAlias = true,
    );

    final featureColor = const Color(0xFF2B2B2B);
    final eyePaint = Paint()
      ..color = featureColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final eyeR = radius * 0.12;
    final eyeY = center.dy - radius * 0.16;
    canvas.drawCircle(Offset(center.dx - radius * 0.30, eyeY), eyeR, eyePaint);
    canvas.drawCircle(Offset(center.dx + radius * 0.30, eyeY), eyeR, eyePaint);

    final mouthPaint = Paint()
      ..color = featureColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.13
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final path = Path();
    if (mood == 0) {
      // Deep frown
      path.moveTo(center.dx - radius * 0.34, center.dy + radius * 0.38);
      path.quadraticBezierTo(
        center.dx,
        center.dy + radius * 0.08,
        center.dx + radius * 0.34,
        center.dy + radius * 0.38,
      );
    } else if (mood == 1) {
      // Slight frown
      path.moveTo(center.dx - radius * 0.30, center.dy + radius * 0.32);
      path.quadraticBezierTo(
        center.dx,
        center.dy + radius * 0.16,
        center.dx + radius * 0.30,
        center.dy + radius * 0.32,
      );
    } else if (mood == 2) {
      // Neutral line
      path.moveTo(center.dx - radius * 0.28, center.dy + radius * 0.26);
      path.lineTo(center.dx + radius * 0.28, center.dy + radius * 0.26);
    } else if (mood == 3) {
      // Gentle smile
      path.moveTo(center.dx - radius * 0.30, center.dy + radius * 0.20);
      path.quadraticBezierTo(
        center.dx,
        center.dy + radius * 0.42,
        center.dx + radius * 0.30,
        center.dy + radius * 0.20,
      );
    } else {
      // Big smile
      path.moveTo(center.dx - radius * 0.36, center.dy + radius * 0.16);
      path.quadraticBezierTo(
        center.dx,
        center.dy + radius * 0.52,
        center.dx + radius * 0.36,
        center.dy + radius * 0.16,
      );
    }
    canvas.drawPath(path, mouthPaint);
  }

  @override
  bool shouldRepaint(covariant _MiniMoodFacePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.mood != mood;
  }
}
