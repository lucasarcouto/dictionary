import 'package:dictionary/presentation/pages/auth/sign_in_page.dart';
import 'package:dictionary/presentation/pages/home/home_page.dart';
import 'package:dictionary/presentation/pages/home/widgets/favorites/favorites_page.dart';
import 'package:dictionary/presentation/pages/home/widgets/history/history_page.dart';
import 'package:dictionary/presentation/pages/home/widgets/words_list/words_list_page.dart';
import 'package:dictionary/presentation/pages/word_details/widgets/word_details_content.dart';
import 'package:dictionary/presentation/widgets/custom_text_form_field.dart';
import 'package:dictionary/presentation/widgets/password_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dictionary/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await Firebase.initializeApp();
  });

  group('end-to-end test', () {
    testWidgets('''sign in with existing user,
    list of words is loaded for all three pages
    and word details opens and is loaded''', (tester) async {
      //! Sign in
      FirebaseAuth.instance.signOut();

      app.main();

      await tester.pumpAndSettle();

      expect(find.byType(SignInPage), findsOneWidget);

      final emailInput = find.byType(CustomTextFormField).first;
      await tester.enterText(emailInput, 'lucascoutodev@gmail.com');

      final passwordInput = find.byType(PasswordFormField);
      await tester.enterText(passwordInput, '123456789');

      final signInButton = find.byType(ElevatedButton).first;
      await tester.tap(signInButton);

      await tester.pumpAndSettle(const Duration(seconds: 4));

      expect(find.byType(HomePage), findsOneWidget);

      //! list of words is loaded for WordsListPage
      expect(find.byType(WordsListPage), findsOneWidget);

      expect(find.byType(GridView), findsOneWidget);

      Finder wordsListGridChildren = find.descendant(
          of: find.byType(GridView), matching: find.byType(GestureDetector));
      expect(wordsListGridChildren, findsWidgets);

      //! list of words is loaded for HistoryPage
      final historyBottomItem = find.text('History');
      await tester.tap(historyBottomItem);

      await tester.pumpAndSettle(const Duration(seconds: 4));

      expect(find.byType(HistoryPage), findsOneWidget);

      final historyGridChildren = find.descendant(
          of: find.byType(GridView), matching: find.byType(GestureDetector));
      expect(historyGridChildren, findsWidgets);

      //! list of words is loaded for FavoritesPage
      final favoritesBottomItem = find.text('Favorites');
      await tester.tap(favoritesBottomItem);

      await tester.pumpAndSettle(const Duration(seconds: 4));

      expect(find.byType(FavoritesPage), findsOneWidget);

      final favoritesGridChildren = find.descendant(
          of: find.byType(GridView), matching: find.byType(GestureDetector));
      expect(favoritesGridChildren, findsWidgets);

      //! navigate to list of words
      final wordsBottomItem = find.text('Words');
      await tester.tap(wordsBottomItem);

      await tester.pumpAndSettle(const Duration(seconds: 4));

      expect(find.byType(WordsListPage), findsOneWidget);

      wordsListGridChildren = find.descendant(
          of: find.byType(GridView), matching: find.byType(GestureDetector));
      await tester.tap(wordsListGridChildren.first);

      await tester.pumpAndSettle(const Duration(seconds: 4));

      expect(find.byType(WordDetailsContent), findsOneWidget);
    });
  });
}
