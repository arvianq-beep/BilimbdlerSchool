import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_bilimdler/Components/My_Button.dart';
import 'package:flutter_bilimdler/Components/My_Textfield.dart';
import 'package:flutter_bilimdler/Pages/Home_Page.dart';
import 'package:flutter_bilimdler/l10n/app_localizations.dart';
import 'package:flutter_bilimdler/l10n/language_button.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() => Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const HomePage()),
  );

  void continueAsGuest() => Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const HomePage()),
  );

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [LanguageButton()], // переключатель языка — только тут
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.public, size: 80, color: cs.inversePrimary),
              const SizedBox(height: 16),
              Text(t.brand, style: TextStyle(color: cs.inversePrimary)),
              const SizedBox(height: 24),

              MyTextfield(
                controller: emailController,
                hintText: t.email,
                obscureText: false,
              ),
              const SizedBox(height: 10),
              MyTextfield(
                controller: passwordController,
                hintText: t.password,
                obscureText: true,
              ),
              const SizedBox(height: 14),

              MyButton(onTap: login, text: t.signIn),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: continueAsGuest,
                child: Text(t.continueAsGuest),
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(t.notMember, style: TextStyle(color: cs.inversePrimary)),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      t.registerNow,
                      style: TextStyle(
                        color: cs.inversePrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
