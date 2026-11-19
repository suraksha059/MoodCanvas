/// Deterministic Pseudo-Random Number Generator (PRNG) using Mulberry32.
/// Guarantees that the exact same daily capture parameters always produce
/// the exact same artistic canvas.
class DeterministicRandom {
  int _state;

  DeterministicRandom(int seed) : _state = seed & 0xFFFFFFFF;

  /// Returns a pseudo-random double in the range [0.0, 1.0).
  double nextDouble() {
    _state = (_state + 0x6D2B79F5) & 0xFFFFFFFF;
    int z = _state;
    z = ((z ^ (z >> 15)) * (z | 1)) & 0xFFFFFFFF;
    z ^= (z + (((z ^ (z >> 7)) * (z | 61)) & 0xFFFFFFFF)) & 0xFFFFFFFF;
    return ((z ^ (z >> 14)) >>> 0) / 4294967296.0;
  }

  /// Returns a double within [min, max).
  double nextRange(double min, double max) => min + (max - min) * nextDouble();

  /// Returns an integer within [min, max] inclusive.
  int nextInt(int min, int max) => (min + (nextDouble() * (max - min + 1))).floor();

  /// Returns true or false based on probability [0.0, 1.0].
  bool nextBool([double probability = 0.5]) => nextDouble() < probability;
}

/// Helper to compute a stable integer seed from daily emotional inputs.
class CanvasSeedGenerator {
  CanvasSeedGenerator._();

  static int computeSeed({
    required DateTime date,
    required String moodName,
    required int moodIntensity,
    required int energyLevel,
    required Set<String> activities,
  }) {
    int hash = 17;
    // Date day uniqueness
    hash = 37 * hash + date.year;
    hash = 37 * hash + date.month;
    hash = 37 * hash + date.day;

    // Mood & Intensity
    hash = 37 * hash + moodName.hashCode;
    hash = 37 * hash + moodIntensity;

    // Energy
    hash = 37 * hash + energyLevel;

    // Sorted activities for determinism
    final sortedActivities = activities.toList()..sort();
    for (final act in sortedActivities) {
      hash = 37 * hash + act.hashCode;
    }

    return hash & 0x7FFFFFFF;
  }
}
