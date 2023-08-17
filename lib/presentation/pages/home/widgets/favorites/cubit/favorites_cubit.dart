import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dictionary/domain/entities/favorites_entity.dart';
import 'package:dictionary/domain/failures/failures.dart';
import 'package:dictionary/domain/usecases/favorites_usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit(this.favoritesUseCases) : super(const FavoritesInitial());

  final FavoritesUseCases favoritesUseCases;

  Future<void> getFavorites(
      {QueryDocumentSnapshot<Map<String, dynamic>>?
          lastFavoriteVisible}) async {
    if (state is FavoritesLoading) return;

    emit(const FavoritesLoading());

    final response = await favoritesUseCases.getFavorites(
      lastFavoriteVisible: lastFavoriteVisible,
    );

    response.fold(
      (failure) => emit(FavoritesError(failure.getMessageOrDefault())),
      (data) {
        if (data == null) {
          emit(const FavoritesError(defaultGeneralFailureMessage));
        } else {
          emit(FavoritesLoaded(data));
        }
      },
    );
  }

  Future<void> addToFavorites(String word) async {
    if (state is FavoritesLoading) return;

    await favoritesUseCases.addToFavorites(word);
  }

  Future<void> removeFavorite(String word) async {
    if (state is FavoritesLoading) return;

    await favoritesUseCases.removeFavorite(word);
  }
}
