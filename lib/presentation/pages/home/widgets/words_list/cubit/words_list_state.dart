part of 'words_list_cubit.dart';

sealed class WordsListState extends Equatable {
  const WordsListState();

  @override
  List<Object?> get props => [];
}

final class WordsListInitial extends WordsListState {
  const WordsListInitial();
}

final class WordsListLoading extends WordsListState {
  const WordsListLoading();
}

final class WordsListLoaded extends WordsListState {
  const WordsListLoaded(this.dictionary);

  final DictionaryEntity dictionary;

  @override
  List<Object?> get props => [dictionary];
}

final class WordsListError extends WordsListState {
  final String errorMessage;

  const WordsListError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
