import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uts/data/quiz_questions.dart';
import 'package:uts/models/app_store.dart';
import 'package:uts/models/quiz_session.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('every built-in quiz contains at least 15 questions', () {
    expect(quizCatalog, hasLength(14));
    for (final quiz in quizCatalog) {
      expect(quiz.questions, hasLength(15), reason: quiz.title);
    }
  });

  test('custom quizzes persist locally and can be deleted', () async {
    final firstStore = AppStore();
    await firstStore.load();
    final quiz = AppStore.createCustomQuiz(
      title: 'Kuis Lokal',
      description: 'Contoh penyimpanan',
      questions: quizCatalog.first.questions.take(3).toList(),
    );
    await firstStore.saveQuiz(quiz);
    firstStore.dispose();

    final restoredStore = AppStore();
    await restoredStore.load();
    expect(restoredStore.customQuizzes.single.title, 'Kuis Lokal');
    expect(restoredStore.customQuizzes.single.questions, hasLength(3));
    await restoredStore.deleteQuiz(restoredStore.customQuizzes.single);
    restoredStore.dispose();

    final finalStore = AppStore();
    await finalStore.load();
    expect(finalStore.customQuizzes, isEmpty);
    finalStore.dispose();
  });

  test('challenge timer completes the quiz at zero', () {
    final session = QuizSession(quizCatalog.first)
      ..start(
        'Naya',
        questionCount: 1,
        shuffleQuestions: false,
        shuffleOptions: false,
        timeLimitSeconds: 1,
      );

    session.tick();

    expect(session.isComplete, isTrue);
    expect(session.isTimedOut, isTrue);
    expect(session.remainingSeconds, 0);
    session.dispose();
  });
}
