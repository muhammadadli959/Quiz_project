import 'package:flutter/foundation.dart';

import 'dart:math';

import 'quiz_pack.dart';
import 'quiz_question.dart';

class QuizSession extends ChangeNotifier {
  QuizSession(this.quiz)
    : _questions = quiz.questions,
      _answers = List<int?>.filled(quiz.questions.length, null);

  QuizPack quiz;
  List<QuizQuestion> _questions;
  List<int?> _answers;
  String _playerName = '';
  int _currentIndex = 0;
  bool _isComplete = false;
  bool _isTimedOut = false;
  int _questionLimit = 0;
  int? _timeLimitSeconds;
  int? _remainingSeconds;
  DateTime? _startedAt;

  List<QuizQuestion> get questions => List.unmodifiable(_questions);
  String get playerName => _playerName;
  int get currentIndex => _currentIndex;
  bool get isComplete => _isComplete;
  bool get isTimedOut => _isTimedOut;
  bool get isTimerEnabled => _timeLimitSeconds != null;
  int? get remainingSeconds => _remainingSeconds;
  int get scoreMultiplier =>
      isTimedOut ? 1 : (_timeLimitSeconds == null ? 1 : 2);
  DateTime? get startedAt => _startedAt;
  int get elapsedSeconds =>
      _startedAt == null ? 0 : DateTime.now().difference(_startedAt!).inSeconds;
  bool get hasProgress => _playerName.isNotEmpty && !_isComplete;
  int get totalQuestions => questions.length;
  int get score => List<int>.generate(questions.length, (index) => index)
      .where((index) => _answers[index] == questions[index].correctAnswerIndex)
      .length;
  double get progress => (_currentIndex + 1) / questions.length;
  QuizQuestion get currentQuestion => questions[_currentIndex];
  int? get selectedAnswer => _answers[_currentIndex];
  List<int?> get answers => List.unmodifiable(_answers);

  void start(
    String name, {
    QuizPack? quiz,
    int? questionCount,
    bool shuffleQuestions = true,
    bool shuffleOptions = true,
    int? timeLimitSeconds,
  }) {
    if (quiz != null) this.quiz = quiz;
    final selectedQuestions = List<QuizQuestion>.of(this.quiz.questions);
    if (shuffleQuestions) selectedQuestions.shuffle(Random());
    final count = questionCount == null || questionCount <= 0
        ? selectedQuestions.length
        : questionCount.clamp(1, selectedQuestions.length);
    _questions = selectedQuestions.take(count).map((question) {
      if (!shuffleOptions) return question;
      final options = List<String>.of(question.options);
      final correctAnswer = options[question.correctAnswerIndex];
      options.shuffle(Random());
      return QuizQuestion(
        category: question.category,
        question: question.question,
        options: options,
        correctAnswerIndex: options.indexOf(correctAnswer),
        explanation: question.explanation,
        icon: question.icon,
      );
    }).toList();
    _answers = List<int?>.filled(_questions.length, null);
    _playerName = name.trim();
    _currentIndex = 0;
    _isComplete = false;
    _isTimedOut = false;
    _questionLimit = _questions.length;
    _timeLimitSeconds = timeLimitSeconds;
    _remainingSeconds = timeLimitSeconds;
    _startedAt = DateTime.now();
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

  void tick() {
    if (_isComplete || _remainingSeconds == null) return;
    if (_remainingSeconds! <= 1) {
      _remainingSeconds = 0;
      _isComplete = true;
      _isTimedOut = true;
    } else {
      _remainingSeconds = _remainingSeconds! - 1;
    }
    notifyListeners();
  }

  Map<String, Object?> toJson() => {
    'quizId': quiz.id,
    'playerName': _playerName,
    'currentIndex': _currentIndex,
    'answers': _answers,
    'questions': _questions.map((question) => question.toJson()).toList(),
    'isComplete': _isComplete,
    'isTimedOut': _isTimedOut,
    'questionLimit': _questionLimit,
    'timeLimitSeconds': _timeLimitSeconds,
    'remainingSeconds': _remainingSeconds,
    'startedAt': _startedAt?.toIso8601String(),
  };

  void restore(Map<String, dynamic> json, QuizPack savedQuiz) {
    quiz = savedQuiz;
    _playerName = json['playerName'] as String;
    _questions = (json['questions'] as List)
        .map(
          (question) => QuizQuestion.fromJson(
            Map<String, dynamic>.from(question as Map),
            savedQuiz.icon,
          ),
        )
        .toList();
    if (_questions.isEmpty) _questions = savedQuiz.questions;
    _answers = List<int?>.from(json['answers'] as List);
    if (_answers.length != _questions.length) {
      _answers = List<int?>.filled(_questions.length, null);
    }
    _questionLimit = _questions.length;
    _currentIndex = (json['currentIndex'] as int).clamp(
      0,
      _questions.length - 1,
    );
    _isComplete = json['isComplete'] as bool;
    _isTimedOut = json['isTimedOut'] as bool? ?? false;
    _timeLimitSeconds = json['timeLimitSeconds'] as int?;
    _remainingSeconds = json['remainingSeconds'] as int?;
    _startedAt = DateTime.tryParse(json['startedAt'] as String? ?? '');
    notifyListeners();
  }
}
