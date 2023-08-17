import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dictionary/data/datasources/remote/history_remote_datasource.dart';
import 'package:dictionary/data/models/history_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../_mocks/firebase_mocks.dart';

const list = ['a', 'b', 'c'];
const userId = '123';

void main() {
  late FakeFirebaseFirestore mockFirebaseFirestore;
  late MockUser mockUser;
  late HistoryRemoteDatasourceImpl sut;

  setUp(() {
    mockFirebaseFirestore = FakeFirebaseFirestore();
    mockUser = MockUser();
    sut = HistoryRemoteDatasourceImpl(mockUser, mockFirebaseFirestore);
  });

  group('HistoryRemoteDatasource', () {
    group('query list of history', () {
      group('current user is signed in', () {
        test('and there is no history registered', () async {
          when(() => mockUser.uid).thenReturn(userId);

          final response = await sut.getHistory();

          expect(response, isNotNull);
          expect(response, isA<HistoryModel>());
          expect(response!.history, isEmpty);
        });

        test('and there are registered words in the history', () async {
          when(() => mockUser.uid).thenReturn(userId);

          await populateInitialData(mockFirebaseFirestore);

          final response = await sut.getHistory();

          expect(response, isNotNull);
          expect(response, isA<HistoryModel>());
          expect(response!.history, equals(list));
          expect(response.lastHistoryVisible, isNotNull);
          expect(response.lastHistoryVisible,
              isA<QueryDocumentSnapshot<Map<String, dynamic>>>());
        });
      });

      test('current user is not signed in', () async {
        expect(() async => await sut.getHistory(), throwsA(isA<TypeError>()));
      });
    });

    group('add word to history', () {
      group('current user is signed in', () {
        test('and there are no history', () async {
          when(() => mockUser.uid).thenReturn(userId);

          await sut.addToHistory('d');

          final response = await sut.getHistory();

          expect(response, isNotNull);
          expect(response!.history, equals(['d']));
        });

        test('there are registered history and a valid word is given',
            () async {
          when(() => mockUser.uid).thenReturn(userId);

          await populateInitialData(mockFirebaseFirestore);

          await sut.addToHistory('d');

          final response = await sut.getHistory();

          expect(response, isNotNull);
          expect(response!.history, equals([...list, 'd']));
        });

        test('there are registered history and an empty word is given',
            () async {
          when(() => mockUser.uid).thenReturn(userId);

          await populateInitialData(mockFirebaseFirestore);

          await sut.addToHistory('');

          final response = await sut.getHistory();

          expect(response, isNotNull);
          expect(response!.history, equals(['', ...list]));
        });
      });

      test('current user is not signed in', () async {
        expect(
            () async => await sut.addToHistory('d'), throwsA(isA<TypeError>()));
      });
    });
  });
}

Future<void> populateInitialData(
    FakeFirebaseFirestore mockFirebaseFirestore) async {
  for (String item in list) {
    await mockFirebaseFirestore.doc('users/$userId/history/$item').set({});
  }
}
