import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('kk'); // стартовый язык

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!['en', 'kk', 'ru'].contains(locale.languageCode)) return;
    _locale = locale;
    notifyListeners();
  }
}
