import 'package:flutter/material.dart';
import 'package:flutter_bilimdler/Auth/Login_or_Register.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_bilimdler/Themes/Themes_Provider.dart';
import 'package:flutter_bilimdler/l10n/app_localizations.dart';
import 'package:flutter_bilimdler/l10n/language_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginOrRegister()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<ThemesProvider>();
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          t.brand,
          style: TextStyle(
            color: cs.inversePrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // 🌙 / ☀️ переключатель темы
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: appTheme.toggleThemes,
            icon: Icon(
              appTheme.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: cs.inversePrimary,
            ),
          ),

          // 🌐 переключатель языка
          const LanguageButton(),

          // 🚪 Logout
          IconButton(
            tooltip: t.signOut,
            onPressed: () => logout(context),
            icon: Icon(Icons.logout, color: cs.inversePrimary),
          ),
        ],
      ),
      body: Center(
        child: Text(
          t.welcome,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: cs.inversePrimary,
          ),
        ),
      ),
    );
  }
}
