import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../capture/presentation/providers/entry_repository_provider.dart';


/// Notifier managing user's preferred display name.
class UserNameNotifier extends Notifier<String> {
  @override
  String build() {
    final repo = ref.watch(dailyEntryRepositoryProvider);
    repo.getSetting('user_name').then((val) {
      if (val != null && val.trim().isNotEmpty) {
        state = val.trim();
      }
    });
    return 'Suraksha';
  }

  Future<void> setUserName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isNotEmpty) {
      state = trimmed;
      final repo = ref.read(dailyEntryRepositoryProvider);
      await repo.setSetting('user_name', trimmed);
    }
  }
}

final userNameProvider =
    NotifierProvider<UserNameNotifier, String>(UserNameNotifier.new);

/// Notifier managing daily reminder toggle.
class ReminderEnabledNotifier extends Notifier<bool> {
  @override
  bool build() {
    final repo = ref.watch(dailyEntryRepositoryProvider);
    repo.getSetting('daily_reminder_enabled').then((val) {
      if (val != null) {
        state = val == 'true';
      }
    });
    return true;
  }

  Future<void> toggle() async {
    state = !state;
    final repo = ref.read(dailyEntryRepositoryProvider);
    await repo.setSetting('daily_reminder_enabled', state ? 'true' : 'false');
  }
}

final reminderEnabledProvider =
    NotifierProvider<ReminderEnabledNotifier, bool>(ReminderEnabledNotifier.new);
