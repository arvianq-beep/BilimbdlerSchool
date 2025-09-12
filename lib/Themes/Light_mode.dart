import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.light(
    background: Colors.white, // светлый фон
    primary: Color(0xFF0A2A52), // тёмно-синий акцент
    secondary: Color(0xFFF4C542), // золотой
    tertiary: Color(0xFFFAFAFA), // карточки/контейнеры
    inversePrimary: Color(0xFF0A2A52), // текст/иконки на белом фоне
  ),
);
