import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dictionary/data/datasources/remote/favorites_remote_datasource.dart';
import 'package:dictionary/domain/entities/favorites_entity.dart';
import 'package:dictionary/domain/failures/failures.dart';
import 'package:dictionary/domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl(this.datasource);

  final FavoritesRemoteDatasource datasource;

  @override
  Future<Either<Failure, FavoritesEntity?>> getFavorites(
      {QueryDocumentSnapshot<Map<String, dynamic>>?
          lastFavoriteVisible}) async {
    try {
      final response = await datasource.getFavorites(
        lastFavoriteVisible: lastFavoriteVisible,
      );
      return Right(response);
    } catch (e) {
      return Left(GeneralFailure(message: e.runtimeType.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToFavorites(String word) async {
    try {
      final response = await datasource.addToFavorites(word);
      return Right(response);
    } catch (e) {
      return Left(GeneralFailure(message: e.runtimeType.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(String word) async {
    try {
      final response = await datasource.isFavorite(word);
      return Right(response);
    } catch (e) {
      return Left(GeneralFailure(message: e.runtimeType.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(String word) async {
    try {
      final response = await datasource.removeFavorite(word);
      return Right(response);
    } catch (e) {
      return Left(GeneralFailure(message: e.runtimeType.toString()));
    }
  }
}
