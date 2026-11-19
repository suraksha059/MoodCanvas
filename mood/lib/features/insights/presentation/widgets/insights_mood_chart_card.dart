import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../home/presentation/widgets/mood_log_card.dart';
import '../../../onboarding/presentation/theme/onboarding_colors.dart';

/// Interactive Mood Chart card supporting all 3 visual modes from
/// 50_Light_insights (Bar), 51_Light_insights (Line/Area), and 52_Light_insights (Dots).
class InsightsMoodChartCard extends StatefulWidget {
  final List<Color> paletteColors;

  const InsightsMoodChartCard({
    super.key,
    required this.paletteColors,
  });

  @override
  State<InsightsMoodChartCard> createState() => _InsightsMoodChartCardState();
}

class _InsightsMoodChartCardState extends State<InsightsMoodChartCard> {
  int _chartType = 0; // 0 = Bar, 1 = Line, 2 = Scatter Dots
  int _periodIndex = 0; // 0 = Weekly, 1 = Monthly, 2 = Yearly, 3 = Lifetime
  int _selectedDayIndex = 1; // Highlights day 17 by default

  static const _periods = ['Weekly', 'Monthly', 'Yearly', 'Lifetime'];
  static const _dateLabels = [
    'Dec 16 - Dec 22, 2024',
    'December 2024',
    '2024',
    'All Time',
  ];

  // 7 data points (0..4 mood level) for each period
  static const _seriesByPeriod = [
    [3, 1, 0, 4, 3, 2, 3], // Weekly
    [2, 3, 3, 4, 2, 3, 4], // Monthly
    [3, 2, 4, 3, 1, 3, 4], // Yearly
    [3, 3, 2, 4, 3, 3, 4], // Lifetime
  ];

  static const _xLabelsByPeriod = [
    ['16', '17', '18', '19', '20', '21', '22'],
    ['W1', 'W2', 'W3', 'W4', 'W5', 'W6', 'W7'],
    ['J', 'M', 'M', 'J', 'S', 'N', 'D'],
    ['19', '20', '21', '22', '23', '24', '25'],
  ];

