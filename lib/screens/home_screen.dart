import 'package:flutter/material.dart';

import '../models/app_store.dart';
import '../models/quiz_pack.dart';
import '../screens/quiz_detail_screen.dart';
import '../screens/quiz_screen.dart';
import '../screens/result_screen.dart';
import '../widgets/quiz_artwork.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.store,
    required this.onExplore,
    required this.onMyQuizzes,
    required this.onActivity,
  });

  final AppStore store;
  final VoidCallback onExplore;
  final VoidCallback onMyQuizzes;
  final VoidCallback onActivity;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.store.playerName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _openQuiz(QuizPack quiz) async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showMessage('Isi nama di profil sebelum memulai kuis.');
      return;
    }
    if (!await _savePlayerName(name) || !mounted) return;

    final session = widget.store.session;
    if (session.hasProgress && session.quiz.id != quiz.id) {
      final replace = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ganti kuis yang sedang berjalan?'),
          content: Text(
            'Progres "${session.quiz.title}" akan diganti dengan kuis baru.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Lanjutkan kuis lama'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Mulai kuis baru'),
            ),
          ],
        ),
      );
      if (replace != true || !mounted) return;
    }

    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => QuizDetailScreen(
          store: widget.store,
          quiz: quiz,
          replaceExistingProgress:
              session.hasProgress && session.quiz.id != quiz.id,
        ),
      ),
    );
  }

  void _continueQuiz() {
    final session = widget.store.session;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => session.isComplete
            ? ResultScreen(session: session)
            : QuizScreen(session: session),
      ),
    );
  }

  Future<void> _browseQuizzes() async {
    final name = _nameController.text.trim();
    if (name.isNotEmpty && !await _savePlayerName(name)) return;
    if (mounted) widget.onExplore();
  }

  Future<bool> _savePlayerName(String name) async {
    try {
      await widget.store.setPlayerName(name);
      return true;
    } on Exception catch (error) {
      if (mounted) _showMessage('Nama tidak dapat disimpan: $error');
      return false;
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) {
        return Scaffold(
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final horizontalPadding = constraints.maxWidth > 760
                    ? 38.0
                    : 20.0;
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
                          _HomeHeader(
                            name: widget.store.playerName,
                            isDarkMode: widget.store.isDarkMode,
                            onToggleTheme: widget.store.toggleTheme,
                          ),
                          const SizedBox(height: 18),
                          if (constraints.maxWidth > 760)
                            _wideContent(context)
                          else
                            _compactContent(context),
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

  Widget _compactContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _hero(context, compact: true),
        const SizedBox(height: 20),
        _welcome(context),
        const SizedBox(height: 18),
        _continueCard(context),
        const SizedBox(height: 18),
        _quickStats(context),
        const SizedBox(height: 24),
        _sectionHeading(
          context,
          title: 'Mulai dari sini',
          action: 'Lihat semua',
          onAction: _browseQuizzes,
        ),
        const SizedBox(height: 12),
        _featuredQuizzes(context),
        const SizedBox(height: 18),
        _studyCard(context),
      ],
    );
  }

  Widget _wideContent(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _welcome(context),
                  const SizedBox(height: 22),
                  _continueCard(context),
                ],
              ),
            ),
            const SizedBox(width: 28),
            Expanded(child: _hero(context, compact: false)),
          ],
        ),
        const SizedBox(height: 20),
        _quickStats(context),
        const SizedBox(height: 28),
        _sectionHeading(
          context,
          title: 'Mulai dari sini',
          action: 'Lihat semua',
          onAction: _browseQuizzes,
        ),
        const SizedBox(height: 12),
        _featuredQuizzes(context),
        const SizedBox(height: 18),
        _studyCard(context),
      ],
    );
  }

  Widget _welcome(BuildContext context) {
    final isKnown = widget.store.playerName.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xFFE8E5FF),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text(
            'BELAJAR, BERMAIN, BERTUMBUH',
            style: TextStyle(
              color: Color(0xFF5144B9),
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.9,
            ),
          ),
        ),
        const SizedBox(height: 13),
        Text(
          isKnown
              ? 'Senang melihatmu,\n${widget.store.playerName}!'
              : 'Seberapa luas\npengetahuanmu?',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 32,
            height: 1.12,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Pilih kuis, ikuti rasa ingin tahu, dan temukan hal baru hari ini.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            height: 1.45,
          ),
        ),
        if (!isKnown) ...[
          const SizedBox(height: 16),
          TextField(
            key: const Key('player-name-field'),
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'Namamu',
              prefixIcon: const Icon(Icons.person_outline_rounded),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            onSubmitted: (value) {
              _savePlayerName(value);
            },
          ),
        ],
      ],
    );
  }

  Widget _hero(BuildContext context, {required bool compact}) {
    return Container(
      padding: EdgeInsets.all(compact ? 16 : 28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5145B9), Color(0xFF8175E8)],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(27),
      ),
      child: compact
          ? Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Satu kuis kecil,\nbanyak hal baru!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          height: 1.2,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        '${widget.store.allQuizzes.length} kuis menantimu',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const SizedBox(width: 112, child: QuizArtwork(compact: true)),
              ],
            )
          : const Column(
              children: [
                QuizArtwork(),
                Text(
                  'Rasa ingin tahu adalah awal dari belajar.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _continueCard(BuildContext context) {
    final session = widget.store.session;
    if (!session.hasProgress && !session.isComplete) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: const Color(0xFFE8E5FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.explore_rounded,
                color: Color(0xFF6658D3),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Siap mencoba?',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: 3),
                  Text('Temukan kuis yang cocok buatmu.'),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Jelajahi kuis',
              onPressed: _browseQuizzes,
              icon: const Icon(Icons.arrow_forward_rounded),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFE9E6FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.play_circle_fill_rounded,
            color: Color(0xFF6658D3),
            size: 38,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.isComplete
                      ? 'Kuis terakhir selesai'
                      : 'Lanjutkan kuis',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                Text(
                  '${session.quiz.title} · ${session.score}/${session.totalQuestions} benar',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          FilledButton.tonal(
            onPressed: _continueQuiz,
            child: Text(session.isComplete ? 'Hasil' : 'Lanjut'),
          ),
        ],
      ),
    );
  }

  Widget _quickStats(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.quiz_outlined,
            label: 'Dimainkan',
            value: '${widget.store.totalPlayed}',
            color: const Color(0xFF6658D3),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.workspace_premium_outlined,
            label: 'Skor terbaik',
            value: '${widget.store.bestScore}%',
            color: const Color(0xFFE69B34),
          ),
        ),
      ],
    );
  }

  Widget _sectionHeading(
    BuildContext context, {
    required String title,
    required String action,
    required VoidCallback onAction,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
          ),
        ),
        TextButton(onPressed: onAction, child: Text(action)),
      ],
    );
  }

  Widget _featuredQuizzes(BuildContext context) {
    final featured = widget.store.allQuizzes.take(3).toList();
    final width = MediaQuery.sizeOf(context).width;
    final columns = width > 800
        ? 3
        : width > 540
        ? 2
        : 1;
    final cardWidth = (width - 40 - 12 * (columns - 1)) / columns;
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final quiz in featured)
          SizedBox(
            width: cardWidth,
            child: _FeaturedQuizCard(quiz: quiz, onTap: () => _openQuiz(quiz)),
          ),
      ],
    );
  }

  Widget _studyCard(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: widget.onMyQuizzes,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              const Icon(
                Icons.edit_note_rounded,
                color: Color(0xFFCE5B8C),
                size: 30,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Belajar dengan caramu',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    Text('Buat kuis dari catatan pelajaranmu.'),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.name,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  final String name;
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
        if (name.isNotEmpty)
          Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
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

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedQuizCard extends StatelessWidget {
  const _FeaturedQuizCard({required this.quiz, required this.onTap});

  final QuizPack quiz;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: quiz.category.color.withValues(alpha: 0.12),
                child: Icon(quiz.icon, color: quiz.category.color),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quiz.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    Text(
                      '${quiz.questions.length} soal · ${quiz.category.title}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 15),
            ],
          ),
        ),
      ),
    );
  }
}
