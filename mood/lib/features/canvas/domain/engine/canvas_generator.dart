import 'package:flutter/material.dart';
import '../../../capture/domain/energy_level.dart';
import '../../../capture/domain/mood_type.dart';
import '../models/canvas_artwork_data.dart';
import '../rules/activity_visual_rules.dart';
import '../rules/energy_visual_rules.dart';
import '../rules/mood_visual_rules.dart';
import 'canvas_seed_generator.dart';

/// The Creative Canvas Engine.
/// Procedurally transforms emotional daily capture inputs into deterministic
/// visual artwork primitives.
class CanvasGenerator {
  CanvasGenerator._();

  static CanvasArtworkData generate({
    required DateTime date,
    required MoodType mood,
    required int moodIntensity,
    required EnergyLevel energy,
    required Set<String> activities,
  }) {
    // 1. Deterministic Seed
    final seed = CanvasSeedGenerator.computeSeed(
      date: date,
      moodName: mood.name,
      moodIntensity: moodIntensity,
      energyLevel: energy.intensityValue,
      activities: activities,
    );

    final rng = DeterministicRandom(seed);
    final moodSpec = MoodVisualRules.getSpec(mood);
    final energySpec = EnergyVisualRules.getSpec(energy);

    // 2. Background & Gradient
    final gradientBegin = Alignment(
      rng.nextRange(-1.0, 0.2),
      rng.nextRange(-1.0, 0.2),
    );
    final gradientEnd = Alignment(
      rng.nextRange(0.2, 1.0),
      rng.nextRange(0.2, 1.0),
    );

    // 3. Primary Mood Orbs (Layers 3 & 4)
    final intensityFactor = (moodIntensity / 10.0).clamp(0.2, 1.0);
    final primaryOrbs = <CanvasOrbPrimitive>[];
    final secondaryOrbs = <CanvasOrbPrimitive>[];

    // Main Dominant Mood Orb
    primaryOrbs.add(
      CanvasOrbPrimitive(
        relativeCenter: Offset(
          rng.nextRange(0.35, 0.65),
          rng.nextRange(0.35, 0.65),
        ),
        relativeRadius: energySpec.baseRadiusFactor * (0.8 + (intensityFactor * 0.4)),
        color: mood.primaryColor.withValues(alpha: 0.65 + (intensityFactor * 0.25)),
        blurRadius: moodSpec.blurIntensity * (0.8 + (intensityFactor * 0.4)),
        driftSpeed: energySpec.driftSpeed,
        phaseOffset: rng.nextRange(0.0, 6.28),
      ),
    );

    // Secondary Accent Orbs based on Energy Count
    for (int i = 0; i < energySpec.orbCount; i++) {
      final color = moodSpec.paletteColors[i % moodSpec.paletteColors.length];
      final radius = energySpec.baseRadiusFactor * rng.nextRange(0.4, 0.85);

      // Keep within margin
      final rx = rng.nextRange(0.15, 0.85);
      final ry = rng.nextRange(0.15, 0.85);

      secondaryOrbs.add(
        CanvasOrbPrimitive(
          relativeCenter: Offset(rx, ry),
          relativeRadius: radius,
          color: color.withValues(alpha: rng.nextRange(0.4, 0.75)),
          blurRadius: moodSpec.blurIntensity * rng.nextRange(0.6, 1.2),
          driftSpeed: energySpec.driftSpeed * rng.nextRange(0.7, 1.3),
          phaseOffset: rng.nextRange(0.0, 6.28),
        ),
      );
    }

    // 4. Activity Visual Motifs (Layer 5)
    final motifs = <CanvasMotifPrimitive>[];
    final sortedActivities = activities.toList()..sort();

    for (int i = 0; i < sortedActivities.length; i++) {
      final act = sortedActivities[i];
      final motifType = ActivityVisualRules.getMotifForActivity(act);

      if (motifType != null) {
        final color = moodSpec.paletteColors[(i + 1) % moodSpec.paletteColors.length];
        motifs.add(
          CanvasMotifPrimitive(
            type: motifType,
            relativeCenter: Offset(
              rng.nextRange(0.25, 0.75),
              rng.nextRange(0.25, 0.75),
            ),
            relativeSize: rng.nextRange(0.22, 0.38),
            color: color.withValues(alpha: 0.85),
            rotation: rng.nextRange(0.0, 6.28),
          ),
        );
      }
    }

    // 5. Flowing Harmonic Strokes
    final strokes = <CanvasStrokePrimitive>[];
    final strokeCount = (energy.intensityValue >= 3 ? 2 : 1);

    for (int s = 0; s < strokeCount; s++) {
      final strokeColor = moodSpec.paletteColors[s % moodSpec.paletteColors.length];
      final p1 = Offset(rng.nextRange(0.05, 0.3), rng.nextRange(0.2, 0.8));
      final p2 = Offset(rng.nextRange(0.35, 0.65), rng.nextRange(0.1, 0.9));
      final p3 = Offset(rng.nextRange(0.7, 0.95), rng.nextRange(0.2, 0.8));

      strokes.add(
        CanvasStrokePrimitive(
          normalizedPoints: [p1, p2, p3],
          color: strokeColor.withValues(alpha: 0.35),
          strokeWidth: energySpec.strokeThickness,
          isSmooth: true,
        ),
      );
    }

    // 6. Stardust & Atmospheric Specks (Layer 7)
    final particles = <CanvasParticlePrimitive>[];
    final particleCount = (24 * energySpec.particleDensity).round();

    for (int p = 0; p < particleCount; p++) {
      final pColor = moodSpec.paletteColors[p % moodSpec.paletteColors.length];
      particles.add(
        CanvasParticlePrimitive(
          relativePos: Offset(rng.nextDouble(), rng.nextDouble()),
          radius: rng.nextRange(1.0, 2.5),
          opacity: rng.nextRange(0.15, 0.65),
          color: pColor,
        ),
      );
    }

    return CanvasArtworkData(
      seed: seed,
      backgroundColor: moodSpec.baseBackground,
      gradientColors: moodSpec.atmosphericGradient,
      gradientStops: const [0.0, 0.6, 1.0],
      gradientBegin: gradientBegin,
      gradientEnd: gradientEnd,
      primaryOrbs: primaryOrbs,
      secondaryOrbs: secondaryOrbs,
      strokes: strokes,
      motifs: motifs,
      particles: particles,
      moodLabel: mood.label,
      intensity: moodIntensity,
      energyLabel: energy.label,
      dateString: '${date.year}-${date.month.toString().padLeft(2, "0")}-${date.day.toString().padLeft(2, "0")}',
    );
  }
}
