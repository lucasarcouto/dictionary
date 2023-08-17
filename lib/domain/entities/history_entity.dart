import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class HistoryEntity extends Equatable {
  final List<String> history;
  final QueryDocumentSnapshot<Map<String, dynamic>>? lastHistoryVisible;

  const HistoryEntity({
    required this.history,
    required this.lastHistoryVisible,
  });

  @override
  List<Object?> get props => [history, lastHistoryVisible];
}
