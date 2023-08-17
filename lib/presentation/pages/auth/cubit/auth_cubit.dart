import 'package:dictionary/domain/usecases/auth_usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authUseCases) : super(const AuthInitial());

  final AuthUseCases authUseCases;

  /// Creates a Firebase account using [email] and [password].
  ///
  /// A [FirebaseAuthException] maybe thrown if any error occurs while creating
  /// it. Check out [FirebaseAuth]'s [createUserWithEmailAndPassword] method
  /// documentation on details about error codes.
  Future<void> createAccount({
    required String email,
    required String password,
  }) async {
    if (state is AuthLoading) return;

    emit(const AuthLoading());

    final response = await authUseCases.createAccount(
      email: email,
      password: password,
    );

    response.fold(
      (failure) => emit(AuthError(failure.getMessageOrDefault())),
      (data) => emit(const AccountCreated()),
    );
  }

  /// Sends a password reset message to the provided [email]. It is important to
  /// let users know they should check the spam folder in case they don't see
  /// any email in their inbox folder.
  ///
  /// A [FirebaseAuthException] maybe thrown if any error occurs while sending
  /// the message. Check out [FirebaseAuth]'s [sendPasswordResetEmail] method
  /// documentation on details about error codes.
  Future<void> sendPasswordResetEmail(String email) async {
    if (state is AuthLoading) return;

    emit(const AuthLoading());

    final response = await authUseCases.sendPasswordResetEmail(email);

    response.fold(
      (failure) => emit(AuthError(failure.getMessageOrDefault())),
      (data) => emit(const ResetPasswordEmailSent()),
    );
  }

  /// Signs in a user using [email] and [password] for the authentatication.
  ///
  /// A [FirebaseAuthException] maybe thrown if any error occurs while
  /// authenticating the user. Check out [FirebaseAuth]'s
  /// [signInWithEmailAndPassword] method documentation on details about
  /// error codes.
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    if (state is AuthLoading) return;

    emit(const AuthLoading());

    final response = await authUseCases.signIn(
      email: email,
      password: password,
    );

    response.fold(
      (failure) => emit(AuthError(failure.getMessageOrDefault())),
      (data) => emit(UserSignedIn(data)),
    );
  }

  /// Signs a user out of the application.
  ///
  /// A [FirebaseAuthException] maybe thrown if any error occurs while
  /// authenticating the user. Check out [FirebaseAuth]'s
  /// [signInWithEmailAndPassword] method documentation on details about
  /// error codes.
  Future<void> signOut() async {
    if (state is AuthLoading) return;

    emit(const AuthLoading());

    final response = await authUseCases.signOut();

    response.fold(
      (failure) => emit(AuthError(failure.getMessageOrDefault())),
      (data) => emit(const UserSignedOut()),
    );
  }
}
