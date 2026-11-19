import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Calming, ambient visuals for MoodCanvas onboarding pages.
/// Driven by soft, slow breathing curves that evoke stillness and reflection.
class ArtisticCanvasVisual extends StatefulWidget {
  final int pageIndex;

  const ArtisticCanvasVisual({
    super.key,
    required this.pageIndex,
  });

  @override
  State<ArtisticCanvasVisual> createState() => _ArtisticCanvasVisualState();
}

class _ArtisticCanvasVisualState extends State<ArtisticCanvasVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _breathAnimation;

  @override
  void initState() {
    super.initState();
    // 7-second gentle inhale/exhale meditative breath cycle
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 7000),
    )..repeat(reverse: true);

    _breathAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _breathAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(280, 280),
          painter: _CalmVisualPainter(
            pageIndex: widget.pageIndex,
            progress: _breathAnimation.value,
          ),
        );
      },
    );
  }
}

class _CalmVisualPainter extends CustomPainter {
  final int pageIndex;
  final double progress;

  _CalmVisualPainter({
    required this.pageIndex,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    switch (pageIndex) {
      case 0:
        _paintBreathingHearth(canvas, size, center);
        break;
      case 1:
        _paintSerenityRipples(canvas, size, center);
        break;
      case 2:
      default:
        _paintConstellationSanctuary(canvas, size, center);
        break;
    }
  }

  /// Page 1: The Breathing Hearth (A quiet sanctuary to pause and breathe)
  void _paintBreathingHearth(Canvas canvas, Size size, Offset center) {
    final t = progress * 2 * math.pi;

    // Atmospheric wide soft glow
    final bgGlowRadius = size.width * (0.46 + progress * 0.08);
    final bgGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.amberWarmth.withValues(alpha: 0.16 + progress * 0.06),
          AppColors.roseDusk.withValues(alpha: 0.08 + progress * 0.04),
          Colors.transparent,
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: bgGlowRadius));
    canvas.drawCircle(center, bgGlowRadius, bgGlow);

