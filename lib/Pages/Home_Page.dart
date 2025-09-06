import 'package:flutter/material.dart';
import 'package:flutter_bilimdler/Themes/Themes_Provider.dart';
import 'package:flutter_bilimdler/l10n/app_localizations.dart';
import 'package:flutter_bilimdler/l10n/locale_provider.dart';

import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<ThemesProvider>();
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.appTitle),
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: appTheme.toggleThemes,
            icon: const Icon(Icons.brightness_6),
          ),
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            onSelected: (locale) =>
                context.read<LocaleProvider>().setLocale(locale),
            itemBuilder: (context) => const [
              PopupMenuItem(value: Locale('kk'), child: Text('Қазақша')),
              PopupMenuItem(value: Locale('ru'), child: Text('Русский')),
              PopupMenuItem(value: Locale('en'), child: Text('English')),
            ],
          ),
        ],
      ),
      body: Center(
        child: Text(t.welcome, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
