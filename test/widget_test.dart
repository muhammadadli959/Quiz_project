import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uts/main.dart';

Future<void> _openCatalog(WidgetTester tester, {String name = 'Naya'}) async {
  await tester.pumpWidget(const QuizApp());
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(const Key('player-name-field')), name);
  await tester.ensureVisible(find.text('Lihat semua'));
  await tester.tap(find.text('Lihat semua'));
  await tester.pumpAndSettle();
}

Future<void> _openGeneralQuiz(WidgetTester tester) async {
  await _openCatalog(tester);
  final quizCard = find.byKey(const Key('quiz-Pengetahuan Umum'));
  await tester.ensureVisible(quizCard);
  await tester.tap(quizCard);
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.byType(DropdownButton<int>));
  await tester.tap(find.byType(DropdownButton<int>));
  await tester.pumpAndSettle();
  await tester.tap(find.text('5 soal').last);
  await tester.pumpAndSettle();
  final shuffleSwitch = find.text('Acak soal dan jawaban');
  await tester.ensureVisible(shuffleSwitch);
  await tester.tap(shuffleSwitch);
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.text('Mulai kuis'));
  await tester.tap(find.text('Mulai kuis'));
  await tester.pumpAndSettle();
}

Future<void> _answerGeneralQuiz(WidgetTester tester) async {
  const answers = [
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
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('player can finish a quiz and see the named score', (
    WidgetTester tester,
  ) async {
    await _openGeneralQuiz(tester);

    expect(find.text('Halo, Naya!'), findsOneWidget);
    expect(find.text('Pengetahuan Umum'), findsOneWidget);
    expect(find.text('1/5'), findsOneWidget);

    await _answerGeneralQuiz(tester);

    expect(find.text('Kuis selesai, Naya!'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('100% akurasi'), findsOneWidget);
  });

  testWidgets('quiz progress remains available after returning home', (
    WidgetTester tester,
  ) async {
    await _openGeneralQuiz(tester);
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
    await tester.tap(find.text('Beranda').last);
    await tester.pumpAndSettle();
    final continueButton = find.text('Lanjut');
    await tester.ensureVisible(continueButton);
    await tester.tap(continueButton);
    await tester.pumpAndSettle();

    expect(find.text('2/5'), findsOneWidget);
    expect(find.text('Tokyo'), findsOneWidget);
  });

  testWidgets('catalog filters categories and searches quiz titles', (
    WidgetTester tester,
  ) async {
    await _openCatalog(tester);

    expect(find.text('Semua  14'), findsOneWidget);
    expect(find.text('Umum  6'), findsOneWidget);
    expect(find.text('Fun  4'), findsOneWidget);
    expect(find.text('Kriptografi  4'), findsOneWidget);

    await tester.tap(find.text('Kriptografi  4'));
    await tester.pumpAndSettle();
    expect(find.text('Dasar Kriptografi'), findsOneWidget);
    expect(find.text('Sandi Klasik'), findsOneWidget);
    expect(find.text('Kunci, Hash, dan Keamanan'), findsOneWidget);
    expect(find.text('4 kuis'), findsOneWidget);

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
  });

  testWidgets('user can create a custom quiz with local questions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const QuizApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kuis Saya').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Buat').last);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('custom-quiz-title-field')),
      'Mini Kuis',
    );
    for (var question = 0; question < 3; question++) {
      final prompt = find.byKey(Key('custom-question-prompt-$question'));
      await tester.ensureVisible(prompt);
      await tester.enterText(prompt, 'Pertanyaan ${question + 1}?');
      for (var option = 0; option < 4; option++) {
        final field = find.byKey(Key('custom-option-$question-$option'));
        await tester.ensureVisible(field);
        await tester.enterText(field, 'Pilihan ${option + 1}');
      }
    }

    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    final saveButton = find.text('Simpan kuis');
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
    expect(find.text('Mini Kuis'), findsOneWidget);
    expect(find.text('1 kuis tersimpan di perangkat ini.'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.pumpWidget(const QuizApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kuis Saya').last);
    await tester.pumpAndSettle();
    expect(find.text('Mini Kuis'), findsOneWidget);
  });

  testWidgets('profile supports saved player names and theme preference', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const QuizApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('profile-name-field')), 'Dio');
    await tester.tap(find.text('Simpan nama'));
    await tester.pumpAndSettle();
    expect(find.text('Dio'), findsOneWidget);

    final themeSwitch = find.byType(SwitchListTile);
    expect(tester.widget<SwitchListTile>(themeSwitch).value, isFalse);
    await tester.tap(themeSwitch);
    await tester.pumpAndSettle();
    expect(tester.widget<SwitchListTile>(themeSwitch).value, isTrue);
  });
}
