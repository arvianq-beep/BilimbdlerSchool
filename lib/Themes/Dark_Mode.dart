import 'package:flutter/material.dart';

// Тёмная тема — глубокий синий фон, контрастные контейнеры.
ThemeData darkMode = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.dark(
    background: Color(0xFF0A2A52),
    surface: Color(0xFF142F4A),
    surfaceVariant: Color(0xFF163A5F),
    primary: Color(0xFFF4C542),
    primaryContainer: Color(0xFF27486E),
    secondary: Colors.white,
    secondaryContainer: Color(0xFF2A4E7A),
    tertiary: Color(0xFF142F4A),
    inversePrimary: Colors.white,
    outline: Color(0xFF3C5A7A),
  ),
);

