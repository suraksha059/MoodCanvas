import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Immutable state holding all user preferences collected during the
/// 8-step account setup wizard.
class AccountSetupState {
  final String email;
  final String nickname;
  final String gender; // 'Male', 'Female', 'Prefer not to say'
  final int age;
  final int emojiThemeIndex;
  final int colorPaletteIndex;
  final Set<String> recordCategories;
  final int reminderHour;
  final int reminderMinute;
  final String referralSource;

  const AccountSetupState({
    this.email = '',
    this.nickname = '',
    this.gender = 'Male',
    this.age = 28,
    this.emojiThemeIndex = 0,
    this.colorPaletteIndex = 0,
    this.recordCategories = const {
      'Emotions',
      'Work',
      'School',
      'Health',
      'Sleep',
      'Food',
      'Hobbies',
    },
    this.reminderHour = 20,
    this.reminderMinute = 0,
    this.referralSource = 'Social Media',
  });

  AccountSetupState copyWith({
    String? email,
    String? nickname,
    String? gender,
    int? age,
    int? emojiThemeIndex,
    int? colorPaletteIndex,
    Set<String>? recordCategories,
    int? reminderHour,
    int? reminderMinute,
    String? referralSource,
  }) {
    return AccountSetupState(
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      emojiThemeIndex: emojiThemeIndex ?? this.emojiThemeIndex,
      colorPaletteIndex: colorPaletteIndex ?? this.colorPaletteIndex,
      recordCategories: recordCategories ?? this.recordCategories,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      referralSource: referralSource ?? this.referralSource,
    );
  }
}

/// Available 5-color mood palettes matching 13_Light & 14_Light_account setup.
const List<List<Color>> moodColorPalettes = [
  // Classic Traffic / Mood
  [
    Color(0xFFEF5350),
    Color(0xFFFFA726),
    Color(0xFFFFCA28),
    Color(0xFF8BC34A),
    Color(0xFF4CAF50),
  ],
  // Pastel Pop
  [
    Color(0xFFA78BFA),
    Color(0xFF38BDF8),
    Color(0xFF9CCC65),
    Color(0xFFFCD34D),
    Color(0xFFF45B69),
  ],
  // Ocean Sun
  [
    Color(0xFF4FC3F7),
    Color(0xFFFFEE58),
    Color(0xFF8BC34A),
    Color(0xFFEF5350),
    Color(0xFFFB8C00),
  ],
  // Berry Vibrant (Premium)
  [
    Color(0xFFEC407A),
    Color(0xFFFF7043),
    Color(0xFFFFCA28),
    Color(0xFF66BB6A),
    Color(0xFF26A69A),
  ],
];

class AccountSetupNotifier extends Notifier<AccountSetupState> {
  @override
  AccountSetupState build() => const AccountSetupState();

  void setEmail(String email) => state = state.copyWith(email: email);
  void setNickname(String nickname) => state = state.copyWith(nickname: nickname);
  void setGender(String gender) => state = state.copyWith(gender: gender);
  void setAge(int age) => state = state.copyWith(age: age);
  void setEmojiTheme(int index) => state = state.copyWith(emojiThemeIndex: index);
  void setColorPalette(int index) => state = state.copyWith(colorPaletteIndex: index);

  void toggleCategory(String category) {
    final updated = Set<String>.from(state.recordCategories);
    if (updated.contains(category)) {
      updated.remove(category);
    } else {
      updated.add(category);
    }
    state = state.copyWith(recordCategories: updated);
  }

  void setReminderTime(int hour, int minute) {
    state = state.copyWith(reminderHour: hour, reminderMinute: minute);
  }

  void setReferralSource(String source) {
    state = state.copyWith(referralSource: source);
  }
}

final accountSetupProvider =
    NotifierProvider<AccountSetupNotifier, AccountSetupState>(
  AccountSetupNotifier.new,
);
