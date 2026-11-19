import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActivityItemModel {
  final String id;
  final String emoji;
  final String name;

  const ActivityItemModel({
    required this.id,
    required this.emoji,
    required this.name,
  });

  ActivityItemModel copyWith({String? emoji, String? name}) {
    return ActivityItemModel(
      id: id,
      emoji: emoji ?? this.emoji,
      name: name ?? this.name,
    );
  }
}

class ActivityGroupModel {
  final String id;
  final String name;
  final bool enabled;
  final List<ActivityItemModel> activities;

  const ActivityGroupModel({
    required this.id,
    required this.name,
    required this.enabled,
    required this.activities,
  });

  ActivityGroupModel copyWith({
    String? name,
    bool? enabled,
    List<ActivityItemModel>? activities,
  }) {
    return ActivityGroupModel(
      id: id,
      name: name ?? this.name,
      enabled: enabled ?? this.enabled,
      activities: activities ?? this.activities,
    );
  }
}

List<ActivityItemModel> _makeItems(String prefix, List<(String, String)> pairs) {
  return List.generate(
    pairs.length,
    (i) => ActivityItemModel(
      id: '${prefix}_$i',
      emoji: pairs[i].$1,
      name: pairs[i].$2,
    ),
  );
}

final List<ActivityGroupModel> _initialActivityGroups = [
  ActivityGroupModel(
    id: 'emotions',
    name: 'Emotions',
    enabled: true,
    activities: _makeItems('emo', [
      ('😊', 'Happy'), ('😌', 'Calm'), ('🙏', 'Grateful'), ('🤩', 'Excited'),
      ('😎', 'Confident'), ('☀️', 'Energized'), ('🥰', 'Loved'), ('✨', 'Inspired'),
      ('😴', 'Tired'), ('😔', 'Sad'), ('😰', 'Anxious'), ('😡', 'Angry'),
      ('😣', 'Stressed'), ('😕', 'Confused'), ('🥱', 'Bored'), ('😌', 'Content'),
      ('🥳', 'Proud'), ('😇', 'Peaceful'), ('🤗', 'Hopeful'), ('🥹', 'Touched'),
    ]),
  ),
  ActivityGroupModel(
    id: 'work',
    name: 'Work',
    enabled: true,
    activities: _makeItems('work', [
      ('⏰', 'Overtime'),
      ('👥', 'Teamwork'),
      ('📅', 'Meeting'),
      ('📌', 'Deadline'),
      ('🗣️', 'Presentation'),
      ('🌴', 'Vacation'),
      ('🏠', 'Remote Work'),
      ('📈', 'Promotion'),
    ]),
  ),
  ActivityGroupModel(
    id: 'school',
    name: 'School',
    enabled: true,
    activities: _makeItems('sch', [
      ('📚', 'Classes'), ('📝', 'Exams'), ('📊', 'Projects'), ('🎓', 'Lectures'),
      ('📖', 'Homework'), ('🧪', 'Lab'), ('🚌', 'Field Trip'), ('🏆', 'Awards'),
    ]),
  ),
  ActivityGroupModel(
    id: 'health',
    name: 'Health',
    enabled: true,
    activities: _makeItems('hlt', [
      ('🏋️', 'Exercise'), ('💊', 'Medication'), ('🛋️', 'Therapy'), ('🩺', 'Doctor Visit'),
      ('💧', 'Hydration'), ('🧘', 'Yoga'), ('🪥', 'Self-Care'),
    ]),
  ),
  ActivityGroupModel(
    id: 'relationships',
    name: 'Relationships',
    enabled: false,
    activities: _makeItems('rel', [
      ('❤️', 'Partner'), ('👨‍👩‍👧', 'Family'), ('🧑‍🤝‍🧑', 'Friends'), ('🌹', 'Date Night'),
      ('💬', 'Deep Talk'), ('🤗', 'Support'), ('🎁', 'Gift'), ('📞', 'Phone Call'),
      ('⚡', 'Conflict'), ('🎉', 'Celebration'),
    ]),
  ),
  ActivityGroupModel(
    id: 'sleep',
    name: 'Sleep',
    enabled: true,
    activities: _makeItems('slp', [
      ('💤', 'Nap'), ('🌙', 'Dream'), ('😴', 'Deep Sleep'), ('⏰', 'Early Wake'),
      ('🦉', 'Late Night'), ('😵', 'Insomnia'), ('🛏️', 'Restless'), ('🌅', 'Refreshed'),
    ]),
  ),
  ActivityGroupModel(
    id: 'food',
    name: 'Food',
    enabled: true,
    activities: _makeItems('food', [
      ('🥐', 'Breakfast'), ('🥗', 'Lunch'), ('🍲', 'Dinner'), ('🍎', 'Fruits'),
      ('🍰', 'Dessert'), ('🍿', 'Snacks'), ('🍳', 'Cooking'), ('🍔', 'Fast Food'),
      ('🥑', 'Healthy Eating'), ('🍜', 'Takeout'),
    ]),
  ),
  ActivityGroupModel(
    id: 'drinks',
    name: 'Drinks',
    enabled: false,
    activities: _makeItems('drk', [
      ('💧', 'Water'), ('☕', 'Coffee'), ('🍵', 'Tea'), ('🧃', 'Juice'),
      ('🥤', 'Soda'), ('🧋', 'Boba'), ('🥛', 'Milk'), ('🍋', 'Lemonade'),
      ('🍷', 'Wine'), ('🍺', 'Beer'),
    ]),
  ),
  ActivityGroupModel(
    id: 'hobbies',
    name: 'Hobbies',
    enabled: true,
    activities: _makeItems('hob', [
      ('📚', 'Reading'), ('🎨', 'Painting'), ('🎮', 'Gaming'), ('🎵', 'Music'),
      ('🌻', 'Gardening'), ('✍️', 'Writing'), ('📷', 'Photography'), ('🎬', 'Movies'),
      ('🧶', 'Knitting'), ('🧩', 'Puzzles'), ('✈️', 'Traveling'),
    ]),
  ),
  ActivityGroupModel(
    id: 'social',
    name: 'Social',
    enabled: true,
    activities: _makeItems('soc', [
      ('🥳', 'Party'), ('🍽️', 'Dining Out'), ('🎤', 'Karaoke'), ('☕', 'Coffee Chat'),
      ('🎟️', 'Concert'), ('🤝', 'Networking'), ('🛍️', 'Hangout'), ('🏕️', 'Camping'),
    ]),
  ),
  ActivityGroupModel(
    id: 'better_me',
    name: 'Better Me',
    enabled: true,
    activities: _makeItems('btm', [
      ('🧘', 'Meditation'), ('📓', 'Journaling'), ('🎯', 'Goal Setting'), ('🙏', 'Gratitude'),
      ('🌅', 'Morning Routine'), ('📵', 'Digital Detox'), ('🧠', 'Learning'), ('🌿', 'Mindfulness'),
    ]),
  ),
  ActivityGroupModel(
    id: 'productivity',
    name: 'Productivity',
    enabled: true,
    activities: _makeItems('prd', [
      ('⏳', 'Focus Time'), ('📋', 'Planning'), ('✅', 'To-Do Done'), ('💻', 'Deep Work'),
      ('📧', 'Inbox Zero'), ('🗂️', 'Organizing'), ('💡', 'Brainstorming'),
    ]),
  ),
  ActivityGroupModel(
    id: 'chores',
    name: 'Chores',
    enabled: true,
    activities: _makeItems('chr', [
      ('🧹', 'Cleaning'), ('🧺', 'Laundry'), ('🛒', 'Groceries'), ('🍽️', 'Dishes'),
      ('🪴', 'Plant Care'), ('🗑️', 'Declutter'), ('🔧', 'Repairs'), ('🐶', 'Pet Care'),
    ]),
  ),
  ActivityGroupModel(
    id: 'weather',
    name: 'Weather',
    enabled: true,
    activities: _makeItems('wth', [
      ('☀️', 'Sunny'), ('☁️', 'Cloudy'), ('🌧️', 'Rainy'), ('🔥', 'Hot'),
      ('❄️', 'Snowy'), ('💨', 'Windy'), ('⛈️', 'Stormy'), ('🌫️', 'Foggy'),
      ('🌈', 'Rainbow'), ('🌡️', 'Humid'),
    ]),
  ),
  ActivityGroupModel(
    id: 'beauty',
    name: 'Beauty',
    enabled: false,
    activities: _makeItems('bty', [
      ('🧴', 'Skincare'), ('💆', 'Spa'), ('💇', 'Haircut'), ('💅', 'Manicure'),
      ('🛁', 'Bath'), ('💄', 'Makeup'), ('🧖', 'Face Mask'), ('🪥', 'Grooming'),
      ('🌸', 'Perfume'), ('✨', 'Glow Up'),
    ]),
  ),
  ActivityGroupModel(
    id: 'events',
    name: 'Events',
    enabled: false,
    activities: _makeItems('evt', [
      ('🎂', 'Birthday'), ('💍', 'Wedding'), ('🎄', 'Holiday'), ('🎆', 'Festival'),
      ('🎓', 'Graduation'), ('🎤', 'Show'), ('🏟️', 'Match'), ('🥂', 'Anniversary'),
      ('🛫', 'Trip'), ('🎉', 'Reunion'),
    ]),
  ),
  ActivityGroupModel(
    id: 'sports',
    name: 'Sports',
    enabled: true,
    activities: _makeItems('spt', [
      ('🏃', 'Running'), ('🚴', 'Cycling'), ('🏊', 'Swimming'), ('⚽', 'Soccer'),
      ('🏀', 'Basketball'), ('🎾', 'Tennis'), ('🥾', 'Hiking'), ('🥊', 'Boxing'),
    ]),
  ),
  ActivityGroupModel(
    id: 'other',
    name: 'Other',
    enabled: false,
    activities: _makeItems('oth', [
      ('🚗', 'Commute'), ('📦', 'Delivery'), ('🏦', 'Banking'), ('🧾', 'Bills'),
      ('📰', 'News'), ('🎧', 'Podcast'), ('🪴', 'Nature'), ('💤', 'Relaxing'),
      ('📱', 'Screen Time'), ('✨', 'Surprise'),
    ]),
  ),
];

