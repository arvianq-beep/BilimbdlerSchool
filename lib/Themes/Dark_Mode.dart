import 'package:flutter/material.dart';

/// Тёмная тема приложения
final ThemeData darkMode = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.dark(
    // Основные цвета
    background: Color(0xFF0A2A52),
    surface: Color(0xFF0A2A52),
    onSurface: Colors.white,

    primary: Color(0xFFF4C542), // жёлтый акцент
    onPrimary: Color(0xFF0A2A52), // тёмно-синий текст на жёлтом фоне

    secondary: Colors.white,
    onSecondary: Color(0xFF0A2A52),

    // Контейнеры для карточек/меню
    primaryContainer: Color(0xFF184567),
    onPrimaryContainer: Colors.white,
    secondaryContainer: Color(0xFF142F4A),
    onSecondaryContainer: Colors.white,

    inversePrimary: Colors.white,
  ),
);
