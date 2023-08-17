import 'dart:convert';

import 'package:dictionary/data/database/database.dart';
import 'package:dictionary/data/datasources/local/word_details_local_datasource.dart';
import 'package:dictionary/data/models/word_details_model.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

final wordDetails = WordDetailsModel(
  word: 'word',
  json: json.encode({'word': 'word'}),
  isFavorite: true,
);

void main() {
  late AppDatabase database;
  late WordDetailsLocalDatasourceImpl sut;

  setUp(() {
    database = AppDatabase.unitTest(NativeDatabase.memory());
    sut = WordDetailsLocalDatasourceImpl(database.wordDetailsDao);
  });

  tearDown(() async {
    await database.close();
  });

  group('WordDetailsLocalDatasource', () {
    group('upsert word details', () {
      test('and new data is provided', () async {
        await sut.cacheWordDetails(wordDetails);

        final details = await sut.getWordDetails(wordDetails.word);

        expect(details, isNotNull);
        expect(details?.word, wordDetails.word);
      });

      test('and existing data is provided', () async {
        await sut.cacheWordDetails(wordDetails);
        await sut.cacheWordDetails(wordDetails);

        final details = await database.wordDetailsDao.getList(wordDetails.word);

        expect(details.length, 1);
      });
    });

    group('get word details', () {
      test('and a word in the cache is provided', () async {
        await sut.cacheWordDetails(wordDetails);

        final details = await sut.getWordDetails(wordDetails.word);

        expect(details, isNotNull);
        expect(details?.word, wordDetails.word);
      });

      test('and a word not in the cache is provided', () async {
        final details = await sut.getWordDetails('');

        expect(details, isNull);
      });
    });
  });
}
