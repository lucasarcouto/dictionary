import 'package:dictionary/data/exceptions/exceptions.dart';
import 'package:dictionary/data/models/word_details_model.dart';
import 'package:dio/dio.dart';

abstract class WordDetailsRemoteDatasource {
  Future<WordDetailsModel?> getWordDetails(String word);
}

class WordDetailsRemoteDatasourceImpl implements WordDetailsRemoteDatasource {
  WordDetailsRemoteDatasourceImpl(this.client);

  final Dio client;

  @override
  Future<WordDetailsModel?> getWordDetails(String word) async {
    try {
      final response = await client.get(
        'https://us-central1-dictionary-lc.cloudfunctions.net/wordsAPI?word=$word',
      );

      if (response.statusCode != 200) {
        throw ServerException();
      } else {
        final data = response.data as Map<String, dynamic>;

        if (data.containsKey('success') && !data['success']) {
          return null;
        }

        return WordDetailsModel.fromJson(data);
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
