import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dictionary/data/datasources/remote/dictionary_remote_datasource.dart';
import 'package:dictionary/data/models/dictionary_model.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

const list = ['a', 'b', 'c'];

void main() {
  late FakeFirebaseFirestore mockFirebaseFirestore;
  late DictionaryRemoteDatasourceImpl sut;

  setUp(() {
    mockFirebaseFirestore = FakeFirebaseFirestore();
    sut = DictionaryRemoteDatasourceImpl(mockFirebaseFirestore);
  });

  group('DictionaryRemoteDatasource', () {
    group('query list of words', () {
      test('and there are no words registered', () async {
        final response = await sut.getWordsList();

        expect(response, isA<DictionaryModel>());
        expect(response.words, isEmpty);
      });

      test('and there are registered words', () async {
        await populateInitialData(mockFirebaseFirestore);

        final response = await sut.getWordsList();

        expect(response, isA<DictionaryModel>());
        expect(response.words, equals(list));
        expect(response.lastWordVisible, isNotNull);
        expect(response.lastWordVisible,
            isA<QueryDocumentSnapshot<Map<String, dynamic>>>());
      });
    });
  });
}

Future<void> populateInitialData(
    FakeFirebaseFirestore mockFirebaseFirestore) async {
  for (String item in list) {
    await mockFirebaseFirestore.doc('dictionary/$item').set({});
  }
}
