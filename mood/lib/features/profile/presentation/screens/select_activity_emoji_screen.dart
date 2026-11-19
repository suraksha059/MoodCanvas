import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../onboarding/presentation/theme/onboarding_colors.dart';

/// Full-screen emoji picker matching 88_Light & 89_Light (Select Activity Emoji).
class SelectActivityEmojiScreen extends StatefulWidget {
  const SelectActivityEmojiScreen({super.key});

  @override
  State<SelectActivityEmojiScreen> createState() =>
      _SelectActivityEmojiScreenState();
}

class _SelectActivityEmojiScreenState extends State<SelectActivityEmojiScreen> {
  int _selectedCategory = 0;
  String _query = '';

  static const _categories = [
    'Smileys',
    'Animals & Nature',
    'Food & Drink',
    'Activity',
    'Travel & Places',
    'Objects',
  ];

  static const Map<int, List<({String emoji, String name})>> _emojisByCategory = {
    0: [
      (emoji: '😀', name: 'grin'), (emoji: '😃', name: 'smile'),
      (emoji: '😄', name: 'happy'), (emoji: '😁', name: 'beam'),
      (emoji: '😆', name: 'laugh'), (emoji: '😅', name: 'sweat'),
      (emoji: '😂', name: 'joy'), (emoji: '🤣', name: 'rofl'),
      (emoji: '😊', name: 'blush'), (emoji: '😇', name: 'angel'),
      (emoji: '🙂', name: 'slight smile'), (emoji: '😉', name: 'wink'),
      (emoji: '😌', name: 'relieved calm'), (emoji: '😍', name: 'heart eyes'),
      (emoji: '🥰', name: 'love'), (emoji: '😘', name: 'kiss'),
      (emoji: '😋', name: 'yum'), (emoji: '😜', name: 'crazy'),
      (emoji: '🤓', name: 'nerd'), (emoji: '😎', name: 'cool'),
      (emoji: '🤩', name: 'star excited'), (emoji: '🥳', name: 'party'),
      (emoji: '😔', name: 'sad pensive'), (emoji: '😞', name: 'disappointed'),
      (emoji: '😟', name: 'worried'), (emoji: '😕', name: 'confused'),
      (emoji: '😣', name: 'stressed'), (emoji: '😫', name: 'tired'),
      (emoji: '😢', name: 'cry'), (emoji: '😭', name: 'sob'),
      (emoji: '😤', name: 'triumph'), (emoji: '😠', name: 'angry'),
      (emoji: '😡', name: 'rage'), (emoji: '🤯', name: 'mind blown'),
      (emoji: '😳', name: 'flushed'), (emoji: '😱', name: 'scream'),
      (emoji: '🤔', name: 'thinking'), (emoji: '😴', name: 'sleep'),
    ],
    1: [
      (emoji: '🐶', name: 'dog'), (emoji: '🐱', name: 'cat'),
      (emoji: '🦊', name: 'fox'), (emoji: '🐻', name: 'bear'),
      (emoji: '🐼', name: 'panda'), (emoji: '🦁', name: 'lion'),
      (emoji: '🦋', name: 'butterfly'), (emoji: '🐝', name: 'bee'),
      (emoji: '🌸', name: 'blossom'), (emoji: '🌻', name: 'sunflower'),
      (emoji: '🌹', name: 'rose'), (emoji: '🌿', name: 'herb leaf'),
      (emoji: '🪴', name: 'plant'), (emoji: '🌴', name: 'palm tree'),
      (emoji: '☀️', name: 'sun'), (emoji: '🌙', name: 'moon'),
      (emoji: '⭐', name: 'star'), (emoji: '🌈', name: 'rainbow'),
      (emoji: '☁️', name: 'cloud'), (emoji: '🌧️', name: 'rain'),
      (emoji: '❄️', name: 'snow'), (emoji: '🔥', name: 'fire'),
      (emoji: '💧', name: 'water'), (emoji: '🌊', name: 'wave'),
    ],
    2: [
      (emoji: '🍎', name: 'apple'), (emoji: '🥑', name: 'avocado'),
      (emoji: '🥐', name: 'croissant'), (emoji: '🍳', name: 'cooking'),
      (emoji: '🥗', name: 'salad'), (emoji: '🍔', name: 'burger'),
      (emoji: '🍕', name: 'pizza'), (emoji: '🍜', name: 'ramen'),
      (emoji: '🍲', name: 'dinner'), (emoji: '🍣', name: 'sushi'),
      (emoji: '🍰', name: 'cake'), (emoji: '🍿', name: 'popcorn'),
      (emoji: '☕', name: 'coffee'), (emoji: '🍵', name: 'tea'),
      (emoji: '🧋', name: 'boba'), (emoji: '🧃', name: 'juice'),
      (emoji: '🍷', name: 'wine'), (emoji: '🥂', name: 'cheers'),
    ],
    3: [
      (emoji: '⚽', name: 'soccer'), (emoji: '🏀', name: 'basketball'),
      (emoji: '🎾', name: 'tennis'), (emoji: '🏋️', name: 'gym exercise'),
      (emoji: '🚴', name: 'cycling'), (emoji: '🏃', name: 'running'),
      (emoji: '🏊', name: 'swimming'), (emoji: '🧘', name: 'yoga'),
      (emoji: '🎨', name: 'art painting'), (emoji: '🎵', name: 'music'),
      (emoji: '🎮', name: 'gaming'), (emoji: '🎬', name: 'movie'),
      (emoji: '🎤', name: 'singing'), (emoji: '📚', name: 'reading'),
      (emoji: '🎯', name: 'goal target'), (emoji: '🏆', name: 'trophy'),
      (emoji: '🧩', name: 'puzzle'), (emoji: '🎸', name: 'guitar'),
    ],
    4: [
      (emoji: '🚗', name: 'car commute'), (emoji: '🚕', name: 'taxi'),
      (emoji: '🚙', name: 'suv'), (emoji: '🚌', name: 'bus'),
      (emoji: '🚎', name: 'trolley'), (emoji: '🚓', name: 'police'),
      (emoji: '🚑', name: 'ambulance'), (emoji: '🚒', name: 'fire truck'),
      (emoji: '🚐', name: 'van'), (emoji: '🚚', name: 'truck'),
      (emoji: '🚲', name: 'bike'), (emoji: '🛵', name: 'scooter'),
      (emoji: '🏍️', name: 'motorcycle'), (emoji: '🚆', name: 'train'),
      (emoji: '🚇', name: 'metro'), (emoji: '✈️', name: 'airplane travel'),
      (emoji: '🚀', name: 'rocket'), (emoji: '🚁', name: 'helicopter'),
      (emoji: '🏠', name: 'home house'), (emoji: '🏢', name: 'office'),
      (emoji: '🏕️', name: 'camping'), (emoji: '🏖️', name: 'beach'),
      (emoji: '🗽', name: 'statue'), (emoji: '🏰', name: 'castle'),
    ],
    5: [
      (emoji: '⏰', name: 'alarm overtime'), (emoji: '⏳', name: 'hourglass focus'),
      (emoji: '📅', name: 'calendar meeting'), (emoji: '📌', name: 'pin deadline'),
      (emoji: '📝', name: 'memo notes'), (emoji: '📊', name: 'chart projects'),
      (emoji: '📈', name: 'growth promotion'), (emoji: '💻', name: 'laptop work'),
      (emoji: '📱', name: 'phone'), (emoji: '🎧', name: 'headphones'),
      (emoji: '💊', name: 'pill medication'), (emoji: '🩺', name: 'doctor'),
      (emoji: '🧹', name: 'broom cleaning'), (emoji: '🧺', name: 'laundry'),
      (emoji: '🛒', name: 'shopping cart'), (emoji: '🎁', name: 'gift'),
      (emoji: '💡', name: 'idea bulb'), (emoji: '🔑', name: 'key'),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final List<({String emoji, String name})> displayed;
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      displayed = _emojisByCategory.values
          .expand((list) => list)
          .where((e) => e.name.contains(q) || e.emoji.contains(q))
          .toList();
    } else {
      displayed = _emojisByCategory[_selectedCategory] ?? const [];
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: OnboardingColors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Top Bar: X | "Select Activity Emoji"
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close_rounded,
                        size: 24,
                        color: OnboardingColors.textDark,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Select Activity Emoji',
                        textAlign: TextAlign.center,
                        style: AppTypography.titleLarge.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: OnboardingColors.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Search Emojis Input
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
                child: TextField(
                  onChanged: (v) => setState(() => _query = v.trim()),
                  style: AppTypography.bodyMedium.copyWith(
                    color: OnboardingColors.textDark,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search emojis...',
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      color: OnboardingColors.textLight,
                    ),
                    filled: true,
                    fillColor: OnboardingColors.backgroundLight,
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: OnboardingColors.textLight,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Category Filter Pills
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final selected = _selectedCategory == index && _query.isEmpty;
                    return GestureDetector(
                      onTap: () => setState(() {
                        _selectedCategory = index;
                        _query = '';
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? OnboardingColors.primaryGreen
                              : OnboardingColors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: selected
                                ? OnboardingColors.primaryGreen
                                : OnboardingColors.borderLight,
                          ),
                        ),
                        child: Text(
                          _categories[index],
                          style: AppTypography.label.copyWith(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: selected
                                ? Colors.white
                                : OnboardingColors.textDark,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // 6-Column Emoji Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  itemCount: displayed.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final item = displayed[index];
                    return InkWell(
                      onTap: () => Navigator.of(context).pop(item.emoji),
                      borderRadius: BorderRadius.circular(12),
                      child: Center(
                        child: Text(
                          item.emoji,
                          style: const TextStyle(fontSize: 30),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
