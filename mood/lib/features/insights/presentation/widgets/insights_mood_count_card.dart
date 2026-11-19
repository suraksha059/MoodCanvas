import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../home/presentation/widgets/mood_log_card.dart';
import '../../../onboarding/presentation/theme/onboarding_colors.dart';

/// Interactive Mood Count card supporting all 3 visual modes from
/// 50_Light_insights (Semicircle Gauge), 51_Light_insights (Pentagon Radar),
/// and 52_Light_insights (Concentric Rings).
class InsightsMoodCountCard extends StatefulWidget {
  final List<Color> paletteColors;
  final List<int> moodCounts; // [Awful, Bad, Okay, Good, Great]

  const InsightsMoodCountCard({
    super.key,
    required this.paletteColors,
    required this.moodCounts,
  });

  @override
  State<InsightsMoodCountCard> createState() => _InsightsMoodCountCardState();
}

class _InsightsMoodCountCardState extends State<InsightsMoodCountCard> {
  int _viewType = 0; // 0 = Semicircle Gauge, 1 = Radar, 2 = Concentric Rings
  int _periodIndex = 2; // Yearly active by default

  static const _periods = ['Weekly', 'Monthly', 'Yearly', 'Lifetime'];
  static const _rangeLabels = ['Dec 16 - 22', 'Dec 2024', '2024', 'All Time'];

