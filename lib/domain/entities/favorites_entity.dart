import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class FavoritesEntity extends Equatable {
  final List<String> favorites;
  final QueryDocumentSnapshot<Map<String, dynamic>>? lastFavoriteVisible;

  const FavoritesEntity({
    required this.favorites,
    required this.lastFavoriteVisible,
  });

  @override
  List<Object?> get props => [favorites, lastFavoriteVisible];
}
