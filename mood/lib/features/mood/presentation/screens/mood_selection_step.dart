import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../capture/domain/mood_type.dart';
import '../../../capture/presentation/providers/daily_capture_provider.dart';
import '../widgets/intensity_slider.dart';
import '../widgets/mood_card.dart';

/// Step 1 of Daily Capture: Mood Selection & Intensity.
class MoodSelectionStep extends ConsumerWidget {
  const MoodSelectionStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final captureState = ref.watch(dailyCaptureProvider);
    final notifier = ref.read(dailyCaptureProvider.notifier);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Prompt Header
          Text(
            'How was your mood today?',
            style: AppTypography.displayLarge.copyWith(
              fontSize: 26,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose the primary emotion that defined your day.',
            style: AppTypography.bodyLarge,
          ),

          const SizedBox(height: 24),

          // Mood List (2 columns or responsive cards)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: MoodType.values.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final mood = MoodType.values[index];
              final isSelected = captureState.mood == mood;

              return MoodCard(
                mood: mood,
                isSelected: isSelected,
                onTap: () => notifier.setMood(mood),
              );
            },
          ),

          // Dynamic Intensity Slider (Appears when mood is selected)
          if (captureState.mood != null) ...[
            const SizedBox(height: 28),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: 1.0,
              child: IntensitySlider(
                intensity: captureState.moodIntensity,
                activeColor: captureState.mood!.primaryColor,
                onChanged: (val) => notifier.setIntensity(val),
              ),
            ),
          ],

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
