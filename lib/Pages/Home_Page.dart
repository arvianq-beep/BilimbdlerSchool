import 'package:flutter/material.dart';
import 'package:flutter_bilimdler/Themes/Themes_Provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<ThemesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: appTheme.toggleThemes,
            icon: const Icon(Icons.brightness_6),
          ),
        ],
      ),
      body: const Center(child: Text('Home stub')),
    );
  }
}