  @override
  Widget build(BuildContext context) {
    final values = _seriesByPeriod[_periodIndex];
    final xLabels = _xLabelsByPeriod[_periodIndex];

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
          // Header: "Mood Chart" + 3 Chart Mode Toggles
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mood Chart',
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
                    _ChartModeButton(
                      icon: Icons.bar_chart_rounded,
                      selected: _chartType == 0,
                      onTap: () => setState(() => _chartType = 0),
                    ),
                    _ChartModeButton(
                      icon: Icons.show_chart_rounded,
                      selected: _chartType == 1,
                      onTap: () => setState(() => _chartType = 1),
                    ),
                    _ChartModeButton(
                      icon: Icons.scatter_plot_rounded,
                      selected: _chartType == 2,
                      onTap: () => setState(() => _chartType = 2),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Period Segmented Bar: Weekly | Monthly | Yearly | Lifetime
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

          const SizedBox(height: 12),

          // Date Range Selector
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
                _dateLabels[_periodIndex],
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

          // Chart Area with Y-axis Mood Faces + Active Visualization
          SizedBox(
            height: 196,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left Y-Axis: 5 Mood Faces (Great -> Awful)
                Padding(
                  padding: const EdgeInsets.only(bottom: 22),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [4, 3, 2, 1, 0].map((level) {
                      return HomeMoodFace(
                        color: widget.paletteColors[level],
                        moodLevel: level,
                        size: 24,
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 12),

                // Right Plot Area
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: _chartType == 0
                            ? _buildBarPlot(values)
                            : _chartType == 1
                                ? _buildLinePlot(values)
                                : _buildScatterPlot(values),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(xLabels.length, (i) {
                          final isSelected = i == _selectedDayIndex;
                          return Text(
                            xLabels[i],
                            style: AppTypography.label.copyWith(
                              fontSize: 11,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? OnboardingColors.primaryGreen
                                  : OnboardingColors.textLight,
                            ),
                          );
                        }),
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

  /// Mode 0 (50_Light_insights): Vertical rounded bars with mood pin above selected bar.
  Widget _buildBarPlot(List<int> values) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxH = constraints.maxHeight;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(values.length, (i) {
            final level = values[i];
            final heightFactor = (level + 1) / 5.2;
            final barH = (maxH * heightFactor).clamp(18.0, maxH - 4);
            final color = widget.paletteColors[level];
            final isSelected = i == _selectedDayIndex;

            return GestureDetector(
              onTap: () => setState(() => _selectedDayIndex = i),
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 30,
                height: maxH,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isSelected) ...[
                      _MoodPinBadge(color: color, moodLevel: level),
                      const SizedBox(height: 4),
                    ],
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOutCubic,
                      width: 22,
                      height: isSelected ? (barH - 34).clamp(16.0, maxH) : barH,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(11),
                          bottom: Radius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  /// Mode 1 (51_Light_insights): Smooth green line chart with gradient fill and pin.
  Widget _buildLinePlot(List<int> values) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTapDown: (details) {
            final stepW = constraints.maxWidth / values.length;
            final idx =
                (details.localPosition.dx / stepW).floor().clamp(0, values.length - 1);
            setState(() => _selectedDayIndex = idx);
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: _LineChartPainter(values: values),
              ),
              // Floating mood pin on the selected point
              Builder(
                builder: (context) {
                  final stepW = constraints.maxWidth / values.length;
                  final cx = stepW * _selectedDayIndex + stepW / 2;
                  final level = values[_selectedDayIndex];
                  final cy = constraints.maxHeight -
                      ((level + 0.5) / 5.0) * constraints.maxHeight;
                  return Positioned(
                    left: cx - 15,
                    top: (cy - 34).clamp(0.0, constraints.maxHeight - 30),
                    child: _MoodPinBadge(
                      color: widget.paletteColors[level],
                      moodLevel: level,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Mode 2 (52_Light_insights): Colored scatter dots on subtle grid.
  Widget _buildScatterPlot(List<int> values) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _ScatterPlotPainter(
            values: values,
            paletteColors: widget.paletteColors,
          ),
        );
      },
    );
  }
}

class _ChartModeButton extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ChartModeButton({
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

/// Teardrop mood-face pin indicator shown above the active day in Mood Chart.
class _MoodPinBadge extends StatelessWidget {
  final Color color;
  final int moodLevel;

  const _MoodPinBadge({
    required this.color,
    required this.moodLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        color: OnboardingColors.primaryGreen,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: OnboardingColors.primaryGreen.withValues(alpha: 0.35),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: HomeMoodFace(color: color, moodLevel: moodLevel, size: 22),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<int> values;

  const _LineChartPainter({required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    // Subtle horizontal grid lines
    final gridPaint = Paint()
      ..color = const Color(0xFFF0F1F3)
      ..strokeWidth = 1;
    for (int i = 0; i < 5; i++) {
      final y = size.height * (i + 0.5) / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final stepW = size.width / values.length;
    final points = List.generate(values.length, (i) {
      final x = stepW * i + stepW / 2;
      final y = size.height - ((values[i] + 0.5) / 5.0) * size.height;
      return Offset(x, y);
    });

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }

    // Soft green vertical gradient fill underneath line
    final areaPath = Path.from(linePath)
      ..lineTo(points.last.dx, size.height)
      ..lineTo(points.first.dx, size.height)
      ..close();

    canvas.drawPath(
      areaPath,
      Paint()
        ..shader = LinearGradient(
          colors: [
            OnboardingColors.primaryGreen.withValues(alpha: 0.24),
            OnboardingColors.primaryGreen.withValues(alpha: 0.0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Offset.zero & size),
    );

    // Line stroke
    canvas.drawPath(
      linePath,
      Paint()
        ..color = OnboardingColors.primaryGreen
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeJoin = StrokeJoin.round
        ..isAntiAlias = true,
    );

    // White-centered green-bordered nodes
    for (final p in points) {
      canvas.drawCircle(p, 5.0, Paint()..color = Colors.white);
      canvas.drawCircle(
        p,
        5.0,
        Paint()
          ..color = OnboardingColors.primaryGreen
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) =>
      oldDelegate.values != values;
}

class _ScatterPlotPainter extends CustomPainter {
  final List<int> values;
  final List<Color> paletteColors;

  const _ScatterPlotPainter({
    required this.values,
    required this.paletteColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFF0F1F3)
      ..strokeWidth = 1;
    for (int i = 0; i < 5; i++) {
      final y = size.height * (i + 0.5) / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final stepW = size.width / values.length;
    for (int i = 0; i < values.length; i++) {
      final level = values[i];
      final x = stepW * i + stepW / 2;
      final y = size.height - ((level + 0.5) / 5.0) * size.height;

      canvas.drawCircle(
        Offset(x, y),
        10.5,
        Paint()
          ..color = paletteColors[level]
          ..isAntiAlias = true,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ScatterPlotPainter oldDelegate) =>
      oldDelegate.values != values ||
      oldDelegate.paletteColors != paletteColors;
}
