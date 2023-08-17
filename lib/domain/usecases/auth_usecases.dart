import 'package:dartz/dartz.dart';
import 'package:dictionary/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../failures/failures.dart';

/// Exposes all available methods for the Auth feature.
class AuthUseCases {
  AuthUseCases(this.repository);

  final AuthRepository repository;

  /// Creates a Firebase account using [email] and [password].
  ///
  /// A [FirebaseAuthException] maybe thrown if any error occurs while creating
  /// it. Check out [FirebaseAuth]'s [createUserWithEmailAndPassword] method
  /// documentation on details about error codes.
  Future<Either<Failure, void>> createAccount({
    required String email,
    required String password,
  }) async {
    return await repository.createAccount(email: email, password: password);
  }

  /// Sends a password reset message to the provided [email]. It is important to
  /// let users know they should check the spam folder in case they don't see
  /// any email in their inbox folder.
  ///
  /// A [FirebaseAuthException] maybe thrown if any error occurs while sending
  /// the message. Check out [FirebaseAuth]'s [sendPasswordResetEmail] method
  /// documentation on details about error codes.
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    return await repository.sendPasswordResetEmail(email);
  }

  /// Signs in a user using [email] and [password] for the authentatication.
  ///
  /// A [FirebaseAuthException] maybe thrown if any error occurs while
  /// authenticating the user. Check out [FirebaseAuth]'s
  /// [signInWithEmailAndPassword] method documentation on details about
  /// error codes.
  Future<Either<Failure, UserCredential>> signIn({
    required String email,
    required String password,
  }) async {
    return await repository.signIn(email: email, password: password);
  }

  /// Signs a user out of the application.
  ///
  /// A [FirebaseAuthException] maybe thrown if any error occurs while
  /// authenticating the user. Check out [FirebaseAuth]'s
  /// [signInWithEmailAndPassword] method documentation on details about
  /// error codes.
  Future<Either<Failure, void>> signOut() async {
    return await repository.signOut();
  }
}
