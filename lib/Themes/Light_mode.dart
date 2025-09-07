import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.white, // 👈 фон для Scaffold
  colorScheme: const ColorScheme.light(
    background: Colors.white, // фон
    surface: Colors.white, // 👈 тоже фон
    primary: Color(0xFF0A2A52), // тёмно-синий акцент
    secondary: Color(0xFFF4C542), // золотой
    tertiary: Color(0xFFFAFAFA), // карточки/контейнеры
    inversePrimary: Color(0xFF0A2A52), // текст/иконки
  ),
);
