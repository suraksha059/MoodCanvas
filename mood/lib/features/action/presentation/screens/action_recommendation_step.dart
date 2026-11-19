import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../capture/presentation/providers/daily_capture_provider.dart';

/// Step 3: "One small step"
/// Presents a focused, realistic micro-action recommendation with optional gentle timer.
class ActionRecommendationStep extends ConsumerStatefulWidget {
  const ActionRecommendationStep({super.key});

  @override
  ConsumerState<ActionRecommendationStep> createState() =>
      _ActionRecommendationStepState();
}

class _ActionRecommendationStepState
    extends ConsumerState<ActionRecommendationStep> {
  Timer? _timer;
  int _secondsRemaining = 0;
  bool _isTimerActive = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleTimer(int minutes) {
    if (_isTimerActive) {
      _timer?.cancel();
      setState(() {
        _isTimerActive = false;
      });
    } else {
      setState(() {
        _secondsRemaining = minutes * 60;
        _isTimerActive = true;
      });

      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsRemaining > 0) {
          setState(() {
            _secondsRemaining--;
          });
        } else {
          timer.cancel();
          setState(() {
            _isTimerActive = false;
          });
          ref.read(dailyCaptureProvider.notifier).setActionCompleted(true);
        }
      });
    }
  }

  String _formatTimer(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final captureState = ref.watch(dailyCaptureProvider);
    final notifier = ref.read(dailyCaptureProvider.notifier);
    final action = captureState.selectedAction;

    if (action == null) {
      return Center(
        child: Text(
          'No recommendation available',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondaryOf(context),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'One small step',
                      style: AppTypography.displayLarge.copyWith(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryOf(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Something realistic you can do right now.',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondaryOf(context),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // Shuffle button
              IconButton(
                onPressed: () {
                  _timer?.cancel();
                  setState(() => _isTimerActive = false);
                  notifier.shuffleAction();
                },
                tooltip: 'Try another suggestion',
                icon: const Icon(Icons.shuffle_rounded),
                color: AppColors.amberWarmth,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Action Hero Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.surfaceOf(context),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.amberWarmth.withValues(alpha: 0.35),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.amberWarmth.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Need pill & time indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.amberWarmth.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        action.need.label,
                        style: AppTypography.label.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.amberWarmth,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 14,
                          color: AppColors.textTertiaryOf(context),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '~${action.suggestedMinutes} mins',
                          style: AppTypography.label.copyWith(
                            fontSize: 12,
                            color: AppColors.textTertiaryOf(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Title
                Text(
                  action.title,
                  style: AppTypography.displayMedium.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryOf(context),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  action.subtitle,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondaryOf(context),
                    fontSize: 14,
                    height: 1.45,
                  ),
                ),

                const SizedBox(height: 20),
                const Divider(color: AppColors.borderSubtle, height: 1),
                const SizedBox(height: 20),

                // Concrete Steps
                ...action.steps.asMap().entries.map((entry) {
                  final idx = entry.key + 1;
                  final stepText = entry.value;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.surfaceElevatedOf(context),
                            border: Border.all(
                              color: AppColors.borderSubtleOf(context),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '$idx',
                              style: AppTypography.label.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.amberWarmth,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            stepText,
                            style: AppTypography.bodyMedium.copyWith(
                              fontSize: 13,
                              height: 1.45,
                              color: AppColors.textPrimaryOf(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 16),

                // Optional Zen Timer
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevatedOf(context),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isTimerActive
                            ? Icons.pause_circle_outline_rounded
                            : Icons.play_circle_outline_rounded,
                        color: AppColors.amberWarmth,
                        size: 32,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isTimerActive
                                  ? _formatTimer(_secondsRemaining)
                                  : '${action.suggestedMinutes}-Minute Focus Timer',
                              style: AppTypography.displayMedium.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimaryOf(context),
                              ),
                            ),
                            Text(
                              _isTimerActive
                                  ? 'Take your time. Step away whenever.'
                                  : 'Tap to start a gentle countdown.',
                              style: AppTypography.label.copyWith(
                                fontSize: 11,
                                color: AppColors.textTertiaryOf(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () => _toggleTimer(action.suggestedMinutes),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: AppColors.amberWarmth.withValues(alpha: 0.5),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          _isTimerActive ? 'Pause' : 'Start',
                          style: TextStyle(
                            color: AppColors.amberWarmth,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Reassurance notice
          Center(
            child: Text(
              'You don’t have to do it perfectly. Doing 10% is already enough.',
              textAlign: TextAlign.center,
              style: AppTypography.label.copyWith(
                color: AppColors.textTertiaryOf(context),
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
