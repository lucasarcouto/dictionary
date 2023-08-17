import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dictionary/domain/entities/dictionary_entity.dart';
import 'package:equatable/equatable.dart';

class DictionaryModel extends DictionaryEntity with EquatableMixin {
  DictionaryModel({
    required super.words,
    required super.lastWordVisible,
  });

  factory DictionaryModel.fromQuerySnapshot(
      QuerySnapshot<Map<String, dynamic>> querySnapshot) {
    return DictionaryModel(
      words: querySnapshot.docs.map<String>((item) => item.id).toList(),
      lastWordVisible:
          querySnapshot.docs.isEmpty ? null : querySnapshot.docs.last,
    );
  }
}
