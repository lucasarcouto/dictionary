import 'package:dictionary/data/datasources/remote/word_details_remote_datasource.dart';
import 'package:dictionary/data/exceptions/exceptions.dart';
import 'package:dictionary/data/models/word_details_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';

void main() {
  late MockClient mockClient;
  late WordDetailsRemoteDatasourceImpl sut;

  setUp(() {
    mockClient = MockClient();
    sut = WordDetailsRemoteDatasourceImpl(mockClient);
  });

  group('WordDetailsRemoteDatasource', () {
    group('query word details', () {
      group('response was 200', () {
        test('and valid data was returned', () async {
          const word = 'word';

          when(
            () => mockClient.get(
                'https://us-central1-dictionary-lc.cloudfunctions.net/wordsAPI?word=$word'),
          ).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(),
              statusCode: 200,
              data: {'word': word},
            ),
          );

          final response = await sut.getWordDetails(word);

          expect(response, isNotNull);
          expect(response, isA<WordDetailsModel>());
        });

        test('and word is not recognized by the API', () async {
          const word = 'word';

          when(
            () => mockClient.get(
                'https://us-central1-dictionary-lc.cloudfunctions.net/wordsAPI?word=$word'),
          ).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(),
              statusCode: 200,
              data: {'success': false},
            ),
          );

          final response = await sut.getWordDetails(word);

          expect(response, isNull);
        });

        test('and invalid data is returned', () async {
          const word = 'word';

          when(
            () => mockClient.get(
                'https://us-central1-dictionary-lc.cloudfunctions.net/wordsAPI?word=$word'),
          ).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(),
              statusCode: 200,
              data: {'a': 'a'},
            ),
          );

          expect(() async => await sut.getWordDetails(word),
              throwsA(isA<ServerException>()));
        });
      });

      test('and status code is not 200', () async {
        const word = 'word';

        when(
          () => mockClient.get(
              'https://us-central1-dictionary-lc.cloudfunctions.net/wordsAPI?word=$word'),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(),
            statusCode: 404,
          ),
        );

        expect(() async => await sut.getWordDetails(word),
            throwsA(isA<ServerException>()));
      });
    });
  });
}

class MockClient extends Mock implements Dio {}
