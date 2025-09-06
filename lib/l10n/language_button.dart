import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'locale_provider.dart';

class LanguageButton extends StatelessWidget {
  const LanguageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      onSelected: (locale) => context.read<LocaleProvider>().setLocale(locale),
      itemBuilder: (_) => const [
        PopupMenuItem(value: Locale('kk'), child: Text('Қазақша')),
        PopupMenuItem(value: Locale('ru'), child: Text('Русский')),
        PopupMenuItem(value: Locale('en'), child: Text('English')),
      ],
    );
  }
}
