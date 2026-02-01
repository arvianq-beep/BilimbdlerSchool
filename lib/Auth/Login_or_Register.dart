import 'package:flutter/material.dart';
import '../Pages/login_page.dart';
import '../Pages/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLogin = true;
  void _toggle() => setState(() => showLogin = !showLogin);

  @override
  Widget build(BuildContext context) {
    return showLogin
        ? LoginPage(onTap: _toggle) // ← передаём onTap
        : RegisterPage(onTap: _toggle); // ← и сюда тоже
  }
}
