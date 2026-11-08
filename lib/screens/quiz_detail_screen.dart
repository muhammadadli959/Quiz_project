import 'package:flutter/material.dart';

import '../models/app_store.dart';
import '../models/quiz_pack.dart';
import 'quiz_editor_screen.dart';
import 'quiz_screen.dart';
import '../widgets/primary_button.dart';

class QuizDetailScreen extends StatefulWidget {
  const QuizDetailScreen({
    super.key,
    required this.store,
    required this.quiz,
    this.replaceExistingProgress = false,
  });

  final AppStore store;
  final QuizPack quiz;
  final bool replaceExistingProgress;

  @override
  State<QuizDetailScreen> createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen> {
  late QuizPack _quiz;
  late final TextEditingController _nameController = TextEditingController(
    text: widget.store.playerName,
  );
  late int _questionCount;
  bool _isTimedMode = false;
  bool _shuffleQuestions = true;

  @override
  void initState() {
    super.initState();
    _quiz = widget.quiz;
    _questionCount = _quiz.questions.length;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _startQuiz() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi namamu di profil sebelum bermain.')),
      );
      return;
    }
    try {
      await widget.store.setPlayerName(name);
    } on Exception catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nama tidak dapat disimpan: $error')),
      );
      return;
    }
    if (!mounted) return;

    final session = widget.store.session;
    if (session.hasProgress &&
        session.quiz.id == _quiz.id &&
        !widget.replaceExistingProgress) {
      final restart = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Kuis ini masih berlangsung'),
          content: const Text(
            'Lanjutkan progres yang tersimpan atau mulai ulang dengan pengaturan ini?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Lanjutkan'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Mulai ulang'),
            ),
          ],
        ),
      );
      if (!mounted || restart == null) return;
      if (!restart) {
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => QuizScreen(session: session)),
        );
        return;
      }
    }
    session.start(
      name,
      quiz: _quiz,
      questionCount: _questionCount,
      shuffleQuestions: _shuffleQuestions,
      shuffleOptions: _shuffleQuestions,
      timeLimitSeconds: _isTimedMode ? _questionCount * 20 : null,
    );
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => QuizScreen(session: session)),
    );
  }

  Future<void> _editQuiz() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => QuizEditorScreen(store: widget.store, quiz: _quiz),
      ),
    );
    if (!mounted) return;
    final updatedQuiz = widget.store.customQuizzes
        .where((quiz) => quiz.id == _quiz.id)
        .firstOrNull;
    if (updatedQuiz == null) return;
    setState(() {
      _quiz = updatedQuiz;
      _questionCount = _availableQuestionCounts.last;
    });
  }

  @override
  Widget build(BuildContext context) {
    final quiz = _quiz;
    final color = quiz.category.color;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Kembali',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text(
          'Detail kuis',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        actions: [
          if (quiz.isCustom)
            IconButton(
              tooltip: 'Edit kuis',
              onPressed: _editQuiz,
              icon: const Icon(Icons.edit_rounded),
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth > 700 ? 44.0 : 20.0;
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                16,
                horizontalPadding,
                28,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color, color.withValues(alpha: 0.72)],
                          ),
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 27,
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.2,
                              ),
                              child: Icon(
                                quiz.icon,
                                color: Colors.white,
                                size: 29,
                              ),
                            ),
                            const SizedBox(height: 17),
                            Text(
                              quiz.title,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              quiz.description,
                              style: const TextStyle(
                                color: Colors.white,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _DetailTag(label: quiz.category.title),
                                _DetailTag(
                                  label:
                                      '${quiz.questions.length} soal tersedia',
                                ),
                                _DetailTag(label: quiz.difficulty),
                                if (quiz.isCustom)
                                  const _DetailTag(label: 'Buatan saya'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Atur permainan',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _SettingsCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Jumlah soal',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                DropdownButton<int>(
                                  value: _questionCount,
                                  items: [
                                    for (final count
                                        in _availableQuestionCounts)
                                      DropdownMenuItem(
                                        value: count,
                                        child: Text('$count soal'),
                                      ),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() => _questionCount = value);
                                    }
                                  },
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                'Acak soal dan jawaban',
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                              subtitle: const Text(
                                'Susunan berubah setiap kali bermain.',
                              ),
                              value: _shuffleQuestions,
                              onChanged: (value) =>
                                  setState(() => _shuffleQuestions = value),
                            ),
                            const Divider(height: 12),
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                'Mode tantangan',
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                              subtitle: Text(
                                _isTimedMode
                                    ? '20 detik per soal'
                                    : 'Santai tanpa batas waktu',
                              ),
                              value: _isTimedMode,
                              onChanged: (value) =>
                                  setState(() => _isTimedMode = value),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      TextField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: 'Nama pemain',
                          hintText: 'Contoh: Naya',
                          prefixIcon: const Icon(Icons.person_outline_rounded),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      PrimaryButton(
                        label: 'Mulai kuis',
                        icon: Icons.play_arrow_rounded,
                        onPressed: _startQuiz,
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

  List<int> get _availableQuestionCounts {
    final total = _quiz.questions.length;
    final candidates = <int>{total, (total / 2).ceil(), total >= 5 ? 5 : total};
    return candidates.where((count) => count > 0).toList()..sort();
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: child,
      ),
    );
  }
}

class _DetailTag extends StatelessWidget {
  const _DetailTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
