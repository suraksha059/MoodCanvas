import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../capture/domain/daily_entry.dart';
import '../../../capture/domain/energy_level.dart';
import '../../../capture/domain/mood_type.dart';
import '../../../capture/presentation/providers/daily_capture_provider.dart';
import '../../../capture/presentation/providers/entry_repository_provider.dart';
import '../../domain/engine/canvas_seed_generator.dart';

/// Screen displaying the final emotional check-in summary card.
/// Replaces abstract canvas artwork with a clean, beautifully styled summary.
class CanvasPreviewScreen extends ConsumerWidget {
  const CanvasPreviewScreen({super.key});

  String _formatLongDate(DateTime dt) {
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday'
    ];
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${days[dt.weekday - 1]}, ${months[dt.month - 1]} ${dt.day}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final captureState = ref.watch(dailyCaptureProvider);
    final mood = captureState.mood ?? MoodType.calm;
    final energy = captureState.energy ?? EnergyLevel.balanced;
    final now = DateTime.now();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Screen Title
          Text(
            'Check-in Summary',
            style: AppTypography.displayLarge.copyWith(
              fontSize: 27,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryOf(context),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            'You noticed how you felt, chose what you needed, and took a small step.',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondaryOf(context),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // THE HERO: Clean, Beautifully Styled Check-in Summary Card
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surfaceOf(context),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: mood.primaryColor.withValues(alpha: 0.35),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: mood.primaryColor.withValues(alpha: 0.12),
                  blurRadius: 28,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card Top Banner: Date & Status
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                  decoration: BoxDecoration(
                    color: mood.primaryColor.withValues(alpha: 0.08),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
                    border: Border(
                      bottom: BorderSide(
                        color: mood.primaryColor.withValues(alpha: 0.15),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 15,
                            color: mood.primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatLongDate(now),
                            style: AppTypography.label.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimaryOf(context),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: mood.primaryColor.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${mood.label} • ${captureState.moodIntensity}/10',
                          style: AppTypography.label.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: mood.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Card Body
                Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Emotional Shift Progression
                      Text(
                        'EMOTIONAL SHIFT',
                        style: AppTypography.label.copyWith(
                          fontSize: 11,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textTertiaryOf(context),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevatedOf(context),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.borderSubtleOf(context)),
                        ),
                        child: Row(
                          children: [
                            // Before
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Before',
                                    style: AppTypography.label.copyWith(
                                      fontSize: 11,
                                      color: AppColors.textTertiaryOf(context),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${mood.label} (${captureState.moodIntensity}/10)',
                                    style: AppTypography.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: AppColors.textPrimaryOf(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.amberWarmth.withValues(alpha: 0.15),
                              ),
                              child: const Icon(
                                Icons.arrow_forward_rounded,
                                size: 16,
                                color: AppColors.amberWarmth,
                              ),
                            ),
                            const SizedBox(width: 8),

                            // After
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Shifted to',
                                    style: AppTypography.label.copyWith(
                                      fontSize: 11,
                                      color: AppColors.amberWarmth,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${captureState.afterMood ?? 'Grounded'} (${captureState.afterIntensity ?? 7}/10)',
                                    style: AppTypography.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: AppColors.amberWarmth,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 2. Need & Micro-Action Taken
                      if (captureState.need != null || captureState.selectedAction != null) ...[
                        Text(
                          'CARE TAKEN',
                          style: AppTypography.label.copyWith(
                            fontSize: 11,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textTertiaryOf(context),
                          ),
                        ),
                        const SizedBox(height: 12),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevatedOf(context),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.borderSubtleOf(context)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (captureState.need != null) ...[
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.favorite_outline_rounded,
                                      size: 16,
                                      color: AppColors.amberWarmth,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Needed: ${captureState.need!.label}',
                                      style: AppTypography.bodyMedium.copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimaryOf(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              if (captureState.selectedAction != null) ...[
                                if (captureState.need != null)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: Divider(color: AppColors.borderSubtle, height: 1),
                                  ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.check_circle_outline_rounded,
                                      size: 16,
                                      color: AppColors.sageSerenity,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            captureState.selectedAction!.title,
                                            style: AppTypography.bodyMedium.copyWith(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textPrimaryOf(context),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            captureState.selectedAction!.subtitle,
                                            style: AppTypography.label.copyWith(
                                              fontSize: 11,
                                              color: AppColors.textSecondaryOf(context),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // 3. Journal Reflection (If present)
                      if (captureState.journal.trim().isNotEmpty) ...[
                        Text(
                          'REFLECTION NOTE',
                          style: AppTypography.label.copyWith(
                            fontSize: 11,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textTertiaryOf(context),
                          ),
                        ),
                        const SizedBox(height: 10),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevatedOf(context),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.borderSubtleOf(context)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.format_quote_rounded,
                                size: 18,
                                color: AppColors.amberWarmth,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  captureState.journal.trim(),
                                  style: AppTypography.bodyMedium.copyWith(
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.textPrimaryOf(context),
                                    height: 1.45,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 36),

          // Final Save Action Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  colors: AppColors.canvasGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.amberWarmth.withValues(alpha: 0.4),
                    blurRadius: 22,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () async {
                  final dateString = DailyEntry.toDateString(now);

                  final seed = CanvasSeedGenerator.computeSeed(
                    date: now,
                    moodName: mood.name,
                    moodIntensity: captureState.moodIntensity,
                    energyLevel: energy.intensityValue,
                    activities: captureState.activities,
                  );

                  final entry = DailyEntry(
                    id: 'entry_$dateString',
                    date: now,
                    dateString: dateString,
                    mood: mood.label,
                    moodIntensity: captureState.moodIntensity,
                    energy: energy.label,
                    activities: captureState.activities.toList(),
                    needed: captureState.need?.name,
                    actionTaken: captureState.selectedAction?.title,
                    afterMood: captureState.afterMood,
                    afterIntensity: captureState.afterIntensity,
                    journal: captureState.journal,
                    canvasSeed: seed,
                    createdAt: now,
                    updatedAt: now,
                  );

                  await ref.read(dailyEntryRepositoryProvider).saveOrUpdateTodayEntry(entry);
                  ref.read(dailyCaptureProvider.notifier).reset();

                  if (context.mounted) {
                    context.go('/home');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text(
                  'Save this check-in',
                  style: AppTypography.button,
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
