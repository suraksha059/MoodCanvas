import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/onboarding_colors.dart';

/// Peeling-sticker smiley logo used on the Splash, Walkthrough mini-header,
/// and Welcome screens.
class MoodStickerLogo extends StatelessWidget {
  final double size;

  /// When true, renders a white circle with green face details (for green bg).
  /// When false, renders a green circle with white face details (for white bg).
  final bool inverted;

  const MoodStickerLogo({
    super.key,
    this.size = 84,
    this.inverted = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _MoodStickerPainter(
          circleColor:
              inverted ? OnboardingColors.white : OnboardingColors.primaryGreen,
          detailColor:
              inverted ? OnboardingColors.primaryGreen : OnboardingColors.white,
        ),
      ),
    );
  }
}

class _MoodStickerPainter extends CustomPainter {
  final Color circleColor;
  final Color detailColor;

  _MoodStickerPainter({
    required this.circleColor,
    required this.detailColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final radius = math.min(w, h) / 2;
    final center = Offset(w / 2, h / 2);

    // Build main circle clipped with a peeled bottom-right corner
    final peelStartAngle = 0.04 * math.pi; // right side slightly below equator
    final peelEndAngle = 0.48 * math.pi; // bottom slightly right of center

    final pRight = Offset(
      center.dx + radius * math.cos(peelStartAngle),
      center.dy + radius * math.sin(peelStartAngle),
    );
    final pBottom = Offset(
      center.dx + radius * math.cos(peelEndAngle),
      center.dy + radius * math.sin(peelEndAngle),
    );

    // Clip path for the main sticker body (circle minus peeled corner)
    final bodyPath = Path()
      ..moveTo(pBottom.dx, pBottom.dy)
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius),
        peelEndAngle,
        2 * math.pi - (peelEndAngle - peelStartAngle),
        false,
      )
      ..quadraticBezierTo(
        center.dx + radius * 0.14,
        center.dy + radius * 0.14,
        pBottom.dx,
        pBottom.dy,
      )
      ..close();

    final bodyPaint = Paint()
      ..color = circleColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawPath(bodyPath, bodyPaint);

    // Draw the folded-up peel flap on top of the body
    final flapTip = Offset(
      center.dx + radius * 0.14,
      center.dy + radius * 0.16,
    );
    final flapPath = Path()
      ..moveTo(pRight.dx, pRight.dy)
      ..quadraticBezierTo(
        center.dx + radius * 0.48,
        center.dy + radius * 0.04,
        flapTip.dx,
        flapTip.dy,
      )
      ..quadraticBezierTo(
        center.dx + radius * 0.04,
        center.dy + radius * 0.50,
        pBottom.dx,
        pBottom.dy,
      )
      ..quadraticBezierTo(
        center.dx + radius * 0.62,
        center.dy + radius * 0.62,
        pRight.dx,
        pRight.dy,
      )
      ..close();

    // Subtle cutout stroke around the peel flap so it reads crisply
    final strokePaint = Paint()
      ..color = detailColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.11
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    canvas.drawPath(flapPath, bodyPaint);
    canvas.drawPath(flapPath, strokePaint);

    // Draw cute eyes (two small circles tilted slightly)
    final eyePaint = Paint()
      ..color = detailColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final eyeRadius = radius * 0.095;
    canvas.drawCircle(
      Offset(center.dx - radius * 0.30, center.dy - radius * 0.16),
      eyeRadius,
      eyePaint,
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.18, center.dy - radius * 0.24),
      eyeRadius,
      eyePaint,
    );

    // Draw smile arc
    final smilePaint = Paint()
      ..color = detailColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.11
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final smilePath = Path()
      ..moveTo(center.dx - radius * 0.34, center.dy + radius * 0.05)
      ..quadraticBezierTo(
        center.dx - radius * 0.06,
        center.dy + radius * 0.24,
        center.dx + radius * 0.18,
        center.dy - radius * 0.02,
      );

    canvas.drawPath(smilePath, smilePaint);
  }

  @override
  bool shouldRepaint(covariant _MoodStickerPainter oldDelegate) {
    return oldDelegate.circleColor != circleColor ||
        oldDelegate.detailColor != detailColor;
  }
}
