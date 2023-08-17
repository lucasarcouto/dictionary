import 'package:firebase_auth/firebase_auth.dart';

/// Service that provides all authentication methods
class AuthService {
  const AuthService(this.firebaseAuthInstance);

  final FirebaseAuth firebaseAuthInstance;

  /// Creates a Firebase account using [email] and [password].
  ///
  /// A [FirebaseAuthException] maybe thrown if any error occurs while creating
  /// it. Check out [FirebaseAuth]'s [createUserWithEmailAndPassword] method
  /// documentation on details about error codes.
  Future<UserCredential> createAccount({
    required String email,
    required String password,
  }) async {
    return await firebaseAuthInstance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Sends a password reset message to the provided [email].
  ///
  /// A [FirebaseAuthException] maybe thrown if any error occurs while sending
  /// the message. Check out [FirebaseAuth]'s [sendPasswordResetEmail] method
  /// documentation on details about error codes.
  Future<void> sendPasswordResetEmail(String email) async {
    await firebaseAuthInstance.sendPasswordResetEmail(email: email);
  }

  /// Signs in a user using [email] and [password] for the authentatication.
  ///
  /// A [FirebaseAuthException] maybe thrown if any error occurs while
  /// authenticating the user. Check out [FirebaseAuth]'s
  /// [signInWithEmailAndPassword] method documentation on details about
  /// error codes.
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await firebaseAuthInstance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Signs a user out of the application.
  ///
  /// A [FirebaseAuthException] maybe thrown if any error occurs while
  /// authenticating the user. Check out [FirebaseAuth]'s
  /// [signInWithEmailAndPassword] method documentation on details about
  /// error codes.
  Future<void> signOut() async {
    return await firebaseAuthInstance.signOut();
  }
}
