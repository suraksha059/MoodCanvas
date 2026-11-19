import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../capture/domain/daily_entry.dart';
import '../../../capture/presentation/providers/entry_repository_provider.dart';
import '../../domain/models/insights_data.dart';
import '../../domain/models/time_period.dart';
import '../../domain/services/insights_calculator.dart';

/// Notifier managing currently selected time period filter.
class TimePeriodNotifier extends Notifier<TimePeriod> {
  @override
  TimePeriod build() => TimePeriod.thisMonth;

  void selectPeriod(TimePeriod period) => state = period;
}

final timePeriodProvider = NotifierProvider<TimePeriodNotifier, TimePeriod>(
  TimePeriodNotifier.new,
);

/// Notifier managing currently viewed calendar month.
class CalendarMonthNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  void previousMonth() {
    state = DateTime(state.year, state.month - 1);
  }

  void nextMonth() {
    state = DateTime(state.year, state.month + 1);
  }

  void resetToToday() {
    final now = DateTime.now();
    state = DateTime(now.year, now.month);
  }
}

final calendarMonthProvider =
    NotifierProvider<CalendarMonthNotifier, DateTime>(
  CalendarMonthNotifier.new,
);

/// Map of all entries keyed by normalized 'YYYY-MM-DD' for fast calendar lookup.
final calendarEntriesMapProvider = Provider<Map<String, DailyEntry>>((ref) {
  final entriesAsync = ref.watch(allEntriesStreamProvider);
  final entries = entriesAsync.value ?? [];
  final map = <String, DailyEntry>{};
  for (final entry in entries) {
    map[entry.dateString] = entry;
  }
  return map;
});

/// Reactive analytics provider calculating statistical metrics for the selected time period.
final insightsDataProvider = Provider<InsightsData>((ref) {
  final entriesAsync = ref.watch(allEntriesStreamProvider);
  final period = ref.watch(timePeriodProvider);
  final entries = entriesAsync.value ?? [];

  return InsightsCalculator.calculate(
    allEntries: entries,
    period: period,
  );
});
