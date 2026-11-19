import 'package:flutter/material.dart';

/// Precomputed organic orb primitive.
class CanvasOrbPrimitive {
  final Offset relativeCenter; // 0.0 to 1.0
  final double relativeRadius; // relative to size.shortestSide
  final Color color;
  final double blurRadius;
  final double driftSpeed;
  final double phaseOffset;

  const CanvasOrbPrimitive({
    required this.relativeCenter,
    required this.relativeRadius,
    required this.color,
    required this.blurRadius,
    this.driftSpeed = 1.0,
    this.phaseOffset = 0.0,
  });
}

/// Precomputed curved brush or line stroke primitive.
class CanvasStrokePrimitive {
  final List<Offset> normalizedPoints; // 0.0 to 1.0
  final Color color;
  final double strokeWidth;
  final bool isClosed;
  final bool isSmooth;

  const CanvasStrokePrimitive({
    required this.normalizedPoints,
    required this.color,
    required this.strokeWidth,
    this.isClosed = false,
    this.isSmooth = true,
  });
}

/// Identifiers for activity visual motifs.
enum MotifType {
  waveLines,     // Music
  leafCurve,     // Nature
  dynamicSpark,  // Exercise
  flowingPath,   // Travel
  layeredFrames, // Reading
  clusterDots,   // Friends / Family
  softCloud,     // Rest
  structureGrid, // Work / Study
  warmEmbers,    // Food
  pigmentArc,    // Creative
  waterRipple,   // Self-care
  crystalNode,   // Gaming / Shopping
}

/// Precomputed activity visual motif primitive.
class CanvasMotifPrimitive {
  final MotifType type;
  final Offset relativeCenter; // 0.0 to 1.0
  final double relativeSize;   // relative to shortestSide
  final Color color;
  final double rotation;

  const CanvasMotifPrimitive({
    required this.type,
    required this.relativeCenter,
    required this.relativeSize,
    required this.color,
    this.rotation = 0.0,
  });
}

/// Precomputed stardust or ambient texture particle.
class CanvasParticlePrimitive {
  final Offset relativePos;
  final double radius;
  final double opacity;
  final Color color;

  const CanvasParticlePrimitive({
    required this.relativePos,
    required this.radius,
    required this.opacity,
    required this.color,
  });
}

/// Complete procedural representation of a generated day's emotional canvas.
/// Immutable and fully decoupled from rendering calculations.
class CanvasArtworkData {
  final int seed;
  final Color backgroundColor;
  final List<Color> gradientColors;
  final List<double> gradientStops;
  final Alignment gradientBegin;
  final Alignment gradientEnd;

  final List<CanvasOrbPrimitive> primaryOrbs;
  final List<CanvasOrbPrimitive> secondaryOrbs;
  final List<CanvasStrokePrimitive> strokes;
  final List<CanvasMotifPrimitive> motifs;
  final List<CanvasParticlePrimitive> particles;

  final String moodLabel;
  final int intensity;
  final String energyLabel;
  final String dateString;

  const CanvasArtworkData({
    required this.seed,
    required this.backgroundColor,
    required this.gradientColors,
    required this.gradientStops,
    this.gradientBegin = Alignment.topLeft,
    this.gradientEnd = Alignment.bottomRight,
    required this.primaryOrbs,
    required this.secondaryOrbs,
    required this.strokes,
    required this.motifs,
    required this.particles,
    required this.moodLabel,
    required this.intensity,
    required this.energyLabel,
    required this.dateString,
  });
}
