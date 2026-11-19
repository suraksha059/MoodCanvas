import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../capture/domain/daily_entry.dart';
import '../../../capture/domain/energy_level.dart';
import '../../../capture/domain/mood_type.dart';
import '../models/monthly_canvas_data.dart';

/// Procedural engine that weaves an entire month of emotional captures into a unified cosmic tapestry.
class MonthlyCanvasGenerator {
  const MonthlyCanvasGenerator._();

  static const List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  static MonthlyCanvasData generate({
    required int year,
    required int month,
    required List<DailyEntry> allEntries,
  }) {
    final totalDays = DateTime(year, month + 1, 0).day;
    final monthName = _monthNames[month - 1];

    // 1. Filter entries for this specific month & year
    final monthEntries = allEntries.where((e) {
      return e.date.year == year && e.date.month == month;
    }).toList();

    if (monthEntries.isEmpty) {
      return MonthlyCanvasData(
        year: year,
        month: month,
        monthName: monthName,
        totalDaysInMonth: totalDays,
        capturedDaysCount: 0,
        averageIntensity: 0.0,
        averageEnergy: 'No data',
        moodDistribution: const {},
        nodes: const [],
        topActivities: const [],
      );
    }

    // Sort by day ascending
    monthEntries.sort((a, b) => a.date.day.compareTo(b.date.day));

    // 2. Compute mood distribution & dominant mood
    final moodCountMap = <MoodType, int>{};
    int totalIntensity = 0;
    double totalEnergyVal = 0.0;
    final activityCounts = <String, int>{};

    for (final entry in monthEntries) {
      final moodType = _parseMood(entry.mood);
      moodCountMap[moodType] = (moodCountMap[moodType] ?? 0) + 1;
      totalIntensity += entry.moodIntensity;
      totalEnergyVal += _energyToNumeric(entry.energy);

      for (final act in entry.activities) {
        final clean = act.trim();
        if (clean.isNotEmpty) {
          activityCounts[clean] = (activityCounts[clean] ?? 0) + 1;
        }
      }
    }

    // Dominant Mood
    MoodType? dominantMoodType;
    int maxMoodCount = 0;
    for (final entry in moodCountMap.entries) {
      if (entry.value > maxMoodCount) {
        maxMoodCount = entry.value;
        dominantMoodType = entry.key;
      }
    }

    // Mood distribution ratio
    final moodDist = <MoodType, double>{};
    for (final entry in moodCountMap.entries) {
      moodDist[entry.key] = entry.value / monthEntries.length;
    }

    // Top activities
    final sortedActivities = activityCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topActivities = sortedActivities.take(4).map((e) => e.key).toList();

    // 3. Generate Day Nodes along a celestial orbital curve
    final nodes = <MonthlyDayNode>[];
    for (final entry in monthEntries) {
      final day = entry.date.day;
      final moodType = _parseMood(entry.mood);
      final energyLevel = _parseEnergy(entry.energy);

      // Deterministic cosmic orbital path coordinate
      // t varies smoothly from 0.0 to 1.0 across the month
      final t = (day - 1) / math.max(1, totalDays - 1);
      final angle = t * 2 * math.pi;

      // Organic celestial Lissajous constellation curve
      final nx = 0.5 + 0.36 * math.cos(angle) * (1.0 + 0.15 * math.sin(angle * 2));
      final ny = 0.5 + 0.34 * math.sin(angle) * (1.0 - 0.12 * math.cos(angle * 2));

      nodes.add(
        MonthlyDayNode(
          day: day,
          mood: moodType,
          intensity: entry.moodIntensity,
          energy: energyLevel,
          normalizedPosition: Offset(nx.clamp(0.12, 0.88), ny.clamp(0.14, 0.86)),
          activities: entry.activities,
        ),
      );
    }

    return MonthlyCanvasData(
      year: year,
      month: month,
      monthName: monthName,
      totalDaysInMonth: totalDays,
      capturedDaysCount: monthEntries.length,
      dominantMood: dominantMoodType?.label,
      dominantMoodType: dominantMoodType,
      averageIntensity: totalIntensity / monthEntries.length,
      averageEnergy: _numericToEnergyLabel(totalEnergyVal / monthEntries.length),
      moodDistribution: moodDist,
      nodes: nodes,
      topActivities: topActivities,
    );
  }

  static MoodType _parseMood(String moodName) {
    return MoodType.values.firstWhere(
      (m) =>
          m.label.toLowerCase() == moodName.toLowerCase() ||
          m.name.toLowerCase() == moodName.toLowerCase(),
      orElse: () => MoodType.calm,
    );
  }

  static EnergyLevel _parseEnergy(String energyName) {
    return EnergyLevel.values.firstWhere(
      (e) =>
          e.label.toLowerCase() == energyName.toLowerCase() ||
          e.name.toLowerCase() == energyName.toLowerCase(),
      orElse: () => EnergyLevel.balanced,
    );
  }

  static double _energyToNumeric(String energy) {
    final lower = energy.toLowerCase();
    if (lower.contains('very low')) return 1.0;
    if (lower.contains('low')) return 2.0;
    if (lower.contains('balanced')) return 3.0;
    if (lower.contains('high')) return 4.0;
    if (lower.contains('vibrant')) return 5.0;
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
