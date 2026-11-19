import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../onboarding/presentation/theme/onboarding_colors.dart';

/// Interactive semicircular 5-segment mood gauge dial matching 27_Light - 31_Light.
/// Supports tapping or dragging across the arc to pick mood levels 0..4.
class MoodGaugeDial extends StatelessWidget {
  final int selectedMood; // 0..4
  final List<Color> paletteColors;
  final ValueChanged<int> onMoodSelected;

  const MoodGaugeDial({
    super.key,
    required this.selectedMood,
    required this.paletteColors,
    required this.onMoodSelected,
  });

  void _handleTouch(Offset localPos, Size size) {
    final center = Offset(size.width / 2, size.height - 20);
    final dx = localPos.dx - center.dx;
    final dy = localPos.dy - center.dy;

    // Angle from left (pi) clockwise to right (0)
    double angle = math.atan2(-dy, -dx); // 0 on left, pi on right
    angle = angle.clamp(0.0, math.pi);
    final index = ((angle / math.pi) * 5).floor().clamp(0, 4);
    if (index != selectedMood) {
      onMoodSelected(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Needle angle: -72°, -36°, 0°, +36°, +72° from straight up
    final targetRadians = (-0.4 + selectedMood * 0.2) * math.pi;

    return SizedBox(
      width: 290,
      height: 168,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          return GestureDetector(
            onTapDown: (d) => _handleTouch(d.localPosition, size),
            onPanUpdate: (d) => _handleTouch(d.localPosition, size),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(end: targetRadians),
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              builder: (context, needleAngle, _) {
                return CustomPaint(
                  size: size,
                  painter: _MoodGaugePainter(
                    paletteColors: paletteColors,
                    selectedMood: selectedMood,
                    needleAngle: needleAngle,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _MoodGaugePainter extends CustomPainter {
  final List<Color> paletteColors;
  final int selectedMood;
  final double needleAngle; // radians relative to 12 o'clock (-pi/2..+pi/2)

  const _MoodGaugePainter({
    required this.paletteColors,
    required this.selectedMood,
    required this.needleAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 22);
    final outerRadius = math.min(size.width / 2 - 8, size.height - 28);
    const bandWidth = 48.0;
    final midRadius = outerRadius - bandWidth / 2;
    final arcRect = Rect.fromCircle(center: center, radius: midRadius);

    const segmentCount = 5;
    const gapRadians = 0.025;
    final segmentSweep = (math.pi - gapRadians * (segmentCount - 1)) / segmentCount;

    // 1. Draw the 5 colored arc segments + tiny white mood faces inside each
    for (int i = 0; i < segmentCount; i++) {
      final startAngle = math.pi + i * (segmentSweep + gapRadians);
      final paint = Paint()
        ..color = paletteColors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = bandWidth
        ..strokeCap = StrokeCap.butt
        ..isAntiAlias = true;

      canvas.drawArc(arcRect, startAngle, segmentSweep, false, paint);

      // Center point of this segment to draw a mini white-outlined face
      final midAngle = startAngle + segmentSweep / 2;
      final faceCenter = Offset(
        center.dx + midRadius * math.cos(midAngle),
        center.dy + midRadius * math.sin(midAngle),
      );
      _drawMiniWhiteFace(canvas, faceCenter, 12.5, i);
    }

    // 2. Draw rotating tapered dark needle
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(needleAngle);

    final needleLength = midRadius - 12;
    final needlePath = Path()
      ..moveTo(-6.5, 0)
      ..lineTo(-2.0, -needleLength)
      ..quadraticBezierTo(0, -needleLength - 4, 2.0, -needleLength)
      ..lineTo(6.5, 0)
      ..close();

    canvas.drawPath(
      needlePath,
      Paint()
        ..color = OnboardingColors.deviceBezel
        ..isAntiAlias = true,
    );
    canvas.restore();

    // 3. Center pivot cap
    canvas.drawCircle(
      center,
      16,
      Paint()
        ..color = const Color(0xFFBDBDBD)
        ..isAntiAlias = true,
    );
    canvas.drawCircle(
      center,
      16,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..isAntiAlias = true,
    );
  }

  void _drawMiniWhiteFace(
    Canvas canvas,
    Offset center,
    double r,
    int mood,
  ) {
    final stroke = Paint()
      ..color = Colors.white.withValues(alpha: 0.92)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final fill = Paint()
      ..color = Colors.white.withValues(alpha: 0.92)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawCircle(center, r, stroke);
    canvas.drawCircle(
      Offset(center.dx - r * 0.30, center.dy - r * 0.16),
      r * 0.12,
      fill,
    );
    canvas.drawCircle(
      Offset(center.dx + r * 0.30, center.dy - r * 0.16),
      r * 0.12,
      fill,
    );

    final mouth = Path();
    if (mood == 0) {
      mouth.moveTo(center.dx - r * 0.34, center.dy + r * 0.40);
      mouth.quadraticBezierTo(
        center.dx,
        center.dy + r * 0.10,
        center.dx + r * 0.34,
        center.dy + r * 0.40,
      );
    } else if (mood == 1) {
      mouth.moveTo(center.dx - r * 0.30, center.dy + r * 0.34);
      mouth.quadraticBezierTo(
        center.dx,
        center.dy + r * 0.18,
        center.dx + r * 0.30,
        center.dy + r * 0.34,
      );
    } else if (mood == 2) {
      mouth.moveTo(center.dx - r * 0.28, center.dy + r * 0.26);
      mouth.lineTo(center.dx + r * 0.28, center.dy + r * 0.26);
    } else if (mood == 3) {
      mouth.moveTo(center.dx - r * 0.30, center.dy + r * 0.18);
      mouth.quadraticBezierTo(
        center.dx,
        center.dy + r * 0.44,
        center.dx + r * 0.30,
        center.dy + r * 0.18,
      );
    } else {
      mouth.moveTo(center.dx - r * 0.36, center.dy + r * 0.14);
      mouth.quadraticBezierTo(
        center.dx,
        center.dy + r * 0.52,
        center.dx + r * 0.36,
        center.dy + r * 0.14,
      );
    }
    canvas.drawPath(mouth, stroke);
  }

  @override
  bool shouldRepaint(covariant _MoodGaugePainter oldDelegate) {
    return oldDelegate.selectedMood != selectedMood ||
        oldDelegate.needleAngle != needleAngle ||
        oldDelegate.paletteColors != paletteColors;
  }
}
