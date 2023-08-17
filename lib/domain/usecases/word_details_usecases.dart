import 'package:dartz/dartz.dart';
import 'package:dictionary/domain/entities/word_details_entity.dart';
import 'package:dictionary/domain/repositories/word_details_repository.dart';

import '../failures/failures.dart';

/// Exposes all available methods for the Word Details feature.
class WordDetailsUseCases {
  WordDetailsUseCases(this.repository);

  final WordDetailsRepository repository;

  /// Queries the details for a given [word]. If a cache is present, that will
  /// be returned instead of making an API request.
  Future<Either<Failure, WordDetailsEntity?>> getWordDetails(
      String word) async {
    return repository.getWordDetails(word);
  }

  /// After the details for a word if loaded, this method should be called to
  /// cache it. If the cache is already present, nothing changes.
  Future<Either<Failure, int>> cacheWordDetails(
      WordDetailsEntity wordDetails) async {
    return repository.cacheWordDetails(wordDetails);
  }
}
