import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_bilimdler/Components/My_Button.dart';
import 'package:flutter_bilimdler/Components/My_Textfield.dart';
import 'package:flutter_bilimdler/Pages/Home_Page.dart';
import 'package:flutter_bilimdler/l10n/app_localizations.dart';
import 'package:flutter_bilimdler/l10n/language_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool loading = false;
  String? errorText;

  Future<void> _register() async {
    final email = emailController.text.trim();
    final pass = passwordController.text;
    final confirm = confirmController.text;

    if (email.isEmpty || pass.isEmpty || confirm.isEmpty) {
      setState(() => errorText = 'Заполните все поля');
      return;
    }
    if (pass != confirm) {
      setState(() => errorText = 'Пароли не совпадают');
      return;
    }

    setState(() {
      loading = true;
      errorText = null;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
        'AUTH REGISTER ERROR => code=${e.code}, message=${e.message}, full=$e',
      );

      setState(() {
        switch (e.code) {
          case 'email-already-in-use':
            errorText = 'Такой email уже зарегистрирован';
            break;
          case 'invalid-email':
            errorText = 'Некорректный email';
            break;
          case 'weak-password':
            errorText = 'Слишком простой пароль (мин. 6 символов)';
            break;
          case 'operation-not-allowed':
            errorText = 'Метод входа отключён в консоли Firebase';
            break;
          default:
            errorText = 'Ошибка регистрации (${e.code})';
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
    confirmController.dispose();
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
            children: [
              Icon(Icons.public, size: 80, color: cs.inversePrimary),
              const SizedBox(height: 16),
              Text(t.brand, style: TextStyle(color: cs.inversePrimary)),
              const SizedBox(height: 24),

              Text(
                'Зарегистрироваться',
                style: TextStyle(
                  color: cs.inversePrimary,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),

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
                    const SizedBox(height: 10),
                    MyTextfield(
                      controller: confirmController,
                      hintText: 'Повторите пароль',
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
                        if (!loading) _register();
                      },
                      text: loading ? '...' : 'Зарегистрироваться',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Уже есть аккаунт?',
                    style: TextStyle(color: cs.inversePrimary),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      if (!loading && widget.onTap != null) {
                        widget.onTap!();
                      }
                    },
                    child: Text(
                      'Войти',
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
