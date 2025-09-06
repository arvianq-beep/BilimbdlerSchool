import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Themes/Themes_Provider.dart';
import 'Pages/Splash_Page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemesProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemesProvider>().themeData;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const SplashPage(),
    );
  }
}
