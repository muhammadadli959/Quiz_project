import 'package:flutter/material.dart';

import '../models/quiz_session.dart';
import '../widgets/primary_button.dart';
import '../widgets/quiz_artwork.dart';
import 'quiz_screen.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.session,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  final QuizSession session;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _openQuiz() {
    if (widget.session.isComplete) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ResultScreen(session: widget.session),
        ),
      );
      return;
    } else if (!widget.session.hasProgress) {
      if (!_formKey.currentState!.validate()) return;
      widget.session.start(_nameController.text);
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => QuizScreen(session: widget.session),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.session,
      builder: (context, _) {
        return Scaffold(
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final horizontalPadding = constraints.maxWidth > 760
                    ? 40.0
                    : 22.0;
                final content = ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1080),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _TopBar(
                        isDarkMode: widget.isDarkMode,
                        onToggleTheme: widget.onToggleTheme,
                      ),
                      const SizedBox(height: 18),
                      if (constraints.maxWidth > 760)
                        _wideLayout(context)
                      else
                        _compactLayout(context),
                    ],
                  ),
                );

                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    8,
                    horizontalPadding,
                    30,
                  ),
                  child: Center(child: content),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _compactLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _heroCard(context, compact: true),
        const SizedBox(height: 24),
        _intro(context),
        const SizedBox(height: 22),
        _nameForm(context),
        const SizedBox(height: 20),
        _startButton(),
        const SizedBox(height: 20),
        _quizDetails(context),
      ],
    );
  }

  Widget _wideLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _intro(context),
                const SizedBox(height: 24),
                _nameForm(context),
                const SizedBox(height: 20),
                _startButton(),
                const SizedBox(height: 24),
                _quizDetails(context),
              ],
            ),
          ),
          const SizedBox(width: 48),
          Expanded(child: _heroCard(context, compact: false)),
        ],
      ),
    );
  }

  Widget _intro(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFE8E5FF),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text(
            'BELAJAR JADI SERU',
            style: TextStyle(
              color: Color(0xFF5144B9),
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Seberapa luas\npengetahuanmu?',
          style: textTheme.headlineMedium?.copyWith(
            fontSize: 34,
            height: 1.12,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Ayo jawab pertanyaan seru, kumpulkan poin, dan buktikan kamu paling tahu!',
          style: textTheme.bodyLarge?.copyWith(
            height: 1.5,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _nameForm(BuildContext context) {
    final hasProgress = widget.session.hasProgress;
    final hasSession = hasProgress || widget.session.isComplete;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hasProgress
                ? 'Kuis kamu sedang berjalan'
                : hasSession
                ? 'Pemain terakhir'
                : 'Siapa nama kamu?',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 9),
          TextFormField(
            key: const Key('player-name-field'),
            controller: _nameController,
            readOnly: hasSession,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _openQuiz(),
            validator: (value) {
              if (hasSession) return null;
              if (value == null || value.trim().isEmpty) {
                return 'Masukkan nama terlebih dahulu.';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Contoh: Naya',
              prefixIcon: const Icon(Icons.person_outline_rounded),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(17),
                borderSide: BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(17),
                borderSide: BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _startButton() {
    final label = widget.session.hasProgress
        ? 'Lanjutkan kuis'
        : widget.session.isComplete
        ? 'Lihat hasil'
        : 'Mulai kuis';

    return PrimaryButton(
      label: label,
      icon: Icons.arrow_forward_rounded,
      onPressed: _openQuiz,
    );
  }

  Widget _quizDetails(BuildContext context) {
    final details = [
      (Icons.help_outline_rounded, '${widget.session.totalQuestions} soal'),
      (Icons.schedule_rounded, '± 3 menit'),
      (Icons.emoji_events_outlined, 'Tunjukkan aksimu'),
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 12,
      children: details
          .map(
            (detail) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(detail.$1, size: 17, color: const Color(0xFF7569D5)),
                const SizedBox(width: 6),
                Text(
                  detail.$2,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _heroCard(BuildContext context, {required bool compact}) {
    return Container(
      padding: EdgeInsets.all(compact ? 18 : 34),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5145B9), Color(0xFF8175E8)],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6658D3).withValues(alpha: 0.2),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: compact
          ? Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Siap untuk\nmulai tantangan?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          height: 1.15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '5 pertanyaan, banyak hal baru!',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.82),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(flex: 4, child: QuizArtwork(compact: true)),
              ],
            )
          : Column(
              children: [
                const QuizArtwork(),
                const SizedBox(height: 8),
                const Text(
                  'Satu kuis kecil, banyak\nhal baru untuk dipelajari.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    height: 1.3,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Main santai, tambah wawasan!',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.isDarkMode, required this.onToggleTheme});

  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFE8E5FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.bolt_rounded,
            color: Color(0xFF5B4FC4),
            size: 27,
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'cerdas yuk!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
        const Spacer(),
        IconButton(
          onPressed: onToggleTheme,
          tooltip: isDarkMode ? 'Gunakan tema terang' : 'Gunakan tema gelap',
          icon: Icon(
            isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          ),
        ),
      ],
    );
  }
}
