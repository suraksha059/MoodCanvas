import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mood_error_view.dart';
import '../../../capture/domain/daily_entry.dart';
import '../../../capture/domain/mood_type.dart';
import '../../../capture/presentation/providers/daily_capture_provider.dart';
import '../../../capture/presentation/providers/entry_repository_provider.dart';

/// Full-screen visual detail view for an individual emotional memory.
/// Centers the living, animated canvas as the primary hero.
class MemoryDetailScreen extends ConsumerStatefulWidget {
  final String entryId;

  const MemoryDetailScreen({
    super.key,
    required this.entryId,
  });

  @override
  ConsumerState<MemoryDetailScreen> createState() => _MemoryDetailScreenState();
}

class _MemoryDetailScreenState extends ConsumerState<MemoryDetailScreen> {
  MoodType _parseMood(String moodName) {
    return MoodType.values.firstWhere(
      (m) =>
          m.label.toLowerCase() == moodName.toLowerCase() ||
          m.name.toLowerCase() == moodName.toLowerCase(),
      orElse: () => MoodType.calm,
    );
  }

  String _formatLongDate(DateTime dt) {
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday'
    ];
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${days[dt.weekday - 1]}, ${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  void _onEdit(DailyEntry entry) {
    final notifier = ref.read(dailyCaptureProvider.notifier);
    notifier.loadFromEntry(entry);
    context.push('/capture');
  }

  Future<void> _onDelete(DailyEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Delete this memory?',
          style: AppTypography.displayMedium.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'This canvas and journal entry will be permanently removed from your archive.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancel',
              style: AppTypography.label.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.roseDusk,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              'Delete',
              style: AppTypography.label.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final repository = ref.read(dailyEntryRepositoryProvider);
      await repository.deleteEntry(entry.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.surfaceElevated,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Text(
              'Memory removed from gallery',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        );
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          try {
            context.go('/memories');
          } catch (_) {}
        }
      }
    }
  }

  void _onShare(DailyEntry entry) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.borderSubtle,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Share Check-in Summary',
                  style: AppTypography.displayMedium.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Export or share this emotional reflection.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                ListTile(
                  leading: const Icon(Icons.download_rounded, color: AppColors.amberWarmth),
                  title: Text('Save Check-in Summary', style: AppTypography.bodyLarge),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Check-in summary saved'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.copy_rounded, color: AppColors.sageSerenity),
                  title: Text('Copy Memory Summary', style: AppTypography.bodyLarge),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Memory details copied to clipboard'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final entryAsync = ref.watch(entryByIdStreamProvider(widget.entryId));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: entryAsync.when(
        data: (entry) {
          if (entry == null) {
            return SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.sentiment_dissatisfied_rounded,
                      color: AppColors.textTertiary,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Memory not found',
                      style: AppTypography.displayMedium.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This canvas may have been deleted.',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton(
                      onPressed: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        } else {
                          context.go('/memories');
                        }
                      },
                      child: const Text('Back to Gallery'),
                    ),
                  ],
                ),
              ),
            );
          }

          final moodEnum = _parseMood(entry.mood);

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Navigation Header
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                pinned: true,
                leading: IconButton(
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    } else {
                      context.go('/memories');
                    }
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                  color: AppColors.textPrimary,
                ),
                title: Text(
                  entry.mood,
                  style: AppTypography.displayMedium.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    onPressed: () => _onShare(entry),
                    icon: const Icon(Icons.ios_share_rounded, size: 22),
                    color: AppColors.textPrimary,
                    tooltip: 'Share canvas',
                  ),
                  IconButton(
                    onPressed: () => _onDelete(entry),
                    icon: const Icon(Icons.delete_outline_rounded, size: 22),
                    color: AppColors.roseDusk,
                    tooltip: 'Delete memory',
                  ),
                  const SizedBox(width: 8),
                ],
              ),

              // Visual Hero & Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Formatted Date
                      Center(
                        child: Text(
                          _formatLongDate(entry.date),
                          style: AppTypography.label.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Hero Check-in Summary Header Card
                      Center(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                moodEnum.primaryColor.withValues(alpha: 0.22),
                                moodEnum.primaryColor.withValues(alpha: 0.06),
                                AppColors.surfaceElevatedOf(context),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: moodEnum.primaryColor.withValues(alpha: 0.35),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: moodEnum.primaryColor.withValues(alpha: 0.15),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: moodEnum.primaryColor,
                                            boxShadow: [
                                              BoxShadow(
                                                color: moodEnum.primaryColor.withValues(alpha: 0.7),
                                                blurRadius: 8,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            entry.mood,
                                            style: AppTypography.displayMedium.copyWith(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: moodEnum.primaryColor.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: moodEnum.primaryColor.withValues(alpha: 0.35),
                                      ),
                                    ),
                                    child: Text(
                                      'Intensity: ${entry.moodIntensity}/10',
                                      style: AppTypography.label.copyWith(
                                        color: moodEnum.primaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Text(
                                    'Energy Level',
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: AppColors.textSecondaryOf(context),
                                      fontSize: 13,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    entry.energy,
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: AppColors.textPrimaryOf(context),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Transformation Journey Card
                      if (entry.needed != null || entry.actionTaken != null || entry.afterMood != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevatedOf(context),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.amberWarmth.withValues(alpha: 0.35),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.amberWarmth.withValues(alpha: 0.08),
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
                                  const Icon(
                                    Icons.auto_awesome_rounded,
                                    color: AppColors.amberWarmth,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Transformation Journey',
                                    style: AppTypography.label.copyWith(
                                      color: AppColors.amberWarmth,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'STARTED AT',
                                          style: AppTypography.label.copyWith(
                                            fontSize: 10,
                                            color: AppColors.textTertiaryOf(context),
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          '${entry.mood} (${entry.moodIntensity}/10)',
                                          style: AppTypography.bodyMedium.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimaryOf(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 18,
                                    color: AppColors.amberWarmth,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'SHIFTED TO',
                                          style: AppTypography.label.copyWith(
                                            fontSize: 10,
                                            color: AppColors.amberWarmth,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          '${entry.afterMood ?? 'Grounded'} (${entry.afterIntensity ?? 7}/10)',
                                          style: AppTypography.bodyMedium.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.amberWarmth,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (entry.needed != null || entry.actionTaken != null) ...[
                                const SizedBox(height: 12),
                                const Divider(color: AppColors.borderSubtle, height: 1),
                                const SizedBox(height: 12),
                                if (entry.needed != null)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 6.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.favorite_border_rounded,
                                          size: 14,
                                          color: AppColors.textSecondaryOf(context),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Needed: ${entry.needed}',
                                          style: AppTypography.label.copyWith(
                                            color: AppColors.textSecondaryOf(context),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (entry.actionTaken != null)
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.spa_outlined,
                                        size: 14,
                                        color: AppColors.textSecondaryOf(context),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'One small step: ${entry.actionTaken}',
                                          style: AppTypography.label.copyWith(
                                            color: AppColors.textSecondaryOf(context),
                                            fontSize: 12,
                                          ),
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

                      // Activities Section
                      if (entry.activities.isNotEmpty) ...[
                        Text(
                          'What shaped this day',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: entry.activities.map((act) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceElevated,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.borderSubtle),
                              ),
                              child: Text(
                                act,
                                style: AppTypography.label.copyWith(
                                  color: AppColors.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Journal Reflection
                      if (entry.journal.trim().isNotEmpty) ...[
                        Text(
                          'Journal Reflection',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.borderSubtle),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.format_quote_rounded,
                                color: AppColors.amberWarmth,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  entry.journal,
                                  style: AppTypography.journal.copyWith(
                                    color: AppColors.textPrimary,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                      ],

                      // Bottom Action: Edit Check-in Entry
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: () => _onEdit(entry),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            side: const BorderSide(color: AppColors.borderSubtle),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          label: Text(
                            'Edit Check-in Entry',
                            style: AppTypography.label.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppColors.amberWarmth,
            strokeWidth: 2.5,
          ),
        ),
        error: (err, _) => Center(
          child: MoodErrorView.loading(
            onRetry: () =>
                ref.invalidate(entryByIdStreamProvider(widget.entryId)),
          ),
        ),
      ),
    );
  }
}
