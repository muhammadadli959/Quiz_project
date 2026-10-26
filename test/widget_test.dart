// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uts/main.dart';

void main() {
  testWidgets('player can finish a quiz and see the named score', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const QuizApp());

    await tester.enterText(find.byKey(const Key('player-name-field')), 'Naya');
    await tester.tap(find.text('Jelajahi semua kuis'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('quiz-Pengetahuan Umum')));
    await tester.pumpAndSettle();

    expect(find.text('Halo, Naya!'), findsOneWidget);
    expect(find.text('Pengetahuan Umum'), findsOneWidget);
    expect(find.text('1/5'), findsOneWidget);

    final answers = [
      'Jupiter',
      'Tokyo',
      'Jantung',
      'Central Processing Unit',
      'Matahari',
    ];
    for (var index = 0; index < answers.length; index++) {
      final answer = find.text(answers[index]).first;
      await tester.ensureVisible(answer);
      await tester.tap(answer);
      await tester.pump();
      final nextButton = find.text(
        index == answers.length - 1 ? 'Selesaikan kuis' : 'Soal berikutnya',
      );
      await tester.ensureVisible(nextButton);
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
    }

    expect(find.text('Kuis selesai, Naya!'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('100% akurasi'), findsOneWidget);
  });

  testWidgets('quiz progress remains available after returning to home', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const QuizApp());

    await tester.enterText(find.byKey(const Key('player-name-field')), 'Dio');
    await tester.tap(find.text('Jelajahi semua kuis'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('quiz-Pengetahuan Umum')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Jupiter'));
    await tester.tap(find.text('Jupiter'));
    await tester.pump();
    final nextButton = find.text('Soal berikutnya');
    await tester.ensureVisible(nextButton);
    await tester.tap(nextButton);
    await tester.pumpAndSettle();
    expect(find.text('2/5'), findsOneWidget);

    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lanjutkan kuis'));
    await tester.pumpAndSettle();

    expect(find.text('2/5'), findsOneWidget);
    expect(find.text('Tokyo'), findsOneWidget);
  });

  testWidgets('quiz catalog filters categories and searches quiz titles', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const QuizApp());

    await tester.enterText(find.byKey(const Key('player-name-field')), 'Naya');
    await tester.tap(find.text('Jelajahi semua kuis'));
    await tester.pumpAndSettle();

    expect(find.text('Semua  9'), findsOneWidget);
    expect(find.text('Umum  3'), findsOneWidget);
    expect(find.text('Fun  3'), findsOneWidget);
    expect(find.text('Kriptografi  3'), findsOneWidget);

    await tester.tap(find.text('Kriptografi  3'));
    await tester.pumpAndSettle();
    expect(find.text('Dasar Kriptografi'), findsOneWidget);
    expect(find.text('Sandi Klasik'), findsOneWidget);
    expect(find.text('Kunci, Hash, dan Keamanan'), findsOneWidget);
    expect(find.text('3 kuis'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('quiz-search-field')),
      'kunci, hash',
    );
    await tester.pumpAndSettle();
    expect(find.text('1 kuis'), findsOneWidget);
    expect(
      find.byKey(const Key('quiz-Kunci, Hash, dan Keamanan')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('quiz-Dasar Kriptografi')), findsNothing);

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    final cryptoQuiz = find.byKey(const Key('quiz-Kunci, Hash, dan Keamanan'));
    await tester.ensureVisible(cryptoQuiz);
    await tester.tap(cryptoQuiz);
    await tester.pumpAndSettle();
    expect(find.text('Jelajahi kuis'), findsNothing);
    expect(find.text('Halo, Naya!'), findsOneWidget);
    expect(find.text('Kunci, Hash, dan Keamanan'), findsOneWidget);
    expect(
      find.text('Fungsi hash kriptografis umumnya mengubah data menjadi...'),
      findsOneWidget,
    );
  });

  testWidgets('home screen supports switching between color themes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const QuizApp());

    expect(find.byTooltip('Gunakan tema gelap'), findsOneWidget);
    await tester.tap(find.byTooltip('Gunakan tema gelap'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Gunakan tema terang'), findsOneWidget);
  });
}
