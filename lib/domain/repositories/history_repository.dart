import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dictionary/domain/entities/history_entity.dart';

import '../failures/failures.dart';

abstract class HistoryRepository {
  Future<Either<Failure, HistoryEntity?>> getHistory({
    QueryDocumentSnapshot<Map<String, dynamic>>? lastHistoryVisible,
  });
  Future<Either<Failure, void>> addToHistory(String word);
}
