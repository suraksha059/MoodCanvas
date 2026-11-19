import '../../action/domain/models/micro_action.dart';
import 'energy_level.dart';
import 'mood_type.dart';

/// Immutable state holding the in-progress human-centered emotional journey.
class DailyCaptureState {
  final MoodType? mood;
  final int moodIntensity; // 1 to 10
  final EnergyLevel? energy;
  final Set<String> activities;
  final NeedType? need;
  final ContextTime? contextTime;
  final ContextLocation? contextLocation;
  final MicroAction? selectedAction;
  final bool actionCompleted;
  final String? afterMood;
  final int? afterIntensity;
  final String journal;
  final int currentStep; // 0: Feeling, 1: Need, 2: Context, 3: Action, 4: Reflection, 5: Preview

  const DailyCaptureState({
    this.mood,
    this.moodIntensity = 5,
    this.energy,
    this.activities = const {},
    this.need,
    this.contextTime = ContextTime.tenMin,
    this.contextLocation = ContextLocation.home,
    this.selectedAction,
    this.actionCompleted = false,
    this.afterMood,
    this.afterIntensity,
    this.journal = '',
    this.currentStep = 0,
  });

  /// True when the user has selected their initial emotional state.
  bool get isMoodValid => mood != null;

  /// True when a core human need is selected.
  bool get isNeedValid => need != null;

  /// Check if the current step can advance.
  bool get canAdvanceFromCurrentStep {
    switch (currentStep) {
      case 0:
        return isMoodValid;
      case 1:
        return isNeedValid;
      case 2: // Context is optional
      case 3: // Action can be completed or moved forward
      case 4: // After reflection
        return true;
      default:
        return true;
    }
  }

  DailyCaptureState copyWith({
    MoodType? mood,
    int? moodIntensity,
    EnergyLevel? energy,
    Set<String>? activities,
    NeedType? need,
    ContextTime? contextTime,
    ContextLocation? contextLocation,
    MicroAction? selectedAction,
    bool? actionCompleted,
    String? afterMood,
    int? afterIntensity,
    String? journal,
    int? currentStep,
  }) {
    return DailyCaptureState(
      mood: mood ?? this.mood,
      moodIntensity: moodIntensity ?? this.moodIntensity,
      energy: energy ?? this.energy,
      activities: activities ?? this.activities,
      need: need ?? this.need,
      contextTime: contextTime ?? this.contextTime,
      contextLocation: contextLocation ?? this.contextLocation,
      selectedAction: selectedAction ?? this.selectedAction,
      actionCompleted: actionCompleted ?? this.actionCompleted,
      afterMood: afterMood ?? this.afterMood,
      afterIntensity: afterIntensity ?? this.afterIntensity,
      journal: journal ?? this.journal,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}
