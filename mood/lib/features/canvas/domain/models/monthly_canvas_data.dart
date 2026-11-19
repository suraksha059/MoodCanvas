import 'package:flutter/material.dart';
import '../../../capture/domain/energy_level.dart';
import '../../../capture/domain/mood_type.dart';

/// Single captured day node within the monthly constellation artwork.
class MonthlyDayNode {
  final int day;
  final MoodType mood;
  final int intensity;
  final EnergyLevel energy;
  final Offset normalizedPosition; // [0.1, 0.9]
  final List<String> activities;

  const MonthlyDayNode({
    required this.day,
    required this.mood,
    required this.intensity,
    required this.energy,
    required this.normalizedPosition,
    required this.activities,
  });
}

/// Immutable data model containing the monthly emotional aggregation and artwork parameters.
class MonthlyCanvasData {
  final int year;
  final int month;
  final String monthName;
  final int totalDaysInMonth;
  final int capturedDaysCount;
  final String? dominantMood;
  final MoodType? dominantMoodType;
  final double averageIntensity;
  final String averageEnergy;
  final Map<MoodType, double> moodDistribution;
  final List<MonthlyDayNode> nodes;
  final List<String> topActivities;

  const MonthlyCanvasData({
    required this.year,
    required this.month,
    required this.monthName,
    required this.totalDaysInMonth,
    required this.capturedDaysCount,
    this.dominantMood,
    this.dominantMoodType,
    required this.averageIntensity,
    required this.averageEnergy,
    required this.moodDistribution,
    required this.nodes,
    required this.topActivities,
  });

  bool get hasEntries => capturedDaysCount > 0;
}
