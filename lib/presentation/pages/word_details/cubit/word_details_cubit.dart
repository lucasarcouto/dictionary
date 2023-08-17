import 'package:dictionary/domain/entities/word_details_entity.dart';
import 'package:dictionary/domain/usecases/favorites_usecases.dart';
import 'package:dictionary/domain/usecases/history_usecases.dart';
import 'package:dictionary/domain/usecases/word_details_usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'word_details_state.dart';

class WordDetailsCubit extends Cubit<WordDetailsState> {
  WordDetailsCubit({
    required this.wordDetailsUseCases,
    required this.historyUseCases,
    required this.favoritesUseCases,
  }) : super(const WordDetailsInitial());

  final WordDetailsUseCases wordDetailsUseCases;
  final HistoryUseCases historyUseCases;
  final FavoritesUseCases favoritesUseCases;

  Future<void> getWordDetails(String word) async {
    emit(const WordDetailsLoading());

    final response = await wordDetailsUseCases.getWordDetails(word);

    await response.fold(
      (failure) async => emit(WordDetailsError(failure.message)),
      (data) async {
        if (data != null) {
          final responseIsFavorite = await favoritesUseCases.isFavorite(word);

          await responseIsFavorite.fold(
            (failureFavorites) async =>
                emit(WordDetailsError(failureFavorites.message)),
            (isFavorite) async {
              emit(WordDetailsLoaded(data.copyWith(isFavorite: isFavorite)));

              await wordDetailsUseCases.cacheWordDetails(data);

              await historyUseCases.addToHistory(data.word);
            },
          );
        } else {
          emit(const WordDetailsLoaded(null));
        }
      },
    );
  }
}
