import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.dark(
    background: Color(0xFF0A2A52), // тёмно-синий фон
    primary: Color(0xFFF4C542), // золотой акцент
    secondary: Colors.white, // белые элементы
    tertiary: Color(0xFF142F4A), // чуть светлее для карточек/кнопок
    inversePrimary: Colors.white, // текст на тёмном фоне
  ),
);