    // Warm Amber drifting orb (soft, organic)
    final orb1Center = Offset(
      center.dx + math.sin(t) * 12,
      center.dy + math.cos(t) * 8 - 14,
    );
    final orb1Radius = 74 + progress * 12;
    final orb1Paint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.amberWarmth.withValues(alpha: 0.68),
          AppColors.amberWarmth.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: orb1Center, radius: orb1Radius));
    canvas.drawCircle(orb1Center, orb1Radius, orb1Paint);

    // Rose Dusk counter-drifting orb
    final orb2Center = Offset(
      center.dx - math.cos(t) * 14 + 16,
      center.dy + math.sin(t) * 10 + 14,
    );
    final orb2Radius = 80 + (1 - progress) * 10;
    final orb2Paint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.roseDusk.withValues(alpha: 0.62),
          AppColors.roseDusk.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: orb2Center, radius: orb2Radius));
    canvas.drawCircle(orb2Center, orb2Radius, orb2Paint);

    // Violet Twilight depth orb
    final orb3Center = Offset(
      center.dx + math.cos(t * 0.8) * 10 - 20,
      center.dy - math.sin(t * 0.8) * 10 + 8,
    );
    final orb3Paint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.violetTwilight.withValues(alpha: 0.55),
          AppColors.violetTwilight.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: orb3Center, radius: 64));
    canvas.drawCircle(orb3Center, 64, orb3Paint);

    // Gentle central pulse spark (meditative center)
    final sparkPaint = Paint()
      ..color = AppColors.textPrimary.withValues(alpha: 0.28 + progress * 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);
    canvas.drawCircle(center, 18 + progress * 6, sparkPaint);

    // Faint golden ring expanding with breath
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = AppColors.amberWarmth.withValues(alpha: 0.25 + progress * 0.2);
    canvas.drawCircle(center, 65 + progress * 16, ringPaint);
  }

  /// Page 2: Serenity Ripples (Listen to what you need & find balance)
  void _paintSerenityRipples(Canvas canvas, Size size, Offset center) {
    final t = progress * 2 * math.pi;

    // Atmospheric calm backdrop
    final backdrop = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.sageSerenity.withValues(alpha: 0.16 + progress * 0.04),
          AppColors.mistBlue.withValues(alpha: 0.08),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: size.width * 0.5));
    canvas.drawCircle(center, size.width * 0.5, backdrop);

    // Three gentle concentric water ripples expanding outward
    final rippleRadii = [
      48.0 + progress * 16,
      78.0 + progress * 20,
      108.0 + progress * 22,
    ];

    for (int i = 0; i < rippleRadii.length; i++) {
      final r = rippleRadii[i];
      final alpha = (0.45 - (i * 0.12) + (math.sin(t + i) * 0.08)).clamp(0.08, 0.6);
      final ripplePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..shader = SweepGradient(
          colors: [
            AppColors.sageSerenity.withValues(alpha: alpha),
            AppColors.amberWarmth.withValues(alpha: alpha * 0.7),
            AppColors.sageSerenity.withValues(alpha: alpha),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: r));

      canvas.drawCircle(center, r, ripplePaint);
    }

    // Central nurturing seed node
    final coreGradient = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.sageSerenity.withValues(alpha: 0.85),
          AppColors.sageSerenity.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: 36));
    canvas.drawCircle(center, 36 + progress * 4, coreGradient);

    final innerCore = Paint()
      ..color = AppColors.amberWarmth.withValues(alpha: 0.8)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(center, 9 + math.sin(t) * 2, innerCore);

    // Subtle drifting light motes floating in calm orbit
    const moteCount = 6;
    for (int i = 0; i < moteCount; i++) {
      final angle = (i * (math.pi * 2 / moteCount)) + (progress * 0.5);
      final dist = 60.0 + (i % 2 == 0 ? 18 : -12) + math.sin(t + i) * 6;
      final px = center.dx + math.cos(angle) * dist;
      final py = center.dy + math.sin(angle) * dist;

      final motePaint = Paint()
        ..color = (i.isEven ? AppColors.sageSerenity : AppColors.amberWarmth)
            .withValues(alpha: 0.65 + math.sin(t + i) * 0.25);
      canvas.drawCircle(Offset(px, py), 2.8, motePaint);
    }
  }

  /// Page 3: Constellation of Sanctuary (Memories preserved safely & privately)
  void _paintConstellationSanctuary(Canvas canvas, Size size, Offset center) {
    final t = progress * 2 * math.pi;

    // Deep dusk warm horizon glow
    final horizonGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.roseDusk.withValues(alpha: 0.18 + progress * 0.05),
          AppColors.amberWarmth.withValues(alpha: 0.09 + progress * 0.03),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: size.width * 0.5));
    canvas.drawCircle(center, size.width * 0.5, horizonGlow);

    // Delicate memory constellation nodes (7 calm stars representing days/moments)
    final baseNodes = [
      Offset(center.dx - 65, center.dy - 35),
      Offset(center.dx - 25, center.dy - 65),
      Offset(center.dx + 35, center.dy - 55),
      Offset(center.dx + 70, center.dy - 15),
      Offset(center.dx + 45, center.dy + 40),
      Offset(center.dx - 15, center.dy + 55),
      Offset(center.dx - 55, center.dy + 25),
    ];

    // Compute gently undulating node positions
    final activeNodes = <Offset>[];
    for (int i = 0; i < baseNodes.length; i++) {
      final bn = baseNodes[i];
      final dy = bn.dy + math.sin(t + (i * 0.9)) * 4.5;
      final dx = bn.dx + math.cos(t + (i * 0.9)) * 3.5;
      activeNodes.add(Offset(dx, dy));
    }

    // Draw delicate connecting starlight threads
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..color = AppColors.borderSubtle.withValues(alpha: 0.25 + progress * 0.15);

    final path = Path()..moveTo(activeNodes[0].dx, activeNodes[0].dy);
    for (int i = 1; i < activeNodes.length; i++) {
      path.lineTo(activeNodes[i].dx, activeNodes[i].dy);
    }
    path.close();
    canvas.drawPath(path, linePaint);

    // Cross-connecting soft harmony threads
    canvas.drawLine(activeNodes[1], activeNodes[5], linePaint);
    canvas.drawLine(activeNodes[2], activeNodes[6], linePaint);

    // Central sanctuary sanctuary glow (safe harbor)
    final sanctuaryCore = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.amberWarmth.withValues(alpha: 0.45 + progress * 0.2),
          AppColors.amberWarmth.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: 45));
    canvas.drawCircle(center, 45, sanctuaryCore);

    final innerSanctuary = Paint()
      ..color = AppColors.roseDusk.withValues(alpha: 0.7)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(center, 12 + math.sin(t) * 2, innerSanctuary);

    // Draw glowing constellation memory stars
    for (int i = 0; i < activeNodes.length; i++) {
      final node = activeNodes[i];
      final nodeColor = (i % 3 == 0)
          ? AppColors.amberWarmth
          : (i % 3 == 1 ? AppColors.roseDusk : AppColors.sageSerenity);

      // Outer glow
      final haloPaint = Paint()
        ..color = nodeColor.withValues(alpha: 0.35 + math.sin(t + i) * 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(node, 7, haloPaint);

      // Bright starlight core
      final dotPaint = Paint()..color = AppColors.textPrimary;
      canvas.drawCircle(node, 2.6, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CalmVisualPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.pageIndex != pageIndex;
  }
}
