import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mood/core/database/app_database.dart';
import 'package:mood/features/capture/data/daily_entry_repository.dart';
import 'package:mood/features/capture/domain/daily_entry.dart';
import 'package:mood/features/capture/presentation/providers/daily_capture_provider.dart';
import 'package:mood/features/capture/presentation/providers/entry_repository_provider.dart';
import 'package:mood/features/memories/presentation/screens/memories_screen.dart';
import 'package:mood/features/memories/presentation/screens/memory_detail_screen.dart';

void main() {
  group('Memories Gallery & Detail Tests', () {
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
      List<String> activities = const ['Music', 'Reading'],
      String journal = 'A gentle afternoon.',
    }) {
      return DailyEntry(
        id: id,
        date: date,
        dateString: DailyEntry.toDateString(date),
        mood: mood,
        moodIntensity: intensity,
        energy: energy,
        activities: activities,
        journal: journal,
        canvasSeed: 42,
        createdAt: date,
        updatedAt: date,
      );
    }

    testWidgets('Renders empty state when no memories exist in database',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(inMemoryDb),
            dailyEntryRepositoryProvider.overrideWithValue(repository),
          ],
          child: const MaterialApp(
            home: MemoriesScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Assert Empty State Text
      expect(find.text('Your memories will live here.'), findsOneWidget);
      expect(
        find.text('Capture your first day\nand turn it into a canvas.'),
        findsOneWidget,
      );
      expect(find.text('Capture today'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('Renders saved memories in masonry gallery layout',
        (WidgetTester tester) async {
      final now = DateTime.now();
      final entry1 = createSampleEntry(
        id: 'mem-1',
        date: now,
        mood: 'Calm',
        intensity: 8,
      );
      final entry2 = createSampleEntry(
        id: 'mem-2',
        date: now.subtract(const Duration(days: 1)),
        mood: 'Happy',
        intensity: 9,
      );

      await repository.saveOrUpdateTodayEntry(entry1);
      // Save second entry on yesterday's date
      await repository.saveOrUpdateTodayEntry(entry2);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(inMemoryDb),
            dailyEntryRepositoryProvider.overrideWithValue(repository),
          ],
          child: const MaterialApp(
            home: MemoriesScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Header should reflect entry count
      expect(find.text('2 canvases created'), findsOneWidget);

      // Gallery cards should display the moods
      expect(find.text('Calm'), findsOneWidget);
      expect(find.text('Happy'), findsOneWidget);
      expect(find.text('8/10'), findsOneWidget);
      expect(find.text('9/10'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('MemoryDetailScreen renders visual canvas, metadata, and journal',
        (WidgetTester tester) async {
      final now = DateTime.now();
      final entry = createSampleEntry(
        id: 'detail-test-1',
        date: now,
        mood: 'Loved',
        intensity: 9,
        energy: 'High',
        activities: ['Nature', 'Coffee'],
        journal: 'A serene morning walk with warm sunshine.',
      );

      await repository.saveOrUpdateTodayEntry(entry);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(inMemoryDb),
            dailyEntryRepositoryProvider.overrideWithValue(repository),
          ],
          child: const MaterialApp(
            home: MemoryDetailScreen(entryId: 'detail-test-1'),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Check header and mood title
      expect(find.text('Loved'), findsWidgets);
      expect(find.text('Intensity: 9/10'), findsOneWidget);
      expect(find.text('Energy Level'), findsOneWidget);
      expect(find.text('High'), findsOneWidget);

      // Check activities
      expect(find.text('Nature'), findsOneWidget);
      expect(find.text('Coffee'), findsOneWidget);

      // Check journal
      expect(
        find.text('A serene morning walk with warm sunshine.'),
        findsOneWidget,
      );

      // Check action buttons
      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline_rounded), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('Deleting a memory removes it from database and detail screen',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.5;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final now = DateTime.now();
      final entry = createSampleEntry(
        id: 'delete-me-id',
        date: now,
        mood: 'Anxious',
        intensity: 6,
      );

      await repository.saveOrUpdateTodayEntry(entry);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(inMemoryDb),
            dailyEntryRepositoryProvider.overrideWithValue(repository),
          ],
          child: MaterialApp(
            home: Builder(
              builder: (ctx) => Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).push(
                      MaterialPageRoute(
                        builder: (_) => const MemoryDetailScreen(entryId: 'delete-me-id'),
                      ),
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.tap(find.text('Open'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Tap delete icon
      await tester.tap(find.byIcon(Icons.delete_outline_rounded));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      // Confirmation dialog shows
      expect(find.text('Delete this memory?'), findsOneWidget);

      // Tap Delete in dialog
      await tester.tap(find.text('Delete'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Verify removed from database
      final deleted = await repository.getEntryById('delete-me-id');
      expect(deleted, isNull);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('Edit action loads memory data into DailyCaptureNotifier',
        (WidgetTester tester) async {
      final now = DateTime.now();
      final entry = createSampleEntry(
        id: 'edit-test-id',
        date: now,
        mood: 'Calm',
        intensity: 8,
        energy: 'Low',
        activities: ['Reading'],
        journal: 'A quiet rainy evening.',
      );

      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(inMemoryDb),
          dailyEntryRepositoryProvider.overrideWithValue(repository),
        ],
      );

      final notifier = container.read(dailyCaptureProvider.notifier);
      notifier.loadFromEntry(entry);

      final state = container.read(dailyCaptureProvider);
      expect(state.mood?.label, 'Calm');
      expect(state.moodIntensity, 8);
      expect(state.energy?.label, 'Low');
      expect(state.activities, contains('Reading'));
      expect(state.journal, 'A quiet rainy evening.');

      container.dispose();
    });
  });
}
