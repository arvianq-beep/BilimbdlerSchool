import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFF0A2A52), // 👈 фон для Scaffold
  colorScheme: const ColorScheme.dark(
    background: Color(0xFF0A2A52), // фон
    surface: Color(0xFF0A2A52), // 👈 тоже фон
    primary: Color(0xFFF4C542), // золотой акцент
    secondary: Colors.white, // белые элементы
    tertiary: Color(0xFF142F4A), // карточки/контейнеры
    inversePrimary: Colors.white, // текст/иконки
  ),
);
