import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mood/core/database/app_database.dart';
import 'package:mood/features/capture/data/daily_entry_repository.dart';
import 'package:mood/features/capture/domain/daily_entry.dart';
import 'package:mood/features/capture/presentation/providers/entry_repository_provider.dart';
import 'package:mood/features/insights/domain/models/time_period.dart';
import 'package:mood/features/insights/domain/services/insights_calculator.dart';
import 'package:mood/features/insights/presentation/screens/insights_screen.dart';

void main() {
  group('InsightsCalculator Unit Tests', () {
    DailyEntry makeEntry({
      required String id,
      required DateTime date,
      required String mood,
      int intensity = 7,
      String energy = 'Balanced',
      List<String> activities = const ['Music'],
    }) {
      return DailyEntry(
        id: id,
        date: date,
        dateString: DailyEntry.toDateString(date),
        mood: mood,
        moodIntensity: intensity,
        energy: energy,
        activities: activities,
        journal: 'A pleasant day',
        canvasSeed: 1234,
        createdAt: date,
        updatedAt: date,
      );
    }

    test('Calculates streak accurately for consecutive days ending today', () {
      final now = DateTime(2026, 9, 18);
      final entries = [
        makeEntry(id: '1', date: now, mood: 'Calm'),
        makeEntry(id: '2', date: now.subtract(const Duration(days: 1)), mood: 'Happy'),
        makeEntry(id: '3', date: now.subtract(const Duration(days: 2)), mood: 'Loved'),
        makeEntry(id: '4', date: now.subtract(const Duration(days: 4)), mood: 'Sad'), // 1 day gap
      ];

      final insights = InsightsCalculator.calculate(
        allEntries: entries,
        period: TimePeriod.allTime,
        referenceDate: now,
      );

      expect(insights.currentStreak, 3);
      expect(insights.totalCapturedDays, 4);
    });

    test('Calculates streak as active if yesterday was captured but today is not yet captured', () {
      final now = DateTime(2026, 9, 18);
      final entries = [
        makeEntry(id: '1', date: now.subtract(const Duration(days: 1)), mood: 'Calm'),
        makeEntry(id: '2', date: now.subtract(const Duration(days: 2)), mood: 'Happy'),
      ];

      final insights = InsightsCalculator.calculate(
        allEntries: entries,
        period: TimePeriod.allTime,
        referenceDate: now,
      );

      expect(insights.currentStreak, 2);
    });

    test('Calculates streak as 0 if neither today nor yesterday was captured', () {
      final now = DateTime(2026, 9, 18);
      final entries = [
        makeEntry(id: '1', date: now.subtract(const Duration(days: 3)), mood: 'Calm'),
        makeEntry(id: '2', date: now.subtract(const Duration(days: 4)), mood: 'Happy'),
      ];

      final insights = InsightsCalculator.calculate(
        allEntries: entries,
        period: TimePeriod.allTime,
        referenceDate: now,
      );

      expect(insights.currentStreak, 0);
    });

    test('Aggregates dominant mood, average intensity, energy, and activities', () {
      final now = DateTime(2026, 9, 18);
      final entries = [
        makeEntry(id: '1', date: now, mood: 'Calm', intensity: 8, energy: 'Balanced', activities: ['Music', 'Reading']),
        makeEntry(id: '2', date: now.subtract(const Duration(days: 1)), mood: 'Calm', intensity: 6, energy: 'Low', activities: ['Music']),
        makeEntry(id: '3', date: now.subtract(const Duration(days: 2)), mood: 'Happy', intensity: 10, energy: 'High', activities: ['Walk']),
      ];

      final insights = InsightsCalculator.calculate(
        allEntries: entries,
        period: TimePeriod.allTime,
        referenceDate: now,
      );

      expect(insights.mostCommonMood, 'Calm');
      expect(insights.mostCommonMoodCount, 2);
      expect(insights.averageIntensity, closeTo(8.0, 0.01)); // (8 + 6 + 10) / 3 = 8.0
      expect(insights.mostFrequentActivity, 'Music');
      expect(insights.mostFrequentActivityCount, 2);
      expect(insights.moodCounts['Calm'], 2);
      expect(insights.moodCounts['Happy'], 1);
      expect(insights.moodPercentages['Calm'], closeTo(2 / 3, 0.01));
    });

    test('Filters metrics properly by TimePeriod', () {
      final now = DateTime(2026, 9, 18); // Friday
      // Monday of current week is Sep 14, 2026
      final entries = [
        makeEntry(id: 'this-week-1', date: DateTime(2026, 9, 16), mood: 'Calm'),
        makeEntry(id: 'this-week-2', date: DateTime(2026, 9, 18), mood: 'Calm'),
        makeEntry(id: 'this-month-old', date: DateTime(2026, 9, 2), mood: 'Happy'),
        makeEntry(id: 'last-month', date: DateTime(2026, 8, 20), mood: 'Sad'),
      ];

      final weekInsights = InsightsCalculator.calculate(
        allEntries: entries,
        period: TimePeriod.thisWeek,
        referenceDate: now,
      );
      expect(weekInsights.totalCapturedDays, 2);

      final monthInsights = InsightsCalculator.calculate(
        allEntries: entries,
        period: TimePeriod.thisMonth,
        referenceDate: now,
      );
      expect(monthInsights.totalCapturedDays, 3);

      final allInsights = InsightsCalculator.calculate(
        allEntries: entries,
        period: TimePeriod.allTime,
        referenceDate: now,
      );
      expect(allInsights.totalCapturedDays, 4);
    });
  });

  group('Insights & Calendar Widget Tests', () {
    late AppDatabase inMemoryDb;
    late DailyEntryRepository repository;

    setUp(() {
      inMemoryDb = AppDatabase(NativeDatabase.memory());
      repository = DriftDailyEntryRepository(inMemoryDb);
    });

    tearDown(() async {
      await inMemoryDb.close();
    });

    DailyEntry createSampleEntry({
      required String id,
      required DateTime date,
      String mood = 'Calm',
      int intensity = 7,
      String energy = 'Balanced',
      List<String> activities = const ['Music'],
    }) {
      return DailyEntry(
        id: id,
        date: date,
        dateString: DailyEntry.toDateString(date),
        mood: mood,
        moodIntensity: intensity,
        energy: energy,
        activities: activities,
        journal: 'Reflecting peacefully.',
        canvasSeed: 555,
        createdAt: date,
        updatedAt: date,
      );
    }

    testWidgets('Shows InsightsEmptyState when no entries are in database',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.5;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(inMemoryDb),
            dailyEntryRepositoryProvider.overrideWithValue(repository),
          ],
          child: const MaterialApp(
            home: InsightsScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Assert Empty State Text
      expect(find.text('Capture a few more days\nto discover your patterns.'), findsOneWidget);

      // Mood Calendar is still visible
      expect(find.text('M'), findsOneWidget);
      expect(find.text('S'), findsWidgets);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('Displays metrics dashboard, emotional spectrum, and colored calendar days',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.5;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final now = DateTime.now();
      final entryToday = createSampleEntry(
        id: 'entry-today',
        date: now,
        mood: 'Calm',
        intensity: 8,
        activities: ['Music'],
      );
      final entryYesterday = createSampleEntry(
        id: 'entry-yesterday',
        date: now.subtract(const Duration(days: 1)),
        mood: 'Happy',
        intensity: 9,
        activities: ['Nature'],
      );

      await repository.saveOrUpdateTodayEntry(entryToday);
      await repository.saveOrUpdateTodayEntry(entryYesterday);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(inMemoryDb),
            dailyEntryRepositoryProvider.overrideWithValue(repository),
          ],
          child: const MaterialApp(
            home: InsightsScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Metrics Dashboard asserts
      expect(find.text('Current streak'), findsOneWidget);
      expect(find.text('Canvases created'), findsOneWidget);
      expect(find.text('Dominant mood'), findsOneWidget);
      expect(find.text('Avg. intensity'), findsOneWidget);
      expect(find.text('Top activity'), findsOneWidget);

      // Emotional Spectrum section
      expect(find.text('Emotional Spectrum'), findsOneWidget);

      // Time period filter tabs
      expect(find.text('This week'), findsOneWidget);
      expect(find.text('This month'), findsOneWidget);
      expect(find.text('All time'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('Tapping calendar day with entry opens preview modal with "Open that memory"',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.5;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final now = DateTime.now();
      final entryToday = createSampleEntry(
        id: 'day-tap-test',
        date: now,
        mood: 'Loved',
        intensity: 9,
      );

      await repository.saveOrUpdateTodayEntry(entryToday);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(inMemoryDb),
            dailyEntryRepositoryProvider.overrideWithValue(repository),
          ],
          child: const MaterialApp(
            home: InsightsScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Scroll down to bring calendar into view
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -600));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Find today's day number in the calendar and tap it
      final todayNum = '${now.day}';
      final dayFinder = find.widgetWithText(GestureDetector, todayNum).last;
      await tester.tap(dayFinder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Day detail modal opened
      expect(find.text('Open that memory'), findsOneWidget);
      expect(find.text('Loved'), findsWidgets);
      expect(find.text('Intensity: 9/10 • Balanced'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 100));
    });
  });
}
