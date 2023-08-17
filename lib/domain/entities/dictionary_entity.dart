import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class DictionaryEntity extends Equatable {
  final List<String> words;
  final QueryDocumentSnapshot<Map<String, dynamic>>? lastWordVisible;

  const DictionaryEntity({
    required this.words,
    required this.lastWordVisible,
  });

  @override
  List<Object?> get props => [words, lastWordVisible];
}
