import 'package:dartz/dartz.dart';
import 'package:dictionary/domain/entities/word_details_entity.dart';

import '../failures/failures.dart';

abstract class WordDetailsRepository {
  Future<Either<Failure, WordDetailsEntity?>> getWordDetails(String word);
  Future<Either<Failure, int>> cacheWordDetails(WordDetailsEntity word);
}
