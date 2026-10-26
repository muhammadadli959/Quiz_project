import 'package:flutter/material.dart';

import '../models/quiz_session.dart';
import '../widgets/answer_option.dart';
import '../widgets/primary_button.dart';
import 'result_screen.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key, required this.session});

  final QuizSession session;

  void _continue(BuildContext context) {
    if (session.isComplete) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => ResultScreen(session: session)),
      );
      return;
    }
    if (session.submitAnswer()) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => ResultScreen(session: session)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: session,
      builder: (context, _) {
        final question = session.currentQuestion;
        final isLastQuestion =
            session.currentIndex == session.totalQuestions - 1;
        final width = MediaQuery.sizeOf(context).width;
        final horizontalPadding = width > 720 ? 48.0 : 20.0;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              tooltip: 'Kembali',
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            title: Text(
              'Halo, ${session.playerName}!',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 18),
                child: Center(
                  child: Text(
                    '${session.currentIndex + 1}/${session.totalQuestions}',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                18,
                horizontalPadding,
                28,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _ProgressHeader(progress: session.progress),
                      const SizedBox(height: 26),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                              .withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              question.icon,
                              color: const Color(0xFF6658D3),
                              size: 21,
                            ),
                            const SizedBox(width: 9),
                            Text(
                              question.category.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 12,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF6658D3),
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.stars_rounded,
                              color: Color(0xFFFFB84D),
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '10 poin',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        question.question,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontSize: width > 720 ? 30 : 25,
                              height: 1.25,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.4,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pilih satu jawaban yang paling tepat.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ...List.generate(
                        question.options.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 11),
                          child: AnswerOption(
                            label: String.fromCharCode(65 + index),
                            text: question.options[index],
                            selected: session.selectedAnswer == index,
                            onTap: () => session.selectAnswer(index),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          if (session.currentIndex > 0)
                            IconButton.filledTonal(
                              tooltip: 'Soal sebelumnya',
                              onPressed: session.goToPreviousQuestion,
                              icon: const Icon(Icons.arrow_back_rounded),
                            ),
                          if (session.currentIndex > 0)
                            const SizedBox(width: 12),
                          Expanded(
                            child: PrimaryButton(
                              label: session.isComplete
                                  ? 'Lihat hasil'
                                  : isLastQuestion
                                  ? 'Selesaikan kuis'
                                  : 'Soal berikutnya',
                              icon: session.isComplete || isLastQuestion
                                  ? Icons.flag_rounded
                                  : Icons.arrow_forward_rounded,
                              enabled:
                                  session.selectedAnswer != null ||
                                  session.isComplete,
                              onPressed: () => _continue(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Perjalananmu',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
              ),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: const TextStyle(
                color: Color(0xFF6658D3),
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 9,
            backgroundColor: Theme.of(context).dividerColor
                .withValues(alpha: 0.4),
            color: const Color(0xFF796CE0),
          ),
        ),
      ],
    );
  }
}
