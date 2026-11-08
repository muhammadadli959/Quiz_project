import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/quiz_questions.dart';
import 'quiz_attempt.dart';
import 'quiz_pack.dart';
import 'quiz_question.dart';
import 'quiz_session.dart';

class AppStore extends ChangeNotifier {
  AppStore() : session = QuizSession(quizCatalog.first) {
    session.addListener(_onSessionChanged);
  }

  static const _customQuizzesKey = 'quiz.userQuizzes.v1';
  static const _attemptsKey = 'quiz.attempts.v1';
  static const _sessionKey = 'quiz.session.v1';
  static const _playerNameKey = 'quiz.playerName.v1';
  static const _darkModeKey = 'quiz.darkMode.v1';

  final QuizSession session;
  final List<QuizPack> _customQuizzes = [];
  final List<QuizAttempt> _attempts = [];
  late SharedPreferences _preferences;
  String _playerName = '';
  bool _isDarkMode = false;
  bool _isLoaded = false;
  String? _lastRecordedSession;

  String get playerName => _playerName;
  bool get isDarkMode => _isDarkMode;
  bool get isLoaded => _isLoaded;
  List<QuizPack> get customQuizzes => List.unmodifiable(_customQuizzes);
  List<QuizAttempt> get attempts => List.unmodifiable(_attempts);
  List<QuizPack> get allQuizzes => [...quizCatalog, ..._customQuizzes];
  int get totalPlayed => _attempts.length;
  int get bestScore => _attempts.fold<int>(
    0,
    (best, attempt) => best > attempt.percentage ? best : attempt.percentage,
  );

  Future<void> load() async {
    _preferences = await SharedPreferences.getInstance();
    _playerName = _preferences.getString(_playerNameKey) ?? '';
    _isDarkMode = _preferences.getBool(_darkModeKey) ?? false;

    final customJson = _preferences.getString(_customQuizzesKey);
    if (customJson != null) {
      final items = jsonDecode(customJson) as List;
      _customQuizzes
        ..clear()
        ..addAll(
          items.map(
            (item) => QuizPack.fromJson(Map<String, dynamic>.from(item as Map)),
          ),
        );
    }

    final attemptsJson = _preferences.getString(_attemptsKey);
    if (attemptsJson != null) {
      final items = jsonDecode(attemptsJson) as List;
      _attempts
        ..clear()
        ..addAll(
          items.map(
            (item) =>
                QuizAttempt.fromJson(Map<String, dynamic>.from(item as Map)),
          ),
        );
    }

    final sessionJson = _preferences.getString(_sessionKey);
    if (sessionJson != null) {
      final data = jsonDecode(sessionJson) as Map<String, dynamic>;
      final quizId = data['quizId'] as String?;
      final savedQuiz = allQuizzes
          .where((quiz) => quiz.id == quizId)
          .firstOrNull;
      if (savedQuiz != null && savedQuiz.questions.isNotEmpty) {
        session.restore(data, savedQuiz);
        _playerName = session.playerName;
        if (session.isComplete) {
          _lastRecordedSession = session.startedAt?.toIso8601String();
        }
      } else {
        await _preferences.remove(_sessionKey);
      }
    }

    _isLoaded = true;
    notifyListeners();
  }

  Future<void> setPlayerName(String name) async {
    final cleanedName = name.trim();
    if (cleanedName.isEmpty || cleanedName == _playerName) return;
    _requireSaved(
      await _preferences.setString(_playerNameKey, cleanedName),
      'player name',
    );
    _playerName = cleanedName;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    final nextTheme = !_isDarkMode;
    _requireSaved(
      await _preferences.setBool(_darkModeKey, nextTheme),
      'theme preference',
    );
    _isDarkMode = nextTheme;
    notifyListeners();
  }

