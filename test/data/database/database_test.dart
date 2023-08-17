import 'package:dictionary/data/database/database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

const wordDetails = WordDetails(word: 'word', json: '{}');

void main() {
  late AppDatabase sut;

  setUp(() {
    sut = AppDatabase.unitTest(NativeDatabase.memory());
  });

  tearDown(() async {
    await sut.close();
  });

  group('AppDatabase', () {
    group('upsert word details', () {
      test('and new data is provided', () async {
        await sut.wordDetailsDao.upsert(wordDetails);

        final details = await sut.wordDetailsDao.get(wordDetails.word);

        expect(details, isNotNull);
        expect(details?.word, wordDetails.word);
      });

      test('and existing data is provided', () async {
        await sut.wordDetailsDao.upsert(wordDetails);
        await sut.wordDetailsDao.upsert(wordDetails);

        final details = await sut.wordDetailsDao.getList(wordDetails.word);

        expect(details.length, 1);
      });
    });

    group('get word details', () {
      test('and a word in the database is provided', () async {
        await sut.wordDetailsDao.upsert(wordDetails);

        final details = await sut.wordDetailsDao.get(wordDetails.word);

        expect(details, isNotNull);
        expect(details?.word, wordDetails.word);
      });

      test('and a word not in the database is provided', () async {
        final details = await sut.wordDetailsDao.get('');

        expect(details, isNull);
      });
    });
  });
}
