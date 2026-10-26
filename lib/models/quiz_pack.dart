import 'package:flutter/material.dart';

import 'quiz_question.dart';

enum QuizCategory { umum, fun, kriptografi }

extension QuizCategoryDetails on QuizCategory {
  String get title => switch (this) {
    QuizCategory.umum => 'Umum',
    QuizCategory.fun => 'Fun',
    QuizCategory.kriptografi => 'Kriptografi',
  };

  String get description => switch (this) {
    QuizCategory.umum => 'Tambah wawasan sehari-hari',
    QuizCategory.fun => 'Fakta seru dan pertanyaan ringan',
    QuizCategory.kriptografi => 'Belajar konsep sandi dan keamanan data',
  };

  IconData get icon => switch (this) {
    QuizCategory.umum => Icons.public_rounded,
    QuizCategory.fun => Icons.celebration_rounded,
    QuizCategory.kriptografi => Icons.key_rounded,
  };

  Color get color => switch (this) {
    QuizCategory.umum => const Color(0xFF6658D3),
    QuizCategory.fun => const Color(0xFFE68B39),
    QuizCategory.kriptografi => const Color(0xFF218B78),
  };
}

class QuizPack {
  const QuizPack({
    required this.title,
    required this.category,
    required this.description,
    required this.duration,
    required this.difficulty,
    required this.icon,
    required this.questions,
  });

  final String title;
  final QuizCategory category;
  final String description;
  final String duration;
  final String difficulty;
  final IconData icon;
  final List<QuizQuestion> questions;
}
