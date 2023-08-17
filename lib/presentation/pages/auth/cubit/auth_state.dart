part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AccountCreated extends AuthState {
  const AccountCreated();
}

final class ResetPasswordEmailSent extends AuthState {
  const ResetPasswordEmailSent();
}

final class UserSignedIn extends AuthState {
  const UserSignedIn(this.user);

  final UserCredential user;

  @override
  List<Object?> get props => [user];
}

final class UserSignedOut extends AuthState {
  const UserSignedOut();
}

final class AuthError extends AuthState {
  const AuthError(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
