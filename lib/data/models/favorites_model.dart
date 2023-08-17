import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dictionary/domain/entities/favorites_entity.dart';
import 'package:equatable/equatable.dart';

class FavoritesModel extends FavoritesEntity with EquatableMixin {
  FavoritesModel({
    required super.favorites,
    required super.lastFavoriteVisible,
  });

  factory FavoritesModel.fromQuerySnapshot(
      QuerySnapshot<Map<String, dynamic>> querySnapshot) {
    return FavoritesModel(
      favorites: querySnapshot.docs.map<String>((item) => item.id).toList(),
      lastFavoriteVisible:
          querySnapshot.docs.isEmpty ? null : querySnapshot.docs.last,
    );
  }
}
