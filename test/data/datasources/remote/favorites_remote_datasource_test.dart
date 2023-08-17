import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dictionary/data/datasources/remote/favorites_remote_datasource.dart';
import 'package:dictionary/data/models/favorites_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../_mocks/firebase_mocks.dart';

const list = ['a', 'b', 'c'];
const userId = '123';

void main() {
  late FakeFirebaseFirestore mockFirebaseFirestore;
  late MockUser mockUser;
  late FavoritesRemoteDatasourceImpl sut;

  setUp(() {
    mockFirebaseFirestore = FakeFirebaseFirestore();
    mockUser = MockUser();
    sut = FavoritesRemoteDatasourceImpl(mockUser, mockFirebaseFirestore);
  });

  group('FavoritesRemoteDatasource', () {
    group('query list of favorites', () {
      group('current user is signed in', () {
        test('and there are no favorites registered', () async {
          when(() => mockUser.uid).thenReturn(userId);

          final response = await sut.getFavorites();

          expect(response, isNotNull);
          expect(response, isA<FavoritesModel>());
          expect(response!.favorites, isEmpty);
        });

        test('and there are registered favorites', () async {
          when(() => mockUser.uid).thenReturn(userId);

          await populateInitialData(mockFirebaseFirestore);

          final response = await sut.getFavorites();

          expect(response, isNotNull);
          expect(response, isA<FavoritesModel>());
          expect(response!.favorites, equals(list));
          expect(response.lastFavoriteVisible, isNotNull);
          expect(response.lastFavoriteVisible,
              isA<QueryDocumentSnapshot<Map<String, dynamic>>>());
        });
      });

      test('current user is not signed in', () async {
        expect(() async => await sut.getFavorites(), throwsA(isA<TypeError>()));
      });
    });

    group('add word to favorites', () {
      group('current user is signed in', () {
        test('and there are no favorites', () async {
          when(() => mockUser.uid).thenReturn(userId);

          await sut.addToFavorites('d');

          final response = await sut.getFavorites();

          expect(response, isNotNull);
          expect(response!.favorites, equals(['d']));
        });

        test('there are registered favorites and a valid word is given',
            () async {
          when(() => mockUser.uid).thenReturn(userId);

          await populateInitialData(mockFirebaseFirestore);

          await sut.addToFavorites('d');

          final response = await sut.getFavorites();

          expect(response, isNotNull);
          expect(response!.favorites, equals([...list, 'd']));
        });

        test('there are registered favorites and an empty word is given',
            () async {
          when(() => mockUser.uid).thenReturn(userId);

          await populateInitialData(mockFirebaseFirestore);

          await sut.addToFavorites('');

          final response = await sut.getFavorites();

          expect(response, isNotNull);
          expect(response!.favorites, equals(['', ...list]));
        });
      });

      test('current user is not signed in', () async {
        expect(() async => await sut.addToFavorites('d'),
            throwsA(isA<TypeError>()));
      });
    });

    group('check if word is in the list of favorites', () {
      group('current user is signed in', () {
        test('and there are no favorites', () async {
          when(() => mockUser.uid).thenReturn(userId);

          final response = await sut.isFavorite('d');

          expect(response, false);
        });

        test('there are registered favorites and word is a favorite', () async {
          when(() => mockUser.uid).thenReturn(userId);

          await populateInitialData(mockFirebaseFirestore);

          final response = await sut.isFavorite('a');

          expect(response, true);
        });

        test('there are registered favorites and word is not a favorite',
            () async {
          when(() => mockUser.uid).thenReturn(userId);

          await populateInitialData(mockFirebaseFirestore);

          final response = await sut.isFavorite('');

          expect(response, false);
        });
      });

      test('current user is not signed in', () async {
        expect(() async => await sut.addToFavorites('d'),
            throwsA(isA<TypeError>()));
      });
    });

    group('remove word from favorites', () {
      group('current user is signed in', () {
        test('and there are no favorites', () async {
          when(() => mockUser.uid).thenReturn(userId);

          await sut.removeFavorite('d');

          final response = await sut.getFavorites();

          expect(response, isNotNull);
          expect(response!.favorites, isEmpty);
        });

        test('there are registered favorites and word is a favorite', () async {
          when(() => mockUser.uid).thenReturn(userId);

          await populateInitialData(mockFirebaseFirestore);

          await sut.removeFavorite('a');

          final response = await sut.getFavorites();

          expect(response, isNotNull);
          expect(response!.favorites, isNot(contains('a')));
          expect(response.favorites, isNot(equals(list)));
        });

        test('there are registered favorites and word is not a favorite',
            () async {
          when(() => mockUser.uid).thenReturn(userId);

          await populateInitialData(mockFirebaseFirestore);

          await sut.removeFavorite('d');

          final response = await sut.getFavorites();

          expect(response, isNotNull);
          expect(response!.favorites, isNot(contains('d')));
          expect(response.favorites, equals(list));
        });
      });

      test('current user is not signed in', () async {
        expect(() async => await sut.removeFavorite('d'),
            throwsA(isA<TypeError>()));
      });
    });
  });
}

Future<void> populateInitialData(
    FakeFirebaseFirestore mockFirebaseFirestore) async {
  for (String item in list) {
    await mockFirebaseFirestore.doc('users/$userId/favorites/$item').set({});
  }
}
