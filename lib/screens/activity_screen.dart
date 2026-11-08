import 'package:flutter/material.dart';

import '../models/app_store.dart';
import '../models/quiz_attempt.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key, required this.store});

  final AppStore store;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final attempts = store.attempts;
        final perfectScores = attempts
            .where((attempt) => attempt.percentage == 100)
            .length;
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Aktivitas',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          body: SafeArea(
            top: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _ActivityStat(
                        title: 'Kuis selesai',
                        value: '${store.totalPlayed}',
                        icon: Icons.checklist_rounded,
                        color: const Color(0xFF6658D3),
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: _ActivityStat(
                        title: 'Skor terbaik',
                        value: '${store.bestScore}%',
                        icon: Icons.emoji_events_rounded,
                        color: const Color(0xFFE69B34),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                const Text(
                  'Pencapaian',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 11),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _Achievement(
                      title: 'Langkah pertama',
                      subtitle: 'Selesaikan kuis pertama',
                      icon: Icons.flag_rounded,
                      unlocked: attempts.isNotEmpty,
                    ),
                    _Achievement(
                      title: 'Juara sempurna',
                      subtitle: 'Raih skor 100%',
                      icon: Icons.workspace_premium_rounded,
                      unlocked: perfectScores > 0,
                    ),
                    _Achievement(
                      title: 'Konsisten',
                      subtitle: 'Selesaikan 5 kuis',
                      icon: Icons.local_fire_department_rounded,
                      unlocked: attempts.length >= 5,
                    ),
                    _Achievement(
                      title: 'Kreator',
                      subtitle: 'Buat kuis pertamamu',
                      icon: Icons.edit_note_rounded,
                      unlocked: store.customQuizzes.isNotEmpty,
                    ),
                  ],
                ),
                const SizedBox(height: 23),
                const Text(
                  'Riwayat permainan',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 9),
                if (attempts.isEmpty)
                  const _EmptyHistory()
                else
                  for (final attempt in attempts)
                    _AttemptTile(attempt: attempt),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ActivityStat extends StatelessWidget {
  const _ActivityStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(19),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 9),
          Text(
            value,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
          ),
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _Achievement extends StatelessWidget {
  const _Achievement({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.unlocked,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    final color = unlocked ? const Color(0xFF6658D3) : Colors.grey;
    return Container(
      width: 168,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 25),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 9),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AttemptTile extends StatelessWidget {
  const _AttemptTile({required this.attempt});

  final QuizAttempt attempt;

  @override
  Widget build(BuildContext context) {
    final color = attempt.percentage >= 80
        ? const Color(0xFF27956F)
        : const Color(0xFF6658D3);
    final date = attempt.completedAt.toLocal();
    return Card(
      margin: const EdgeInsets.only(bottom: 9),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(Icons.quiz_rounded, color: color),
        ),
        title: Text(
          attempt.quizTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        subtitle: Text(
          '${date.day}/${date.month}/${date.year} · ${attempt.durationSeconds} dtk · ${attempt.score}/${attempt.totalQuestions} benar',
        ),
        trailing: Text(
          '${attempt.percentage}%',
          style: TextStyle(fontWeight: FontWeight.w900, color: color),
        ),
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 26),
      child: Text(
        'Selesaikan kuis untuk mulai mengisi riwayat permainanmu.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
  }
}
