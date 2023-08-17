import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dictionary/domain/entities/history_entity.dart';
import 'package:equatable/equatable.dart';

class HistoryModel extends HistoryEntity with EquatableMixin {
  HistoryModel({
    required super.history,
    required super.lastHistoryVisible,
  });

  factory HistoryModel.fromQuerySnapshot(
      QuerySnapshot<Map<String, dynamic>> querySnapshot) {
    return HistoryModel(
      history: querySnapshot.docs.map<String>((item) => item.id).toList(),
      lastHistoryVisible:
          querySnapshot.docs.isEmpty ? null : querySnapshot.docs.last,
    );
  }
}
