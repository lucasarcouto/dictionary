import 'package:dartz/dartz.dart';
import 'package:dictionary/data/datasources/remote/auth_remote_datasource.dart';
import 'package:dictionary/domain/failures/failures.dart';
import 'package:dictionary/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this.datasource);

  final AuthRemoteDatasource datasource;

  @override
  Future<Either<Failure, void>> createAccount(
      {required String email, required String password}) async {
    try {
      final response =
          await datasource.createAccount(email: email, password: password);
      return Right(response);
    } on FirebaseAuthException catch (e) {
      return Left(GeneralFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    try {
      final response = await datasource.sendPasswordResetEmail(email);
      return Right(response);
    } on FirebaseAuthException catch (e) {
      return Left(GeneralFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserCredential>> signIn(
      {required String email, required String password}) async {
    try {
      final response =
          await datasource.signIn(email: email, password: password);
      return Right(response);
    } on FirebaseAuthException catch (e) {
      return Left(GeneralFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      final response = await datasource.signOut();
      return Right(response);
    } on FirebaseAuthException catch (e) {
      return Left(GeneralFailure(message: e.message));
    }
  }
}
