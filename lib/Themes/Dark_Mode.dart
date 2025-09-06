import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    background: const Color(0xFF141414),
    primary: const Color(0xFF7A7A7A),
    secondary: const Color(0xFF1E1E1E),
    tertiary: const Color(0xFF2F2F2F),
    inversePrimary: Colors.grey.shade300,
  ),
);
