// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DailyEntriesTable extends DailyEntries
    with TableInfo<$DailyEntriesTable, DailyEntryRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateStringMeta = const VerificationMeta(
    'dateString',
  );
  @override
  late final GeneratedColumn<String> dateString = GeneratedColumn<String>(
    'date_string',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<String> mood = GeneratedColumn<String>(
    'mood',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moodIntensityMeta = const VerificationMeta(
    'moodIntensity',
  );
  @override
  late final GeneratedColumn<int> moodIntensity = GeneratedColumn<int>(
    'mood_intensity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _energyMeta = const VerificationMeta('energy');
  @override
  late final GeneratedColumn<String> energy = GeneratedColumn<String>(
    'energy',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activitiesMeta = const VerificationMeta(
    'activities',
  );
  @override
  late final GeneratedColumn<String> activities = GeneratedColumn<String>(
    'activities',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _journalMeta = const VerificationMeta(
    'journal',
  );
  @override
  late final GeneratedColumn<String> journal = GeneratedColumn<String>(
    'journal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _canvasSeedMeta = const VerificationMeta(
    'canvasSeed',
  );
  @override
  late final GeneratedColumn<int> canvasSeed = GeneratedColumn<int>(
    'canvas_seed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _neededMeta = const VerificationMeta('needed');
  @override
  late final GeneratedColumn<String> needed = GeneratedColumn<String>(
    'needed',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actionTakenMeta = const VerificationMeta(
    'actionTaken',
  );
  @override
  late final GeneratedColumn<String> actionTaken = GeneratedColumn<String>(
    'action_taken',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _afterMoodMeta = const VerificationMeta(
    'afterMood',
  );
  @override
  late final GeneratedColumn<String> afterMood = GeneratedColumn<String>(
    'after_mood',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _afterIntensityMeta = const VerificationMeta(
    'afterIntensity',
  );
  @override
  late final GeneratedColumn<int> afterIntensity = GeneratedColumn<int>(
    'after_intensity',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    dateString,
    mood,
    moodIntensity,
    energy,
    activities,
    journal,
    canvasSeed,
    needed,
    actionTaken,
    afterMood,
    afterIntensity,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyEntryRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('date_string')) {
      context.handle(
        _dateStringMeta,
        dateString.isAcceptableOrUnknown(data['date_string']!, _dateStringMeta),
      );
    } else if (isInserting) {
      context.missing(_dateStringMeta);
    }
    if (data.containsKey('mood')) {
      context.handle(
        _moodMeta,
        mood.isAcceptableOrUnknown(data['mood']!, _moodMeta),
      );
    } else if (isInserting) {
      context.missing(_moodMeta);
    }
    if (data.containsKey('mood_intensity')) {
      context.handle(
        _moodIntensityMeta,
        moodIntensity.isAcceptableOrUnknown(
          data['mood_intensity']!,
          _moodIntensityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_moodIntensityMeta);
    }
    if (data.containsKey('energy')) {
      context.handle(
        _energyMeta,
        energy.isAcceptableOrUnknown(data['energy']!, _energyMeta),
      );
    } else if (isInserting) {
      context.missing(_energyMeta);
    }
    if (data.containsKey('activities')) {
      context.handle(
        _activitiesMeta,
        activities.isAcceptableOrUnknown(data['activities']!, _activitiesMeta),
      );
    } else if (isInserting) {
      context.missing(_activitiesMeta);
    }
    if (data.containsKey('journal')) {
      context.handle(
        _journalMeta,
        journal.isAcceptableOrUnknown(data['journal']!, _journalMeta),
      );
    } else if (isInserting) {
      context.missing(_journalMeta);
    }
    if (data.containsKey('canvas_seed')) {
      context.handle(
        _canvasSeedMeta,
        canvasSeed.isAcceptableOrUnknown(data['canvas_seed']!, _canvasSeedMeta),
      );
    } else if (isInserting) {
      context.missing(_canvasSeedMeta);
    }
    if (data.containsKey('needed')) {
      context.handle(
        _neededMeta,
        needed.isAcceptableOrUnknown(data['needed']!, _neededMeta),
      );
    }
    if (data.containsKey('action_taken')) {
      context.handle(
        _actionTakenMeta,
        actionTaken.isAcceptableOrUnknown(
          data['action_taken']!,
          _actionTakenMeta,
        ),
      );
    }
    if (data.containsKey('after_mood')) {
      context.handle(
        _afterMoodMeta,
        afterMood.isAcceptableOrUnknown(data['after_mood']!, _afterMoodMeta),
      );
    }
    if (data.containsKey('after_intensity')) {
      context.handle(
        _afterIntensityMeta,
        afterIntensity.isAcceptableOrUnknown(
          data['after_intensity']!,
          _afterIntensityMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyEntryRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyEntryRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      dateString: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_string'],
      )!,
      mood: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mood'],
      )!,
      moodIntensity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood_intensity'],
      )!,
      energy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}energy'],
      )!,
      activities: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activities'],
      )!,
      journal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}journal'],
      )!,
      canvasSeed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}canvas_seed'],
      )!,
      needed: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}needed'],
      ),
      actionTaken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_taken'],
      ),
      afterMood: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}after_mood'],
      ),
      afterIntensity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}after_intensity'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DailyEntriesTable createAlias(String alias) {
    return $DailyEntriesTable(attachedDatabase, alias);
  }
}

