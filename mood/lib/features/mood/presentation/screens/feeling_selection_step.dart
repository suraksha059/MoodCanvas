import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../capture/domain/mood_type.dart';
import '../../../capture/presentation/providers/daily_capture_provider.dart';
import '../widgets/intensity_slider.dart';

/// Human emotional feeling option.
class FeelingOption {
  final MoodType moodType;
  final String title;
  final String emoji;
  final String hint;

  const FeelingOption({
    required this.moodType,
    required this.title,
    required this.emoji,
    required this.hint,
  });
}

/// Step 0: "How are you doing right now?"
/// Non-judgmental, mature, human emotional check-in with custom feeling options.
class FeelingSelectionStep extends ConsumerStatefulWidget {
  const FeelingSelectionStep({super.key});

  @override
  ConsumerState<FeelingSelectionStep> createState() =>
      _FeelingSelectionStepState();
}

class _FeelingSelectionStepState extends ConsumerState<FeelingSelectionStep> {
  late final TextEditingController _noteController;
  late final TextEditingController _customFeelingController;
  final List<String> _userCustomTags = [];
  bool _showCustomInput = false;

  static const List<FeelingOption> _options = [
    FeelingOption(
      moodType: MoodType.sad,
      title: 'Low',
      emoji: '😔',
      hint: 'Heavy or tender inside',
    ),
    FeelingOption(
      moodType: MoodType.anxious,
      title: 'Overwhelmed',
      emoji: '😵',
      hint: 'Too much to hold at once',
    ),
    FeelingOption(
      moodType: MoodType.tired,
      title: 'Tired',
      emoji: '😴',
      hint: 'Physically or mentally drained',
    ),
    FeelingOption(
      moodType: MoodType.lonely,
      title: 'Lonely',
      emoji: '😶',
      hint: 'Needing to feel seen or connected',
    ),
    FeelingOption(
      moodType: MoodType.angry,
      title: 'Frustrated',
      emoji: '😤',
      hint: 'Tension, irritation or friction',
    ),
    FeelingOption(
      moodType: MoodType.okay,
      title: 'Just okay',
      emoji: '😐',
      hint: 'Neutral, floating through the day',
    ),
    FeelingOption(
      moodType: MoodType.calm,
      title: 'Good / Calm',
      emoji: '🙂',
      hint: 'Steady, grounded and peaceful',
    ),
    FeelingOption(
      moodType: MoodType.happy,
      title: 'Great',
      emoji: '✨',
      hint: 'Energized, grateful or bright',
    ),
  ];

  static const List<({String label, MoodType family})> _quickNuances = [
    (label: 'Hopeful', family: MoodType.happy),
    (label: 'Peaceful', family: MoodType.calm),
    (label: 'Grateful', family: MoodType.happy),
    (label: 'Restless', family: MoodType.anxious),
    (label: 'Burned out', family: MoodType.tired),
    (label: 'Nostalgic', family: MoodType.sad),
    (label: 'Overthinking', family: MoodType.anxious),
    (label: 'Quiet / Numb', family: MoodType.okay),
    (label: 'Heartbroken', family: MoodType.sad),
    (label: 'Content', family: MoodType.calm),
  ];

  @override
  void initState() {
    super.initState();
    final initialJournal = ref.read(dailyCaptureProvider).journal;
    _noteController = TextEditingController(text: initialJournal);
    _customFeelingController = TextEditingController();
  }

  @override
  void dispose() {
    _noteController.dispose();
    _customFeelingController.dispose();
    super.dispose();
  }

  void _addCustomFeelingTag() {
    final text = _customFeelingController.text.trim();
    if (text.isNotEmpty && !_userCustomTags.contains(text)) {
      setState(() {
        _userCustomTags.add(text);
        _customFeelingController.clear();
        _showCustomInput = false;
      });

      // Also ensure a default mood is set if none chosen
      if (ref.read(dailyCaptureProvider).mood == null) {
        ref.read(dailyCaptureProvider.notifier).setMood(MoodType.okay);
      }

      _appendNoteTag(text);
    }
  }

