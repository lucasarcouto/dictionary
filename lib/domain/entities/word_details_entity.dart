import 'package:equatable/equatable.dart';

class WordDetailsEntity extends Equatable {
  const WordDetailsEntity({
    required this.word,
    this.results,
    this.syllables,
    this.pronunciation,
    this.frequency,
    required this.json,
    required this.isFavorite,
  });

  final String word;
  final List<WordResult>? results;
  final WordSyllables? syllables;
  final WordPronunciation? pronunciation;
  final double? frequency;
  final String json;
  final bool isFavorite;

  @override
  List<Object?> get props => [
        word,
        results,
        syllables,
        pronunciation,
        frequency,
        json,
        isFavorite,
      ];

  WordDetailsEntity copyWith({
    String? word,
    List<WordResult>? results,
    WordSyllables? syllables,
    WordPronunciation? pronunciation,
    double? frequency,
    String? json,
    bool? isFavorite,
  }) {
    return WordDetailsEntity(
      word: word ?? this.word,
      results: results ?? this.results,
      syllables: syllables ?? this.syllables,
      pronunciation: pronunciation ?? this.pronunciation,
      frequency: frequency ?? this.frequency,
      json: json ?? this.json,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class WordResult extends Equatable {
  const WordResult({
    this.definition,
    this.partOfSpeech,
    this.synonyms,
    this.typeOf,
    this.hasTypes,
    this.derivation,
    this.examples,
  });

  final String? definition;
  final String? partOfSpeech;
  final List<String>? synonyms;
  final List<String>? typeOf;
  final List<String>? hasTypes;
  final List<String>? derivation;
  final List<String>? examples;

  @override
  List<Object?> get props => [
        definition,
        partOfSpeech,
        synonyms,
        typeOf,
        hasTypes,
        derivation,
        examples,
      ];
}

class WordSyllables extends Equatable {
  const WordSyllables({required this.count, required this.list});

  final int? count;
  final List<String>? list;

  @override
  List<Object?> get props => [count, list];
}

class WordPronunciation extends Equatable {
  const WordPronunciation(this.all);

  final String? all;

  @override
  List<Object?> get props => [all];
}
