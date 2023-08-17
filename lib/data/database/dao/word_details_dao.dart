import 'package:dictionary/data/database/tables/word_details_table.dart';
import 'package:drift/drift.dart';

import '../database.dart';

part 'word_details_dao.g.dart';

@DriftAccessor(tables: [WordDetailsTable])
class WordDetailsDao extends DatabaseAccessor<AppDatabase>
    with _$WordDetailsDaoMixin {
  WordDetailsDao(this.db) : super(db);

  final AppDatabase db;

  /// Queries the local database to get [word]. If no row is found, a null will
  /// be returned.
  Future<WordDetails?> get(String word) => (select(wordDetailsTable)
        ..where((t) => t.word.equals(word))
        ..orderBy(
            [(t) => OrderingTerm(expression: t.word, mode: OrderingMode.asc)])
        ..limit(1))
      .getSingleOrNull();

  /// Inserts a new [wordDetails] into the database. If the row is already
  /// present, then it is updated.
  Future<int> upsert(WordDetails wordDetails) =>
      into(wordDetailsTable).insertOnConflictUpdate(wordDetails);

  ///! WARNING: this method is mainly intended to be used for testing.
  Future<List<WordDetails>> getList(String word) => (select(wordDetailsTable)
        ..where((t) => t.word.equals(word))
        ..orderBy(
            [(t) => OrderingTerm(expression: t.word, mode: OrderingMode.asc)])
        ..limit(1))
      .get();
}
