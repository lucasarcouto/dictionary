import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dictionary/domain/entities/history_entity.dart';
import 'package:dictionary/domain/failures/failures.dart';
import 'package:dictionary/domain/usecases/history_usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(this.historyUseCases) : super(const HistoryInitial());

  final HistoryUseCases historyUseCases;

  Future<void> getHistory(
      {QueryDocumentSnapshot<Map<String, dynamic>>? lastHistoryVisible}) async {
    if (state is HistoryLoading) return;

    emit(const HistoryLoading());

    final response = await historyUseCases.getHistory(
      lastHistoryVisible: lastHistoryVisible,
    );

    response.fold(
      (failure) => emit(HistoryError(failure.getMessageOrDefault())),
      (data) {
        if (data == null) {
          emit(const HistoryError(defaultGeneralFailureMessage));
        } else {
          emit(HistoryLoaded(data));
        }
      },
    );
  }
}
