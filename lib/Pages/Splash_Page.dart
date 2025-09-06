import 'package:flutter/material.dart';
import 'package:flutter_bilimdler/l10n/app_localizations.dart';

import 'package:provider/provider.dart';

import '../Auth/Login_or_Register.dart';
import '../l10n/locale_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _languageSelected = false;

  void _goNextPage() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginOrRegister()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final localeProvider = context.read<LocaleProvider>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF101012), Color(0xFF0F1A24)],
            begin: Alignment.topCenter,

            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // логотип
              Image.asset('lib/Images/Bilimdler.png'),
              const SizedBox(height: 20),

              // приветствие
              Text(
                t.welcome,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 40),

              // выбор языка
              if (!_languageSelected)
                Column(
                  children: [
                    const Text(
                      "Choose language / Тілді таңдаңыз / Выберите язык",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            localeProvider.setLocale(const Locale('kk'));
                            setState(() => _languageSelected = true);
                            _goNextPage();
                          },
                          child: const Text("Қазақша"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            localeProvider.setLocale(const Locale('ru'));
                            setState(() => _languageSelected = true);
                            _goNextPage();
                          },
                          child: const Text("Русский"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            localeProvider.setLocale(const Locale('en'));
                            setState(() => _languageSelected = true);
                            _goNextPage();
                          },
                          child: const Text("English"),
                        ),
                      ],
                    ),
                  ],
                )
              else
                const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
