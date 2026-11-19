import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../capture/presentation/providers/daily_capture_provider.dart';

/// Step 4: "How do you feel now?"
/// Records before/after emotional shift and, if the user still feels heavy or paused,
/// provides an empathetic, soothing cheer-up experience to comfort them.
class AfterReflectionStep extends ConsumerStatefulWidget {
  const AfterReflectionStep({super.key});

  @override
  ConsumerState<AfterReflectionStep> createState() => _AfterReflectionStepState();
}

class _AfterReflectionStepState extends ConsumerState<AfterReflectionStep>
    with SingleTickerProviderStateMixin {
  late TextEditingController _journalController;
  int _currentShiftIntensity = 6;
  String _selectedShiftMood = 'A bit lighter';

  // Guided breathing animation state
  bool _isBreathingActive = false;
  int _breathPhaseSeconds = 0;
  String _breathPrompt = 'Inhale warmth...';
  Timer? _breathTimer;
  late AnimationController _breathController;

  // Cheer-up affirmations
  int _currentAffirmationIndex = 0;
  static const List<String> _comfortAffirmations = [
    '“You have survived 100% of your hardest days. Be proud of yourself for simply being here.”',
    '“You don’t have to figure out the rest of your life today. Just treat yourself with kindness tonight.”',
    '“Rest is not a prize you have to earn. It is safe to just pause and breathe.”',
    '“Heavy feelings are like passing weather. You are the vast, quiet sky holding it all.”',
    '“You showed up and checked in with yourself today. That took real bravery.”',
    '“Give yourself the same patient love you would give a wounded friend.”',
  ];

  // Hug effect
  bool _hugReceived = false;

  static const List<({String label, bool isHeavy, String emoji})> _shiftFeelings = [
    (label: 'A bit lighter', isHeavy: false, emoji: '🌱'),
    (label: 'More calm & steady', isHeavy: false, emoji: '🕊️'),
    (label: 'Grounded & present', isHeavy: false, emoji: '⚓'),
    (label: 'Clearer head', isHeavy: false, emoji: '💡'),
    (label: 'Still heavy', isHeavy: true, emoji: '🌧️'),
    (label: 'Paused & quiet', isHeavy: true, emoji: '⏸️'),
    (label: 'Not nice / unsettled', isHeavy: true, emoji: '🥀'),
    (label: 'Tired & low', isHeavy: true, emoji: '🌙'),
    (label: 'Same as before', isHeavy: true, emoji: '☁️'),
  ];

  bool get _shouldCheerUp {
    final selected = _shiftFeelings.firstWhere(
      (f) => f.label == _selectedShiftMood,
      orElse: () => (label: '', isHeavy: false, emoji: ''),
    );
    return selected.isHeavy || _currentShiftIntensity <= 4;
  }

  @override
  void initState() {
    super.initState();
    final captureState = ref.read(dailyCaptureProvider);
    _journalController = TextEditingController(text: captureState.journal);
    _currentShiftIntensity = captureState.afterIntensity ??
        ((captureState.moodIntensity + 2).clamp(1, 10));
    _selectedShiftMood = captureState.afterMood ?? 'A bit lighter';

    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void dispose() {
    _journalController.dispose();
    _breathTimer?.cancel();
    _breathController.dispose();
    super.dispose();
  }

  void _syncToState() {
    ref.read(dailyCaptureProvider.notifier).setAfterReflection(
          afterMood: _selectedShiftMood,
          afterIntensity: _currentShiftIntensity,
          journal: _journalController.text.trim(),
        );
  }

  void _startBreathingExercise() {
    setState(() {
      _isBreathingActive = true;
      _breathPhaseSeconds = 0;
      _breathPrompt = 'Inhale warmth...';
    });
    _breathController.forward(from: 0.0);

    _breathTimer?.cancel();
    _breathTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _breathPhaseSeconds++;
        if (_breathPhaseSeconds <= 4) {
          _breathPrompt = 'Inhale warmth...';
        } else if (_breathPhaseSeconds <= 7) {
          _breathPrompt = 'Hold gently...';
        } else if (_breathPhaseSeconds <= 12) {
          _breathPrompt = 'Exhale the weight slowly...';
        } else {
          _isBreathingActive = false;
          _breathPrompt = 'Notice the quiet in your chest.';
          timer.cancel();
        }
      });
    });
  }

  void _nextAffirmation() {
    setState(() {
      _currentAffirmationIndex =
          (_currentAffirmationIndex + 1) % _comfortAffirmations.length;
    });
  }

  void _giveHug() {
    setState(() {
      _hugReceived = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final captureState = ref.watch(dailyCaptureProvider);
    final initialMood = captureState.mood;
    final initialIntensity = captureState.moodIntensity;
    final action = captureState.selectedAction;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Header
          Text(
            'How do you feel now?',
            style: AppTypography.displayLarge.copyWith(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryOf(context),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Notice any shift—even a quiet pause or breathing room matters.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondaryOf(context),
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 20),

          // Before & Action Summary Pill
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceOf(context),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.borderSubtleOf(context)),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: initialMood?.primaryColor ?? AppColors.amberWarmth,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Started at: ${initialMood?.label ?? 'Feeling'} ($initialIntensity/10) • ${action?.title ?? 'Checked in'}',
                    style: AppTypography.label.copyWith(
                      fontSize: 12,
                      color: AppColors.textSecondaryOf(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 26),

          // Shift Feeling Options
          Text(
            'Current emotional state',
            style: AppTypography.displayMedium.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryOf(context),
            ),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _shiftFeelings.map((item) {
              final isSelected = _selectedShiftMood == item.label;
              return ChoiceChip(
                avatar: Text(item.emoji, style: const TextStyle(fontSize: 14)),
                label: Text(item.label),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _selectedShiftMood = item.label);
                    _syncToState();
                  }
                },
                selectedColor: AppColors.amberWarmth.withValues(alpha: 0.2),
                backgroundColor: AppColors.surfaceOf(context),
                labelStyle: AppTypography.label.copyWith(
                  color: isSelected
                      ? AppColors.amberWarmth
                      : AppColors.textPrimaryOf(context),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.amberWarmth
                      : AppColors.borderSubtleOf(context),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 26),

          // Shift Intensity Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'How grounded or relieved do you feel?',
                  style: AppTypography.displayMedium.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryOf(context),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$_currentShiftIntensity / 10',
                style: AppTypography.label.copyWith(
                  color: AppColors.amberWarmth,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.amberWarmth,
              thumbColor: AppColors.amberWarmth,
              inactiveTrackColor: AppColors.surfaceElevatedOf(context),
              overlayColor: AppColors.amberWarmth.withValues(alpha: 0.2),
              trackHeight: 4,
            ),
            child: Slider(
              value: _currentShiftIntensity.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (val) {
                setState(() => _currentShiftIntensity = val.round());
                _syncToState();
              },
            ),
          ),

          // ==========================================
          // CHEER-UP & COMFORT SECTION
          // Displayed when user feels heavy / paused / not nice
          // ==========================================
          if (_shouldCheerUp) ...[
            const SizedBox(height: 28),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [
                    AppColors.roseDusk.withValues(alpha: 0.15),
                    AppColors.amberWarmth.withValues(alpha: 0.12),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: AppColors.roseDusk.withValues(alpha: 0.4),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.roseDusk.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.roseDusk.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: AppColors.roseDusk,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'It is completely okay to still feel this way.',
                          style: AppTypography.displayMedium.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimaryOf(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'You don’t have to force yourself to feel cheerful. Healing is not a straight line, and you did something kind for yourself just by checking in.',
                    style: AppTypography.bodyMedium.copyWith(
                      fontSize: 13,
                      height: 1.5,
                      color: AppColors.textSecondaryOf(context),
                    ),
                  ),

                  const SizedBox(height: 18),
                  const Divider(color: AppColors.borderSubtle, height: 1),
                  const SizedBox(height: 18),

                  // Comfort Affirmation Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceOf(context),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.borderSubtleOf(context)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _comfortAffirmations[_currentAffirmationIndex],
                          style: AppTypography.quote.copyWith(
                            fontSize: 14,
                            color: AppColors.textPrimaryOf(context),
                            height: 1.55,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: _nextAffirmation,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            icon: const Icon(
                              Icons.refresh_rounded,
                              size: 14,
                              color: AppColors.amberWarmth,
                            ),
                            label: Text(
                              'Another reminder',
                              style: AppTypography.label.copyWith(
                                color: AppColors.amberWarmth,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Interactive Breathing Cheer-Up Tool
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceOf(context),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.borderSubtleOf(context)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.air_rounded,
                                    color: AppColors.sageSerenity,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      '10-Second Calming Breath',
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypography.label.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        color: AppColors.textPrimaryOf(context),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (!_isBreathingActive)
                              ElevatedButton(
                                onPressed: _startBreathingExercise,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppColors.sageSerenity.withValues(alpha: 0.2),
                                  foregroundColor: AppColors.sageSerenity,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    side: const BorderSide(
                                      color: AppColors.sageSerenity,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Breathe with me',
                                  style: AppTypography.label.copyWith(
                                    color: AppColors.sageSerenity,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (_isBreathingActive) ...[
                          const SizedBox(height: 16),
                          AnimatedBuilder(
                            animation: _breathController,
                            builder: (context, child) {
                              final scale =
                                  0.85 + (_breathPhaseSeconds <= 4 ? 0.3 : 0.1);
                              return Container(
                                width: 70 * scale,
                                height: 70 * scale,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.sageSerenity
                                      .withValues(alpha: 0.25),
                                  border: Border.all(
                                    color: AppColors.sageSerenity,
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.sageSerenity
                                          .withValues(alpha: 0.3),
                                      blurRadius: 18,
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.spa_rounded,
                                    color: AppColors.sageSerenity,
                                    size: 26,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                        const SizedBox(height: 10),
                        Text(
                          _breathPrompt,
                          style: AppTypography.label.copyWith(
                            color: AppColors.amberWarmth,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Send yourself a gentle hug button
                  InkWell(
                    onTap: _giveHug,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: _hugReceived
                            ? AppColors.amberWarmth.withValues(alpha: 0.2)
                            : AppColors.surfaceOf(context),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _hugReceived
                              ? AppColors.amberWarmth
                              : AppColors.borderSubtleOf(context),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _hugReceived
                                ? Icons.volunteer_activism_rounded
                                : Icons.favorite_outline_rounded,
                            color: AppColors.amberWarmth,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _hugReceived
                                ? 'Quiet warmth sent to you. You are enough. 🫂'
                                : 'Receive a moment of warmth 🫂',
                            style: AppTypography.label.copyWith(
                              color: AppColors.textPrimaryOf(context),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 28),

          // Reflection Journal
          Text(
            'Reflect on today (optional)',
            style: AppTypography.displayMedium.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryOf(context),
            ),
          ),
          const SizedBox(height: 10),

          TextField(
            controller: _journalController,
            maxLines: 4,
            onChanged: (_) => _syncToState(),
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimaryOf(context),
            ),
            decoration: InputDecoration(
              hintText:
                  'What happened? Or what did taking this small moment give you?',
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.textTertiaryOf(context),
                fontSize: 13,
              ),
              filled: true,
              fillColor: AppColors.surfaceOf(context),
              contentPadding: const EdgeInsets.all(16),
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
                borderSide:
                    const BorderSide(color: AppColors.amberWarmth, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