  @override
  Widget build(BuildContext context) {
    final total = widget.moodCounts.fold<int>(0, (sum, c) => sum + c);

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: "Mood Count" + 3 View Mode Toggles
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mood Count',
                style: AppTypography.titleLarge.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: OnboardingColors.textDark,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: OnboardingColors.backgroundLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _CountModeBtn(
                      icon: Icons.speed_rounded,
                      selected: _viewType == 0,
                      onTap: () => setState(() => _viewType = 0),
                    ),
                    _CountModeBtn(
                      icon: Icons.hexagon_outlined,
                      selected: _viewType == 1,
                      onTap: () => setState(() => _viewType = 1),
                    ),
                    _CountModeBtn(
                      icon: Icons.donut_large_rounded,
                      selected: _viewType == 2,
                      onTap: () => setState(() => _viewType = 2),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Period Tabs
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: OnboardingColors.backgroundLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: List.generate(_periods.length, (index) {
                final isSelected = _periodIndex == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _periodIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? OnboardingColors.primaryGreen
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _periods[index],
                        textAlign: TextAlign.center,
                        style: AppTypography.label.copyWith(
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : OnboardingColors.textMuted,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 10),

          // Year / Range Navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _periodIndex = (_periodIndex - 1 + _periods.length) %
                        _periods.length;
                  });
                },
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  size: 20,
                  color: OnboardingColors.textDark,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              ),
              Text(
                _rangeLabels[_periodIndex],
                style: AppTypography.titleMedium.copyWith(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: OnboardingColors.textDark,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _periodIndex = (_periodIndex + 1) % _periods.length;
                  });
                },
                icon: const Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: OnboardingColors.textDark,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Active Mood Count Visualization
          if (_viewType == 0)
            _buildSemiGaugeView(total)
          else if (_viewType == 1)
            _buildRadarView(total)
          else
            _buildConcentricRingsView(total),
        ],
      ),
    );
  }

  /// Mode 0 (50_Light_insights): Semicircle Gauge + 5 Mood Badges Row.
  Widget _buildSemiGaugeView(int total) {
    return Column(
      children: [
        SizedBox(
          height: 128,
          width: 240,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CustomPaint(
                size: const Size(240, 128),
                painter: _SemiGaugePainter(
                  counts: widget.moodCounts,
                  colors: widget.paletteColors,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Text(
                  '$total',
                  style: AppTypography.displayLarge.copyWith(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: OnboardingColors.textDark,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (i) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                HomeMoodFace(
                  color: widget.paletteColors[i],
                  moodLevel: i,
                  size: 40,
                ),
                Positioned(
                  top: -6,
                  right: -8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1.5,
                    ),
                    decoration: BoxDecoration(
                      color: widget.paletteColors[i],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Text(
                      '${widget.moodCounts[i]}',
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  /// Mode 1 (51_Light_insights): Pentagon Radar Chart.
  Widget _buildRadarView(int total) {
    // Vertex order clockwise from top: Great(4), Good(3), Okay(2), Bad(1), Awful(0)
    const vertexOrder = [4, 3, 2, 1, 0];
    final orderedCounts = vertexOrder.map((i) => widget.moodCounts[i]).toList();
    final maxCount = orderedCounts.fold<int>(1, (a, b) => a > b ? a : b);

    return SizedBox(
      height: 230,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cx = constraints.maxWidth / 2;
          final cy = constraints.maxHeight / 2 + 4;
          const webRadius = 74.0;
          const labelRadius = 100.0;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: _RadarChartPainter(
                  center: Offset(cx, cy),
                  radius: webRadius,
                  normalizedValues:
                      orderedCounts.map((c) => (c / maxCount).clamp(0.15, 1.0)).toList(),
                ),
              ),
              // Total centered inside radar web
              Positioned(
                left: cx - 32,
                top: cy - 12,
                width: 64,
                child: Text(
                  '$total',
                  textAlign: TextAlign.center,
                  style: AppTypography.titleLarge.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: OnboardingColors.textDark,
                  ),
                ),
              ),
              // 5 Mood Faces + Counts around the pentagon vertices
              ...List.generate(5, (idx) {
                final angle = -math.pi / 2 + idx * (2 * math.pi / 5);
                final lx = cx + labelRadius * math.cos(angle);
                final ly = cy + labelRadius * math.sin(angle);
                final moodIdx = vertexOrder[idx];
                return Positioned(
                  left: lx - 24,
                  top: ly - 22,
                  width: 48,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HomeMoodFace(
                        color: widget.paletteColors[moodIdx],
                        moodLevel: moodIdx,
                        size: 24,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${widget.moodCounts[moodIdx]}',
                        style: AppTypography.label.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: OnboardingColors.textDark,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  /// Mode 2 (52_Light_insights): Concentric Activity-style Rings with 12-o'clock labels.
  Widget _buildConcentricRingsView(int total) {
    const names = ['Bad', 'Not Good', 'Okay', 'Good', 'Great'];
    final maxCount = widget.moodCounts.fold<int>(1, (a, b) => a > b ? a : b);

    return SizedBox(
      height: 230,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(220, 220),
            painter: _ConcentricRingsPainter(
              counts: widget.moodCounts,
              maxCount: maxCount,
              colors: widget.paletteColors,
            ),
          ),
          // Center Total
          Text(
            '$total',
            style: AppTypography.titleLarge.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: OnboardingColors.textDark,
            ),
          ),
          // Top-left aligned legend next to the 12-o'clock start of each ring
          Positioned(
            top: 4,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [4, 3, 2, 1, 0].map((level) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 3.5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${names[level]} (${widget.moodCounts[level]})',
                        style: AppTypography.label.copyWith(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: OnboardingColors.textDark,
                        ),
                      ),
                      const SizedBox(width: 5),
                      HomeMoodFace(
                        color: widget.paletteColors[level],
                        moodLevel: level,
                        size: 13,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CountModeBtn extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _CountModeBtn({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? OnboardingColors.primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Icon(
          icon,
          size: 16,
          color: selected ? Colors.white : OnboardingColors.textLight,
        ),
      ),
    );
  }
}

class _SemiGaugePainter extends CustomPainter {
  final List<int> counts;
  final List<Color> colors;

  const _SemiGaugePainter({required this.counts, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final total = counts.fold<int>(0, (s, c) => s + c);
    if (total <= 0) return;

    const strokeW = 24.0;
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height - 6),
      radius: size.width / 2 - strokeW / 2,
    );

    double startAngle = math.pi;
    for (int i = 0; i < counts.length; i++) {
      final sweep = (counts[i] / total) * math.pi;
      if (sweep <= 0) continue;

      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeW
        ..strokeCap = StrokeCap.butt
        ..isAntiAlias = true;

      canvas.drawArc(rect, startAngle, sweep, false, paint);
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _SemiGaugePainter oldDelegate) =>
      oldDelegate.counts != counts || oldDelegate.colors != colors;
}

class _RadarChartPainter extends CustomPainter {
  final Offset center;
  final double radius;
  final List<double> normalizedValues;

  const _RadarChartPainter({
    required this.center,
    required this.radius,
    required this.normalizedValues,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final webPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // 4 concentric pentagons
    for (int ring = 1; ring <= 4; ring++) {
      final r = radius * (ring / 4);
      final path = Path();
      for (int i = 0; i < 5; i++) {
        final angle = -math.pi / 2 + i * (2 * math.pi / 5);
        final p = Offset(
          center.dx + r * math.cos(angle),
          center.dy + r * math.sin(angle),
        );
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      path.close();
      canvas.drawPath(path, webPaint);
    }

    // 5 radial spokes
    for (int i = 0; i < 5; i++) {
      final angle = -math.pi / 2 + i * (2 * math.pi / 5);
      canvas.drawLine(
        center,
        Offset(
          center.dx + radius * math.cos(angle),
          center.dy + radius * math.sin(angle),
        ),
        webPaint,
      );
    }

    // Filled green data polygon
    final dataPath = Path();
    for (int i = 0; i < 5; i++) {
      final angle = -math.pi / 2 + i * (2 * math.pi / 5);
      final r = radius * normalizedValues[i];
      final p = Offset(
        center.dx + r * math.cos(angle),
        center.dy + r * math.sin(angle),
      );
      if (i == 0) {
        dataPath.moveTo(p.dx, p.dy);
      } else {
        dataPath.lineTo(p.dx, p.dy);
      }
    }
    dataPath.close();

    canvas.drawPath(
      dataPath,
      Paint()
        ..color = OnboardingColors.primaryGreen.withValues(alpha: 0.28)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      dataPath,
      Paint()
        ..color = OnboardingColors.primaryGreen
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );
  }

  @override
  bool shouldRepaint(covariant _RadarChartPainter oldDelegate) =>
      oldDelegate.normalizedValues != normalizedValues;
}

class _ConcentricRingsPainter extends CustomPainter {
  final List<int> counts;
  final int maxCount;
  final List<Color> colors;

  const _ConcentricRingsPainter({
    required this.counts,
    required this.maxCount,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const strokeW = 10.5;
    const gap = 5.5;

    // Outermost ring = Great (4), innermost = Bad (0)
    for (int idx = 0; idx < 5; idx++) {
      final level = 4 - idx;
      final r = (size.width / 2 - strokeW / 2) - idx * (strokeW + gap);
      final rect = Rect.fromCircle(center: center, radius: r);

      // Background track (3/4 circle leaving top-left for legend)
      canvas.drawArc(
        rect,
        -math.pi / 2,
        1.5 * math.pi,
        false,
        Paint()
          ..color = const Color(0xFFF1F3F4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeW
          ..strokeCap = StrokeCap.round,
      );

      final frac = (counts[level] / maxCount).clamp(0.2, 1.0);
      canvas.drawArc(
        rect,
        -math.pi / 2,
        1.5 * math.pi * frac,
        false,
        Paint()
          ..color = colors[level]
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeW
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ConcentricRingsPainter oldDelegate) =>
      oldDelegate.counts != counts || oldDelegate.colors != colors;
}
