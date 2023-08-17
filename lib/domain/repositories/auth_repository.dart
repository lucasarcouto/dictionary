import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../failures/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> createAccount({
    required String email,
    required String password,
  });
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);
  Future<Either<Failure, UserCredential>> signIn({
    required String email,
    required String password,
  });
  Future<Either<Failure, void>> signOut();
}
