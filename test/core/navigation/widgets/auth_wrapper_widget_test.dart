import 'package:dictionary/core/navigation/widgets/auth_wrapper.dart';
import 'package:dictionary/presentation/pages/auth/cubit/auth_cubit.dart';
import 'package:dictionary/presentation/pages/auth/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

import '../../../_mocks/firebase_mocks.dart';

const placeholderText = 'Placeholder text';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockAuthCubit mockAuthCubit;
  late MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockAuthCubit = MockAuthCubit();
    mockUser = MockUser();
  });

  Widget createWidgetUnderTest({bool requireAuth = true}) {
    return MaterialApp(
      home: BlocProvider<AuthCubit>(
        create: (context) => mockAuthCubit,
        child: AuthWrapper(
          firebaseAuth: mockFirebaseAuth,
          requireAuth: requireAuth,
          child: const Text(placeholderText),
        ),
      ),
    );
  }

  group('AuthWrapper', () {
    group('listen for auth changes', () {
      testWidgets('and there is a user signed in', (tester) async {
        when(mockFirebaseAuth.authStateChanges)
            .thenAnswer((_) => Stream.fromIterable([mockUser]));
        whenListen(
          mockAuthCubit,
          Stream.fromIterable(const [AuthInitial()]),
          initialState: const AuthInitial(),
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text(placeholderText), findsOneWidget);
      });

      testWidgets('and there is no user signed in', (tester) async {
        when(mockFirebaseAuth.authStateChanges)
            .thenAnswer((_) => Stream.fromIterable([null]));
        whenListen(
          mockAuthCubit,
          Stream.fromIterable(const [AuthInitial()]),
          initialState: const AuthInitial(),
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(SignInPage), findsOneWidget);
      });

      testWidgets(
          'and there is a user signed in, but page does not require auth',
          (tester) async {
        when(mockFirebaseAuth.authStateChanges)
            .thenAnswer((_) => Stream.fromIterable([mockUser]));
        whenListen(
          mockAuthCubit,
          Stream.fromIterable(const [AuthInitial()]),
          initialState: const AuthInitial(),
        );

        await tester.pumpWidget(createWidgetUnderTest(requireAuth: false));
        await tester.pumpAndSettle();

        expect(find.text(placeholderText), findsOneWidget);
      });

      testWidgets(
          'and there is no user signed in, but page does not require auth',
          (tester) async {
        when(mockFirebaseAuth.authStateChanges)
            .thenAnswer((_) => Stream.fromIterable([null]));
        whenListen(
          mockAuthCubit,
          Stream.fromIterable(const [AuthInitial()]),
          initialState: const AuthInitial(),
        );

        await tester.pumpWidget(createWidgetUnderTest(requireAuth: false));
        await tester.pumpAndSettle();

        expect(find.text(placeholderText), findsOneWidget);
      });
    });
  });
}

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}
