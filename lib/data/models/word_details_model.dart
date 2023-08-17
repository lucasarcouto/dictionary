import 'dart:convert';

import 'package:dictionary/domain/entities/word_details_entity.dart';
import 'package:equatable/equatable.dart';

class WordDetailsModel extends WordDetailsEntity with EquatableMixin {
  const WordDetailsModel({
    required super.word,
    super.results,
    super.syllables,
    super.pronunciation,
    super.frequency,
    required super.json,
    required super.isFavorite,
  });

  factory WordDetailsModel.fromJson(Map<String, dynamic> json) {
    final results = json['results'] as List?;
    final syllables = json['syllables'];
    final pronunciation = json['pronunciation'];

    return WordDetailsModel(
      word: json['word'],
      results: results
          ?.map((result) => WordResult(
                definition: result['definition'],
                partOfSpeech: result['partOfSpeech'],
                synonyms: _mapToStringList(result['synonyms']),
                typeOf: _mapToStringList(result['typeOf']),
                hasTypes: _mapToStringList(result['hasTypes']),
                derivation: _mapToStringList(result['derivation']),
                examples: _mapToStringList(result['examples']),
              ))
          .toList(),
      syllables: WordSyllables(
        count: syllables?['count'],
        list: _mapToStringList(syllables?['list']),
      ),
      pronunciation: WordPronunciation(
        pronunciation is String ? pronunciation : pronunciation?['all'],
      ),
      frequency: json['frequency'],
      json: jsonEncode(json),
      isFavorite: false,
    );
  }
}

List<String>? _mapToStringList(dynamic list) {
  if (list == null) return null;

  return (list as List).map((item) => item as String).toList();
}
