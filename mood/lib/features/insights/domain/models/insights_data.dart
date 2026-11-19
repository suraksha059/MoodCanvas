import 'package:flutter/foundation.dart';
import '../../../capture/domain/mood_type.dart';

/// Immutable domain aggregate holding all calculated emotional analytics.
@immutable
class InsightsData {
  final int totalCapturedDays;
  final int currentStreak;
  final String? mostCommonMood;
  final MoodType? mostCommonMoodType;
  final int mostCommonMoodCount;
  final double averageIntensity;
  final double averageEnergyNumeric; // 1.0 to 5.0
  final String averageEnergyLabel;
  final String? mostFrequentActivity;
  final int mostFrequentActivityCount;
  final Map<String, int> moodCounts;
  final Map<String, double> moodPercentages;

  const InsightsData({
    required this.totalCapturedDays,
    required this.currentStreak,
    this.mostCommonMood,
    this.mostCommonMoodType,
    this.mostCommonMoodCount = 0,
    required this.averageIntensity,
    required this.averageEnergyNumeric,
    required this.averageEnergyLabel,
    this.mostFrequentActivity,
    this.mostFrequentActivityCount = 0,
    required this.moodCounts,
    required this.moodPercentages,
  });

  /// Factory for an empty dataset before entries exist.
  factory InsightsData.empty() {
    return const InsightsData(
      totalCapturedDays: 0,
      currentStreak: 0,
      averageIntensity: 0.0,
      averageEnergyNumeric: 0.0,
      averageEnergyLabel: 'No data',
      moodCounts: {},
      moodPercentages: {},
    );
  }

  bool get hasEnoughData => totalCapturedDays > 0;
}
