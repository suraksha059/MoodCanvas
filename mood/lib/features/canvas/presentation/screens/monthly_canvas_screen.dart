import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../capture/presentation/providers/entry_repository_provider.dart';
import '../../domain/engine/monthly_canvas_generator.dart';
import '../widgets/monthly_canvas_view.dart';

/// Screen displaying the monthly emotional summary and cosmic canvas tapestry.
class MonthlyCanvasScreen extends ConsumerStatefulWidget {
  const MonthlyCanvasScreen({super.key});

  @override
  ConsumerState<MonthlyCanvasScreen> createState() =>
      _MonthlyCanvasScreenState();
}

class _MonthlyCanvasScreenState extends ConsumerState<MonthlyCanvasScreen> {
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
  }

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
  }

  void _onShareMonthly() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Monthly tapestry ready to export'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(allEntriesStreamProvider);
    final allEntries = entriesAsync.value ?? [];

    final monthlyData = MonthlyCanvasGenerator.generate(
      year: _selectedMonth.year,
      month: _selectedMonth.month,
      allEntries: allEntries,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/insights');
            }
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: AppColors.textPrimaryOf(context),
          tooltip: 'Back',
        ),
        title: Text(
          'Monthly Canvas',
          style: AppTypography.displayMedium.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          if (monthlyData.hasEntries)
            IconButton(
              onPressed: _onShareMonthly,
              icon: const Icon(Icons.ios_share_rounded, size: 22),
              color: AppColors.textPrimary,
              tooltip: 'Share monthly tapestry',
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Month Selector Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _previousMonth,
                    icon: const Icon(Icons.chevron_left_rounded, size: 24),
                    color: AppColors.textSecondary,
                    tooltip: 'Previous month',
                  ),
                  Expanded(
                    child: Text(
                      '${monthlyData.monthName} ${monthlyData.year}',
                      textAlign: TextAlign.center,
                      style: AppTypography.displayLarge.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: _nextMonth,
                    icon: const Icon(Icons.chevron_right_rounded, size: 24),
                    color: AppColors.textSecondary,
                    tooltip: 'Next month',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Monthly Summary Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${monthlyData.totalDaysInMonth} days in month',
                          style: AppTypography.label.copyWith(
                            color: AppColors.textTertiary,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${monthlyData.capturedDaysCount} captured',
                          style: AppTypography.label.copyWith(
                            color: AppColors.amberWarmth,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: AppColors.borderSubtle, height: 1),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Most common mood',
                                style: AppTypography.label.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                monthlyData.dominantMood ?? 'None',
                                style: AppTypography.displayMedium.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: monthlyData.dominantMoodType?.primaryColor ??
                                      AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Average energy',
                                style: AppTypography.label.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                monthlyData.averageEnergy,
                                style: AppTypography.displayMedium.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Artwork Area or Empty State
              if (!monthlyData.hasEntries) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 40,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surface,
                          border: Border.all(color: AppColors.borderSubtle),
                        ),
                        child: const Icon(
                          Icons.auto_awesome_mosaic_outlined,
                          color: AppColors.textTertiary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'No memories captured in ${monthlyData.monthName} yet.',
                        textAlign: TextAlign.center,
                        style: AppTypography.displayMedium.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Capture your days to weave your monthly canvas.',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () => context.push('/capture'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.amberWarmth,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('Capture today'),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Large living Monthly Canvas Tapestry
                Center(
                  child: MonthlyCanvasView(
                    data: monthlyData,
                    width: MediaQuery.of(context).size.width - 48,
                    height: MediaQuery.of(context).size.width - 48,
                    borderRadius: 28,
                    isAnimated: true,
                  ),
                ),
                const SizedBox(height: 24),

                // Emotional Highlights
                if (monthlyData.topActivities.isNotEmpty) ...[
                  Text(
                    'Shaped this month',
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
                    children: monthlyData.topActivities.map((act) {
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
                  const SizedBox(height: 28),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
