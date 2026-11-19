import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Drift Table definition for persisted Daily Canvas entries.
@DataClassName('DailyEntryRecord')
class DailyEntries extends Table {
  TextColumn get id => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get dateString => text()(); // Normalized 'YYYY-MM-DD'
  TextColumn get mood => text()();
  IntColumn get moodIntensity => integer()();
  TextColumn get energy => text()();
  TextColumn get activities => text()(); // JSON string of activities
  TextColumn get journal => text()();
  IntColumn get canvasSeed => integer()();
  TextColumn get needed => text().nullable()();
  TextColumn get actionTaken => text().nullable()();
  TextColumn get afterMood => text().nullable()();
  IntColumn get afterIntensity => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Drift Table definition for local key-value settings and preferences.
@DataClassName('AppSettingRecord')
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(tables: [DailyEntries, AppSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.addColumn(dailyEntries, dailyEntries.needed);
            await m.addColumn(dailyEntries, dailyEntries.actionTaken);
            await m.addColumn(dailyEntries, dailyEntries.afterMood);
            await m.addColumn(dailyEntries, dailyEntries.afterIntensity);
          }
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'mood_canvas_db');
  }
}
