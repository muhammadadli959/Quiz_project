import 'package:flutter/material.dart';

import '../models/app_store.dart';
import '../models/quiz_pack.dart';
import '../widgets/quiz_catalog_card.dart';
import 'quiz_detail_screen.dart';
import 'quiz_editor_screen.dart';

class MyQuizzesScreen extends StatelessWidget {
  const MyQuizzesScreen({super.key, required this.store});

  final AppStore store;

  Future<void> _delete(BuildContext context, QuizPack quiz) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus kuis?'),
        content: Text('"${quiz.title}" akan dihapus dari perangkat ini.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirm != true || !context.mounted) return;
    try {
      await store.deleteQuiz(quiz);
    } on Exception catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kuis tidak dapat dihapus: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final quizzes = store.customQuizzes;
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Kuis Saya',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            actions: [
              IconButton(
                tooltip: 'Buat kuis',
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => QuizEditorScreen(store: store),
                  ),
                ),
                icon: const Icon(Icons.add_circle_outline_rounded),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            top: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final horizontalPadding = constraints.maxWidth > 760
                    ? 38.0
                    : 18.0;
                final contentWidth =
                    constraints.maxWidth - 2 * horizontalPadding;
                final columns = contentWidth > 820
                    ? 3
                    : contentWidth > 510
                    ? 2
                    : 1;
                final cardWidth = (contentWidth - (columns - 1) * 13) / columns;
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    12,
                    horizontalPadding,
                    28,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1050),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _MyQuizzesIntro(
                            count: quizzes.length,
                            onCreate: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => QuizEditorScreen(store: store),
                              ),
                            ),
                          ),
                          const SizedBox(height: 23),
                          if (quizzes.isEmpty)
                            const _EmptyQuizzes()
                          else
                            Wrap(
                              spacing: 13,
                              runSpacing: 13,
                              children: [
                                for (final quiz in quizzes)
                                  SizedBox(
                                    width: cardWidth,
                                    child: _MyQuizCard(
                                      quiz: quiz,
                                      onOpen: () => Navigator.of(context).push(
                                        MaterialPageRoute<void>(
                                          builder: (_) => QuizDetailScreen(
                                            store: store,
                                            quiz: quiz,
                                          ),
                                        ),
                                      ),
                                      onEdit: () => Navigator.of(context).push(
                                        MaterialPageRoute<void>(
                                          builder: (_) => QuizEditorScreen(
                                            store: store,
                                            quiz: quiz,
                                          ),
                                        ),
                                      ),
                                      onDelete: () => _delete(context, quiz),
                                    ),
                                  ),
                              ],
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
      },
    );
  }
}

class _MyQuizzesIntro extends StatelessWidget {
  const _MyQuizzesIntro({required this.count, required this.onCreate});

  final int count;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: const Color(0xFFF9EAF1),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.edit_note_rounded,
            color: Color(0xFFCE5B8C),
            size: 36,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Belajar dengan caramu',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                ),
                Text('$count kuis tersimpan di perangkat ini.'),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Buat'),
          ),
        ],
      ),
    );
  }
}

class _MyQuizCard extends StatelessWidget {
  const _MyQuizCard({
    required this.quiz,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
  });

  final QuizPack quiz;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        QuizCatalogCard(quiz: quiz, onTap: onOpen),
        Positioned(
          top: 10,
          right: 38,
          child: PopupMenuButton<String>(
            tooltip: 'Aksi kuis',
            onSelected: (action) {
              if (action == 'edit') onEdit();
              if (action == 'delete') onDelete();
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit kuis')),
              PopupMenuItem(value: 'delete', child: Text('Hapus kuis')),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptyQuizzes extends StatelessWidget {
  const _EmptyQuizzes();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        children: [
          const Icon(
            Icons.menu_book_rounded,
            size: 58,
            color: Color(0xFFCE5B8C),
          ),
          const SizedBox(height: 12),
          const Text(
            'Belum ada kuis buatanmu',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 5),
          Text(
            'Ubah catatan pelajaran menjadi kuis seru.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
