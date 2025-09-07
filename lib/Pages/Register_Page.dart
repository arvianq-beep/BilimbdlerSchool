import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bilimdler/Auth/header.dart';
import 'package:flutter_bilimdler/Components/My_Button.dart';
import 'package:flutter_bilimdler/Components/My_Textfield.dart';
import 'package:flutter_bilimdler/l10n/app_localizations.dart';
import 'package:flutter_bilimdler/l10n/language_button.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool loading = false;
  String? errorKey; // 👈 ключ локализации вместо текста

  Future<void> register() async {
    final email = emailController.text.trim();
    final pass = passwordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    if (email.isEmpty || pass.isEmpty || confirmPass.isEmpty) {
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
      final userCred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass);

      await userCred.user?.sendEmailVerification();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.verificationEmailSent(email),
          ),
        ),
      );

      // 👉 возвращаем на логин
      widget.onTap?.call();
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'weak-password':
            errorKey = 'weakPassword';
            break;
          case 'email-already-in-use':
            errorKey = 'emailInUse';
            break;
          case 'invalid-email':
            errorKey = 'invalidEmail';
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
        padding: const EdgeInsets.all(20),
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      _localizedError(t, errorKey!),
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),

                MyButton(
                  onTap: loading ? null : register,
                  text: loading ? "..." : t.registerNow,
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

  /// Перевод ошибки по ключу
  String _localizedError(AppLocalizations t, String key) {
    switch (key) {
      case 'enterEmailPassword':
        return t.enterEmailPassword;
      case 'passwordsNotMatch':
        return t.passwordsNotMatch;
      case 'weakPassword':
        return t.weakPassword;
      case 'emailInUse':
        return t.emailInUse;
      case 'invalidEmail':
        return t.invalidEmail;
      default:
        return t.unknownError;
    }
  }
}
