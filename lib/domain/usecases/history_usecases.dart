import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dictionary/domain/entities/history_entity.dart';
import 'package:dictionary/domain/repositories/history_repository.dart';

import '../failures/failures.dart';

/// Exposes all available methods for the History feature.
///
/// All methods in this class require [userId] which is the id for the currently
/// signed in user. You can get this from [FirebaseAuth]'s [currentUser].
class HistoryUseCases {
  HistoryUseCases(this.repository);

  final HistoryRepository repository;

  /// Queries the history of words a user accessed the details of.
  ///
  /// [lastHistoryVisible] is used for pagination purposes. If it is provided,
  /// then the results returned will start from the next available history item
  /// in the storage.
  ///
  /// Usually the first time this method is called, [lastHistoryVisible] is
  /// null and subsequent calls will use the [HistoryEntity] returned to
  /// provide this variable.
  Future<Either<Failure, HistoryEntity?>> getHistory({
    QueryDocumentSnapshot<Map<String, dynamic>>? lastHistoryVisible,
  }) async {
    return repository.getHistory(lastHistoryVisible: lastHistoryVisible);
  }

  /// After a user open the details for a given [word], this method should be
  /// called to add that word to the history.
  Future<Either<Failure, void>> addToHistory(String word) async {
    return repository.addToHistory(word);
  }
}