class ManageActivitiesNotifier extends Notifier<List<ActivityGroupModel>> {
  @override
  List<ActivityGroupModel> build() => List<ActivityGroupModel>.from(_initialActivityGroups);

  void toggleGroup(String groupId) {
    state = [
      for (final g in state)
        if (g.id == groupId) g.copyWith(enabled: !g.enabled) else g,
    ];
  }

  void reorderGroups(int oldIndex, int newIndex) {
    final list = List<ActivityGroupModel>.from(state);
    if (newIndex > oldIndex) newIndex -= 1;
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
    state = list;
  }

  void addGroup(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    final id = 'grp_${DateTime.now().millisecondsSinceEpoch}';
    state = [
      ...state,
      ActivityGroupModel(
        id: id,
        name: trimmed,
        enabled: false,
        activities: const [],
      ),
    ];
  }

  void renameGroup(String groupId, String newName) {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) return;
    state = [
      for (final g in state)
        if (g.id == groupId) g.copyWith(name: trimmed) else g,
    ];
  }

  void deleteGroup(String groupId) {
    state = state.where((g) => g.id != groupId).toList();
  }

  void addActivity(String groupId, String emoji, String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    final newActivity = ActivityItemModel(
      id: 'act_${DateTime.now().millisecondsSinceEpoch}',
      emoji: emoji.isEmpty ? '✨' : emoji,
      name: trimmed,
    );
    state = [
      for (final g in state)
        if (g.id == groupId)
          g.copyWith(activities: [...g.activities, newActivity])
        else
          g,
    ];
  }

  void editActivity(
      String groupId, String activityId, String emoji, String newName) {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) return;
    state = [
      for (final g in state)
        if (g.id == groupId)
          g.copyWith(
            activities: [
              for (final a in g.activities)
                if (a.id == activityId)
                  a.copyWith(emoji: emoji, name: trimmed)
                else
                  a,
            ],
          )
        else
          g,
    ];
  }

  void deleteActivity(String groupId, String activityId) {
    state = [
      for (final g in state)
        if (g.id == groupId)
          g.copyWith(
            activities:
                g.activities.where((a) => a.id != activityId).toList(),
          )
        else
          g,
    ];
  }

  void reorderActivities(String groupId, int oldIndex, int newIndex) {
    state = [
      for (final g in state)
        if (g.id == groupId)
          () {
            final items = List<ActivityItemModel>.from(g.activities);
            if (newIndex > oldIndex) newIndex -= 1;
            final moved = items.removeAt(oldIndex);
            items.insert(newIndex, moved);
            return g.copyWith(activities: items);
          }()
        else
          g,
    ];
  }
}

final manageActivitiesProvider =
    NotifierProvider<ManageActivitiesNotifier, List<ActivityGroupModel>>(
  ManageActivitiesNotifier.new,
);
