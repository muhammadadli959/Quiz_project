import 'package:flutter/material.dart';

class QuizQuestion {
  const QuizQuestion({
    required this.category,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    required this.icon,
  });

  final String category;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final IconData icon;

  Map<String, Object> toJson() => {
    'category': category,
    'question': question,
    'options': options,
    'correctAnswerIndex': correctAnswerIndex,
    'explanation': explanation,
  };

  factory QuizQuestion.fromJson(Map<String, dynamic> json, IconData icon) {
    return QuizQuestion(
      category: json['category'] as String,
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      correctAnswerIndex: json['correctAnswerIndex'] as int,
      explanation: (json['explanation'] as String?) ?? '',
      icon: icon,
    );
  }
}
