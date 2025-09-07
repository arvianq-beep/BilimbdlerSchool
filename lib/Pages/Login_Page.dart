import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_bilimdler/Components/My_Button.dart';
import 'package:flutter_bilimdler/Components/My_Textfield.dart';
import 'package:flutter_bilimdler/Pages/Home_Page.dart';
import 'package:flutter_bilimdler/l10n/app_localizations.dart';
import 'package:flutter_bilimdler/l10n/language_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;
  String? errorText;

  Future<void> _login() async {
    final email = emailController.text.trim();
    final pass = passwordController.text;

    if (email.isEmpty || pass.isEmpty) {
      setState(() => errorText = 'Введите email и пароль');
      return;
    }

    setState(() {
      loading = true;
      errorText = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      debugPrint(
        'AUTH LOGIN ERROR => code=${e.code}, message=${e.message}, full=$e',
      );

      setState(() {
        switch (e.code) {
          case 'user-not-found':
            errorText = 'Пользователь не найден';
            break;
          case 'wrong-password':
            errorText = 'Неверный пароль';
            break;
          case 'invalid-email':
            errorText = 'Некорректный email';
            break;
          case 'too-many-requests':
            errorText = 'Слишком много попыток. Попробуйте позже';
            break;
          default:
            errorText = 'Ошибка входа (${e.code})';
        }
      });
    } catch (e) {
      setState(() => errorText = 'Неизвестная ошибка: ${e.toString()}');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

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
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          Padding(padding: EdgeInsets.only(right: 12), child: LanguageButton()),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.public, size: 80, color: cs.inversePrimary),
              const SizedBox(height: 16),
              Text(t.brand, style: TextStyle(color: cs.inversePrimary)),
              const SizedBox(height: 24),

              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  children: [
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
                    const SizedBox(height: 12),

                    if (errorText != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          errorText!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    MyButton(
                      onTap: () {
                        if (!loading) _login();
                      },
                      text: loading ? '...' : t.signIn,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(t.notMember, style: TextStyle(color: cs.inversePrimary)),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      if (!loading && widget.onTap != null) {
                        widget.onTap!();
                      }
                    },
                    child: Text(
                      t.registerNow,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: cs.inversePrimary,
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
