import 'package:dartz/dartz.dart';
import 'package:dictionary/data/datasources/local/word_details_local_datasource.dart';
import 'package:dictionary/data/datasources/remote/word_details_remote_datasource.dart';
import 'package:dictionary/data/exceptions/exceptions.dart';
import 'package:dictionary/data/models/word_details_model.dart';
import 'package:dictionary/domain/entities/word_details_entity.dart';
import 'package:dictionary/domain/failures/failures.dart';
import 'package:dictionary/domain/repositories/word_details_repository.dart';

class WordDetailsRepositoryImpl implements WordDetailsRepository {
  WordDetailsRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  final WordDetailsRemoteDatasource remoteDatasource;
  final WordDetailsLocalDatasource localDatasource;

  @override
  Future<Either<Failure, WordDetailsEntity?>> getWordDetails(
      String word) async {
    try {
      final cache = await localDatasource.getWordDetails(word);

      if (cache == null) {
        final response = await remoteDatasource.getWordDetails(word);
        return Right(response);
      }

      return Right(cache);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.runtimeType.toString()));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.runtimeType.toString()));
    } catch (e) {
      return Left(GeneralFailure(message: e.runtimeType.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> cacheWordDetails(
      WordDetailsEntity wordDetails) async {
    try {
      final success = await localDatasource
          .cacheWordDetails(wordDetails as WordDetailsModel);
      return Right(success);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.runtimeType.toString()));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.runtimeType.toString()));
    } catch (e) {
      return Left(GeneralFailure(message: e.runtimeType.toString()));
    }
  }
}
