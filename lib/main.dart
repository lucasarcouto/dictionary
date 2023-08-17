import 'package:dictionary/core/navigation/custom_route.dart';
import 'package:dictionary/presentation/pages/auth/create_account_page.dart';
import 'package:dictionary/presentation/pages/auth/cubit/auth_cubit.dart';
import 'package:dictionary/presentation/pages/auth/forgot_password_page.dart';
import 'package:dictionary/presentation/pages/home/home_page.dart';
import 'package:dictionary/presentation/pages/word_details/word_details_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();

  runApp(BlocProvider(
    create: (context) => di.injection<AuthCubit>(),
    child: const MyApp(),
  ));
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    CustomRoute.build(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
      routes: <RouteBase>[
        CustomRoute.build(
          path: 'details/:word',
          builder: (BuildContext context, GoRouterState state) {
            return WordDetailsPage(word: state.pathParameters['word']!);
          },
        ),
        CustomRoute.build(
          path: 'create_account',
          requireAuth: false,
          builder: (BuildContext context, GoRouterState state) {
            return const CreateAccountPage();
          },
        ),
        CustomRoute.build(
          path: 'forgot_password',
          requireAuth: false,
          builder: (BuildContext context, GoRouterState state) {
            return const ForgotPasswordPage();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Dictionary',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      routerConfig: _router,
    );
  }
}