class DailyEntryRecord extends DataClass
    implements Insertable<DailyEntryRecord> {
  final String id;
  final DateTime date;
  final String dateString;
  final String mood;
  final int moodIntensity;
  final String energy;
  final String activities;
  final String journal;
  final int canvasSeed;
  final String? needed;
  final String? actionTaken;
  final String? afterMood;
  final int? afterIntensity;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DailyEntryRecord({
    required this.id,
    required this.date,
    required this.dateString,
    required this.mood,
    required this.moodIntensity,
    required this.energy,
    required this.activities,
    required this.journal,
    required this.canvasSeed,
    this.needed,
    this.actionTaken,
    this.afterMood,
    this.afterIntensity,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<DateTime>(date);
    map['date_string'] = Variable<String>(dateString);
    map['mood'] = Variable<String>(mood);
    map['mood_intensity'] = Variable<int>(moodIntensity);
    map['energy'] = Variable<String>(energy);
    map['activities'] = Variable<String>(activities);
    map['journal'] = Variable<String>(journal);
    map['canvas_seed'] = Variable<int>(canvasSeed);
    if (!nullToAbsent || needed != null) {
      map['needed'] = Variable<String>(needed);
    }
    if (!nullToAbsent || actionTaken != null) {
      map['action_taken'] = Variable<String>(actionTaken);
    }
    if (!nullToAbsent || afterMood != null) {
      map['after_mood'] = Variable<String>(afterMood);
    }
    if (!nullToAbsent || afterIntensity != null) {
      map['after_intensity'] = Variable<int>(afterIntensity);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DailyEntriesCompanion toCompanion(bool nullToAbsent) {
    return DailyEntriesCompanion(
      id: Value(id),
      date: Value(date),
      dateString: Value(dateString),
      mood: Value(mood),
      moodIntensity: Value(moodIntensity),
      energy: Value(energy),
      activities: Value(activities),
      journal: Value(journal),
      canvasSeed: Value(canvasSeed),
      needed: needed == null && nullToAbsent
          ? const Value.absent()
          : Value(needed),
      actionTaken: actionTaken == null && nullToAbsent
          ? const Value.absent()
          : Value(actionTaken),
      afterMood: afterMood == null && nullToAbsent
          ? const Value.absent()
          : Value(afterMood),
      afterIntensity: afterIntensity == null && nullToAbsent
          ? const Value.absent()
          : Value(afterIntensity),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DailyEntryRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyEntryRecord(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      dateString: serializer.fromJson<String>(json['dateString']),
      mood: serializer.fromJson<String>(json['mood']),
      moodIntensity: serializer.fromJson<int>(json['moodIntensity']),
      energy: serializer.fromJson<String>(json['energy']),
      activities: serializer.fromJson<String>(json['activities']),
      journal: serializer.fromJson<String>(json['journal']),
      canvasSeed: serializer.fromJson<int>(json['canvasSeed']),
      needed: serializer.fromJson<String?>(json['needed']),
      actionTaken: serializer.fromJson<String?>(json['actionTaken']),
      afterMood: serializer.fromJson<String?>(json['afterMood']),
      afterIntensity: serializer.fromJson<int?>(json['afterIntensity']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<DateTime>(date),
      'dateString': serializer.toJson<String>(dateString),
      'mood': serializer.toJson<String>(mood),
      'moodIntensity': serializer.toJson<int>(moodIntensity),
      'energy': serializer.toJson<String>(energy),
      'activities': serializer.toJson<String>(activities),
      'journal': serializer.toJson<String>(journal),
      'canvasSeed': serializer.toJson<int>(canvasSeed),
      'needed': serializer.toJson<String?>(needed),
      'actionTaken': serializer.toJson<String?>(actionTaken),
      'afterMood': serializer.toJson<String?>(afterMood),
      'afterIntensity': serializer.toJson<int?>(afterIntensity),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DailyEntryRecord copyWith({
    String? id,
    DateTime? date,
    String? dateString,
    String? mood,
    int? moodIntensity,
    String? energy,
    String? activities,
    String? journal,
    int? canvasSeed,
    Value<String?> needed = const Value.absent(),
    Value<String?> actionTaken = const Value.absent(),
    Value<String?> afterMood = const Value.absent(),
    Value<int?> afterIntensity = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DailyEntryRecord(
    id: id ?? this.id,
    date: date ?? this.date,
    dateString: dateString ?? this.dateString,
    mood: mood ?? this.mood,
    moodIntensity: moodIntensity ?? this.moodIntensity,
    energy: energy ?? this.energy,
    activities: activities ?? this.activities,
    journal: journal ?? this.journal,
    canvasSeed: canvasSeed ?? this.canvasSeed,
    needed: needed.present ? needed.value : this.needed,
    actionTaken: actionTaken.present ? actionTaken.value : this.actionTaken,
    afterMood: afterMood.present ? afterMood.value : this.afterMood,
    afterIntensity: afterIntensity.present
        ? afterIntensity.value
        : this.afterIntensity,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DailyEntryRecord copyWithCompanion(DailyEntriesCompanion data) {
    return DailyEntryRecord(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      dateString: data.dateString.present
          ? data.dateString.value
          : this.dateString,
      mood: data.mood.present ? data.mood.value : this.mood,
      moodIntensity: data.moodIntensity.present
          ? data.moodIntensity.value
          : this.moodIntensity,
      energy: data.energy.present ? data.energy.value : this.energy,
      activities: data.activities.present
          ? data.activities.value
          : this.activities,
      journal: data.journal.present ? data.journal.value : this.journal,
      canvasSeed: data.canvasSeed.present
          ? data.canvasSeed.value
          : this.canvasSeed,
      needed: data.needed.present ? data.needed.value : this.needed,
      actionTaken: data.actionTaken.present
          ? data.actionTaken.value
          : this.actionTaken,
      afterMood: data.afterMood.present ? data.afterMood.value : this.afterMood,
      afterIntensity: data.afterIntensity.present
          ? data.afterIntensity.value
          : this.afterIntensity,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyEntryRecord(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('dateString: $dateString, ')
          ..write('mood: $mood, ')
          ..write('moodIntensity: $moodIntensity, ')
          ..write('energy: $energy, ')
          ..write('activities: $activities, ')
          ..write('journal: $journal, ')
          ..write('canvasSeed: $canvasSeed, ')
          ..write('needed: $needed, ')
          ..write('actionTaken: $actionTaken, ')
          ..write('afterMood: $afterMood, ')
          ..write('afterIntensity: $afterIntensity, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    dateString,
    mood,
    moodIntensity,
    energy,
    activities,
    journal,
    canvasSeed,
    needed,
    actionTaken,
    afterMood,
    afterIntensity,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyEntryRecord &&
          other.id == this.id &&
          other.date == this.date &&
          other.dateString == this.dateString &&
          other.mood == this.mood &&
          other.moodIntensity == this.moodIntensity &&
          other.energy == this.energy &&
          other.activities == this.activities &&
          other.journal == this.journal &&
          other.canvasSeed == this.canvasSeed &&
          other.needed == this.needed &&
          other.actionTaken == this.actionTaken &&
          other.afterMood == this.afterMood &&
          other.afterIntensity == this.afterIntensity &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DailyEntriesCompanion extends UpdateCompanion<DailyEntryRecord> {
  final Value<String> id;
  final Value<DateTime> date;
  final Value<String> dateString;
  final Value<String> mood;
  final Value<int> moodIntensity;
  final Value<String> energy;
  final Value<String> activities;
  final Value<String> journal;
  final Value<int> canvasSeed;
  final Value<String?> needed;
  final Value<String?> actionTaken;
  final Value<String?> afterMood;
  final Value<int?> afterIntensity;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DailyEntriesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.dateString = const Value.absent(),
    this.mood = const Value.absent(),
    this.moodIntensity = const Value.absent(),
    this.energy = const Value.absent(),
    this.activities = const Value.absent(),
    this.journal = const Value.absent(),
    this.canvasSeed = const Value.absent(),
    this.needed = const Value.absent(),
    this.actionTaken = const Value.absent(),
    this.afterMood = const Value.absent(),
    this.afterIntensity = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyEntriesCompanion.insert({
    required String id,
    required DateTime date,
    required String dateString,
    required String mood,
    required int moodIntensity,
    required String energy,
    required String activities,
    required String journal,
    required int canvasSeed,
    this.needed = const Value.absent(),
    this.actionTaken = const Value.absent(),
    this.afterMood = const Value.absent(),
    this.afterIntensity = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       dateString = Value(dateString),
       mood = Value(mood),
       moodIntensity = Value(moodIntensity),
       energy = Value(energy),
       activities = Value(activities),
       journal = Value(journal),
       canvasSeed = Value(canvasSeed),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<DailyEntryRecord> custom({
    Expression<String>? id,
    Expression<DateTime>? date,
    Expression<String>? dateString,
    Expression<String>? mood,
    Expression<int>? moodIntensity,
    Expression<String>? energy,
    Expression<String>? activities,
    Expression<String>? journal,
    Expression<int>? canvasSeed,
    Expression<String>? needed,
    Expression<String>? actionTaken,
    Expression<String>? afterMood,
    Expression<int>? afterIntensity,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (dateString != null) 'date_string': dateString,
      if (mood != null) 'mood': mood,
      if (moodIntensity != null) 'mood_intensity': moodIntensity,
      if (energy != null) 'energy': energy,
      if (activities != null) 'activities': activities,
      if (journal != null) 'journal': journal,
      if (canvasSeed != null) 'canvas_seed': canvasSeed,
      if (needed != null) 'needed': needed,
      if (actionTaken != null) 'action_taken': actionTaken,
      if (afterMood != null) 'after_mood': afterMood,
      if (afterIntensity != null) 'after_intensity': afterIntensity,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyEntriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? date,
    Value<String>? dateString,
    Value<String>? mood,
    Value<int>? moodIntensity,
    Value<String>? energy,
    Value<String>? activities,
    Value<String>? journal,
    Value<int>? canvasSeed,
    Value<String?>? needed,
    Value<String?>? actionTaken,
    Value<String?>? afterMood,
    Value<int?>? afterIntensity,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DailyEntriesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      dateString: dateString ?? this.dateString,
      mood: mood ?? this.mood,
      moodIntensity: moodIntensity ?? this.moodIntensity,
      energy: energy ?? this.energy,
      activities: activities ?? this.activities,
      journal: journal ?? this.journal,
      canvasSeed: canvasSeed ?? this.canvasSeed,
      needed: needed ?? this.needed,
      actionTaken: actionTaken ?? this.actionTaken,
      afterMood: afterMood ?? this.afterMood,
      afterIntensity: afterIntensity ?? this.afterIntensity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (dateString.present) {
      map['date_string'] = Variable<String>(dateString.value);
    }
    if (mood.present) {
      map['mood'] = Variable<String>(mood.value);
    }
    if (moodIntensity.present) {
      map['mood_intensity'] = Variable<int>(moodIntensity.value);
    }
    if (energy.present) {
      map['energy'] = Variable<String>(energy.value);
    }
    if (activities.present) {
      map['activities'] = Variable<String>(activities.value);
    }
    if (journal.present) {
      map['journal'] = Variable<String>(journal.value);
    }
    if (canvasSeed.present) {
      map['canvas_seed'] = Variable<int>(canvasSeed.value);
    }
    if (needed.present) {
      map['needed'] = Variable<String>(needed.value);
    }
    if (actionTaken.present) {
      map['action_taken'] = Variable<String>(actionTaken.value);
    }
    if (afterMood.present) {
      map['after_mood'] = Variable<String>(afterMood.value);
    }
    if (afterIntensity.present) {
      map['after_intensity'] = Variable<int>(afterIntensity.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyEntriesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('dateString: $dateString, ')
          ..write('mood: $mood, ')
          ..write('moodIntensity: $moodIntensity, ')
          ..write('energy: $energy, ')
          ..write('activities: $activities, ')
          ..write('journal: $journal, ')
          ..write('canvasSeed: $canvasSeed, ')
          ..write('needed: $needed, ')
          ..write('actionTaken: $actionTaken, ')
          ..write('afterMood: $afterMood, ')
          ..write('afterIntensity: $afterIntensity, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSettingRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSettingRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingRecord(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSettingRecord extends DataClass
    implements Insertable<AppSettingRecord> {
  final String key;
  final String value;
  const AppSettingRecord({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSettingRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingRecord(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSettingRecord copyWith({String? key, String? value}) =>
      AppSettingRecord(key: key ?? this.key, value: value ?? this.value);
  AppSettingRecord copyWithCompanion(AppSettingsCompanion data) {
    return AppSettingRecord(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingRecord(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingRecord &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSettingRecord> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSettingRecord> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DailyEntriesTable dailyEntries = $DailyEntriesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    dailyEntries,
    appSettings,
  ];
}

typedef $$DailyEntriesTableCreateCompanionBuilder =
    DailyEntriesCompanion Function({
      required String id,
      required DateTime date,
      required String dateString,
      required String mood,
      required int moodIntensity,
      required String energy,
      required String activities,
      required String journal,
      required int canvasSeed,
      Value<String?> needed,
      Value<String?> actionTaken,
      Value<String?> afterMood,
      Value<int?> afterIntensity,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$DailyEntriesTableUpdateCompanionBuilder =
    DailyEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> date,
      Value<String> dateString,
      Value<String> mood,
      Value<int> moodIntensity,
      Value<String> energy,
      Value<String> activities,
      Value<String> journal,
      Value<int> canvasSeed,
      Value<String?> needed,
      Value<String?> actionTaken,
      Value<String?> afterMood,
      Value<int?> afterIntensity,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$DailyEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $DailyEntriesTable> {
  $$DailyEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateString => $composableBuilder(
    column: $table.dateString,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get moodIntensity => $composableBuilder(
    column: $table.moodIntensity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get energy => $composableBuilder(
    column: $table.energy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activities => $composableBuilder(
    column: $table.activities,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get journal => $composableBuilder(
    column: $table.journal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get canvasSeed => $composableBuilder(
    column: $table.canvasSeed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get needed => $composableBuilder(
    column: $table.needed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionTaken => $composableBuilder(
    column: $table.actionTaken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get afterMood => $composableBuilder(
    column: $table.afterMood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get afterIntensity => $composableBuilder(
    column: $table.afterIntensity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyEntriesTable> {
  $$DailyEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateString => $composableBuilder(
    column: $table.dateString,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get moodIntensity => $composableBuilder(
    column: $table.moodIntensity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get energy => $composableBuilder(
    column: $table.energy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activities => $composableBuilder(
    column: $table.activities,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get journal => $composableBuilder(
    column: $table.journal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get canvasSeed => $composableBuilder(
    column: $table.canvasSeed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get needed => $composableBuilder(
    column: $table.needed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionTaken => $composableBuilder(
    column: $table.actionTaken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get afterMood => $composableBuilder(
    column: $table.afterMood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get afterIntensity => $composableBuilder(
    column: $table.afterIntensity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyEntriesTable> {
  $$DailyEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get dateString => $composableBuilder(
    column: $table.dateString,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<int> get moodIntensity => $composableBuilder(
    column: $table.moodIntensity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get energy =>
      $composableBuilder(column: $table.energy, builder: (column) => column);

  GeneratedColumn<String> get activities => $composableBuilder(
    column: $table.activities,
    builder: (column) => column,
  );

  GeneratedColumn<String> get journal =>
      $composableBuilder(column: $table.journal, builder: (column) => column);

  GeneratedColumn<int> get canvasSeed => $composableBuilder(
    column: $table.canvasSeed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get needed =>
      $composableBuilder(column: $table.needed, builder: (column) => column);

  GeneratedColumn<String> get actionTaken => $composableBuilder(
    column: $table.actionTaken,
    builder: (column) => column,
  );

  GeneratedColumn<String> get afterMood =>
      $composableBuilder(column: $table.afterMood, builder: (column) => column);

  GeneratedColumn<int> get afterIntensity => $composableBuilder(
    column: $table.afterIntensity,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DailyEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyEntriesTable,
          DailyEntryRecord,
          $$DailyEntriesTableFilterComposer,
          $$DailyEntriesTableOrderingComposer,
          $$DailyEntriesTableAnnotationComposer,
          $$DailyEntriesTableCreateCompanionBuilder,
          $$DailyEntriesTableUpdateCompanionBuilder,
          (
            DailyEntryRecord,
            BaseReferences<_$AppDatabase, $DailyEntriesTable, DailyEntryRecord>,
          ),
          DailyEntryRecord,
          PrefetchHooks Function()
        > {
  $$DailyEntriesTableTableManager(_$AppDatabase db, $DailyEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> dateString = const Value.absent(),
                Value<String> mood = const Value.absent(),
                Value<int> moodIntensity = const Value.absent(),
                Value<String> energy = const Value.absent(),
                Value<String> activities = const Value.absent(),
                Value<String> journal = const Value.absent(),
                Value<int> canvasSeed = const Value.absent(),
                Value<String?> needed = const Value.absent(),
                Value<String?> actionTaken = const Value.absent(),
                Value<String?> afterMood = const Value.absent(),
                Value<int?> afterIntensity = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyEntriesCompanion(
                id: id,
                date: date,
                dateString: dateString,
                mood: mood,
                moodIntensity: moodIntensity,
                energy: energy,
                activities: activities,
                journal: journal,
                canvasSeed: canvasSeed,
                needed: needed,
                actionTaken: actionTaken,
                afterMood: afterMood,
                afterIntensity: afterIntensity,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime date,
                required String dateString,
                required String mood,
                required int moodIntensity,
                required String energy,
                required String activities,
                required String journal,
                required int canvasSeed,
                Value<String?> needed = const Value.absent(),
                Value<String?> actionTaken = const Value.absent(),
                Value<String?> afterMood = const Value.absent(),
                Value<int?> afterIntensity = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => DailyEntriesCompanion.insert(
                id: id,
                date: date,
                dateString: dateString,
                mood: mood,
                moodIntensity: moodIntensity,
                energy: energy,
                activities: activities,
                journal: journal,
                canvasSeed: canvasSeed,
                needed: needed,
                actionTaken: actionTaken,
                afterMood: afterMood,
                afterIntensity: afterIntensity,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DailyEntriesTable, DailyEntryRecord>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $DailyEntriesTable,
                    DailyEntryRecord
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyEntriesTable,
      DailyEntryRecord,
      $$DailyEntriesTableFilterComposer,
      $$DailyEntriesTableOrderingComposer,
      $$DailyEntriesTableAnnotationComposer,
      $$DailyEntriesTableCreateCompanionBuilder,
      $$DailyEntriesTableUpdateCompanionBuilder,
      (
        DailyEntryRecord,
        BaseReferences<_$AppDatabase, $DailyEntriesTable, DailyEntryRecord>,
      ),
      DailyEntryRecord,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSettingRecord,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSettingRecord,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSettingRecord>,
          ),
          AppSettingRecord,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSettingRecord>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AppSettingsTable,
                    AppSettingRecord
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSettingRecord,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSettingRecord,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSettingRecord>,
      ),
      AppSettingRecord,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DailyEntriesTableTableManager get dailyEntries =>
      $$DailyEntriesTableTableManager(_db, _db.dailyEntries);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
