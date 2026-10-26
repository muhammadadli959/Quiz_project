import 'package:flutter/material.dart';

import '../models/quiz_question.dart';

const quizQuestions = <QuizQuestion>[
  QuizQuestion(
    category: 'Sains',
    question: 'Planet terbesar di tata surya kita adalah...',
    options: ['Mars', 'Jupiter', 'Saturnus', 'Bumi'],
    correctAnswerIndex: 1,
    explanation: 'Jupiter adalah planet terbesar, dengan ukuran lebih dari 11 kali diameter Bumi.',
    icon: Icons.public_rounded,
  ),
  QuizQuestion(
    category: 'Geografi',
    question: 'Ibu kota negara Jepang adalah...',
    options: ['Kyoto', 'Osaka', 'Tokyo', 'Hiroshima'],
    correctAnswerIndex: 2,
    explanation: 'Tokyo merupakan ibu kota Jepang dan salah satu kawasan metropolitan terbesar di dunia.',
    icon: Icons.explore_rounded,
  ),
  QuizQuestion(
    category: 'Biologi',
    question: 'Organ tubuh manusia yang memompa darah adalah...',
    options: ['Paru-paru', 'Hati', 'Ginjal', 'Jantung'],
    correctAnswerIndex: 3,
    explanation: 'Jantung memompa darah ke seluruh tubuh melalui sistem peredaran darah.',
    icon: Icons.favorite_rounded,
  ),
  QuizQuestion(
    category: 'Teknologi',
    question: 'Kepanjangan dari CPU adalah...',
    options: [
      'Central Processing Unit',
      'Computer Personal Utility',
      'Central Program User',
      'Core Power Unit',
    ],
    correctAnswerIndex: 0,
    explanation: 'CPU atau Central Processing Unit menjalankan instruksi dan mengolah data pada komputer.',
    icon: Icons.memory_rounded,
  ),
  QuizQuestion(
    category: 'Astronomi',
    question: 'Bintang yang menjadi pusat tata surya adalah...',
    options: ['Sirius', 'Matahari', 'Proxima Centauri', 'Vega'],
    correctAnswerIndex: 1,
    explanation: 'Matahari adalah bintang di pusat tata surya dan sumber energi utama bagi Bumi.',
    icon: Icons.wb_sunny_rounded,
  ),
];
