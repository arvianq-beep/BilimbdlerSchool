import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.dark(
    // Base palette aligned with GeographyPage
    background: Color(0xFF0A2A52),
    surface: Color(0xFF0A2A52),
    onSurface: Colors.white,

    primary: Color(0xFFF4C542), // yellow accent
    onPrimary: Color(0xFF0A2A52), // dark-blue text on yellow

    secondary: Colors.white,
    onSecondary: Color(0xFF0A2A52),

    // Containers used by menu tiles and map fill
    primaryContainer: Color(0xFF184567),
    onPrimaryContainer: Colors.white,
    secondaryContainer: Color(0xFF142F4A),
    onSecondaryContainer: Colors.white,

    inversePrimary: Colors.white,
  ),
);

