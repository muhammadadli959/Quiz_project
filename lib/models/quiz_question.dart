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
}
