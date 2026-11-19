import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../domain/models/monthly_canvas_data.dart';

/// CustomPainter rendering an organic, animated celestial constellation of the user's month.
class MonthlyCanvasPainter extends CustomPainter {
  final MonthlyCanvasData data;
  final double animationProgress; // 0.0 to 1.0

  const MonthlyCanvasPainter({
    required this.data,
    required this.animationProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // 1. Deep cosmic base background
    final basePaint = Paint()..color = const Color(0xFF0C0D14);
    canvas.drawRect(rect, basePaint);

    if (!data.hasEntries) {
      _paintEmptyBackdrop(canvas, size);
      return;
    }

    // 2. Multi-chromatic background nebulae blended by actual mood distribution
    _paintNebulaBlooms(canvas, size);

    // 3. Connecting harmonic constellation threads between days
    _paintConstellationThreads(canvas, size);

    // 4. Day Nodes (Planetary emotional anchors)
    _paintDayNodes(canvas, size);
  }

  void _paintEmptyBackdrop(Canvas canvas, Size size) {
    final emptyPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.8,
        colors: [
          const Color(0xFF222533).withValues(alpha: 0.4),
          Colors.transparent,
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, emptyPaint);
  }

  void _paintNebulaBlooms(Canvas canvas, Size size) {
    int index = 0;
    for (final entry in data.moodDistribution.entries) {
      final mood = entry.key;
      final ratio = entry.value;

      // Position each bloom dynamically around the canvas
      final angle = (index / data.moodDistribution.length) * 2 * math.pi +
          animationProgress * 0.2;
      final bloomCenter = Offset(
        size.width * (0.5 + 0.28 * math.cos(angle)),
        size.height * (0.5 + 0.25 * math.sin(angle)),
      );

      final bloomPaint = Paint()
        ..shader = RadialGradient(
          center: Alignment.center,
          radius: 0.7,
          colors: [
            mood.primaryColor.withValues(alpha: 0.22 * ratio.clamp(0.2, 1.0)),
            mood.primaryColor.withValues(alpha: 0.06 * ratio.clamp(0.2, 1.0)),
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromCircle(
            center: bloomCenter,
            radius: size.width * (0.45 + 0.1 * ratio),
          ),
        );

      canvas.drawCircle(
        bloomCenter,
        size.width * (0.45 + 0.1 * ratio),
        bloomPaint,
      );
      index++;
    }
  }

  void _paintConstellationThreads(Canvas canvas, Size size) {
    if (data.nodes.length < 2) return;

    // Harmonic wave offset driven by breathing animation
    final waveOffset = math.sin(animationProgress * 2 * math.pi) * 8.0;

    final linePath = Path();
    final firstPoint = Offset(
      data.nodes.first.normalizedPosition.dx * size.width,
      data.nodes.first.normalizedPosition.dy * size.height,
    );
    linePath.moveTo(firstPoint.dx, firstPoint.dy);

    for (int i = 1; i < data.nodes.length; i++) {
      final prev = data.nodes[i - 1];
      final curr = data.nodes[i];

      final p0 = Offset(
        prev.normalizedPosition.dx * size.width,
        prev.normalizedPosition.dy * size.height,
      );
      final p1 = Offset(
        curr.normalizedPosition.dx * size.width,
        curr.normalizedPosition.dy * size.height,
      );

      // Smooth flowing cubic connection with breathing wave curvature
      final cp1 = Offset(
        p0.dx + (p1.dx - p0.dx) * 0.5,
        p0.dy + waveOffset,
      );
      final cp2 = Offset(
        p0.dx + (p1.dx - p0.dx) * 0.5,
        p1.dy - waveOffset,
      );

      linePath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p1.dx, p1.dy);
    }

    // Outer glow for thread
    final glowPaint = Paint()
      ..color = (data.dominantMoodType?.primaryColor ?? Colors.white)
          .withValues(alpha: 0.18)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawPath(linePath, glowPaint);

    // Inner fine luminous thread
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(linePath, linePaint);
  }

  void _paintDayNodes(Canvas canvas, Size size) {
    for (int i = 0; i < data.nodes.length; i++) {
      final node = data.nodes[i];
      final center = Offset(
        node.normalizedPosition.dx * size.width,
        node.normalizedPosition.dy * size.height,
      );

      // Node breathing oscillation
      final nodeFloat = math.sin(animationProgress * 2 * math.pi + i * 0.7);
      final baseRadius = 5.0 + (node.intensity / 10.0) * 5.0;
      final animatedRadius = baseRadius + nodeFloat * 1.0;

      // 1. Outer chromatic halo
      final haloPaint = Paint()
        ..color = node.mood.primaryColor.withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(center, animatedRadius * 2.2, haloPaint);

      // 2. Middle mood circle
      final middlePaint = Paint()
        ..color = node.mood.primaryColor.withValues(alpha: 0.85);
      canvas.drawCircle(center, animatedRadius, middlePaint);

      // 3. Bright core
      final corePaint = Paint()..color = Colors.white;
      canvas.drawCircle(center, animatedRadius * 0.45, corePaint);

      // 4. Micro day label
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${node.day}',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.85),
            fontSize: 9,
            fontWeight: FontWeight.w700,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.8),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(center.dx - textPainter.width / 2, center.dy + animatedRadius + 3),
      );
      textPainter.dispose();
    }
  }

  @override
  bool shouldRepaint(covariant MonthlyCanvasPainter oldDelegate) {
    return oldDelegate.animationProgress != animationProgress ||
        oldDelegate.data != data;
  }
}
