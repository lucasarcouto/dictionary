part of 'word_details_cubit.dart';

sealed class WordDetailsState extends Equatable {
  const WordDetailsState();

  @override
  List<Object?> get props => [];
}

final class WordDetailsInitial extends WordDetailsState {
  const WordDetailsInitial();
}

final class WordDetailsLoading extends WordDetailsState {
  const WordDetailsLoading();
}

final class WordDetailsLoaded extends WordDetailsState {
  const WordDetailsLoaded(this.wordDetails);

  final WordDetailsEntity? wordDetails;

  @override
  List<Object?> get props => [wordDetails];
}

final class WordDetailsError extends WordDetailsState {
  const WordDetailsError(this.errorMessage);

  final String? errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
