import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dictionary/domain/entities/dictionary_entity.dart';

import '../failures/failures.dart';

abstract class DictionaryRepository {
  Future<Either<Failure, DictionaryEntity>> getWordsList({
    QueryDocumentSnapshot<Map<String, dynamic>>? lastWordVisible,
  });
}
