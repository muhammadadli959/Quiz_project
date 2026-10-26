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
    await tester.tap(find.text('Mulai kuis'));
    await tester.pumpAndSettle();

    expect(find.text('Halo, Naya!'), findsOneWidget);
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
    await tester.tap(find.text('Mulai kuis'));
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
    await tester.tap(find.text('Lanjutkan kuis'));
    await tester.pumpAndSettle();

    expect(find.text('2/5'), findsOneWidget);
    expect(find.text('Tokyo'), findsOneWidget);
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
