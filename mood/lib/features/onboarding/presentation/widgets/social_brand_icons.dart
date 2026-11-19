import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/onboarding_colors.dart';

/// Multicolor Google "G" mark.
class GoogleLogoIcon extends StatelessWidget {
  final double size;

  const GoogleLogoIcon({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  const _GoogleLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.42;
    final stroke = size.width * 0.19;
    final rect = Rect.fromCircle(center: center, radius: radius);

    Paint arcPaint(Color color) => Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt
      ..isAntiAlias = true;

    canvas.drawArc(rect, -0.15 * math.pi, 0.48 * math.pi, false, arcPaint(const Color(0xFF4285F4)));
    canvas.drawArc(rect, 0.33 * math.pi, 0.45 * math.pi, false, arcPaint(const Color(0xFF34A853)));
    canvas.drawArc(rect, 0.78 * math.pi, 0.42 * math.pi, false, arcPaint(const Color(0xFFFBBC05)));
    canvas.drawArc(rect, 1.20 * math.pi, 0.56 * math.pi, false, arcPaint(const Color(0xFFEA4335)));

    canvas.drawLine(
      Offset(center.dx, center.dy),
      Offset(center.dx + radius + stroke * 0.35, center.dy),
      arcPaint(const Color(0xFF4285F4)),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Crisp blue circular Facebook icon.
class FacebookLogoIcon extends StatelessWidget {
  final double size;

  const FacebookLogoIcon({super.key, this.size = 22});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFF1877F2),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        'f',
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.72,
          fontWeight: FontWeight.w800,
          height: 1.05,
        ),
      ),
    );
  }
}

/// Crisp X (Twitter) monogram icon.
class XLogoIcon extends StatelessWidget {
  final double size;

  const XLogoIcon({super.key, this.size = 18});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const CustomPaint(painter: _XLogoPainter()),
    );
  }
}

class _XLogoPainter extends CustomPainter {
  const _XLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final fillPaint = Paint()
      ..color = OnboardingColors.textDark
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final ribbon = Path()
      ..moveTo(w * 0.08, h * 0.06)
      ..lineTo(w * 0.34, h * 0.06)
      ..lineTo(w * 0.92, h * 0.94)
      ..lineTo(w * 0.66, h * 0.94)
      ..close();
    canvas.drawPath(ribbon, fillPaint);

    final strokePaint = Paint()
      ..color = OnboardingColors.textDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.13
      ..strokeCap = StrokeCap.square
      ..isAntiAlias = true;
    canvas.drawLine(Offset(w * 0.86, h * 0.10), Offset(w * 0.14, h * 0.90), strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
