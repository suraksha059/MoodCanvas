import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mood/core/database/app_database.dart';
import 'package:mood/features/capture/data/daily_entry_repository.dart';
import 'package:mood/features/capture/domain/daily_entry.dart';

void main() {
  late AppDatabase db;
  late DailyEntryRepository repository;

  setUp(() {
    // In-memory Drift database for high-speed, isolated unit tests
    db = AppDatabase(NativeDatabase.memory());
    repository = DriftDailyEntryRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Drift DailyEntryRepository Tests', () {
    test('Create entry and retrieve it by date', () async {
      final now = DateTime(2026, 9, 18, 12, 0);
      final dateString = DailyEntry.toDateString(now);

      final entry = DailyEntry(
        id: 'entry_$dateString',
        date: now,
        dateString: dateString,
        mood: 'Calm',
        moodIntensity: 7,
        energy: 'Balanced',
        activities: ['Music', 'Reading'],
        journal: 'A very peaceful afternoon.',
        canvasSeed: 1234567,
        createdAt: now,
        updatedAt: now,
      );

      await repository.saveOrUpdateTodayEntry(entry);

      final fetched = await repository.getEntryByDate(dateString);
      expect(fetched, isNotNull);
      expect(fetched!.mood, equals('Calm'));
      expect(fetched.moodIntensity, equals(7));
      expect(fetched.activities, containsAll(['Music', 'Reading']));
      expect(fetched.journal, equals('A very peaceful afternoon.'));
    });

    test('Update existing entry without creating duplicates', () async {
      final now = DateTime(2026, 9, 18, 14, 0);
      final dateString = DailyEntry.toDateString(now);

      final initialEntry = DailyEntry(
        id: 'entry_$dateString',
        date: now,
        dateString: dateString,
        mood: 'Okay',
        moodIntensity: 5,
        energy: 'Low',
        activities: ['Rest'],
        journal: 'Felt tired.',
        canvasSeed: 111,
        createdAt: now,
        updatedAt: now,
      );

      await repository.saveOrUpdateTodayEntry(initialEntry);

      // Verify 1 entry exists
      var entries = await repository.getRecentEntries();
      expect(entries.length, equals(1));

      // Update later today
      final updatedEntry = initialEntry.copyWith(
        mood: 'Happy',
        moodIntensity: 9,
        energy: 'High',
        activities: ['Music', 'Friends'],
        journal: 'Evening turned out amazing!',
        canvasSeed: 222,
      );

      await repository.saveOrUpdateTodayEntry(updatedEntry);

      // Verify still only 1 entry exists (no duplicates)
      entries = await repository.getRecentEntries();
      expect(entries.length, equals(1));

      // Verify updated content
      final fetched = await repository.getEntryByDate(dateString);
      expect(fetched!.mood, equals('Happy'));
      expect(fetched.moodIntensity, equals(9));
      expect(fetched.energy, equals('High'));
      expect(fetched.journal, equals('Evening turned out amazing!'));
      expect(fetched.canvasSeed, equals(222));
    });

    test('Multiple dates handling & sorting', () async {
      final day1 = DateTime(2026, 9, 16);
      final day2 = DateTime(2026, 9, 17);
      final day3 = DateTime(2026, 9, 18);

      for (final dt in [day1, day2, day3]) {
        final dStr = DailyEntry.toDateString(dt);
        await repository.saveOrUpdateTodayEntry(
          DailyEntry(
            id: 'entry_$dStr',
            date: dt,
            dateString: dStr,
            mood: 'Loved',
            moodIntensity: 8,
            energy: 'Balanced',
            activities: ['Family'],
            journal: 'Grateful for today.',
            canvasSeed: dt.day * 100,
            createdAt: dt,
            updatedAt: dt,
          ),
        );
      }

      final recent = await repository.getRecentEntries(limit: 10);
      expect(recent.length, equals(3));
      // Ordered descending by date
      expect(recent.first.dateString, equals(DailyEntry.toDateString(day3)));
      expect(recent.last.dateString, equals(DailyEntry.toDateString(day1)));
    });

    test('Delete entry by id', () async {
      final now = DateTime(2026, 9, 18);
      final dStr = DailyEntry.toDateString(now);
      const entryId = 'entry_to_delete';

      await repository.saveOrUpdateTodayEntry(
        DailyEntry(
          id: entryId,
          date: now,
          dateString: dStr,
          mood: 'Tired',
          moodIntensity: 4,
          energy: 'Very low',
          activities: ['Rest'],
          journal: '',
          canvasSeed: 999,
          createdAt: now,
          updatedAt: now,
        ),
      );

      var fetched = await repository.getEntryByDate(dStr);
      expect(fetched, isNotNull);

      await repository.deleteEntry(entryId);

      fetched = await repository.getEntryByDate(dStr);
      expect(fetched, isNull);
    });
  });
}
