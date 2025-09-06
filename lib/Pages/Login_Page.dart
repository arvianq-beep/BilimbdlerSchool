import 'package:flutter/material.dart';
import 'package:flutter_bilimdler/Auth/header.dart';
import 'package:flutter_bilimdler/Components/My_Button.dart';
import 'package:flutter_bilimdler/Components/My_Textfield.dart';
import 'package:flutter_bilimdler/Pages/home_page.dart';

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
        actions: const [LanguageButton()],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AuthHeader(title: t.signIn),

              MyTextfield(
                controller: emailController,
                hintText: t.email,
                obscureText: false,
              ),
              const SizedBox(height: 12),
              MyTextfield(
                controller: passwordController,
                hintText: t.password,
                obscureText: true,
              ),
              const SizedBox(height: 20),

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
