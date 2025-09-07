import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_bilimdler/Auth/header.dart';
import 'package:flutter_bilimdler/Components/My_Button.dart';
import 'package:flutter_bilimdler/Components/My_Textfield.dart';
import 'package:flutter_bilimdler/l10n/app_localizations.dart';
import 'package:flutter_bilimdler/l10n/language_button.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool loading = false;
  String? errorKey;

  Future<void> register() async {
    final email = emailController.text.trim();
    final pass = passwordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      setState(() => errorKey = 'enterEmailPassword');
      return;
    }
    if (pass != confirmPass) {
      setState(() => errorKey = 'passwordsNotMatch');
      return;
    }

    setState(() {
      loading = true;
      errorKey = null;
    });

    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      await cred.user?.sendEmailVerification();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("На почту отправлено письмо для подтверждения."),
        ),
      );

      await FirebaseAuth.instance.signOut();
      widget.onTap?.call();
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'email-already-in-use':
            errorKey = 'emailAlreadyInUse';
            break;
          case 'invalid-email':
            errorKey = 'invalidEmail';
            break;
          case 'weak-password':
            errorKey = 'weakPassword';
            break;
          default:
            errorKey = 'unknownError';
        }
      });
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
        actions: const [
          Padding(padding: EdgeInsets.only(right: 12), child: LanguageButton()),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthHeader(title: t.registerNow),

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
                  controller: confirmPasswordController,
                  hintText: t.confirmPassword,
                  obscureText: true,
                ),
                const SizedBox(height: 16),

                if (errorKey != null)
                  Text(
                    _localizedError(t, errorKey!),
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 12),

                // ✅ onTap теперь async — ошибок не будет
                MyButton(
                  onTap: !loading ? () async => await register() : null,
                  text: loading ? '...' : t.registerNow,
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      t.alreadyMember,
                      style: TextStyle(color: cs.inversePrimary),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        t.loginNow,
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
      ),
    );
  }

  String _localizedError(AppLocalizations t, String key) {
    switch (key) {
      case 'enterEmailPassword':
        return t.enterEmailPassword;
      case 'passwordsNotMatch':
        return "Пароли не совпадают!";
      case 'emailAlreadyInUse':
        return "Такой e-mail уже зарегистрирован";
      case 'weakPassword':
        return "Слишком слабый пароль";
      case 'invalidEmail':
        return t.invalidEmail;
      default:
        return t.unknownError;
    }
  }
}
