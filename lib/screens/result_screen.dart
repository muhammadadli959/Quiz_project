import 'package:flutter/material.dart';

import '../models/quiz_session.dart';
import '../widgets/primary_button.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.session});

  final QuizSession session;

  @override
  Widget build(BuildContext context) {
    final score = session.score;
    final total = session.totalQuestions;
    final ratio = score / total;
    final headline = ratio == 1
        ? 'Luar biasa!'
        : ratio >= 0.6
        ? 'Kerja bagus!'
        : 'Tetap semangat!';
    final message = ratio == 1
        ? 'Semua jawabanmu benar. Kamu hebat!'
        : ratio >= 0.6
        ? 'Kamu sudah menjawab dengan sangat baik.'
        : 'Terus belajar, kesempatan berikutnya pasti lebih baik.';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Hasil kuis',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth > 700 ? 50.0 : 22.0;
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                16,
                horizontalPadding,
                28,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 660),
                  child: Column(
                    children: [
                      Container(
                        width: 108,
                        height: 108,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFF1CE),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          ratio == 1
                              ? Icons.workspace_premium_rounded
                              : Icons.emoji_events_rounded,
                          size: 58,
                          color: const Color(0xFFE5A629),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        headline,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Kuis selesai, ${session.playerName}!',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF5549BF), Color(0xFF8175E8)],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'SKOR AKHIR',
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$score',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 72,
                                height: 1.05,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              'dari $total pertanyaan benar',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                '${(ratio * 100).round()}% akurasi',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 22),
                      _AnswerReview(session: session),
                      const SizedBox(height: 22),
                      PrimaryButton(
                        label: 'Main lagi',
                        icon: Icons.refresh_rounded,
                        onPressed: () {
                          final navigator = Navigator.of(context);
                          session.start(session.playerName);
                          navigator.popUntil((route) => route.isFirst);
                          navigator.push(
                            MaterialPageRoute<void>(
                              builder: (_) => QuizScreen(session: session),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      TextButton.icon(
                        onPressed: () =>
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst),
                        icon: const Icon(Icons.home_rounded),
                        label: const Text('Kembali ke beranda'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AnswerReview extends StatelessWidget {
  const _AnswerReview({required this.session});

  final QuizSession session;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Ringkasan jawaban',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        ...List.generate(session.totalQuestions, (index) {
          final question = session.questions[index];
          final answer = session.answers[index];
          final isCorrect = answer == question.correctAnswerIndex;
          final color = isCorrect
              ? const Color(0xFF27956F)
              : const Color(0xFFD35F69);

          return Container(
            margin: const EdgeInsets.only(bottom: 9),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  color: color,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.question,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        answer == null
                            ? 'Belum dijawab'
                            : 'Jawabanmu: ${question.options[answer]}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                      if (!isCorrect)
                        Text(
                          'Jawaban benar: ${question.options[question.correctAnswerIndex]}',
                          style: const TextStyle(
                            color: Color(0xFF27956F),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      const SizedBox(height: 5),
                      Text(
                        question.explanation,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
