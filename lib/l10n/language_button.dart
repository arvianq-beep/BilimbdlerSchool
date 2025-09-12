import 'package:flutter/material.dart';
import 'package:flutter_bilimdler/l10n/locale_provider.dart';
import 'package:provider/provider.dart';

class LanguageButton extends StatelessWidget {
  const LanguageButton({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    Locale current = localeProvider.locale;

    return DropdownButton<Locale>(
      value: current,
      underline: const SizedBox(),
      icon: const Icon(Icons.language),
      items: const [
        DropdownMenuItem(value: Locale('kk'), child: Text("Қазақша")),
        DropdownMenuItem(value: Locale('ru'), child: Text("Русский")),
        DropdownMenuItem(value: Locale('en'), child: Text("English")),
      ],
      onChanged: (locale) {
        if (locale != null) {
          localeProvider.setLocale(locale); // ✅ переключает язык
        }
      },
    );
  }
}