  Future<void> saveQuiz(QuizPack quiz) async {
    if (!quiz.isCustom || quiz.questions.isEmpty) {
      throw ArgumentError.value(
        quiz,
        'quiz',
        'A custom quiz must have questions.',
      );
    }
    final index = _customQuizzes.indexWhere((item) => item.id == quiz.id);
    final previousQuiz = index == -1 ? null : _customQuizzes[index];
    if (index == -1) {
      _customQuizzes.insert(0, quiz);
    } else {
      _customQuizzes[index] = quiz;
    }
    try {
      await _persistCustomQuizzes();
    } catch (_) {
      if (index == -1) {
        _customQuizzes.removeWhere((item) => item.id == quiz.id);
      } else {
        _customQuizzes[index] = previousQuiz!;
      }
      rethrow;
    }
    notifyListeners();
  }

  Future<void> deleteQuiz(QuizPack quiz) async {
    if (!quiz.isCustom) {
      throw ArgumentError.value(
        quiz,
        'quiz',
        'Built-in quizzes cannot be deleted.',
      );
    }
    final index = _customQuizzes.indexWhere((item) => item.id == quiz.id);
    if (index == -1) return;
    final removedQuiz = _customQuizzes.removeAt(index);
    try {
      await _persistCustomQuizzes();
    } catch (_) {
      _customQuizzes.insert(index, removedQuiz);
      rethrow;
    }
    notifyListeners();
  }

  Future<void> _persistCustomQuizzes() async {
    _requireSaved(
      await _preferences.setString(
        _customQuizzesKey,
        jsonEncode(_customQuizzes.map((quiz) => quiz.toJson()).toList()),
      ),
      'custom quizzes',
    );
  }

  void _onSessionChanged() {
    if (!_isLoaded) return;
    _saveInBackground(_persistSession());

    if (session.isComplete) {
      final sessionId = session.startedAt?.toIso8601String();
      if (sessionId == null || sessionId == _lastRecordedSession) return;
      _lastRecordedSession = sessionId;
      final attempt = QuizAttempt(
        id: '${session.quiz.id}-$sessionId',
        quizId: session.quiz.id,
        quizTitle: session.quiz.title,
        playerName: session.playerName,
        score: session.score,
        totalQuestions: session.totalQuestions,
        durationSeconds: session.elapsedSeconds,
        completedAt: DateTime.now(),
      );
      _attempts.insert(0, attempt);
      if (_attempts.length > 100) _attempts.removeLast();
      _saveInBackground(_persistAttempts());
    }
    notifyListeners();
  }

  Future<void> _persistSession() async {
    _requireSaved(
      await _preferences.setString(_sessionKey, jsonEncode(session.toJson())),
      'quiz progress',
    );
  }

  Future<void> _persistAttempts() async {
    _requireSaved(
      await _preferences.setString(
        _attemptsKey,
        jsonEncode(_attempts.map((attempt) => attempt.toJson()).toList()),
      ),
      'quiz history',
    );
  }

  void _requireSaved(bool saved, String label) {
    if (!saved) throw StateError('Could not save $label to local storage.');
  }

  void _saveInBackground(Future<void> save) {
    unawaited(
      save.catchError((Object error, StackTrace stackTrace) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stackTrace,
            library: 'Cerdas Yuk local storage',
            context: ErrorDescription('while saving quiz data'),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    session
      ..removeListener(_onSessionChanged)
      ..dispose();
    super.dispose();
  }

  static QuizPack createCustomQuiz({
    required String title,
    required String description,
    required List<QuizQuestion> questions,
    String? id,
  }) {
    final stableId = id ?? 'custom-${DateTime.now().microsecondsSinceEpoch}';
    const category = QuizCategory.custom;
    return QuizPack(
      id: stableId,
      title: title.trim(),
      category: category,
      description: description.trim().isEmpty
          ? 'Kuis buatan ${title.trim()}.'
          : description.trim(),
      duration: '${(questions.length + 1) ~/ 2} menit',
      difficulty: 'Bebas',
      icon: category.icon,
      isCustom: true,
      questions: questions
          .map(
            (question) => QuizQuestion(
              category: title.trim(),
              question: question.question.trim(),
              options: question.options.map((option) => option.trim()).toList(),
              correctAnswerIndex: question.correctAnswerIndex,
              explanation: question.explanation.trim(),
              icon: category.icon,
            ),
          )
          .toList(),
    );
  }
}
