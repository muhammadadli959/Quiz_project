import 'package:flutter/material.dart';

import 'models/app_store.dart';
import 'screens/app_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const QuizApp());
}

class QuizApp extends StatefulWidget {
  const QuizApp({super.key});

  @override
  State<QuizApp> createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  late final AppStore _store = AppStore()..addListener(_refresh);
  late final Future<void> _loading = _store.load();

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _store
      ..removeListener(_refresh)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _store,
      builder: (context, _) {
        return MaterialApp(
          title: 'Cerdas Yuk!',
          debugShowCheckedModeBanner: false,
          themeMode: _store.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: _buildTheme(Brightness.light),
          darkTheme: _buildTheme(Brightness.dark),
          home: _store.isLoaded
              ? AppShell(store: _store)
              : FutureBuilder<void>(
                  future: _loading,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return _StartupError(error: snapshot.error!);
                    }
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
        );
      },
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6658D3),
      brightness: brightness,
      surface: isDark ? const Color(0xFF1B1D29) : Colors.white,
    );
    final textTheme = ThemeData(
      brightness: brightness,
      fontFamily: 'Nunito',
    ).textTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF12131B)
          : const Color(0xFFF7F7FC),
      fontFamily: 'Nunito',
      textTheme: textTheme.apply(
        bodyColor: isDark ? const Color(0xFFF3F2FA) : const Color(0xFF24233A),
        displayColor: isDark
            ? const Color(0xFFF3F2FA)
            : const Color(0xFF24233A),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}

class _StartupError extends StatelessWidget {
  const _StartupError({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, size: 44),
              const SizedBox(height: 12),
              const Text(
                'Data lokal tidak dapat dimuat.',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              SelectableText('$error', textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
