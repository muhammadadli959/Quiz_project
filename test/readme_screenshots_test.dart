import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uts/main.dart';

const _screenshotKey = Key('readme-screenshot-root');

Future<void> _launch(WidgetTester tester) async {
  await tester.pumpWidget(
    const RepaintBoundary(key: _screenshotKey, child: QuizApp()),
  );
  await tester.pumpAndSettle();
}

Future<void> _openCatalog(WidgetTester tester) async {
  await _launch(tester);
  await tester.enterText(find.byKey(const Key('player-name-field')), 'Naya');
  await tester.ensureVisible(find.text('Lihat semua'));
  await tester.tap(find.text('Lihat semua'));
  await tester.pumpAndSettle();
}

Future<void> _openDetail(WidgetTester tester) async {
  await _openCatalog(tester);
  final quizCard = find.byKey(const Key('quiz-Pengetahuan Umum'));
  await tester.ensureVisible(quizCard);
  await tester.tap(quizCard);
  await tester.pumpAndSettle();
}

Future<void> _openGeneralQuiz(WidgetTester tester) async {
  await _openDetail(tester);
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

Future<void> _finishGeneralQuiz(WidgetTester tester) async {
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
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  setUpAll(() async {
    final nunito = FontLoader('Nunito')
      ..addFont(rootBundle.load('assets/fonts/Nunito-Variable.ttf'));
    await nunito.load();

    final materialIcons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await materialIcons.load();
  });

  group('README screenshots', () {
    testWidgets('home page', (tester) async {
      tester.view.physicalSize = const Size(432, 936);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await _launch(tester);
      await expectLater(
        find.byKey(_screenshotKey),
        matchesGoldenFile('../docs/screenshots/home.png'),
      );
    });

    testWidgets('quiz category catalog page', (tester) async {
      tester.view.physicalSize = const Size(432, 936);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await _openCatalog(tester);
      await tester.tap(find.text('Kriptografi  4'));
      await tester.pumpAndSettle();
      await expectLater(
        find.byKey(_screenshotKey),
        matchesGoldenFile('../docs/screenshots/catalog.png'),
      );
    });

    testWidgets('quiz detail page', (tester) async {
      tester.view.physicalSize = const Size(432, 936);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await _openDetail(tester);
      await expectLater(
        find.byKey(_screenshotKey),
        matchesGoldenFile('../docs/screenshots/detail.png'),
      );
    });

    testWidgets('quiz question page', (tester) async {
      tester.view.physicalSize = const Size(432, 936);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await _openGeneralQuiz(tester);
      await expectLater(
        find.byKey(_screenshotKey),
        matchesGoldenFile('../docs/screenshots/quiz.png'),
      );
    });

    testWidgets('quiz result page', (tester) async {
      tester.view.physicalSize = const Size(432, 936);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await _openGeneralQuiz(tester);
      await _finishGeneralQuiz(tester);
      await expectLater(
        find.byKey(_screenshotKey),
        matchesGoldenFile('../docs/screenshots/result.png'),
      );
    });

    testWidgets('my quizzes page', (tester) async {
      tester.view.physicalSize = const Size(432, 936);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await _launch(tester);
      await tester.tap(find.text('Kuis Saya').last);
      await tester.pumpAndSettle();
      await expectLater(
        find.byKey(_screenshotKey),
        matchesGoldenFile('../docs/screenshots/my-quizzes.png'),
      );
    });

    testWidgets('quiz editor page', (tester) async {
      tester.view.physicalSize = const Size(432, 936);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await _launch(tester);
      await tester.tap(find.text('Kuis Saya').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Buat').last);
      await tester.pumpAndSettle();
      await expectLater(
        find.byKey(_screenshotKey),
        matchesGoldenFile('../docs/screenshots/quiz-editor.png'),
      );
    });

    testWidgets('activity page', (tester) async {
      tester.view.physicalSize = const Size(432, 936);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await _launch(tester);
      await tester.tap(find.text('Aktivitas'));
      await tester.pumpAndSettle();
      await expectLater(
        find.byKey(_screenshotKey),
        matchesGoldenFile('../docs/screenshots/activity.png'),
      );
    });

    testWidgets('profile page', (tester) async {
      tester.view.physicalSize = const Size(432, 936);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await _launch(tester);
      await tester.tap(find.text('Profil'));
      await tester.pumpAndSettle();
      await expectLater(
        find.byKey(_screenshotKey),
        matchesGoldenFile('../docs/screenshots/profile.png'),
      );
    });
  });
}
