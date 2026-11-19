import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../domain/models/canvas_artwork_data.dart';

/// High-performance CustomPainter rendering procedural emotional artworks.
/// Produces a living, museum-grade generative artwork composed of ethereal
/// fluid aurora waves, volumetric chromatic light blooms, silky light ribbons,
/// and luminous celestial poetry. Strictly free of crude wireframe doodles.
class MoodCanvasPainter extends CustomPainter {
  final CanvasArtworkData artwork;
  final double progress; // 0.0 to 1.0 ambient breathing

  // Cached paint objects to eliminate runtime allocations during 60fps painting
  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;
  final Paint _strokePaint = Paint()..style = PaintingStyle.stroke;

  MoodCanvasPainter({
    required this.artwork,
    this.progress = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final t = progress * 2 * math.pi;
    final shortest = size.shortestSide;

    canvas.save();
    canvas.clipRRect(RRect.fromRectAndRadius(rect, const Radius.circular(24)));

    // 1. Deep Atmospheric Gradient Foundation
    _fillPaint.shader = LinearGradient(
      begin: artwork.gradientBegin,
      end: artwork.gradientEnd,
      colors: artwork.gradientColors,
      stops: artwork.gradientStops,
    ).createShader(rect);
    canvas.drawRect(rect, _fillPaint);
    _fillPaint.shader = null;

    // 2. Multi-Layered Generative Aurora Waves (Living Fluid Light Currents)
    _drawFluidAuroraWaves(canvas, size, t);

    // 3. Volumetric Chromatic Light Blooms (Primary & Secondary Inner Light)
    _drawAtmosphericLightBlooms(canvas, size, t, shortest);

    // 4. Harmonic Ethereal Silk Ribbons (Flowing Light Streams)
    _drawSilkLightRibbons(canvas, size, t);

    // 5. Ambient Luminous Accents (Pure Optical Poetry, No Wireframes)
    _drawLuminousAccents(canvas, size, t, shortest);

    // 6. Celestial Stardust & Atmospheric Micro-Glow
    _drawCelestialStardust(canvas, size, t);

    // 7. Soft Film Vignette (Museum-Grade Framing)
    _fillPaint.shader = RadialGradient(
      colors: [
        Colors.transparent,
        Colors.black.withValues(alpha: 0.12),
        Colors.black.withValues(alpha: 0.42),
      ],
      stops: const [0.55, 0.82, 1.0],
    ).createShader(rect);
    canvas.drawRect(rect, _fillPaint);
    _fillPaint.shader = null;

    canvas.restore();
  }

  /// Layer 2: Draws 4 sweeping, organic liquid aurora wave currents that weave through each other.
  void _drawFluidAuroraWaves(Canvas canvas, Size size, double t) {
    if (artwork.gradientColors.length < 2) return;
    final primaryAccent = artwork.gradientColors[1];
    final secondaryAccent = artwork.gradientColors[0];
    final highlightAccent = artwork.gradientColors.length > 2
        ? artwork.gradientColors[2]
        : primaryAccent;

    // Wave Current 1: Lower sweeping tide
    final path1 = Path();
    final y1a = size.height * 0.42 + math.sin(t * 0.8) * 16;
    final y1b = size.height * 0.68 + math.cos(t * 0.6) * 18;

    path1.moveTo(-20, y1a);
    path1.cubicTo(
      size.width * 0.32,
      y1a - 40 + math.sin(t * 1.1) * 14,
      size.width * 0.68,
      y1b + 40 + math.cos(t * 1.1) * 14,
      size.width + 20,
      y1b,
    );
    path1.lineTo(size.width + 20, size.height + 20);
    path1.lineTo(-20, size.height + 20);
    path1.close();

    _fillPaint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        primaryAccent.withValues(alpha: 0.26),
        secondaryAccent.withValues(alpha: 0.12),
        Colors.transparent,
      ],
      stops: const [0.0, 0.52, 1.0],
    ).createShader(Offset.zero & size);
    canvas.drawPath(path1, _fillPaint);

    // Wave Current 2: Upper counter-balancing aurora crest
    final path2 = Path();
    final y2a = size.height * 0.58 + math.cos(t * 0.7) * 15;
    final y2b = size.height * 0.28 + math.sin(t * 0.9) * 16;

