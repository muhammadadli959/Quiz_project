import 'package:flutter/material.dart';

import '../models/app_store.dart';
import '../models/quiz_pack.dart';
import '../models/quiz_question.dart';
import '../widgets/primary_button.dart';

class QuizEditorScreen extends StatefulWidget {
  const QuizEditorScreen({super.key, required this.store, this.quiz});

  final AppStore store;
  final QuizPack? quiz;

  @override
  State<QuizEditorScreen> createState() => _QuizEditorScreenState();
}

class _QuizEditorScreenState extends State<QuizEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final List<_QuestionDraft> _questions;
  bool _isSaving = false;

  bool get _isEditing => widget.quiz != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.quiz?.title);
    _descriptionController = TextEditingController(
      text: widget.quiz?.description,
    );
    _questions = widget.quiz == null
        ? List.generate(3, (_) => _QuestionDraft())
        : widget.quiz!.questions.map(_QuestionDraft.fromQuestion).toList();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    for (final question in _questions) {
      question.dispose();
    }
    super.dispose();
  }

  void _addQuestion() {
    if (_questions.length >= 30) return;
    setState(() => _questions.add(_QuestionDraft()));
  }

  void _removeQuestion(int index) {
    if (_questions.length <= 1) return;
    setState(() {
      _questions.removeAt(index).dispose();
    });
  }

  Future<void> _saveQuiz() async {
    if (_isSaving || !_formKey.currentState!.validate()) return;
    if (_questions.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kuis harus memiliki minimal 3 soal.')),
      );
      return;
    }
    final title = _titleController.text.trim();
    final normalizedTitle = title.toLowerCase();
    final duplicate = widget.store.customQuizzes.any(
      (quiz) =>
          quiz.id != widget.quiz?.id &&
          quiz.title.trim().toLowerCase() == normalizedTitle,
    );
    if (duplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul kuis tersebut sudah digunakan.')),
      );
      return;
    }

    setState(() => _isSaving = true);
    final quiz = AppStore.createCustomQuiz(
      id: widget.quiz?.id,
      title: title,
      description: _descriptionController.text,
      questions: [
        for (final draft in _questions)
          QuizQuestion(
            category: title,
            question: draft.prompt.text.trim(),
            options: draft.options.map((option) => option.text.trim()).toList(),
            correctAnswerIndex: draft.correctAnswer,
            explanation: draft.explanation.text.trim(),
            icon: QuizCategory.custom.icon,
          ),
      ],
    );

    try {
      await widget.store.saveQuiz(quiz);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Kuis berhasil diperbarui.'
                : 'Kuis berhasil disimpan.',
          ),
        ),
      );
      Navigator.of(context).pop();
    } on Exception catch (error) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kuis tidak dapat disimpan: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit kuis' : 'Buat kuis',
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalPadding = constraints.maxWidth > 700
                  ? 40.0
                  : 18.0;
              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  12,
                  horizontalPadding,
                  30,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _intro(),
                        const SizedBox(height: 17),
                        TextFormField(
                          key: const Key('custom-quiz-title-field'),
                          controller: _titleController,
                          maxLength: 48,
                          textCapitalization: TextCapitalization.sentences,
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                              ? 'Judul kuis wajib diisi.'
                              : null,
                          decoration: _decoration(
                            'Nama kuis',
                            Icons.title_rounded,
                          ),
                        ),
                        TextFormField(
                          controller: _descriptionController,
                          maxLength: 120,
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: 2,
                          decoration: _decoration(
                            'Deskripsi singkat (opsional)',
                            Icons.notes_rounded,
                          ),
                        ),
                        const SizedBox(height: 13),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Pertanyaan (${_questions.length}/30)',
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: _questions.length >= 30
                                  ? null
                                  : _addQuestion,
                              icon: const Icon(Icons.add_rounded),
                              label: const Text('Tambah soal'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        for (var index = 0; index < _questions.length; index++)
                          _QuestionEditor(
                            key: ValueKey('custom-question-$index'),
                            index: index,
                            draft: _questions[index],
                            canRemove: _questions.length > 1,
                            onRemove: () => _removeQuestion(index),
                          ),
                        const SizedBox(height: 14),
                        PrimaryButton(
                          label: _isSaving
                              ? 'Menyimpan...'
                              : _isEditing
                              ? 'Simpan perubahan'
                              : 'Simpan kuis',
                          icon: _isSaving ? null : Icons.save_rounded,
                          enabled: !_isSaving,
                          onPressed: _saveQuiz,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _intro() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFFF9EAF1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.edit_note_rounded, color: Color(0xFFCE5B8C), size: 31),
          SizedBox(width: 11),
          Expanded(
            child: Text(
              'Tulis pertanyaan dan tandai pilihan yang benar. Kuis tersimpan hanya di perangkat ini.',
              style: TextStyle(height: 1.4, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Theme.of(context).colorScheme.surface,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}

class _QuestionDraft {
  _QuestionDraft({
    String prompt = '',
    List<String> options = const ['', '', '', ''],
    this.correctAnswer = 0,
    String explanation = '',
  }) : prompt = TextEditingController(text: prompt),
       options = options
           .map((option) => TextEditingController(text: option))
           .toList(),
       explanation = TextEditingController(text: explanation);

  factory _QuestionDraft.fromQuestion(QuizQuestion question) => _QuestionDraft(
    prompt: question.question,
    options: question.options,
    correctAnswer: question.correctAnswerIndex,
    explanation: question.explanation,
  );

  final TextEditingController prompt;
  final List<TextEditingController> options;
  final TextEditingController explanation;
  int correctAnswer;

  void dispose() {
    prompt.dispose();
    explanation.dispose();
    for (final option in options) {
      option.dispose();
    }
  }
}

class _QuestionEditor extends StatefulWidget {
  const _QuestionEditor({
    super.key,
    required this.index,
    required this.draft,
    required this.canRemove,
    required this.onRemove,
  });

  final int index;
  final _QuestionDraft draft;
  final bool canRemove;
  final VoidCallback onRemove;

  @override
  State<_QuestionEditor> createState() => _QuestionEditorState();
}

class _QuestionEditorState extends State<_QuestionEditor> {
  @override
  Widget build(BuildContext context) {
    final draft = widget.draft;
    return Card(
      margin: const EdgeInsets.only(bottom: 13),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Soal ${widget.index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                if (widget.canRemove)
                  IconButton(
                    tooltip: 'Hapus soal',
                    onPressed: widget.onRemove,
                    icon: const Icon(Icons.delete_outline_rounded),
                  ),
              ],
            ),
            TextFormField(
              key: Key('custom-question-prompt-${widget.index}'),
              controller: draft.prompt,
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Tulis pertanyaannya.'
                  : null,
              decoration: const InputDecoration(labelText: 'Pertanyaan'),
            ),
            const SizedBox(height: 11),
            const Text(
              'Pilihan jawaban',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            for (
              var optionIndex = 0;
              optionIndex < draft.options.length;
              optionIndex++
            )
              TextFormField(
                key: Key('custom-option-${widget.index}-$optionIndex'),
                controller: draft.options[optionIndex],
                textCapitalization: TextCapitalization.sentences,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Pilihan tidak boleh kosong.'
                    : null,
                decoration: InputDecoration(
                  labelText: 'Pilihan ${String.fromCharCode(65 + optionIndex)}',
                ),
              ),
            DropdownButtonFormField<int>(
              initialValue: draft.correctAnswer,
              decoration: const InputDecoration(labelText: 'Jawaban benar'),
              items: [
                for (
                  var optionIndex = 0;
                  optionIndex < draft.options.length;
                  optionIndex++
                )
                  DropdownMenuItem(
                    value: optionIndex,
                    child: Text(
                      'Pilihan ${String.fromCharCode(65 + optionIndex)}',
                    ),
                  ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => draft.correctAnswer = value);
                }
              },
            ),
            TextFormField(
              controller: draft.explanation,
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Pembahasan (opsional)',
                prefixIcon: Icon(Icons.lightbulb_outline_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
