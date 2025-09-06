import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_bilimdler/Themes/Themes_Provider.dart';
import 'package:flutter_bilimdler/l10n/app_localizations.dart';
import 'package:flutter_bilimdler/l10n/language_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<ThemesProvider>();
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.brand),
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: appTheme.toggleThemes,
            icon: const Icon(Icons.brightness_6),
          ),
          const LanguageButton(), // переключатель языка — только тут
        ],
      ),
      body: Center(child: Text(t.brand, style: const TextStyle(fontSize: 20))),
    );
  }
}
