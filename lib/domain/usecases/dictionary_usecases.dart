import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dictionary/domain/entities/dictionary_entity.dart';
import 'package:dictionary/domain/repositories/dictionary_repository.dart';

import '../failures/failures.dart';

/// Exposes all available methods for the Dictionary feature.
class DictionaryUseCases {
  DictionaryUseCases(this.repository);

  final DictionaryRepository repository;

  /// Queries the list of words available.
  ///
  /// [lastWordVisible] is used for pagination purposes. If it is provided, then
  /// the results returned will start from the next available word in the storage.
  ///
  /// Usually the first time this method is called, [lastWordVisible] is null and
  /// subsequent calls will use the [DictionaryEntity] returned to provide this
  /// variable.
  Future<Either<Failure, DictionaryEntity>> getWordsList({
    QueryDocumentSnapshot<Map<String, dynamic>>? lastWordVisible,
  }) async {
    return repository.getWordsList(lastWordVisible: lastWordVisible);
  }
}
