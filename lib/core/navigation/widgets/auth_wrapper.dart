import 'package:dictionary/presentation/pages/auth/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Wrapper for any widgets that needs authentication verification. This is
/// intended to be used to wrap all of the app's routes.
///
/// If [requireAuth] is false, then no verification will be made. Otherwise,
/// authentication status will be verified and, if no user is signed in, a
/// sign in page will be shown instead of the route.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({
    super.key,
    required this.child,
    required this.firebaseAuth,
    this.requireAuth = true,
  });

  final Widget child;
  final FirebaseAuth firebaseAuth;
  final bool requireAuth;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: firebaseAuth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData || !requireAuth) {
          return child;
        } else {
          return const SignInPage();
        }
      },
    );
  }
}
