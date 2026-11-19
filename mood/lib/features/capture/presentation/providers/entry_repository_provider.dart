import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/daily_entry.dart';
import '../../data/daily_entry_repository.dart';

/// Central singleton provider for the Drift AppDatabase.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

/// Provider for the DailyEntryRepository.
final dailyEntryRepositoryProvider = Provider<DailyEntryRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftDailyEntryRepository(db);
});

/// Reactive stream providing real-time updates for today's entry.
final todayEntryStreamProvider = StreamProvider<DailyEntry?>((ref) {
  final repository = ref.watch(dailyEntryRepositoryProvider);
  return repository.watchTodayEntry();
});

/// Reactive stream providing the 10 most recent persistent canvas entries.
final recentEntriesStreamProvider = StreamProvider<List<DailyEntry>>((ref) {
  final repository = ref.watch(dailyEntryRepositoryProvider);
  return repository.watchRecentEntries(limit: 10);
});

/// Reactive stream providing all saved canvas entries in the database.
final allEntriesStreamProvider = StreamProvider<List<DailyEntry>>((ref) {
  final repository = ref.watch(dailyEntryRepositoryProvider);
  return repository.watchAllEntries();
});

/// Reactive stream providing a specific entry by its unique ID.
/// Auto-disposed when navigating away to prevent lingering SQLite listeners.
final entryByIdStreamProvider =
    StreamProvider.autoDispose.family<DailyEntry?, String>((ref, id) {
  final repository = ref.watch(dailyEntryRepositoryProvider);
  return repository.watchEntryById(id);
});

