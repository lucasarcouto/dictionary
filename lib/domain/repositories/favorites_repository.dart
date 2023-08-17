import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dictionary/domain/entities/favorites_entity.dart';

import '../failures/failures.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, FavoritesEntity?>> getFavorites({
    QueryDocumentSnapshot<Map<String, dynamic>>? lastFavoriteVisible,
  });
  Future<Either<Failure, void>> addToFavorites(String word);
  Future<Either<Failure, bool>> isFavorite(String word);
  Future<Either<Failure, void>> removeFavorite(String word);
}
