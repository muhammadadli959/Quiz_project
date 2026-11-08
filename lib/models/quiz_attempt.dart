class QuizAttempt {
  const QuizAttempt({
    required this.id,
    required this.quizId,
    required this.quizTitle,
    required this.playerName,
    required this.score,
    required this.totalQuestions,
    required this.durationSeconds,
    required this.completedAt,
  });

  final String id;
  final String quizId;
  final String quizTitle;
  final String playerName;
  final int score;
  final int totalQuestions;
  final int durationSeconds;
  final DateTime completedAt;

  int get percentage =>
      totalQuestions == 0 ? 0 : (score * 100 / totalQuestions).round();

  Map<String, Object> toJson() => {
    'id': id,
    'quizId': quizId,
    'quizTitle': quizTitle,
    'playerName': playerName,
    'score': score,
    'totalQuestions': totalQuestions,
    'durationSeconds': durationSeconds,
    'completedAt': completedAt.toIso8601String(),
  };

  factory QuizAttempt.fromJson(Map<String, dynamic> json) => QuizAttempt(
    id: json['id'] as String,
    quizId: json['quizId'] as String,
    quizTitle: json['quizTitle'] as String,
    playerName: json['playerName'] as String,
    score: json['score'] as int,
    totalQuestions: json['totalQuestions'] as int,
    durationSeconds: json['durationSeconds'] as int,
    completedAt: DateTime.parse(json['completedAt'] as String),
  );
}
