import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mood_error_view.dart';
import '../../../capture/presentation/providers/entry_repository_provider.dart';
import '../widgets/memories_empty_state.dart';
import '../widgets/memories_masonry_grid.dart';

/// Main Memories Gallery screen displaying all saved emotional canvases.
class MemoriesScreen extends ConsumerWidget {
  const MemoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allEntriesAsync = ref.watch(allEntriesStreamProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Memories',
                        style: AppTypography.displayLarge.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      allEntriesAsync.when(
                        data: (entries) {
                          if (entries.isEmpty) {
                            return Text(
                              'Your emotional canvas archive',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            );
                          }
                          return Text(
                            '${entries.length} ${entries.length == 1 ? 'canvas' : 'canvases'} created',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.amberWarmth,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                        loading: () => Text(
                          'Loading archive...',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textTertiary,
                            fontSize: 13,
                          ),
                        ),
                        error: (err, stack) => Text(
                          'Your gallery archive',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Quick New Memory Capture Shortcut
                  IconButton(
                    onPressed: () => context.push('/capture'),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surfaceElevated,
                      foregroundColor: AppColors.textPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: const BorderSide(
                          color: AppColors.borderSubtle,
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.add_rounded, size: 22),
                    tooltip: 'Capture today',
                  ),
                ],
              ),
            ),

            const Divider(
              color: AppColors.borderSubtle,
              height: 1,
              thickness: 0.8,
            ),

            // Content Area
            Expanded(
              child: allEntriesAsync.when(
                data: (entries) {
                  if (entries.isEmpty) {
                    return const MemoriesEmptyState();
                  }
                  return MemoriesMasonryGrid(entries: entries);
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.amberWarmth,
                    strokeWidth: 2.5,
                  ),
                ),
                error: (err, stack) => Center(
                  child: MoodErrorView.database(
                    onRetry: () => ref.invalidate(allEntriesStreamProvider),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
