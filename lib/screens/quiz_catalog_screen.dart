import 'package:flutter/material.dart';

import '../data/quiz_questions.dart';
import '../models/quiz_pack.dart';
import '../models/quiz_session.dart';
import '../widgets/quiz_catalog_card.dart';
import 'quiz_screen.dart';

class QuizCatalogScreen extends StatefulWidget {
  const QuizCatalogScreen({
    super.key,
    required this.session,
    required this.playerName,
  });

  final QuizSession session;
  final String playerName;

  @override
  State<QuizCatalogScreen> createState() => _QuizCatalogScreenState();
}

class _QuizCatalogScreenState extends State<QuizCatalogScreen> {
  final _searchController = TextEditingController();
  QuizCategory? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<QuizPack> get _visibleQuizzes {
    final search = _searchController.text.trim().toLowerCase();
    return quizCatalog.where((quiz) {
      final matchesCategory =
          _selectedCategory == null || quiz.category == _selectedCategory;
      final matchesSearch =
          search.isEmpty ||
          quiz.title.toLowerCase().contains(search) ||
          quiz.description.toLowerCase().contains(search) ||
          quiz.category.title.toLowerCase().contains(search);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  Future<void> _openQuiz(QuizPack quiz) async {
    final hasDifferentQuizInProgress =
        widget.session.hasProgress && widget.session.quiz.title != quiz.title;
    if (hasDifferentQuizInProgress) {
      final shouldReplace = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Mulai kuis baru?'),
          content: Text(
            'Progres "${widget.session.quiz.title}" akan digantikan. '
            'Kamu bisa melanjutkannya jika memilih kuis yang sama.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Mulai kuis baru'),
            ),
          ],
        ),
      );
      if (shouldReplace != true || !mounted) return;
    }

    if (!widget.session.hasProgress ||
        widget.session.quiz.title != quiz.title) {
      widget.session.start(widget.playerName, quiz: quiz);
    }
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => QuizScreen(session: widget.session),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Kembali',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text(
          'Jelajahi kuis',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth > 760 ? 40.0 : 20.0;
            final contentWidth = constraints.maxWidth - horizontalPadding * 2;
            final columns = contentWidth > 820
                ? 3
                : contentWidth > 510
                ? 2
                : 1;
            final cardWidth = (contentWidth - (columns - 1) * 14) / columns;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                14,
                horizontalPadding,
                30,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1080),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _CatalogHeading(totalQuizzes: quizCatalog.length),
                      const SizedBox(height: 18),
                      TextField(
                        key: const Key('quiz-search-field'),
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: 'Cari nama kuis...',
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: _searchController.text.isEmpty
                              ? null
                              : IconButton(
                                  tooltip: 'Hapus pencarian',
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.close_rounded),
                                ),
                          filled: true,
                          fillColor: theme.colorScheme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        'Pilih kategori',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 11),
                      Wrap(
                        spacing: 9,
                        runSpacing: 9,
                        children: [
                          _CategoryFilter(
                            label: 'Semua',
                            count: quizCatalog.length,
                            icon: Icons.grid_view_rounded,
                            color: theme.colorScheme.primary,
                            selected: _selectedCategory == null,
                            onTap: () =>
                                setState(() => _selectedCategory = null),
                          ),
                          for (final category in QuizCategory.values)
                            _CategoryFilter(
                              label: category.title,
                              count: quizCatalog
                                  .where((quiz) => quiz.category == category)
                                  .length,
                              icon: category.icon,
                              color: category.color,
                              selected: _selectedCategory == category,
                              onTap: () => setState(
                                () => _selectedCategory =
                                    _selectedCategory == category
                                    ? null
                                    : category,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedCategory?.title ?? 'Semua kuis',
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          Text(
                            '${_visibleQuizzes.length} kuis',
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 13),
                      if (_visibleQuizzes.isEmpty)
                        const _EmptySearchResults()
                      else
                        Wrap(
                          spacing: 14,
                          runSpacing: 14,
                          children: [
                            for (final quiz in _visibleQuizzes)
                              SizedBox(
                                width: cardWidth,
                                child: QuizCatalogCard(
                                  quiz: quiz,
                                  onTap: () => _openQuiz(quiz),
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
  }
}

class _CatalogHeading extends StatelessWidget {
  const _CatalogHeading({required this.totalQuizzes});

  final int totalQuizzes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5145B9), Color(0xFF8175E8)],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ada yang ingin kamu pelajari?',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$totalQuizzes kuis siap menemani rasa ingin tahumu.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.86),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(
            Icons.auto_awesome_rounded,
            color: Color(0xFFFFD76D),
            size: 38,
          ),
        ],
      ),
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      avatar: Icon(icon, size: 17, color: selected ? Colors.white : color),
      label: Text('$label  $count'),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => onTap(),
      labelStyle: TextStyle(
        color: selected
            ? Colors.white
            : Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.w800,
      ),
      selectedColor: color,
      backgroundColor: Theme.of(context).colorScheme.surface,
      side: BorderSide(
        color: selected ? color : Theme.of(context).dividerColor,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }
}

class _EmptySearchResults extends StatelessWidget {
  const _EmptySearchResults();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 46),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          const Text(
            'Kuis tidak ditemukan',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Coba kata kunci atau kategori yang berbeda.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
