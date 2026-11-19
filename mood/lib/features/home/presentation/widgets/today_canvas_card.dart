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

/// Prominent artistic card representing today's canvas status.
/// Reactively updates when today's emotional canvas is saved to the local database.
class TodayCanvasCard extends ConsumerStatefulWidget {
  const TodayCanvasCard({super.key});

  @override
  ConsumerState<TodayCanvasCard> createState() => _TodayCanvasCardState();
}

class _TodayCanvasCardState extends ConsumerState<TodayCanvasCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  MoodType _parseMood(String moodName) {
    return MoodType.values.firstWhere(
      (m) => m.label.toLowerCase() == moodName.toLowerCase(),
      orElse: () => MoodType.calm,
    );
  }

  EnergyLevel _parseEnergy(String energyName) {
    return EnergyLevel.values.firstWhere(
      (e) => e.label.toLowerCase() == energyName.toLowerCase(),
      orElse: () => EnergyLevel.balanced,
    );
  }

  void _onEditEntry(DailyEntry entry) {
    final notifier = ref.read(dailyCaptureProvider.notifier);
    notifier.setMood(_parseMood(entry.mood));
    notifier.setIntensity(entry.moodIntensity);
    notifier.setEnergy(_parseEnergy(entry.energy));
    for (final act in entry.activities) {
      notifier.toggleActivity(act);
    }
    notifier.setJournal(entry.journal);
    notifier.goToStep(0);
    context.push('/capture');
  }

  @override
  Widget build(BuildContext context) {
    final todayEntryAsync = ref.watch(todayEntryStreamProvider);

    if (todayEntryAsync.hasError) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: AppColors.surfaceOf(context),
            border: Border.all(color: AppColors.borderSubtleOf(context)),
          ),
          child: Row(
            children: [
              const Icon(Icons.sentiment_neutral_rounded, color: AppColors.roseDusk, size: 28),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Unable to load today’s status',
                      style: AppTypography.displayMedium.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryOf(context),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Check local storage and tap to retry',
                      style: AppTypography.bodyMedium.copyWith(
                        fontSize: 12,
                        color: AppColors.textSecondaryOf(context),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => ref.invalidate(todayEntryStreamProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final todayEntry = todayEntryAsync.value;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final glowAlpha = (0.18 + (_pulseController.value * 0.12)) * (isDark ? 1.0 : 0.4);

          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: AppColors.surfaceOf(context),
              border: Border.all(
                color: AppColors.amberWarmth.withValues(
                  alpha: 0.2 + _pulseController.value * 0.15,
                ),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.amberWarmth.withValues(alpha: glowAlpha),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: AppColors.roseDusk.withValues(alpha: glowAlpha * 0.7),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: child,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: todayEntry != null
              ? _buildCapturedState(todayEntry)
              : _buildUncapturedState(),
        ),
      ),
    );
  }

  /// State when an entry already exists for today.
  Widget _buildCapturedState(DailyEntry entry) {
    final moodEnum = _parseMood(entry.mood);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Header pill
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: moodEnum.primaryColor.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: moodEnum.primaryColor.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: moodEnum.primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    "Today's check-in • Completed",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.label.copyWith(
                      color: AppColors.textPrimaryOf(context),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 18),

        // Emotional Shift Container
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevatedOf(context),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderSubtleOf(context)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'STARTED AS',
                          style: AppTypography.label.copyWith(
                            fontSize: 10,
                            letterSpacing: 0.5,
                            color: AppColors.textTertiaryOf(context),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: moodEnum.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                '${entry.mood} (${entry.moodIntensity}/10)',
                                style: AppTypography.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: AppColors.textPrimaryOf(context),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (entry.afterMood != null) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.amberWarmth,
                        size: 18,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'SHIFTED TO',
                            style: AppTypography.label.copyWith(
                              fontSize: 10,
                              letterSpacing: 0.5,
                              color: AppColors.amberWarmth,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${entry.afterMood} (${entry.afterIntensity ?? 7}/10)',
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: AppColors.amberWarmth,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: moodEnum.primaryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        entry.energy,
                        style: AppTypography.label.copyWith(
                          color: moodEnum.primaryColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              if (entry.needed != null || entry.actionTaken != null) ...[
                const SizedBox(height: 12),
                Divider(color: AppColors.borderSubtleOf(context), height: 1),
                const SizedBox(height: 12),
                if (entry.needed != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.favorite_outline_rounded,
                          size: 14,
                          color: AppColors.amberWarmth,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Needed: ${entry.needed}',
                            style: AppTypography.bodyMedium.copyWith(
                              fontSize: 13,
                              color: AppColors.textSecondaryOf(context),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (entry.actionTaken != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        size: 14,
                        color: AppColors.sageSerenity,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          entry.actionTaken!,
                          style: AppTypography.bodyMedium.copyWith(
                            fontSize: 13,
                            color: AppColors.textSecondaryOf(context),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 12),

        if (entry.journal.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '"${entry.journal}"',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondaryOf(context),
                fontStyle: FontStyle.italic,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          )
        else
          Text(
            'Your emotional check-in and transformation are saved.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondaryOf(context),
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),

        const SizedBox(height: 18),

        // Update/Edit Button
        OutlinedButton.icon(
          onPressed: () => _onEditEntry(entry),
          icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.amberWarmth),
          label: const Text(
            'Update today\'s check-in',
            style: TextStyle(color: AppColors.amberWarmth, fontWeight: FontWeight.w600),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.amberWarmth),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }

  /// Original empty state when no entry has been captured yet.
  Widget _buildUncapturedState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceGlass,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderSubtleOf(context)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.spa_outlined, size: 14, color: AppColors.amberWarmth),
              const SizedBox(width: 6),
              Text("Today's check-in", style: AppTypography.label),
            ],
          ),
        ),

        const SizedBox(height: 20),

        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            color: AppColors.surfaceElevatedOf(context),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.amberWarmth.withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
          child: const Icon(
            Icons.self_improvement_rounded,
            color: AppColors.amberWarmth,
            size: 34,
          ),
        ),

        const SizedBox(height: 18),

        Text(
          "Take a gentle pause.",
          textAlign: TextAlign.center,
          style: AppTypography.displayMedium.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryOf(context),
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Notice how you feel, discover what you need, and give form to today.',
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondaryOf(context),
          ),
        ),

        const SizedBox(height: 22),

        SizedBox(
          width: double.infinity,
          height: 50,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: const LinearGradient(
                colors: AppColors.canvasGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.amberWarmth.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () => context.push('/capture'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.arrow_forward_rounded, color: AppColors.background, size: 18),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Start check-in',
                      style: AppTypography.button,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
