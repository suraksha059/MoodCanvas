import '../../../capture/domain/energy_level.dart';

/// Visual dynamics derived from the user's energy level.
class EnergyVisualSpec {
  final int orbCount;
  final double baseRadiusFactor; // relative to canvas shortestSide
  final double particleDensity;  // density multiplier (0.5 to 2.0)
  final double strokeThickness;
  final double driftSpeed;
  final double whitespaceRatio;

  const EnergyVisualSpec({
    required this.orbCount,
    required this.baseRadiusFactor,
    required this.particleDensity,
    required this.strokeThickness,
    required this.driftSpeed,
    required this.whitespaceRatio,
  });
}

class EnergyVisualRules {
  EnergyVisualRules._();

  static EnergyVisualSpec getSpec(EnergyLevel? energy) {
    final level = energy ?? EnergyLevel.balanced;

    switch (level) {
      case EnergyLevel.veryLow:
        return const EnergyVisualSpec(
          orbCount: 2,
          baseRadiusFactor: 0.60,
          particleDensity: 0.4,
          strokeThickness: 1.0,
          driftSpeed: 0.4,
          whitespaceRatio: 0.65,
        );

      case EnergyLevel.low:
        return const EnergyVisualSpec(
          orbCount: 3,
          baseRadiusFactor: 0.50,
          particleDensity: 0.7,
          strokeThickness: 1.2,
          driftSpeed: 0.7,
          whitespaceRatio: 0.50,
        );

      case EnergyLevel.balanced:
        return const EnergyVisualSpec(
          orbCount: 4,
          baseRadiusFactor: 0.42,
          particleDensity: 1.0,
          strokeThickness: 1.6,
          driftSpeed: 1.0,
          whitespaceRatio: 0.35,
        );

      case EnergyLevel.high:
        return const EnergyVisualSpec(
          orbCount: 6,
          baseRadiusFactor: 0.34,
          particleDensity: 1.4,
          strokeThickness: 2.0,
          driftSpeed: 1.5,
          whitespaceRatio: 0.22,
        );

      case EnergyLevel.veryHigh:
        return const EnergyVisualSpec(
          orbCount: 8,
          baseRadiusFactor: 0.26,
          particleDensity: 2.0,
          strokeThickness: 2.6,
          driftSpeed: 2.0,
          whitespaceRatio: 0.12,
        );
    }
  }
}
