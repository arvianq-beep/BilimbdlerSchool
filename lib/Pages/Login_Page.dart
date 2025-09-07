import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Components/my_button.dart';
import '../Components/my_textfield.dart';
import 'home_page.dart';
import '../l10n/app_localizations.dart';
import '../l10n/language_button.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;
  String? errorKey;

  Future<void> _login() async {
    final email = emailController.text.trim();
    final pass = passwordController.text;

    if (email.isEmpty || pass.isEmpty) {
      setState(() => errorKey = 'enterEmailPassword');
      return;
    }

    setState(() {
      loading = true;
      errorKey = null;
    });

    try {
      final userCred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );

      final user = userCred.user;

      if (user != null && !user.emailVerified) {
        await FirebaseAuth.instance.signOut();
        setState(() => errorKey = 'verifyYourEmail');
        return;
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'user-not-found':
            errorKey = 'userNotFound';
            break;
          case 'wrong-password':
            errorKey = 'wrongPassword';
            break;
          case 'invalid-email':
            errorKey = 'invalidEmail';
            break;
          case 'too-many-requests':
            errorKey = 'tooManyRequests';
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

  void continueAsGuest() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
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
              if (errorKey != null)
                Text(
                  _localizedError(t, errorKey!),
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 12),
              MyButton(
                onTap: () => !loading ? _login() : null,
                text: loading ? '...' : t.signIn,
              ),
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

  String _localizedError(AppLocalizations t, String key) {
    switch (key) {
      case 'enterEmailPassword':
        return t.enterEmailPassword;
      case 'userNotFound':
        return t.userNotFound;
      case 'wrongPassword':
        return t.wrongPassword;
      case 'invalidEmail':
        return t.invalidEmail;
      case 'tooManyRequests':
        return t.tooManyRequests;
      case 'verifyYourEmail':
        return t.verifyYourEmail;
      default:
        return t.unknownError;
    }
  }
}
