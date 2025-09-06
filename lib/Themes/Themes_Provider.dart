import 'package:flutter/material.dart';
import 'Dark_mode.dart';
import 'Light_mode.dart';

class ThemesProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;
  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData value) {
    _themeData = value;
    notifyListeners();
  }

  void toggleThemes() {
    _themeData = _themeData == lightMode ? darkMode : lightMode;
    notifyListeners();
  }
}
