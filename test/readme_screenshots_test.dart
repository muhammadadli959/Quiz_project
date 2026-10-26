import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uts/main.dart';

const _screenshotKey = Key('readme-screenshot-root');

Future<void> _openCatalog(WidgetTester tester) async {
  await tester.pumpWidget(
    const RepaintBoundary(key: _screenshotKey, child: QuizApp()),
  );
  await tester.enterText(find.byKey(const Key('player-name-field')), 'Naya');
  await tester.tap(find.text('Jelajahi semua kuis'));
  await tester.pumpAndSettle();
}

Future<void> _openGeneralQuiz(WidgetTester tester) async {
  await _openCatalog(tester);
  await tester.tap(find.byKey(const Key('quiz-Pengetahuan Umum')));
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

      await tester.pumpWidget(
        const RepaintBoundary(key: _screenshotKey, child: QuizApp()),
      );
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
      await tester.tap(find.text('Kriptografi  3'));
      await tester.pumpAndSettle();
      await expectLater(
        find.byKey(_screenshotKey),
        matchesGoldenFile('../docs/screenshots/catalog.png'),
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

      await expectLater(
        find.byKey(_screenshotKey),
        matchesGoldenFile('../docs/screenshots/result.png'),
      );
    });
  });
}
