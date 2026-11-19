import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../action/domain/models/micro_action.dart';
import '../../../action/domain/engine/action_recommendation_engine.dart';
import '../../domain/daily_capture_state.dart';
import '../../domain/daily_entry.dart';
import '../../domain/energy_level.dart';
import '../../domain/mood_type.dart';

/// Riverpod Notifier managing the in-memory human-centered emotional journey.
class DailyCaptureNotifier extends Notifier<DailyCaptureState> {
  @override
  DailyCaptureState build() {
    return const DailyCaptureState();
  }

  void setMood(MoodType mood) {
    state = state.copyWith(mood: mood);
  }

  void setIntensity(int intensity) {
    state = state.copyWith(moodIntensity: intensity.clamp(1, 10));
  }

  void setEnergy(EnergyLevel energy) {
    state = state.copyWith(energy: energy);
  }

  void setNeed(NeedType need) {
    final recommendations = ActionRecommendationEngine.getRecommendations(
      need: need,
      time: state.contextTime,
      location: state.contextLocation,
    );

    state = state.copyWith(
      need: need,
      selectedAction: recommendations.isNotEmpty ? recommendations.first : null,
    );
  }

  void setContextTime(ContextTime time) {
    state = state.copyWith(contextTime: time);
    _refreshRecommendation();
  }

  void setContextLocation(ContextLocation location) {
    state = state.copyWith(contextLocation: location);
    _refreshRecommendation();
  }

  void setSelectedAction(MicroAction action) {
    state = state.copyWith(selectedAction: action);
  }

  void shuffleAction() {
    if (state.need == null) return;
    final all = ActionRecommendationEngine.getRecommendations(
      need: state.need!,
      time: state.contextTime,
      location: state.contextLocation,
    );
    if (all.length <= 1) return;

    final currentIndex = all.indexWhere((a) => a.id == state.selectedAction?.id);
    final nextIndex = (currentIndex + 1) % all.length;
    state = state.copyWith(selectedAction: all[nextIndex]);
  }

  void _refreshRecommendation() {
    if (state.need != null) {
      final all = ActionRecommendationEngine.getRecommendations(
        need: state.need!,
        time: state.contextTime,
        location: state.contextLocation,
      );
      if (all.isNotEmpty) {
        state = state.copyWith(selectedAction: all.first);
      }
    }
  }

  void setActionCompleted(bool completed) {
    state = state.copyWith(actionCompleted: completed);
  }

  void setAfterReflection({
    String? afterMood,
    int? afterIntensity,
    String? journal,
  }) {
    state = state.copyWith(
      afterMood: afterMood ?? state.afterMood,
      afterIntensity: afterIntensity ?? state.afterIntensity,
      journal: journal ?? state.journal,
    );
  }

  void toggleActivity(String activity) {
    final updated = Set<String>.from(state.activities);
    if (updated.contains(activity)) {
      updated.remove(activity);
    } else {
      updated.add(activity);
    }
    state = state.copyWith(activities: updated);
  }

  void setJournal(String text) {
    state = state.copyWith(journal: text);
  }

  void goToStep(int step) {
    state = state.copyWith(currentStep: step.clamp(0, 4));
  }

  bool nextStep() {
    if (state.canAdvanceFromCurrentStep && state.currentStep < 4) {
      state = state.copyWith(currentStep: state.currentStep + 1);
      return true;
    }
    return false;
  }

  bool previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
      return true;
    }
    return false;
  }

  void loadFromEntry(DailyEntry entry) {
    MoodType parsedMood = MoodType.calm;
    for (final m in MoodType.values) {
      if (m.label.toLowerCase() == entry.mood.toLowerCase() ||
          m.name.toLowerCase() == entry.mood.toLowerCase()) {
        parsedMood = m;
        break;
      }
    }

    EnergyLevel parsedEnergy = EnergyLevel.balanced;
    for (final e in EnergyLevel.values) {
      if (e.label.toLowerCase() == entry.energy.toLowerCase() ||
          e.name.toLowerCase() == entry.energy.toLowerCase()) {
        parsedEnergy = e;
        break;
      }
    }

    NeedType? parsedNeed;
    if (entry.needed != null) {
      for (final n in NeedType.values) {
        if (n.label.toLowerCase() == entry.needed!.toLowerCase() ||
            n.name.toLowerCase() == entry.needed!.toLowerCase()) {
          parsedNeed = n;
          break;
        }
      }
    }

    state = DailyCaptureState(
      mood: parsedMood,
      moodIntensity: entry.moodIntensity,
      energy: parsedEnergy,
      activities: entry.activities.toSet(),
      need: parsedNeed,
      afterMood: entry.afterMood,
      afterIntensity: entry.afterIntensity,
      journal: entry.journal,
      currentStep: 0,
    );
  }

  void reset() {
    state = const DailyCaptureState();
  }
}

/// Provider for the in-progress daily capture session.
final dailyCaptureProvider =
    NotifierProvider<DailyCaptureNotifier, DailyCaptureState>(
  DailyCaptureNotifier.new,
);
