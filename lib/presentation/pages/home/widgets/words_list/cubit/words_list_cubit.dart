import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dictionary/domain/usecases/dictionary_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dictionary/domain/entities/dictionary_entity.dart';
import 'package:equatable/equatable.dart';

part 'words_list_state.dart';

class WordsListCubit extends Cubit<WordsListState> {
  WordsListCubit(this.dictionaryUseCases) : super(const WordsListInitial());

  final DictionaryUseCases dictionaryUseCases;

  Future<void> getWordsList(
      {QueryDocumentSnapshot<Map<String, dynamic>>? lastWordVisible}) async {
    if (state is WordsListLoading) return;

    emit(const WordsListLoading());

    final response = await dictionaryUseCases.getWordsList(
      lastWordVisible: lastWordVisible,
    );

    response.fold(
      (failure) => emit(WordsListError(failure.getMessageOrDefault())),
      (data) => emit(WordsListLoaded(data)),
    );
  }
}
