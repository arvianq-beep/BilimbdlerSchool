import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bilimdler/Auth/auth_service.dart';

import '../Components/my_button.dart';
import '../Components/my_textfield.dart';
import 'home_page.dart';
import 'edit_profile_page.dart'; // гость пойдёт сюда
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
      final userCred = await AuthService.signIn(email, pass);
      final user = userCred.user;

      if (user != null && !user.emailVerified) {
        await AuthService.signOut();
        setState(() => errorKey = 'verifyYourEmail');
        return;
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      final code = e.code;
      setState(() {
        switch (code) {
          case 'user-not-found':
            errorKey = 'userNotFound';
            break;
          case 'wrong-password':
            errorKey = 'badEmailOrPassword';
            break;
          case 'invalid-email':
            errorKey = 'invalidEmail';
            break;
          case 'too-many-requests':
            errorKey = 'tooManyRequests';
            break;
          case 'invalid-credential':
          case 'INVALID_LOGIN_CREDENTIALS':
          case 'account-exists-with-different-credential':
          case 'operation-not-allowed':
            errorKey = 'badEmailOrPassword';
            break;
          default:
            errorKey = 'badEmailOrPassword';
        }
      });
    } catch (_) {
      setState(() => errorKey = 'badEmailOrPassword');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _resetPassword() async {
    final email = emailController.text.trim();
    final t = AppLocalizations.of(context)!;

    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.pleaseEnterEmail)));
      return;
    }

    setState(() => loading = true);
    try {
      await AuthService.resetPassword(email);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.resetEmailSent(email))));
    } on FirebaseAuthException catch (e) {
      String msg;
      switch (e.code) {
        case 'user-not-found':
          msg = t.userNotFound;
          break;
        case 'invalid-email':
          msg = t.invalidEmail;
          break;
        default:
          msg = t.unknownError;
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.unknownError)));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _resendVerificationEmail() async {
    final t = AppLocalizations.of(context)!;
    setState(() => loading = true);
    try {
      await AuthService.sendEmailVerification();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.verificationEmailResent)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.unknownError)));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> continueAsGuest() async {
    if (loading) return;
    setState(() => loading = true);
    try {
      final localeCode = Localizations.localeOf(
        context,
      ).languageCode; // kk|ru|en
      await AuthService.signInAnonymously(locale: localeCode);

      final profile = await AuthService.getCurrentProfile();
      final guestId = profile?['guestId'] as String?;
      final t = AppLocalizations.of(context)!;

      if (!mounted) return;
      if (guestId != null) {
        // Локализованная подпись из l10n
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t.guestIdDisplay(guestId))));
      }

      // Гостя ведём на экран ввода имени/фамилии
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const EditProfilePage()),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.unknownError)),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
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

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: loading ? null : _resetPassword,
                  child: Text(t.forgotPassword),
                ),
              ),

              const SizedBox(height: 8),

              if (errorKey != null) ...[
                Text(
                  _localizedError(t, errorKey!),
                  style: const TextStyle(color: Colors.red),
                ),
                if (errorKey == 'verifyYourEmail')
                  TextButton(
                    onPressed: loading ? null : _resendVerificationEmail,
                    child: Text(t.resendVerification),
                  ),
              ],

              const SizedBox(height: 12),

              MyButton(
                onTap: () => !loading ? _login() : null,
                text: loading ? '...' : t.signIn,
              ),

              const SizedBox(height: 8),

              OutlinedButton(
                onPressed: loading ? null : continueAsGuest,
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
      case 'invalidEmail':
        return t.invalidEmail;
      case 'tooManyRequests':
        return t.tooManyRequests;
      case 'verifyYourEmail':
        return t.verifyYourEmail;
      case 'badEmailOrPassword':
      case 'wrongPassword':
        return t.badEmailOrPassword;
      default:
        return t.badEmailOrPassword;
    }
  }
}
