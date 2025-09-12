import 'package:flutter/material.dart';

class LanguageButton extends StatelessWidget {
  final bool showIcon; // 👈 параметр для включения/выключения иконки
  const LanguageButton({super.key, this.showIcon = true});

  @override
  Widget build(BuildContext context) {
    Locale current = Localizations.localeOf(context);

    return DropdownButton<Locale>(
      value: current,
      underline: const SizedBox(),
      icon: showIcon ? const Icon(Icons.language) : const SizedBox.shrink(),
      items: const [
        DropdownMenuItem(value: Locale('kk'), child: Text("Қазақша")),
        DropdownMenuItem(value: Locale('ru'), child: Text("Русский")),
        DropdownMenuItem(value: Locale('en'), child: Text("English")),
      ],
      onChanged: (locale) {
        if (locale != null) {
          // ⚡ здесь вызови метод для смены языка
          // например через Provider или свой LocaleNotifier
        }
      },
    );
  }
}
