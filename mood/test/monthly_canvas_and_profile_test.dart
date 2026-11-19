import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mood/core/database/app_database.dart';
import 'package:mood/core/widgets/mood_error_view.dart';
import 'package:mood/features/canvas/domain/engine/monthly_canvas_generator.dart';
import 'package:mood/features/canvas/presentation/screens/monthly_canvas_screen.dart';
import 'package:mood/features/capture/data/daily_entry_repository.dart';
import 'package:mood/features/capture/domain/daily_entry.dart';
import 'package:mood/features/capture/presentation/providers/entry_repository_provider.dart';
import 'package:mood/features/profile/presentation/screens/profile_screen.dart';

void main() {
  group('MonthlyCanvasGenerator Tests', () {
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
        journal: 'Reflecting on the month',
        canvasSeed: 777,
        createdAt: date,
        updatedAt: date,
      );
    }

    test('Returns empty monthly data when no entries exist in requested month', () {
      final entries = [
        makeEntry(id: '1', date: DateTime(2026, 8, 15), mood: 'Calm'),
      ];

      final result = MonthlyCanvasGenerator.generate(
        year: 2026,
        month: 9,
        allEntries: entries,
      );

      expect(result.capturedDaysCount, 0);
      expect(result.hasEntries, false);
      expect(result.monthName, 'September');
      expect(result.totalDaysInMonth, 30);
    });

    test('Generates celestial constellation nodes and aggregates monthly metrics', () {
      final entries = [
        makeEntry(id: '1', date: DateTime(2026, 9, 2), mood: 'Calm', intensity: 8, activities: ['Music', 'Reading']),
        makeEntry(id: '2', date: DateTime(2026, 9, 10), mood: 'Calm', intensity: 6, activities: ['Music']),
        makeEntry(id: '3', date: DateTime(2026, 9, 18), mood: 'Happy', intensity: 9, activities: ['Nature']),
      ];

      final result = MonthlyCanvasGenerator.generate(
        year: 2026,
        month: 9,
        allEntries: entries,
      );

      expect(result.capturedDaysCount, 3);
      expect(result.hasEntries, true);
      expect(result.dominantMood, 'Calm');
      expect(result.nodes.length, 3);
      expect(result.nodes[0].day, 2);
      expect(result.nodes[1].day, 10);
      expect(result.nodes[2].day, 18);
      expect(result.topActivities, contains('Music'));
    });
  });

  group('MonthlyCanvasScreen Widget Tests', () {
    late AppDatabase inMemoryDb;
    late DailyEntryRepository repository;

    setUp(() {
      inMemoryDb = AppDatabase(NativeDatabase.memory());
      repository = DriftDailyEntryRepository(inMemoryDb);
    });

    tearDown(() async {
      await inMemoryDb.close();
    });

    testWidgets('Renders empty state when no memories exist in current month',
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
            home: MonthlyCanvasScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Monthly Canvas'), findsOneWidget);
      expect(find.text('Capture today'), findsOneWidget);
      expect(find.textContaining('Capture your days to weave your monthly canvas.'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 100));
    });
  });

  group('ProfileScreen & Settings Tests', () {
    late AppDatabase inMemoryDb;
    late DailyEntryRepository repository;

    setUp(() {
      inMemoryDb = AppDatabase(NativeDatabase.memory());
      repository = DriftDailyEntryRepository(inMemoryDb);
    });

    tearDown(() async {
      await inMemoryDb.close();
    });

    testWidgets('Renders user identity, privacy section, and theme settings',
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
            home: ProfileScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // User name
      expect(find.text('Suraksha'), findsOneWidget);

      // Privacy statement (exact required copy)
      expect(find.text('Your memories belong to you.'), findsOneWidget);
      expect(
        find.text('MoodCanvas stores your journal and mood data locally on your device.'),
        findsOneWidget,
      );

      // Preferences (Daily Reminder)
      expect(find.text('Preferences'), findsOneWidget);
      expect(find.text('Daily reflection reminder'), findsOneWidget);

      // Verify theme switching controls are removed (permanent dark theme)
      expect(find.text('System'), findsNothing);
      expect(find.text('Light'), findsNothing);

      // App version
      expect(find.text('1.0.0 (V1)'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('Clear local archive dialog confirms and clears database',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.5;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      // Insert an entry first
      final now = DateTime.now();
      await repository.saveOrUpdateTodayEntry(
        DailyEntry(
          id: 'temp-1',
          date: now,
          dateString: DailyEntry.toDateString(now),
          mood: 'Calm',
          moodIntensity: 8,
          energy: 'Balanced',
          activities: ['Music'],
          journal: 'A calm day.',
          canvasSeed: 123,
          createdAt: now,
          updatedAt: now,
        ),
      );

      final beforeEntries = await repository.getAllEntries();
      expect(beforeEntries.length, 1);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(inMemoryDb),
            dailyEntryRepositoryProvider.overrideWithValue(repository),
          ],
          child: const MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Scroll to Clear Local Archive and tap
      await tester.scrollUntilVisible(find.text('Clear Local Archive'), 300);
      await tester.pump();
      await tester.tap(find.text('Clear Local Archive'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Confirmation dialog shows
      expect(find.text('Clear all local data?'), findsOneWidget);
      await tester.tap(find.text('Clear Archive'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Verify entries deleted
      final afterEntries = await repository.getAllEntries();
      expect(afterEntries.isEmpty, true);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('MoodErrorView displays calm title, message, and executes retry',
        (WidgetTester tester) async {
      bool retried = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MoodErrorView.database(
              onRetry: () => retried = true,
            ),
          ),
        ),
      );

      expect(find.text('Archive resting'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);

      await tester.tap(find.text('Try again'));
      expect(retried, true);
    });
  });
}
