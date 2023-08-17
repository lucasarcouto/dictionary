import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dictionary/data/datasources/remote/history_remote_datasource.dart';
import 'package:dictionary/domain/entities/history_entity.dart';
import 'package:dictionary/domain/failures/failures.dart';
import 'package:dictionary/domain/repositories/history_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  HistoryRepositoryImpl(this.datasource);

  final HistoryRemoteDatasource datasource;

  @override
  Future<Either<Failure, HistoryEntity?>> getHistory(
      {QueryDocumentSnapshot<Map<String, dynamic>>? lastHistoryVisible}) async {
    try {
      final response = await datasource.getHistory(
        lastHistoryVisible: lastHistoryVisible,
      );
      return Right(response);
    } catch (e) {
      return Left(GeneralFailure(message: e.runtimeType.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToHistory(String word) async {
    try {
      final response = await datasource.addToHistory(word);
      return Right(response);
    } catch (e) {
      return Left(GeneralFailure(message: e.runtimeType.toString()));
    }
  }
}
