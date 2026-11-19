import '../../../capture/domain/daily_entry.dart';
import '../../../capture/domain/energy_level.dart';
import '../../../capture/domain/mood_type.dart';
import '../models/insights_data.dart';
import '../models/time_period.dart';

/// Pure domain service performing statistical aggregations on stored daily entries.
/// Decoupled from widgets and database APIs for testability.
class InsightsCalculator {
  const InsightsCalculator._();

  static InsightsData calculate({
    required List<DailyEntry> allEntries,
    required TimePeriod period,
    DateTime? referenceDate,
  }) {
    if (allEntries.isEmpty) {
      return InsightsData.empty();
    }

    final ref = referenceDate ?? DateTime.now();

    // 1. Calculate overall consecutive streak across all-time entries
    final currentStreak = _calculateCurrentStreak(allEntries, ref);

    // 2. Filter entries by requested time window
    final filtered = _filterByPeriod(allEntries, period, ref);

    if (filtered.isEmpty) {
      return InsightsData(
        totalCapturedDays: 0,
        currentStreak: currentStreak,
        averageIntensity: 0.0,
        averageEnergyNumeric: 0.0,
        averageEnergyLabel: 'No data',
        moodCounts: const {},
        moodPercentages: const {},
      );
    }

    // 3. Mood distribution & dominant mood
    final moodCounts = <String, int>{};
    int totalIntensity = 0;
    double totalEnergyValue = 0.0;
    final activityCounts = <String, int>{};

    for (final entry in filtered) {
      // Mood count
      final normalizedMood = _normalizeMoodName(entry.mood);
      moodCounts[normalizedMood] = (moodCounts[normalizedMood] ?? 0) + 1;

      // Intensity sum
      totalIntensity += entry.moodIntensity;

      // Energy mapping
      final energyNum = _energyToNumeric(entry.energy);
      totalEnergyValue += energyNum;

      // Activities
      for (final act in entry.activities) {
        final cleanAct = act.trim();
        if (cleanAct.isNotEmpty) {
          activityCounts[cleanAct] = (activityCounts[cleanAct] ?? 0) + 1;
        }
      }
    }

    // Determine most common mood
    String? mostCommonMood;
    int mostCommonMoodCount = 0;
    for (final entry in moodCounts.entries) {
      if (entry.value > mostCommonMoodCount) {
        mostCommonMoodCount = entry.value;
        mostCommonMood = entry.key;
      }
    }

    MoodType? mostCommonMoodType;
    if (mostCommonMood != null) {
      mostCommonMoodType = _parseMoodType(mostCommonMood);
    }

    // Percentages
    final moodPercentages = <String, double>{};
    for (final entry in moodCounts.entries) {
      moodPercentages[entry.key] = entry.value / filtered.length;
    }

    // Averages
    final avgIntensity = totalIntensity / filtered.length;
    final avgEnergyNumeric = totalEnergyValue / filtered.length;
    final avgEnergyLabel = _numericToEnergyLabel(avgEnergyNumeric);

    // Most frequent activity
    String? mostFrequentActivity;
    int mostFrequentActivityCount = 0;
    for (final entry in activityCounts.entries) {
      if (entry.value > mostFrequentActivityCount) {
        mostFrequentActivityCount = entry.value;
        mostFrequentActivity = entry.key;
      }
    }

    return InsightsData(
      totalCapturedDays: filtered.length,
      currentStreak: currentStreak,
      mostCommonMood: mostCommonMood,
      mostCommonMoodType: mostCommonMoodType,
      mostCommonMoodCount: mostCommonMoodCount,
      averageIntensity: avgIntensity,
      averageEnergyNumeric: avgEnergyNumeric,
      averageEnergyLabel: avgEnergyLabel,
      mostFrequentActivity: mostFrequentActivity,
      mostFrequentActivityCount: mostFrequentActivityCount,
      moodCounts: moodCounts,
      moodPercentages: moodPercentages,
    );
  }

  static List<DailyEntry> _filterByPeriod(
    List<DailyEntry> entries,
    TimePeriod period,
    DateTime ref,
  ) {
    switch (period) {
      case TimePeriod.thisWeek:
        // Current week starting from Monday (inclusive) to Sunday
        final monday = DateTime(ref.year, ref.month, ref.day - (ref.weekday - 1));
        final nextMonday = monday.add(const Duration(days: 7));
        return entries.where((e) {
          return !e.date.isBefore(monday) && e.date.isBefore(nextMonday);
        }).toList();

      case TimePeriod.thisMonth:
        return entries.where((e) {
          return e.date.year == ref.year && e.date.month == ref.month;
        }).toList();

      case TimePeriod.allTime:
        return entries;
    }
  }

  static int _calculateCurrentStreak(List<DailyEntry> entries, DateTime ref) {
    if (entries.isEmpty) return 0;

    final dateSet = entries.map((e) => e.dateString).toSet();
    final today = DateTime(ref.year, ref.month, ref.day);
    final todayStr = DailyEntry.toDateString(today);
    final yesterdayStr = DailyEntry.toDateString(today.subtract(const Duration(days: 1)));

    // If neither today nor yesterday has an entry, streak is broken
    DateTime checkDate;
    if (dateSet.contains(todayStr)) {
      checkDate = today;
    } else if (dateSet.contains(yesterdayStr)) {
      checkDate = today.subtract(const Duration(days: 1));
    } else {
      return 0;
    }

    int streak = 0;
    while (dateSet.contains(DailyEntry.toDateString(checkDate))) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    return streak;
  }

  static String _normalizeMoodName(String mood) {
    if (mood.isEmpty) return 'Calm';
    return mood[0].toUpperCase() + mood.substring(1).toLowerCase();
  }

  static MoodType _parseMoodType(String moodName) {
    return MoodType.values.firstWhere(
      (m) =>
          m.label.toLowerCase() == moodName.toLowerCase() ||
          m.name.toLowerCase() == moodName.toLowerCase(),
      orElse: () => MoodType.calm,
    );
  }

  static double _energyToNumeric(String energy) {
    final lower = energy.toLowerCase();
    if (lower.contains('very low')) return 1.0;
    if (lower.contains('low')) return 2.0;
    if (lower.contains('balanced')) return 3.0;
    if (lower.contains('high')) return 4.0;
    if (lower.contains('vibrant')) return 5.0;

    for (final e in EnergyLevel.values) {
      if (e.label.toLowerCase() == lower || e.name.toLowerCase() == lower) {
        return (e.index + 1).toDouble();
      }
    }
    return 3.0;
  }

  static String _numericToEnergyLabel(double value) {
    if (value <= 1.5) return 'Very low';
    if (value <= 2.5) return 'Low';
    if (value <= 3.5) return 'Balanced';
    if (value <= 4.5) return 'High';
    return 'Vibrant';
  }
}
