import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dictionary/domain/entities/favorites_entity.dart';
import 'package:dictionary/domain/repositories/favorites_repository.dart';

import '../failures/failures.dart';

/// Exposes all available methods for the Favorites feature.
class FavoritesUseCases {
  FavoritesUseCases(this.repository);

  final FavoritesRepository repository;

  /// Queries the list of favorites available.
  ///
  /// [lastFavoriteVisible] is used for pagination purposes. If it is provided,
  /// then the results returned will start from the next available favorite in
  /// the storage.
  ///
  /// Usually the first time this method is called, [lastFavoriteVisible] is
  /// null and subsequent calls will use the [FavoritesEntity] returned to
  /// provide this variable.
  Future<Either<Failure, FavoritesEntity?>> getFavorites({
    QueryDocumentSnapshot<Map<String, dynamic>>? lastFavoriteVisible,
  }) async {
    return repository.getFavorites(lastFavoriteVisible: lastFavoriteVisible);
  }

  /// Adds [word] to the user's list of favorites. If the word is already
  /// present, nothing happens.
  Future<Either<Failure, void>> addToFavorites(String word) async {
    return repository.addToFavorites(word);
  }

  /// Checks whether a [word] is in the list of favorites.
  Future<Either<Failure, bool>> isFavorite(String word) async {
    return repository.isFavorite(word);
  }

  /// Removes [word] from the list of favorites.
  Future<Either<Failure, void>> removeFavorite(String word) async {
    return repository.removeFavorite(word);
  }
}
