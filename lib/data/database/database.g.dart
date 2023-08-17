// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $WordDetailsTableTable extends WordDetailsTable
    with TableInfo<$WordDetailsTableTable, WordDetails> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WordDetailsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  @override
  late final GeneratedColumn<String> word = GeneratedColumn<String>(
      'word', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'UNIQUE NOT NULL');
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
      'json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [word, json];
  @override
  String get aliasedName => _alias ?? 'word_details_table';
  @override
  String get actualTableName => 'word_details_table';
  @override
  VerificationContext validateIntegrity(Insertable<WordDetails> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('word')) {
      context.handle(
          _wordMeta, word.isAcceptableOrUnknown(data['word']!, _wordMeta));
    } else if (isInserting) {
      context.missing(_wordMeta);
    }
    if (data.containsKey('json')) {
      context.handle(
          _jsonMeta, json.isAcceptableOrUnknown(data['json']!, _jsonMeta));
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {word};
  @override
  WordDetails map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WordDetails(
      word: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}word'])!,
      json: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}json'])!,
    );
  }

  @override
  $WordDetailsTableTable createAlias(String alias) {
    return $WordDetailsTableTable(attachedDatabase, alias);
  }
}

class WordDetails extends DataClass implements Insertable<WordDetails> {
  final String word;
  final String json;
  const WordDetails({required this.word, required this.json});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['word'] = Variable<String>(word);
    map['json'] = Variable<String>(json);
    return map;
  }

  WordDetailsTableCompanion toCompanion(bool nullToAbsent) {
    return WordDetailsTableCompanion(
      word: Value(word),
      json: Value(json),
    );
  }

  factory WordDetails.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WordDetails(
      word: serializer.fromJson<String>(json['word']),
      json: serializer.fromJson<String>(json['json']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'word': serializer.toJson<String>(word),
      'json': serializer.toJson<String>(json),
    };
  }

  WordDetails copyWith({String? word, String? json}) => WordDetails(
        word: word ?? this.word,
        json: json ?? this.json,
      );
  @override
  String toString() {
    return (StringBuffer('WordDetails(')
          ..write('word: $word, ')
          ..write('json: $json')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(word, json);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WordDetails &&
          other.word == this.word &&
          other.json == this.json);
}

class WordDetailsTableCompanion extends UpdateCompanion<WordDetails> {
  final Value<String> word;
  final Value<String> json;
  final Value<int> rowid;
  const WordDetailsTableCompanion({
    this.word = const Value.absent(),
    this.json = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WordDetailsTableCompanion.insert({
    required String word,
    required String json,
    this.rowid = const Value.absent(),
  })  : word = Value(word),
        json = Value(json);
  static Insertable<WordDetails> custom({
    Expression<String>? word,
    Expression<String>? json,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (word != null) 'word': word,
      if (json != null) 'json': json,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WordDetailsTableCompanion copyWith(
      {Value<String>? word, Value<String>? json, Value<int>? rowid}) {
    return WordDetailsTableCompanion(
      word: word ?? this.word,
      json: json ?? this.json,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordDetailsTableCompanion(')
          ..write('word: $word, ')
          ..write('json: $json, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $WordDetailsTableTable wordDetailsTable =
      $WordDetailsTableTable(this);
  late final WordDetailsDao wordDetailsDao =
      WordDetailsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [wordDetailsTable];
}
