import 'package:dictionary/core/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDatasource {
  Future<void> createAccount({
    required String email,
    required String password,
  });
  Future<void> sendPasswordResetEmail(String email);
  Future<UserCredential> signIn({
    required String email,
    required String password,
  });
  Future<void> signOut();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  AuthRemoteDatasourceImpl(this.authService);

  final AuthService authService;

  @override
  Future<UserCredential> createAccount({
    required String email,
    required String password,
  }) async {
    return await authService.createAccount(email: email, password: password);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    return await authService.sendPasswordResetEmail(email);
  }

  @override
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await authService.signIn(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    return await authService.signOut();
  }
}
