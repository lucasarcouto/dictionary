import 'package:dictionary/core/auth/auth_service.dart';
import 'package:dictionary/data/datasources/remote/auth_remote_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../_mocks/firebase_mocks.dart';

const email = 'email';
const password = 'password';

void main() {
  late MockAuthService mockAuthService;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late AuthRemoteDatasourceImpl sut;

  setUp(() {
    mockAuthService = MockAuthService();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    sut = AuthRemoteDatasourceImpl(mockAuthService);
  });

  group('AuthRemoteDatasource', () {
    group('create an account with email and password', () {
      test('and account is created successfully', () async {
        when(
          () => mockAuthService.createAccount(email: email, password: password),
        ).thenAnswer(
          (_) async => mockUserCredential,
        );
        when(() => mockUserCredential.user).thenReturn(mockUser);
        when(() => mockUser.uid).thenReturn('123');

        final result =
            await sut.createAccount(email: email, password: password);

        expect(result, isNotNull);
        expect(result.user, isNotNull);
        expect(result.user?.uid, isNotEmpty);
        verify(() =>
                mockAuthService.createAccount(email: email, password: password))
            .called(1);
        verifyNoMoreInteractions(mockAuthService);
      });

      test('and invalid email was provided', () async {
        when(
          () => mockAuthService.createAccount(email: email, password: password),
        ).thenThrow(
          FirebaseAuthException(code: 'invalid-email'),
        );

        expect(
          () async => await sut.createAccount(email: email, password: password),
          throwsA(predicate(
              (e) => e is FirebaseAuthException && e.code == 'invalid-email')),
        );
        verify(() =>
                mockAuthService.createAccount(email: email, password: password))
            .called(1);
        verifyNoMoreInteractions(mockAuthService);
      });

      test('and a weak password was provided', () async {
        when(
          () => mockAuthService.createAccount(email: email, password: password),
        ).thenThrow(
          FirebaseAuthException(code: 'weak-password'),
        );

        expect(
          () async => await sut.createAccount(email: email, password: password),
          throwsA(predicate(
              (e) => e is FirebaseAuthException && e.code == 'weak-password')),
        );
        verify(() =>
                mockAuthService.createAccount(email: email, password: password))
            .called(1);
        verifyNoMoreInteractions(mockAuthService);
      });

      test('and user is already registered', () async {
        when(
          () => mockAuthService.createAccount(email: email, password: password),
        ).thenThrow(
          FirebaseAuthException(code: 'email-already-in-use'),
        );

        expect(
          () async => await sut.createAccount(email: email, password: password),
          throwsA(
            predicate((e) =>
                e is FirebaseAuthException && e.code == 'email-already-in-use'),
          ),
        );
        verify(() =>
                mockAuthService.createAccount(email: email, password: password))
            .called(1);
        verifyNoMoreInteractions(mockAuthService);
      });
    });

    group('send reset password email', () {
      test('and email is sent successfully', () async {
        when<Future<void>>(
          () => mockAuthService.sendPasswordResetEmail(email),
        ).thenAnswer(
          (_) async => {},
        );

        await sut.sendPasswordResetEmail(email);

        verify(() => mockAuthService.sendPasswordResetEmail(email)).called(1);
        verifyNoMoreInteractions(mockAuthService);
      });

      test('and invalid email was provided', () async {
        when(
          () => mockAuthService.sendPasswordResetEmail(email),
        ).thenThrow(
          FirebaseAuthException(code: 'auth/invalid-email'),
        );

        expect(
          () async => await sut.sendPasswordResetEmail(email),
          throwsA(predicate((e) =>
              e is FirebaseAuthException && e.code == 'auth/invalid-email')),
        );
        verify(() => mockAuthService.sendPasswordResetEmail(email)).called(1);
        verifyNoMoreInteractions(mockAuthService);
      });

      test('and the user was not found', () async {
        when(
          () => mockAuthService.sendPasswordResetEmail(email),
        ).thenThrow(
          FirebaseAuthException(code: 'auth/user-not-found'),
        );

        expect(
          () async => await sut.sendPasswordResetEmail(email),
          throwsA(predicate((e) =>
              e is FirebaseAuthException && e.code == 'auth/user-not-found')),
        );
        verify(() => mockAuthService.sendPasswordResetEmail(email)).called(1);
        verifyNoMoreInteractions(mockAuthService);
      });
    });

    group('sign in with email and password', () {
      test('and user is signed in successfully', () async {
        when(
          () => mockAuthService.signIn(email: email, password: password),
        ).thenAnswer(
          (_) async => mockUserCredential,
        );
        when(() => mockUserCredential.user).thenReturn(mockUser);
        when(() => mockUser.uid).thenReturn('123');

        final result = await sut.signIn(email: email, password: password);

        expect(result, isNotNull);
        expect(result.user, isNotNull);
        expect(result.user?.uid, isNotEmpty);
        verify(() => mockAuthService.signIn(email: email, password: password))
            .called(1);
        verifyNoMoreInteractions(mockAuthService);
      });

      test('and invalid email was provided', () async {
        when(
          () => mockAuthService.signIn(email: email, password: password),
        ).thenThrow(
          FirebaseAuthException(code: 'invalid-email'),
        );

        expect(
          () async => await sut.signIn(email: email, password: password),
          throwsA(predicate(
              (e) => e is FirebaseAuthException && e.code == 'invalid-email')),
        );
        verify(() => mockAuthService.signIn(email: email, password: password))
            .called(1);
        verifyNoMoreInteractions(mockAuthService);
      });

      test('and invalid password was provided', () async {
        when(
          () => mockAuthService.signIn(email: email, password: password),
        ).thenThrow(
          FirebaseAuthException(code: 'wrong-password'),
        );

        expect(
          () async => await sut.signIn(email: email, password: password),
          throwsA(predicate(
              (e) => e is FirebaseAuthException && e.code == 'wrong-password')),
        );
        verify(() => mockAuthService.signIn(email: email, password: password))
            .called(1);
        verifyNoMoreInteractions(mockAuthService);
      });

      test('and user does not exist', () async {
        when(
          () => mockAuthService.signIn(email: email, password: password),
        ).thenThrow(
          FirebaseAuthException(code: 'user-not-found'),
        );

        expect(
          () async => await sut.signIn(email: email, password: password),
          throwsA(
            predicate((e) =>
                e is FirebaseAuthException && e.code == 'user-not-found'),
          ),
        );
        verify(() => mockAuthService.signIn(email: email, password: password))
            .called(1);
        verifyNoMoreInteractions(mockAuthService);
      });
    });

    group('sign out', () {
      test('and user is signed out successfully', () async {
        when<Future<void>>(
          () => mockAuthService.signOut(),
        ).thenAnswer(
          (_) async {},
        );

        await sut.signOut();

        verify(() => mockAuthService.signOut()).called(1);
        verifyNoMoreInteractions(mockAuthService);
      });
    });
  });
}

class MockAuthService extends Mock implements AuthService {}
