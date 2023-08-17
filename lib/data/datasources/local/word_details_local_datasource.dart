import 'dart:convert';

import 'package:dictionary/data/database/dao/word_details_dao.dart';
import 'package:dictionary/data/database/database.dart';
import 'package:dictionary/data/models/word_details_model.dart';

abstract class WordDetailsLocalDatasource {
  Future<WordDetailsModel?> getWordDetails(String word);
  Future<int> cacheWordDetails(WordDetailsModel wordDetails);
}

class WordDetailsLocalDatasourceImpl implements WordDetailsLocalDatasource {
  WordDetailsLocalDatasourceImpl(this.dao);

  final WordDetailsDao dao;

  @override
  Future<WordDetailsModel?> getWordDetails(String word) async {
    final response = await dao.get(word);

    if (response == null) {
      return null;
    } else {
      return WordDetailsModel.fromJson(json.decode(response.json));
    }
  }

  @override
  Future<int> cacheWordDetails(WordDetailsModel wordDetails) async {
    return await dao.upsert(WordDetails(
      word: wordDetails.word,
      json: wordDetails.json,
    ));
  }
}
