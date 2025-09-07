import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_bilimdler/Auth/auth_service.dart'; // ⬅️ используем сервис
import 'package:flutter_bilimdler/Auth/header.dart';
import 'package:flutter_bilimdler/Components/My_Button.dart';
import 'package:flutter_bilimdler/Components/My_Textfield.dart';
import 'package:flutter_bilimdler/l10n/app_localizations.dart';
import 'package:flutter_bilimdler/l10n/language_button.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback?
  onTap; // можно передавать переключатель из Login_or_Register
  const RegisterPage({super.key, this.onTap});

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
    final pass = passwordController.text;
    final confirmPass = confirmPasswordController.text;

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
      // Создаём аккаунт и документ в Firestore через сервис
      await AuthService.signUp(email, pass);

      // Отправляем письмо подтверждения
      await AuthService.sendEmailVerification();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('На почту отправлено письмо для подтверждения.'),
        ),
      );

      // Выходим из аккаунта до подтверждения
      await AuthService.signOut();

      // Возврат к логину:
      // 1) если страница открыта через Login_or_Register — дергаем переключатель
      // 2) иначе — просто закрываем текущую страницу
      if (widget.onTap != null) {
        widget.onTap!();
      } else if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
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
          case 'operation-not-allowed':
            // Например, если в консоли Firebase выключен Email/Password
            errorKey = 'operationNotAllowed';
            break;
          default:
            errorKey = 'unknownError';
        }
      });
    } catch (_) {
      setState(() => errorKey = 'unknownError');
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

                // ВАЖНО: всегда передаём не-null функцию, чтобы не было ошибок типов
                MyButton(
                  onTap: () {
                    if (!loading) register();
                  },
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
                      onTap: widget
                          .onTap, // переключатель из обёртки Login_or_Register
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
        return 'Пароли не совпадают!';
      case 'emailAlreadyInUse':
        return 'Такой e-mail уже зарегистрирован';
      case 'weakPassword':
        return 'Слишком слабый пароль';
      case 'invalidEmail':
        return t.invalidEmail;
      case 'operationNotAllowed':
        return 'Email/Password выключен в Firebase Console (Authentication → Sign-in method).';
      default:
        return t.unknownError;
    }
  }
}
