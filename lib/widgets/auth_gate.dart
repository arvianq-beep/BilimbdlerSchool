import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Pages/Home_Page.dart';
import '../Pages/login_Page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.hasData) {
          return const HomePage(); // пользователь вошёл
        } else {
          return const LoginPage(); // гость → на логин
        }
      },
    );
  }
}
