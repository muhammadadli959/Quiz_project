import 'package:flutter/material.dart';

import 'quiz_question.dart';

enum QuizCategory { umum, fun, kriptografi, custom }

extension QuizCategoryDetails on QuizCategory {
  String get title => switch (this) {
    QuizCategory.umum => 'Umum',
    QuizCategory.fun => 'Fun',
    QuizCategory.kriptografi => 'Kriptografi',
    QuizCategory.custom => 'Kuis Saya',
  };

  String get description => switch (this) {
    QuizCategory.umum => 'Tambah wawasan sehari-hari',
    QuizCategory.fun => 'Fakta seru dan pertanyaan ringan',
    QuizCategory.kriptografi => 'Belajar konsep sandi dan keamanan data',
    QuizCategory.custom => 'Kuis buatanmu sendiri',
  };

  IconData get icon => switch (this) {
    QuizCategory.umum => Icons.public_rounded,
    QuizCategory.fun => Icons.celebration_rounded,
    QuizCategory.kriptografi => Icons.key_rounded,
    QuizCategory.custom => Icons.edit_note_rounded,
  };

  Color get color => switch (this) {
    QuizCategory.umum => const Color(0xFF6658D3),
    QuizCategory.fun => const Color(0xFFE68B39),
    QuizCategory.kriptografi => const Color(0xFF218B78),
    QuizCategory.custom => const Color(0xFFCE5B8C),
  };
}

class QuizPack {
  const QuizPack({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.duration,
    required this.difficulty,
    required this.icon,
    required this.questions,
    this.isCustom = false,
  });

  final String id;
  final String title;
  final QuizCategory category;
  final String description;
  final String duration;
  final String difficulty;
  final IconData icon;
  final List<QuizQuestion> questions;
  final bool isCustom;

  Map<String, Object> toJson() => {
    'id': id,
    'title': title,
    'category': category.name,
    'description': description,
    'duration': duration,
    'difficulty': difficulty,
    'questions': questions.map((question) => question.toJson()).toList(),
  };

  factory QuizPack.fromJson(Map<String, dynamic> json) {
    const category = QuizCategory.custom;
    return QuizPack(
      id: json['id'] as String,
      title: json['title'] as String,
      category: category,
      description: json['description'] as String,
      duration: json['duration'] as String,
      difficulty: json['difficulty'] as String,
      icon: category.icon,
      isCustom: true,
      questions: (json['questions'] as List)
          .map(
            (question) => QuizQuestion.fromJson(
              Map<String, dynamic>.from(question as Map),
              category.icon,
            ),
          )
          .toList(),
    );
  }
}
