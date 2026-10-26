import 'package:flutter/foundation.dart';

import 'quiz_question.dart';

class QuizSession extends ChangeNotifier {
  QuizSession(this.questions)
    : _answers = List<int?>.filled(questions.length, null);

  final List<QuizQuestion> questions;
  final List<int?> _answers;
  String _playerName = '';
  int _currentIndex = 0;
  bool _isComplete = false;

  String get playerName => _playerName;
  int get currentIndex => _currentIndex;
  bool get isComplete => _isComplete;
  bool get hasProgress => _playerName.isNotEmpty && !_isComplete;
  int get totalQuestions => questions.length;
  int get score => List<int>.generate(questions.length, (index) => index)
      .where((index) => _answers[index] == questions[index].correctAnswerIndex)
      .length;
  double get progress => (_currentIndex + 1) / questions.length;
  QuizQuestion get currentQuestion => questions[_currentIndex];
  int? get selectedAnswer => _answers[_currentIndex];
  List<int?> get answers => List.unmodifiable(_answers);

  void start(String name) {
    _playerName = name.trim();
    _currentIndex = 0;
    _isComplete = false;
    for (var index = 0; index < _answers.length; index++) {
      _answers[index] = null;
    }
    notifyListeners();
  }

  void selectAnswer(int answerIndex) {
    if (_isComplete ||
        answerIndex < 0 ||
        answerIndex >= currentQuestion.options.length) {
      return;
    }
    _answers[_currentIndex] = answerIndex;
    notifyListeners();
  }

  bool submitAnswer() {
    if (_isComplete || selectedAnswer == null) return false;
    if (_currentIndex == questions.length - 1) {
      _isComplete = true;
    } else {
      _currentIndex++;
    }
    notifyListeners();
    return _isComplete;
  }

  void goToPreviousQuestion() {
    if (_currentIndex == 0 || _isComplete) return;
    _currentIndex--;
    notifyListeners();
  }
}