  void _appendNoteTag(String tag) {
    final current = _noteController.text.trim();
    if (!current.contains(tag)) {
      final updated = current.isEmpty ? 'Feeling: $tag' : '$current • $tag';
      _noteController.text = updated;
      ref.read(dailyCaptureProvider.notifier).setJournal(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final captureState = ref.watch(dailyCaptureProvider);
    final notifier = ref.read(dailyCaptureProvider.notifier);
    final selectedMood = captureState.mood;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Header
          Text(
            'How are you doing?',
            style: AppTypography.displayLarge.copyWith(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryOf(context),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Honest and without judgment. Whatever is here is allowed.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondaryOf(context),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 22),

          // Feelings Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.35,
            ),
            itemCount: _options.length,
            itemBuilder: (context, index) {
              final option = _options[index];
              final isSelected = selectedMood == option.moodType;

              return InkWell(
                onTap: () => notifier.setMood(option.moodType),
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? option.moodType.primaryColor.withValues(alpha: 0.18)
                        : AppColors.surfaceOf(context),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? option.moodType.primaryColor
                          : AppColors.borderSubtleOf(context),
                      width: isSelected ? 1.8 : 1.0,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: option.moodType.primaryColor
                                  .withValues(alpha: 0.25),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            option.emoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                          if (isSelected)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: option.moodType.primaryColor,
                              ),
                            ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            option.title,
                            style: AppTypography.displayMedium.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? option.moodType.primaryColor
                                  : AppColors.textPrimaryOf(context),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            option.hint,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.label.copyWith(
                              fontSize: 11,
                              color: AppColors.textTertiaryOf(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Nuance Feeling Tags & Custom Adder
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'More specific feelings',
                style: AppTypography.displayMedium.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryOf(context),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _showCustomInput = !_showCustomInput;
                  });
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: Icon(
                  _showCustomInput ? Icons.close : Icons.add,
                  size: 16,
                  color: AppColors.amberWarmth,
                ),
                label: Text(
                  _showCustomInput ? 'Close' : 'Add custom',
                  style: AppTypography.label.copyWith(
                    color: AppColors.amberWarmth,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          if (_showCustomInput) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customFeelingController,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimaryOf(context),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Type your feeling (e.g. homesick, eager)...',
                      hintStyle: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textTertiaryOf(context),
                        fontSize: 13,
                      ),
                      filled: true,
                      fillColor: AppColors.surfaceOf(context),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: AppColors.borderSubtleOf(context)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: AppColors.borderSubtleOf(context)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: AppColors.amberWarmth,
                          width: 1.5,
                        ),
                      ),
                    ),
                    onSubmitted: (_) => _addCustomFeelingTag(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _addCustomFeelingTag,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.amberWarmth,
                    foregroundColor: AppColors.background,
                  ),
                  icon: const Icon(Icons.check, size: 18),
                ),
              ],
            ),
          ],

          const SizedBox(height: 10),

          // Feeling tags wrap
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._userCustomTags.map((tag) {
                return Chip(
                  label: Text(tag),
                  avatar: const Icon(Icons.star_rounded, size: 14, color: AppColors.amberWarmth),
                  backgroundColor: AppColors.amberWarmth.withValues(alpha: 0.18),
                  side: const BorderSide(color: AppColors.amberWarmth),
                  labelStyle: AppTypography.label.copyWith(
                    color: AppColors.amberWarmth,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }),
              ..._quickNuances.map((nuance) {
                final isActive = (selectedMood == nuance.family) &&
                    _noteController.text.contains(nuance.label);

                return ActionChip(
                  label: Text(nuance.label),
                  onPressed: () {
                    notifier.setMood(nuance.family);
                    _appendNoteTag(nuance.label);
                  },
                  backgroundColor: isActive
                      ? nuance.family.primaryColor.withValues(alpha: 0.18)
                      : AppColors.surfaceOf(context),
                  side: BorderSide(
                    color: isActive
                        ? nuance.family.primaryColor
                        : AppColors.borderSubtleOf(context),
                  ),
                  labelStyle: AppTypography.label.copyWith(
                    color: isActive
                        ? nuance.family.primaryColor
                        : AppColors.textSecondaryOf(context),
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                );
              }),
            ],
          ),

          const SizedBox(height: 24),

          // Intensity Slider (appears once feeling selected)
          if (selectedMood != null) ...[
            Text(
              'How strongly do you feel this?',
              style: AppTypography.displayMedium.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryOf(context),
              ),
            ),
            const SizedBox(height: 12),
            IntensitySlider(
              intensity: captureState.moodIntensity,
              activeColor: selectedMood.primaryColor,
              onChanged: (val) => notifier.setIntensity(val),
            ),
            const SizedBox(height: 24),
          ],

          // In your own words personal note
          Text(
            'In your own words (optional)',
            style: AppTypography.displayMedium.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryOf(context),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _noteController,
            maxLines: 3,
            onChanged: (text) => notifier.setJournal(text),
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimaryOf(context),
            ),
            decoration: InputDecoration(
              hintText: 'What is bringing this up today? Anything on your mind...',
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.textTertiaryOf(context),
                fontSize: 13,
              ),
              filled: true,
              fillColor: AppColors.surfaceOf(context),
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: AppColors.borderSubtleOf(context)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: AppColors.borderSubtleOf(context)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(
                  color: AppColors.amberWarmth,
                  width: 1.5,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
