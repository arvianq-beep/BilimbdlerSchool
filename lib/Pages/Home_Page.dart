// lib/home_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Экран после успешного входа.
/// В MaterialApp должен быть маршрут '/login'.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _dark = false;

  Future<void> _logout() async {
    // диалог подтверждения
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Выйти из аккаунта?'),
        content: const Text(
          'Вы будете разлогинены и вернётесь на экран входа.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      // очищаем стек и уходим на экран логина
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Не удалось выйти: $e')));
    }
  }

  void _toggleTheme() => setState(() => _dark = !_dark);

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      brightness: _dark ? Brightness.dark : Brightness.light,
      colorSchemeSeed: const Color(0xFF0D2D52),
      useMaterial3: true,
    );

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          leading: null, // убираем стрелку "назад"
          automaticallyImplyLeading: false, // запрещаем автопоявление
          title: const Text('ГЕО 2026 · БИЛИМ «ДЛЕР»'),
          actions: [
            IconButton(
              tooltip: _dark ? 'Светлая тема' : 'Тёмная тема',
              icon: const Icon(Icons.bedtime),
              onPressed: _toggleTheme,
            ),
            IconButton(
              tooltip: 'Выйти',
              icon: const Icon(Icons.logout),
              onPressed: _logout,
            ),
          ],
        ),
        body: const Center(
          child: Text(
            'Добро пожаловать!',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
