import 'package:flutter/material.dart';

import '../models/app_store.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.store});

  final AppStore store;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nameController = TextEditingController(
    text: widget.store.playerName,
  );
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveName() async {
    if (_isSaving || _nameController.text.trim().isEmpty) return;
    setState(() => _isSaving = true);
    try {
      await widget.store.setPlayerName(_nameController.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama pemain berhasil disimpan.')),
      );
    } on Exception catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nama tidak dapat disimpan: $error')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _toggleTheme() async {
    try {
      await widget.store.toggleTheme();
    } on Exception catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preferensi tema tidak dapat disimpan: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Profil',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          body: SafeArea(
            top: false,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  padding: const EdgeInsets.all(21),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5145B9), Color(0xFF8175E8)],
                    ),
                    borderRadius: BorderRadius.circular(23),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.white24,
                        child: Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 34,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.store.playerName.isEmpty
                                  ? 'Pemain Cerdas Yuk!'
                                  : widget.store.playerName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              '${widget.store.totalPlayed} kuis selesai · skor terbaik ${widget.store.bestScore}%',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Informasi pemain',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                TextField(
                  key: const Key('profile-name-field'),
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Nama panggilan',
                    prefixIcon: const Icon(Icons.badge_outlined),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 9),
                FilledButton.icon(
                  onPressed: _isSaving || _nameController.text.trim().isEmpty
                      ? null
                      : _saveName,
                  icon: const Icon(Icons.save_rounded),
                  label: Text(_isSaving ? 'Menyimpan...' : 'Simpan nama'),
                ),
                const SizedBox(height: 23),
                const Text(
                  'Preferensi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                Card(
                  child: SwitchListTile(
                    secondary: Icon(
                      widget.store.isDarkMode
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                    ),
                    title: const Text('Tema gelap'),
                    subtitle: const Text(
                      'Tampilan nyaman untuk kondisi redup.',
                    ),
                    value: widget.store.isDarkMode,
                    onChanged: (_) => _toggleTheme(),
                  ),
                ),
                const SizedBox(height: 20),
                const AboutListTile(
                  icon: Icon(Icons.info_outline_rounded),
                  applicationName: 'Cerdas Yuk!',
                  applicationVersion: '1.0.0',
                  applicationLegalese: 'Belajar seru, kapan saja.',
                  child: Text('Tentang aplikasi'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
