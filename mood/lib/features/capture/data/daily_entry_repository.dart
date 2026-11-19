import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../domain/daily_entry.dart';

/// Repository interface managing local persistence of emotional canvas entries.
abstract class DailyEntryRepository {
  Future<void> saveOrUpdateTodayEntry(DailyEntry entry);
  Future<DailyEntry?> getTodayEntry();
  Future<DailyEntry?> getEntryByDate(String dateString);
  Future<DailyEntry?> getEntryById(String id);
  Future<List<DailyEntry>> getRecentEntries({int limit = 10});
  Future<List<DailyEntry>> getAllEntries({int? limit, int? offset});
  Stream<DailyEntry?> watchTodayEntry();
  Stream<DailyEntry?> watchEntryById(String id);
  Stream<List<DailyEntry>> watchRecentEntries({int limit = 10});
  Stream<List<DailyEntry>> watchAllEntries({int? limit, int? offset});
  Future<void> deleteEntry(String id);
  Future<void> clearAllEntries();

  // Settings & Preferences
  Future<String?> getSetting(String key);
  Future<void> setSetting(String key, String value);
  Stream<String?> watchSetting(String key);
}

/// Drift implementation of [DailyEntryRepository].
class DriftDailyEntryRepository implements DailyEntryRepository {
  final AppDatabase _db;

  DriftDailyEntryRepository(this._db);

  DailyEntry _toDomain(DailyEntryRecord row) {
    List<String> activitiesList = [];
    try {
      final decoded = jsonDecode(row.activities);
      if (decoded is List) {
        activitiesList = decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {
      activitiesList = row.activities.split(',').where((e) => e.isNotEmpty).toList();
    }

    return DailyEntry(
      id: row.id,
      date: row.date,
      dateString: row.dateString,
      mood: row.mood,
      moodIntensity: row.moodIntensity,
      energy: row.energy,
      activities: activitiesList,
      journal: row.journal,
      canvasSeed: row.canvasSeed,
      needed: row.needed,
      actionTaken: row.actionTaken,
      afterMood: row.afterMood,
      afterIntensity: row.afterIntensity,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  @override
  Future<void> saveOrUpdateTodayEntry(DailyEntry entry) async {
    // 1. Check if an entry already exists for this specific day
    final existingQuery = _db.select(_db.dailyEntries)
      ..where((tbl) => tbl.dateString.equals(entry.dateString));
    final existing = await existingQuery.getSingleOrNull();

    if (existing != null) {
      // 2. Update existing entry without creating duplicates
      final updateStatement = _db.update(_db.dailyEntries)
        ..where((tbl) => tbl.id.equals(existing.id));

      await updateStatement.write(
        DailyEntriesCompanion(
          mood: Value(entry.mood),
          moodIntensity: Value(entry.moodIntensity),
          energy: Value(entry.energy),
          activities: Value(jsonEncode(entry.activities)),
          journal: Value(entry.journal),
          canvasSeed: Value(entry.canvasSeed),
          needed: Value(entry.needed),
          actionTaken: Value(entry.actionTaken),
          afterMood: Value(entry.afterMood),
          afterIntensity: Value(entry.afterIntensity),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } else {
      // 3. Insert new daily entry
      await _db.into(_db.dailyEntries).insert(
        DailyEntriesCompanion(
          id: Value(entry.id),
          date: Value(entry.date),
          dateString: Value(entry.dateString),
          mood: Value(entry.mood),
          moodIntensity: Value(entry.moodIntensity),
          energy: Value(entry.energy),
          activities: Value(jsonEncode(entry.activities)),
          journal: Value(entry.journal),
          canvasSeed: Value(entry.canvasSeed),
          needed: Value(entry.needed),
          actionTaken: Value(entry.actionTaken),
          afterMood: Value(entry.afterMood),
          afterIntensity: Value(entry.afterIntensity),
          createdAt: Value(entry.createdAt),
          updatedAt: Value(entry.updatedAt),
        ),
      );
    }
  }

  @override
  Future<DailyEntry?> getTodayEntry() async {
    final todayString = DailyEntry.toDateString(DateTime.now());
    return getEntryByDate(todayString);
  }

  @override
  Future<DailyEntry?> getEntryByDate(String dateString) async {
    final query = _db.select(_db.dailyEntries)
      ..where((tbl) => tbl.dateString.equals(dateString));
    final row = await query.getSingleOrNull();
    return row != null ? _toDomain(row) : null;
  }

  @override
  Future<DailyEntry?> getEntryById(String id) async {
    final query = _db.select(_db.dailyEntries)
      ..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _toDomain(row) : null;
  }

  @override
  Future<List<DailyEntry>> getRecentEntries({int limit = 10}) async {
    final query = _db.select(_db.dailyEntries)
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)])
      ..limit(limit);
    final rows = await query.get();
    return rows.map(_toDomain).toList();
  }

  @override
  Future<List<DailyEntry>> getAllEntries({int? limit, int? offset}) async {
    final query = _db.select(_db.dailyEntries)
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)]);
    if (limit != null) {
      query.limit(limit, offset: offset);
    }
    final rows = await query.get();
    return rows.map(_toDomain).toList();
  }

  @override
  Stream<DailyEntry?> watchTodayEntry() {
    final todayString = DailyEntry.toDateString(DateTime.now());
    final query = _db.select(_db.dailyEntries)
      ..where((tbl) => tbl.dateString.equals(todayString));

    return query.watchSingleOrNull().map((row) => row != null ? _toDomain(row) : null);
  }

  @override
  Stream<DailyEntry?> watchEntryById(String id) {
    final query = _db.select(_db.dailyEntries)
      ..where((tbl) => tbl.id.equals(id));

    return query.watchSingleOrNull().map((row) => row != null ? _toDomain(row) : null);
  }

  @override
  Stream<List<DailyEntry>> watchRecentEntries({int limit = 10}) {
    final query = _db.select(_db.dailyEntries)
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)])
      ..limit(limit);

    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Stream<List<DailyEntry>> watchAllEntries({int? limit, int? offset}) {
    final query = _db.select(_db.dailyEntries)
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)]);
    if (limit != null) {
      query.limit(limit, offset: offset);
    }

    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<void> deleteEntry(String id) async {
    final deleteStatement = _db.delete(_db.dailyEntries)
      ..where((tbl) => tbl.id.equals(id));
    await deleteStatement.go();
  }

  @override
  Future<void> clearAllEntries() async {
    await _db.delete(_db.dailyEntries).go();
  }

  @override
  Future<String?> getSetting(String key) async {
    final query = _db.select(_db.appSettings)..where((tbl) => tbl.key.equals(key));
    final record = await query.getSingleOrNull();
    return record?.value;
  }

  @override
  Future<void> setSetting(String key, String value) async {
    await _db.into(_db.appSettings).insertOnConflictUpdate(
          AppSettingsCompanion.insert(
            key: key,
            value: value,
          ),
        );
  }

  @override
  Stream<String?> watchSetting(String key) {
    final query = _db.select(_db.appSettings)..where((tbl) => tbl.key.equals(key));
    return query.watchSingleOrNull().map((record) => record?.value);
  }
}