    path2.moveTo(-20, y2a);
    path2.cubicTo(
      size.width * 0.38,
      y2a + 35 + math.cos(t * 1.2) * 12,
      size.width * 0.62,
      y2b - 35 + math.sin(t * 1.2) * 12,
      size.width + 20,
      y2b,
    );
    path2.lineTo(size.width + 20, -20);
    path2.lineTo(-20, -20);
    path2.close();

    _fillPaint.shader = LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [
        secondaryAccent.withValues(alpha: 0.20),
        highlightAccent.withValues(alpha: 0.08),
        Colors.transparent,
      ],
      stops: const [0.0, 0.48, 1.0],
    ).createShader(Offset.zero & size);
    canvas.drawPath(path2, _fillPaint);

    // Wave Current 3: Central diagonal luminous veil
    final path3 = Path();
    final y3a = size.height * 0.25 + math.sin(t + 1.2) * 14;
    final y3b = size.height * 0.75 + math.cos(t + 1.2) * 16;

    path3.moveTo(-20, y3a);
    path3.cubicTo(
      size.width * 0.45,
      y3a + 50 + math.sin(t * 0.95) * 18,
      size.width * 0.55,
      y3b - 50 + math.cos(t * 0.95) * 18,
      size.width + 20,
      y3b,
    );
    path3.lineTo(size.width + 20, y3b + 70);
    path3.cubicTo(
      size.width * 0.55,
      y3b + 20,
      size.width * 0.45,
      y3a + 120,
      -20,
      y3a + 70,
    );
    path3.close();

    _fillPaint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        highlightAccent.withValues(alpha: 0.16),
        primaryAccent.withValues(alpha: 0.06),
        Colors.transparent,
      ],
      stops: const [0.0, 0.6, 1.0],
    ).createShader(Offset.zero & size);
    canvas.drawPath(path3, _fillPaint);
    _fillPaint.shader = null;
  }

  /// Layer 3: Multi-stage volumetric light blooms that gently drift and breathe.
  void _drawAtmosphericLightBlooms(
    Canvas canvas,
    Size size,
    double t,
    double shortest,
  ) {
    final allOrbs = [...artwork.primaryOrbs, ...artwork.secondaryOrbs];

    for (int i = 0; i < allOrbs.length; i++) {
      final orb = allOrbs[i];
      final driftX =
          math.sin(t * orb.driftSpeed + orb.phaseOffset) * (shortest * 0.045);
      final driftY =
          math.cos(t * orb.driftSpeed + orb.phaseOffset) * (shortest * 0.04);

      final center = Offset(
        (orb.relativeCenter.dx * size.width) + driftX,
        (orb.relativeCenter.dy * size.height) + driftY,
      );
      final radius = orb.relativeRadius * shortest;

      // Stage 1: Expansive Ambient Aura (Warm/Cool surrounding glow)
      _fillPaint.shader = RadialGradient(
        colors: [
          orb.color.withValues(alpha: 0.48),
          orb.color.withValues(alpha: 0.15),
          orb.color.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.6));
      canvas.drawCircle(center, radius * 1.6, _fillPaint);

      // Stage 2: Saturated Chromatic Body
      _fillPaint.shader = RadialGradient(
        colors: [
          Color.lerp(orb.color, Colors.white, 0.20)!.withValues(alpha: 0.70),
          orb.color.withValues(alpha: 0.40),
          orb.color.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.65, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 0.9));
      canvas.drawCircle(center, radius * 0.9, _fillPaint);

      // Stage 3: Inner Radiant Pearl Nucleus (Soft luminous focal warmth)
      if (i == 0) {
        _fillPaint.shader = RadialGradient(
          colors: [
            Colors.white.withValues(alpha: 0.55),
            orb.color.withValues(alpha: 0.25),
            Colors.transparent,
          ],
          stops: const [0.0, 0.45, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radius * 0.45));
        canvas.drawCircle(center, radius * 0.45, _fillPaint);
      }

      _fillPaint.shader = null;
    }
  }

  /// Layer 4: Wide, fluid silk light ribbons (Harmonic filaments, fading at both ends).
  void _drawSilkLightRibbons(Canvas canvas, Size size, double t) {
    for (int idx = 0; idx < artwork.strokes.length; idx++) {
      final stroke = artwork.strokes[idx];
      if (stroke.normalizedPoints.length < 3) continue;

      final p0 = Offset(
        stroke.normalizedPoints[0].dx * size.width,
        stroke.normalizedPoints[0].dy * size.height,
      );
      final p1 = Offset(
        stroke.normalizedPoints[1].dx * size.width + math.sin(t + idx) * 12,
        stroke.normalizedPoints[1].dy * size.height + math.cos(t + idx) * 12,
      );
      final p2 = Offset(
        stroke.normalizedPoints[2].dx * size.width,
        stroke.normalizedPoints[2].dy * size.height,
      );

      final path = Path()
        ..moveTo(p0.dx, p0.dy)
        ..quadraticBezierTo(p1.dx, p1.dy, p2.dx, p2.dy);

      // Broad luminous ambient veil
      _strokePaint
        ..color = stroke.color.withValues(alpha: 0.12)
        ..strokeWidth = 22.0
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(path, _strokePaint);

      // Soft mid-layer silk glow
      _strokePaint
        ..color = stroke.color.withValues(alpha: 0.32)
        ..strokeWidth = 8.0
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(path, _strokePaint);

      // Delicate luminous core
      _strokePaint
        ..color = Color.lerp(stroke.color, Colors.white, 0.4)!.withValues(alpha: 0.78)
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(path, _strokePaint);
    }
  }

  /// Layer 5: Replaces all wireframe doodles with pure ambient optical light poetry.
  void _drawLuminousAccents(
    Canvas canvas,
    Size size,
    double t,
    double shortest,
  ) {
    for (final motif in artwork.motifs) {
      final center = Offset(
        motif.relativeCenter.dx * size.width,
        motif.relativeCenter.dy * size.height,
      );
      final motifSize = motif.relativeSize * shortest;

      canvas.save();
      canvas.translate(center.dx, center.dy);
      _renderPureAmbientAccent(canvas, motif.type, motifSize, motif.color, t);
      canvas.restore();
    }
  }

  /// Renders pure atmospheric light accents without any wireframe rectangles,
  /// steam squiggles, or stick-figure diagrams.
  void _renderPureAmbientAccent(
    Canvas canvas,
    MotifType type,
    double size,
    Color color,
    double t,
  ) {
    final half = size / 2;

    switch (type) {
      // 1. Focus / Clarity -> Luminous Optical Refraction Halo
      case MotifType.structureGrid:
      case MotifType.crystalNode:
        // Wide soft prismatic aura
        _fillPaint.shader = RadialGradient(
          colors: [
            color.withValues(alpha: 0.35),
            color.withValues(alpha: 0.08),
            Colors.transparent,
          ],
          stops: const [0.0, 0.6, 1.0],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: half));
        canvas.drawCircle(Offset.zero, half, _fillPaint);

        // Delicate luminous diamond focal point
        final diamond = Path()
          ..moveTo(0, -half * 0.45)
          ..lineTo(half * 0.45, 0)
          ..lineTo(0, half * 0.45)
          ..lineTo(-half * 0.45, 0)
          ..close();
        _fillPaint.shader = null;
        _fillPaint.color = Color.lerp(color, Colors.white, 0.5)!.withValues(alpha: 0.25);
        canvas.drawPath(diamond, _fillPaint);

        // Core jewel pearl
        _fillPaint.color = Colors.white.withValues(alpha: 0.85);
        canvas.drawCircle(Offset.zero, 2.5, _fillPaint);
        break;

      // 2. Harmonic Sound / Music -> Luminous Horizontal Wave Resonance (NO vertical steam lines)
      case MotifType.waveLines:
        // Smooth horizontal resonance wave with soft fade
        for (int i = -1; i <= 1; i++) {
          final yOffset = i * (size * 0.16);
          final path = Path();
          final amp = (size * 0.08) + math.sin(t + i) * 3.0;

          path.moveTo(-half * 0.9, yOffset);
          path.cubicTo(
            -half * 0.45,
            yOffset - amp,
            half * 0.45,
            yOffset + amp,
            half * 0.9,
            yOffset,
          );

          // Soft ambient halo
          _strokePaint
            ..color = color.withValues(alpha: 0.20 - i.abs() * 0.05)
            ..strokeWidth = 6.0
            ..strokeCap = StrokeCap.round;
          canvas.drawPath(path, _strokePaint);

          // Luminous melody thread
          _strokePaint
            ..color = Color.lerp(color, Colors.white, 0.35)!
                .withValues(alpha: 0.70 - i.abs() * 0.15)
            ..strokeWidth = 1.4
            ..strokeCap = StrokeCap.round;
          canvas.drawPath(path, _strokePaint);
        }
        break;

      // 3. Nature / Outdoors -> Organic Living Light Sprout (Graceful flowing curve)
      case MotifType.leafCurve:
        final stem = Path()
          ..moveTo(-half * 0.3, half * 0.6)
          ..cubicTo(
            -half * 0.1,
            half * 0.1,
            half * 0.4,
            -half * 0.1,
            half * 0.1,
            -half * 0.6,
          );

        // Wide aura wash
        _strokePaint
          ..color = color.withValues(alpha: 0.22)
          ..strokeWidth = 10.0
          ..strokeCap = StrokeCap.round;
        canvas.drawPath(stem, _strokePaint);

        // Radiant green/gold light filament
        _strokePaint
          ..color = Color.lerp(color, Colors.white, 0.4)!.withValues(alpha: 0.85)
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round;
        canvas.drawPath(stem, _strokePaint);

        // Apex bud glow
        _fillPaint.color = Colors.white.withValues(alpha: 0.9);
        canvas.drawCircle(Offset(half * 0.1, -half * 0.6), 3.0, _fillPaint);
        break;

      // 4. Movement / Energy -> Radiant Optical Starburst Flare
      case MotifType.dynamicSpark:
        _fillPaint.shader = RadialGradient(
          colors: [
            Colors.white.withValues(alpha: 0.75),
            color.withValues(alpha: 0.35),
            Colors.transparent,
          ],
          stops: const [0.0, 0.4, 1.0],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: half * 0.75));
        canvas.drawCircle(Offset.zero, half * 0.75, _fillPaint);
        _fillPaint.shader = null;

        // Subtle cross light rays
        _strokePaint
          ..color = Colors.white.withValues(alpha: 0.7)
          ..strokeWidth = 1.2
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(Offset(-half * 0.6, 0), Offset(half * 0.6, 0), _strokePaint);
        canvas.drawLine(Offset(0, -half * 0.6), Offset(0, half * 0.6), _strokePaint);
        break;

      // 5. Flow / Rhythm -> Ethereal Fluid Light Ribbon
      case MotifType.flowingPath:
        final path = Path()
          ..moveTo(-half * 0.8, half * 0.3)
          ..cubicTo(
            -half * 0.2,
            -half * 0.6,
            half * 0.2,
            half * 0.6,
            half * 0.8,
            -half * 0.3,
          );

        _strokePaint
          ..color = color.withValues(alpha: 0.25)
          ..strokeWidth = 12.0
          ..strokeCap = StrokeCap.round;
        canvas.drawPath(path, _strokePaint);

        _strokePaint
          ..color = Color.lerp(color, Colors.white, 0.35)!.withValues(alpha: 0.80)
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round;
        canvas.drawPath(path, _strokePaint);
        break;

      // 6. Contemplation / Journaling -> Translucent Light Aperture (NO wireframe boxes)
      case MotifType.layeredFrames:
        // Soft glowing circular/oval light disc
        _fillPaint.shader = RadialGradient(
          colors: [
            color.withValues(alpha: 0.28),
            color.withValues(alpha: 0.08),
            Colors.transparent,
          ],
          stops: const [0.0, 0.65, 1.0],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: half * 0.85));
        canvas.drawCircle(Offset.zero, half * 0.85, _fillPaint);
        _fillPaint.shader = null;

        // Delicate luminous ring halo with soft gradient
        _strokePaint
          ..color = color.withValues(alpha: 0.45)
          ..strokeWidth = 1.4
          ..strokeCap = StrokeCap.round;
        canvas.drawCircle(Offset.zero, half * 0.55, _strokePaint);

        // Core pearlescent ember
        _fillPaint.color = Colors.white.withValues(alpha: 0.85);
        canvas.drawCircle(Offset.zero, 2.5, _fillPaint);
        break;

      // 7. Connection / Social -> Glowing Celestial Star Cluster (NO stick lines)
      case MotifType.clusterDots:
        final nodes = [
          Offset.zero,
          Offset(-half * 0.38, -half * 0.32),
          Offset(half * 0.42, -half * 0.28),
          Offset(-half * 0.32, half * 0.38),
          Offset(half * 0.36, half * 0.34),
        ];

        for (final pt in nodes) {
          // Soft radial starlight halo
          _fillPaint.color = color.withValues(alpha: 0.30);
          canvas.drawCircle(pt, 6.5, _fillPaint);

          // Glowing diamond core
          _fillPaint.color = Colors.white.withValues(alpha: 0.95);
          canvas.drawCircle(pt, 2.2, _fillPaint);
        }
        break;

      // 8. Sleep / Rest -> Dreamy Horizon Nebula Cloud
      case MotifType.softCloud:
        _fillPaint.shader = RadialGradient(
          colors: [
            color.withValues(alpha: 0.32),
            color.withValues(alpha: 0.10),
            Colors.transparent,
          ],
          stops: const [0.0, 0.6, 1.0],
        ).createShader(Rect.fromCenter(
          center: Offset.zero,
          width: size * 0.9,
          height: size * 0.55,
        ));
        canvas.drawOval(
          Rect.fromCenter(center: Offset.zero, width: size * 0.9, height: size * 0.55),
          _fillPaint,
        );
        _fillPaint.shader = null;
        break;

      // 9. Warmth / Food -> Orbiting Luminous Embers
      case MotifType.warmEmbers:
        for (int i = 0; i < 6; i++) {
          final angle = i * (math.pi * 2 / 6) + (t * 0.25);
          final dist = half * (0.35 + (i % 2) * 0.25);
          final pt = Offset(math.cos(angle) * dist, math.sin(angle) * dist);

          // Soft ember glow
          _fillPaint.color = color.withValues(alpha: 0.35);
          canvas.drawCircle(pt, 5.5, _fillPaint);
          // Radiant core
          _fillPaint.color = Colors.white.withValues(alpha: 0.95);
          canvas.drawCircle(pt, 2.2, _fillPaint);
        }
        break;

      // 10. Creative / Art -> Sweeping Calligraphic Light Arc
      case MotifType.pigmentArc:
        _strokePaint
          ..strokeWidth = 6.0
          ..color = color.withValues(alpha: 0.25)
          ..strokeCap = StrokeCap.round;
        canvas.drawArc(
          Rect.fromCenter(center: Offset.zero, width: size * 0.85, height: size * 0.85),
          0.3,
          2.5,
          false,
          _strokePaint,
        );

        _strokePaint
          ..strokeWidth = 2.0
          ..color = Color.lerp(color, Colors.white, 0.4)!.withValues(alpha: 0.85)
          ..strokeCap = StrokeCap.round;
        canvas.drawArc(
          Rect.fromCenter(center: Offset.zero, width: size * 0.85, height: size * 0.85),
          0.3,
          2.5,
          false,
          _strokePaint,
        );
        break;

      // 11. Rest / Hydration -> Concentric Luminous Light Ripples
      case MotifType.waterRipple:
        for (int i = 1; i <= 3; i++) {
          final r = half * (i / 3.0);
          _strokePaint
            ..strokeWidth = 1.2
            ..color = color.withValues(alpha: 0.45 - i * 0.1)
            ..strokeCap = StrokeCap.round;
          canvas.drawCircle(Offset.zero, r, _strokePaint);
        }
        _fillPaint.color = Colors.white.withValues(alpha: 0.9);
        canvas.drawCircle(Offset.zero, 2.8, _fillPaint);
        break;
    }
  }

  /// Layer 6: Fine celestial stardust with soft atmospheric diffusion.
  void _drawCelestialStardust(Canvas canvas, Size size, double t) {
    for (int i = 0; i < artwork.particles.length; i++) {
      final p = artwork.particles[i];
      final px = p.relativePos.dx * size.width;
      final py = p.relativePos.dy * size.height;
      final sparkle = math.sin(t * 1.6 + i * 0.8) * 0.35;
      final effectiveRadius = (p.radius * (1.0 + sparkle * 0.5)).clamp(0.8, 3.2);

      // Star particle core
      _fillPaint.color = p.color.withValues(
        alpha: (p.opacity * (0.75 + sparkle * 0.25)).clamp(0.15, 0.95),
      );
      canvas.drawCircle(Offset(px, py), effectiveRadius, _fillPaint);

      // Selected prominent particles receive a soft celestial light halo (NO harsh cross lines)
      if (i % 6 == 0 && effectiveRadius > 1.8) {
        _fillPaint.color = p.color.withValues(alpha: 0.22);
        canvas.drawCircle(Offset(px, py), effectiveRadius * 2.8, _fillPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant MoodCanvasPainter oldDelegate) {
    return oldDelegate.artwork.seed != artwork.seed ||
        oldDelegate.progress != progress;
  }
}

