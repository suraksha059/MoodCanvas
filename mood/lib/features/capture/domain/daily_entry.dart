import 'dart:convert';

/// Domain entity representing a complete daily emotional memory entry.
class DailyEntry {
  final String id;
  final DateTime date;
  final String dateString; // Normalized 'YYYY-MM-DD'
  final String mood;
  final int moodIntensity;
  final String energy;
  final List<String> activities;
  final String journal;
  final int canvasSeed;
  final String? needed;
  final String? actionTaken;
  final String? afterMood;
  final int? afterIntensity;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DailyEntry({
    required this.id,
    required this.date,
    required this.dateString,
    required this.mood,
    required this.moodIntensity,
    required this.energy,
    required this.activities,
    required this.journal,
    required this.canvasSeed,
    this.needed,
    this.actionTaken,
    this.afterMood,
    this.afterIntensity,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Formats date to 'YYYY-MM-DD' for date-based lookups and uniqueness.
  static String toDateString(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  DailyEntry copyWith({
    String? id,
    DateTime? date,
    String? dateString,
    String? mood,
    int? moodIntensity,
    String? energy,
    List<String>? activities,
    String? journal,
    int? canvasSeed,
    String? needed,
    String? actionTaken,
    String? afterMood,
    int? afterIntensity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DailyEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      dateString: dateString ?? this.dateString,
      mood: mood ?? this.mood,
      moodIntensity: moodIntensity ?? this.moodIntensity,
      energy: energy ?? this.energy,
      activities: activities ?? this.activities,
      journal: journal ?? this.journal,
      canvasSeed: canvasSeed ?? this.canvasSeed,
      needed: needed ?? this.needed,
      actionTaken: actionTaken ?? this.actionTaken,
      afterMood: afterMood ?? this.afterMood,
      afterIntensity: afterIntensity ?? this.afterIntensity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'dateString': dateString,
      'mood': mood,
      'moodIntensity': moodIntensity,
      'energy': energy,
      'activities': jsonEncode(activities),
      'journal': journal,
      'canvasSeed': canvasSeed,
      'needed': needed,
      'actionTaken': actionTaken,
      'afterMood': afterMood,
      'afterIntensity': afterIntensity,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory DailyEntry.fromMap(Map<String, dynamic> map) {
    return DailyEntry(
      id: map['id'] as String,
      date: DateTime.parse(map['date'] as String),
      dateString: map['dateString'] as String,
      mood: map['mood'] as String,
      moodIntensity: map['moodIntensity'] as int,
      energy: map['energy'] as String,
      activities: List<String>.from(jsonDecode(map['activities'] as String)),
      journal: map['journal'] as String,
      canvasSeed: map['canvasSeed'] as int,
      needed: map['needed'] as String?,
      actionTaken: map['actionTaken'] as String?,
      afterMood: map['afterMood'] as String?,
      afterIntensity: map['afterIntensity'] as int?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }
}
