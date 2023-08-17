import 'package:dictionary/core/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../_mocks/firebase_mocks.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late AuthService sut;

  const email = 'email';
  const password = 'password';

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    sut = AuthService(mockFirebaseAuth);
  });

  group('AuthService', () {
    group('create an account with email and password', () {
      test('and account is created successfully', () async {
        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password)).thenAnswer(
          (_) async => mockUserCredential,
        );
        when(() => mockUserCredential.user).thenReturn(mockUser);
        when(() => mockUser.uid).thenReturn('123');

        final result =
            await sut.createAccount(email: email, password: password);

        expect(result, isNotNull);
        expect(result.user, isNotNull);
        expect(result.user?.uid, isNotEmpty);
        verify(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password)).called(1);
        verifyNoMoreInteractions(mockFirebaseAuth);
      });

      test('and invalid email was provided', () async {
        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password)).thenThrow(
          FirebaseAuthException(code: 'invalid-email'),
        );

        expect(
          () async => await sut.createAccount(email: email, password: password),
          throwsA(predicate(
              (e) => e is FirebaseAuthException && e.code == 'invalid-email')),
        );
        verify(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password)).called(1);
        verifyNoMoreInteractions(mockFirebaseAuth);
      });

      test('and a weak password was provided', () async {
        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password)).thenThrow(
          FirebaseAuthException(code: 'weak-password'),
        );

        expect(
          () async => await sut.createAccount(email: email, password: password),
          throwsA(predicate(
              (e) => e is FirebaseAuthException && e.code == 'weak-password')),
        );
        verify(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password)).called(1);
        verifyNoMoreInteractions(mockFirebaseAuth);
      });

      test('and user is already registered', () async {
        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password)).thenThrow(
          FirebaseAuthException(code: 'email-already-in-use'),
        );

        expect(
          () async => await sut.createAccount(email: email, password: password),
          throwsA(
            predicate((e) =>
                e is FirebaseAuthException && e.code == 'email-already-in-use'),
          ),
        );
        verify(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password)).called(1);
        verifyNoMoreInteractions(mockFirebaseAuth);
      });
    });

    group('send reset password email', () {
      test('and email is sent successfully', () async {
        when<Future<void>>(
          () => mockFirebaseAuth.sendPasswordResetEmail(email: email),
        ).thenAnswer(
          (_) async => {},
        );

        await sut.sendPasswordResetEmail(email);

        verify(() => mockFirebaseAuth.sendPasswordResetEmail(email: email))
            .called(1);
        verifyNoMoreInteractions(mockFirebaseAuth);
      });

      test('and invalid email was provided', () async {
        when(() => mockFirebaseAuth.sendPasswordResetEmail(email: email))
            .thenThrow(
          FirebaseAuthException(code: 'auth/invalid-email'),
        );

        expect(
          () async => await sut.sendPasswordResetEmail(email),
          throwsA(predicate((e) =>
              e is FirebaseAuthException && e.code == 'auth/invalid-email')),
        );
        verify(() => mockFirebaseAuth.sendPasswordResetEmail(email: email))
            .called(1);
        verifyNoMoreInteractions(mockFirebaseAuth);
      });

      test('and the user was not found', () async {
        when(() => mockFirebaseAuth.sendPasswordResetEmail(email: email))
            .thenThrow(
          FirebaseAuthException(code: 'auth/user-not-found'),
        );

        expect(
          () async => await sut.sendPasswordResetEmail(email),
          throwsA(predicate((e) =>
              e is FirebaseAuthException && e.code == 'auth/user-not-found')),
        );
        verify(() => mockFirebaseAuth.sendPasswordResetEmail(email: email))
            .called(1);
        verifyNoMoreInteractions(mockFirebaseAuth);
      });
    });

    group('sign in with email and password', () {
      test('and user is signed in successfully', () async {
        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: email, password: password)).thenAnswer(
          (_) async => mockUserCredential,
        );
        when(() => mockUserCredential.user).thenReturn(mockUser);
        when(() => mockUser.uid).thenReturn('123');

        final result = await sut.signIn(email: email, password: password);

        expect(result, isNotNull);
        expect(result.user, isNotNull);
        expect(result.user?.uid, isNotEmpty);
        verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: email, password: password)).called(1);
        verifyNoMoreInteractions(mockFirebaseAuth);
      });

      test('and invalid email was provided', () async {
        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: email, password: password)).thenThrow(
          FirebaseAuthException(code: 'invalid-email'),
        );

        expect(
          () async => await sut.signIn(email: email, password: password),
          throwsA(predicate(
              (e) => e is FirebaseAuthException && e.code == 'invalid-email')),
        );
        verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: email, password: password)).called(1);
        verifyNoMoreInteractions(mockFirebaseAuth);
      });

      test('and invalid password was provided', () async {
        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: email, password: password)).thenThrow(
          FirebaseAuthException(code: 'wrong-password'),
        );

        expect(
          () async => await sut.signIn(email: email, password: password),
          throwsA(predicate(
              (e) => e is FirebaseAuthException && e.code == 'wrong-password')),
        );
        verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: email, password: password)).called(1);
        verifyNoMoreInteractions(mockFirebaseAuth);
      });

      test('and user does not exist', () async {
        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: email, password: password)).thenThrow(
          FirebaseAuthException(code: 'user-not-found'),
        );

        expect(
          () async => await sut.signIn(email: email, password: password),
          throwsA(
            predicate((e) =>
                e is FirebaseAuthException && e.code == 'user-not-found'),
          ),
        );
        verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: email, password: password)).called(1);
        verifyNoMoreInteractions(mockFirebaseAuth);
      });
    });

    group('sign out', () {
      test('and user is signed out successfully', () async {
        when<Future<void>>(() => mockFirebaseAuth.signOut()).thenAnswer(
          (_) async {},
        );

        await sut.signOut();

        verify(() => mockFirebaseAuth.signOut()).called(1);
        verifyNoMoreInteractions(mockFirebaseAuth);
      });
    });
  });
}
