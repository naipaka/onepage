// dart format width=80
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

class Diaries extends Table with TableInfo<Diaries, DiariesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Diaries(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints:
        'NOT NULL DEFAULT (CAST(strftime(\'%s\', CURRENT_TIMESTAMP) AS INTEGER))',
    defaultValue: const CustomExpression(
      'CAST(strftime(\'%s\', CURRENT_TIMESTAMP) AS INTEGER)',
    ),
  );
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints:
        'NOT NULL DEFAULT (CAST(strftime(\'%s\', CURRENT_TIMESTAMP) AS INTEGER))',
    defaultValue: const CustomExpression(
      'CAST(strftime(\'%s\', CURRENT_TIMESTAMP) AS INTEGER)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    content,
    date,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diaries';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiariesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiariesData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  Diaries createAlias(String alias) {
    return Diaries(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class DiariesData extends DataClass implements Insertable<DiariesData> {
  final int id;
  final String content;
  final int date;
  final int createdAt;
  final int updatedAt;
  const DiariesData({
    required this.id,
    required this.content,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['content'] = Variable<String>(content);
    map['date'] = Variable<int>(date);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  DiariesCompanion toCompanion(bool nullToAbsent) {
    return DiariesCompanion(
      id: Value(id),
      content: Value(content),
      date: Value(date),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DiariesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiariesData(
      id: serializer.fromJson<int>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      date: serializer.fromJson<int>(json['date']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'content': serializer.toJson<String>(content),
      'date': serializer.toJson<int>(date),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  DiariesData copyWith({
    int? id,
    String? content,
    int? date,
    int? createdAt,
    int? updatedAt,
  }) => DiariesData(
    id: id ?? this.id,
    content: content ?? this.content,
    date: date ?? this.date,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DiariesData copyWithCompanion(DiariesCompanion data) {
    return DiariesData(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      date: data.date.present ? data.date.value : this.date,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiariesData(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, content, date, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiariesData &&
          other.id == this.id &&
          other.content == this.content &&
          other.date == this.date &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DiariesCompanion extends UpdateCompanion<DiariesData> {
  final Value<int> id;
  final Value<String> content;
  final Value<int> date;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const DiariesCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.date = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DiariesCompanion.insert({
    this.id = const Value.absent(),
    required String content,
    required int date,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : content = Value(content),
       date = Value(date);
  static Insertable<DiariesData> custom({
    Expression<int>? id,
    Expression<String>? content,
    Expression<int>? date,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (date != null) 'date': date,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DiariesCompanion copyWith({
    Value<int>? id,
    Value<String>? content,
    Value<int>? date,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return DiariesCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiariesCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class DiaryImages extends Table with TableInfo<DiaryImages, DiaryImagesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  DiaryImages(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  late final GeneratedColumn<int> diaryId = GeneratedColumn<int>(
    'diary_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES diaries(id)ON DELETE CASCADE',
  );
  late final GeneratedColumn<String> photoId = GeneratedColumn<String>(
    'photo_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints:
        'NOT NULL DEFAULT (CAST(strftime(\'%s\', CURRENT_TIMESTAMP) AS INTEGER))',
    defaultValue: const CustomExpression(
      'CAST(strftime(\'%s\', CURRENT_TIMESTAMP) AS INTEGER)',
    ),
  );
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints:
        'NOT NULL DEFAULT (CAST(strftime(\'%s\', CURRENT_TIMESTAMP) AS INTEGER))',
    defaultValue: const CustomExpression(
      'CAST(strftime(\'%s\', CURRENT_TIMESTAMP) AS INTEGER)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    diaryId,
    photoId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diary_images';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiaryImagesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiaryImagesData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      diaryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}diary_id'],
      )!,
      photoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  DiaryImages createAlias(String alias) {
    return DiaryImages(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class DiaryImagesData extends DataClass implements Insertable<DiaryImagesData> {
  final int id;
  final int diaryId;
  final String photoId;
  final int createdAt;
  final int updatedAt;
  const DiaryImagesData({
    required this.id,
    required this.diaryId,
    required this.photoId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['diary_id'] = Variable<int>(diaryId);
    map['photo_id'] = Variable<String>(photoId);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  DiaryImagesCompanion toCompanion(bool nullToAbsent) {
    return DiaryImagesCompanion(
      id: Value(id),
      diaryId: Value(diaryId),
      photoId: Value(photoId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DiaryImagesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiaryImagesData(
      id: serializer.fromJson<int>(json['id']),
      diaryId: serializer.fromJson<int>(json['diaryId']),
      photoId: serializer.fromJson<String>(json['photoId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'diaryId': serializer.toJson<int>(diaryId),
      'photoId': serializer.toJson<String>(photoId),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  DiaryImagesData copyWith({
    int? id,
    int? diaryId,
    String? photoId,
    int? createdAt,
    int? updatedAt,
  }) => DiaryImagesData(
    id: id ?? this.id,
    diaryId: diaryId ?? this.diaryId,
    photoId: photoId ?? this.photoId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DiaryImagesData copyWithCompanion(DiaryImagesCompanion data) {
    return DiaryImagesData(
      id: data.id.present ? data.id.value : this.id,
      diaryId: data.diaryId.present ? data.diaryId.value : this.diaryId,
      photoId: data.photoId.present ? data.photoId.value : this.photoId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiaryImagesData(')
          ..write('id: $id, ')
          ..write('diaryId: $diaryId, ')
          ..write('photoId: $photoId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, diaryId, photoId, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiaryImagesData &&
          other.id == this.id &&
          other.diaryId == this.diaryId &&
          other.photoId == this.photoId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DiaryImagesCompanion extends UpdateCompanion<DiaryImagesData> {
  final Value<int> id;
  final Value<int> diaryId;
  final Value<String> photoId;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const DiaryImagesCompanion({
    this.id = const Value.absent(),
    this.diaryId = const Value.absent(),
    this.photoId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DiaryImagesCompanion.insert({
    this.id = const Value.absent(),
    required int diaryId,
    required String photoId,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : diaryId = Value(diaryId),
       photoId = Value(photoId);
  static Insertable<DiaryImagesData> custom({
    Expression<int>? id,
    Expression<int>? diaryId,
    Expression<String>? photoId,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (diaryId != null) 'diary_id': diaryId,
      if (photoId != null) 'photo_id': photoId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DiaryImagesCompanion copyWith({
    Value<int>? id,
    Value<int>? diaryId,
    Value<String>? photoId,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return DiaryImagesCompanion(
      id: id ?? this.id,
      diaryId: diaryId ?? this.diaryId,
      photoId: photoId ?? this.photoId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (diaryId.present) {
      map['diary_id'] = Variable<int>(diaryId.value);
    }
    if (photoId.present) {
      map['photo_id'] = Variable<String>(photoId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiaryImagesCompanion(')
          ..write('id: $id, ')
          ..write('diaryId: $diaryId, ')
          ..write('photoId: $photoId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV3 extends GeneratedDatabase {
  DatabaseAtV3(QueryExecutor e) : super(e);
  late final Diaries diaries = Diaries(this);
  late final DiaryImages diaryImages = DiaryImages(this);
  late final Index idxDiariesDate = Index(
    'idx_diaries_date',
    'CREATE INDEX idx_diaries_date ON diaries (date)',
  );
  late final Index idxDiaryImagesDiaryId = Index(
    'idx_diary_images_diary_id',
    'CREATE INDEX idx_diary_images_diary_id ON diary_images (diary_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    diaries,
    diaryImages,
    idxDiariesDate,
    idxDiaryImagesDiaryId,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'diaries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('diary_images', kind: UpdateKind.delete)],
    ),
  ]);
  @override
  int get schemaVersion => 3;
}
