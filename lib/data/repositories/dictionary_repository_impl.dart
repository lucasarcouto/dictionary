import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dictionary/data/datasources/remote/dictionary_remote_datasource.dart';
import 'package:dictionary/domain/entities/dictionary_entity.dart';
import 'package:dictionary/domain/failures/failures.dart';
import 'package:dictionary/domain/repositories/dictionary_repository.dart';

class DictionaryRepositoryImpl implements DictionaryRepository {
  DictionaryRepositoryImpl(this.datasource);

  final DictionaryRemoteDatasource datasource;

  @override
  Future<Either<Failure, DictionaryEntity>> getWordsList(
      {QueryDocumentSnapshot<Map<String, dynamic>>? lastWordVisible}) async {
    try {
      final response =
          await datasource.getWordsList(lastWordVisible: lastWordVisible);
      return Right(response);
    } catch (e) {
      return Left(GeneralFailure(message: e.runtimeType.toString()));
    }
  }
}
