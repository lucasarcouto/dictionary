import 'package:dictionary/core/navigation/widgets/auth_wrapper.dart';
import 'package:dictionary/injection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

typedef RouteBuilder = Widget Function(
  BuildContext context,
  GoRouterState state,
);

/// Wrapper around [GoRoute] to add authentication verification.
class CustomRoute {
  /// Builds a route that adds user authentication verification into each page.
  ///
  /// If [requireAuth] is false, then no verification will be made. Otherwise,
  /// authentication status will be verified and, if no user is signed in, a
  /// sign in page will be shown instead of the route.
  static GoRoute build({
    required String path,
    required RouteBuilder builder,
    List<RouteBase>? routes,
    bool requireAuth = true,
  }) {
    return GoRoute(
      path: path,
      builder: (BuildContext context, GoRouterState state) {
        return AuthWrapper(
          requireAuth: requireAuth,
          firebaseAuth: injection<FirebaseAuth>(),
          child: builder.call(context, state),
        );
      },
      routes: routes ?? [],
    );
  }
}
