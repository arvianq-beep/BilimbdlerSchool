import 'package:flutter/material.dart';
import 'package:flutter_bilimdler/Components/My_Button.dart';
import 'package:flutter_bilimdler/Components/My_Textfield.dart';
import 'package:flutter_bilimdler/Pages/Home_Page.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
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
    return Scaffold(
      backgroundColor: cs.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.public, size: 80, color: cs.inversePrimary),
              const SizedBox(height: 16),
              Text(
                'GEO 2026 · BILIM"D"LER',
                style: TextStyle(color: cs.inversePrimary),
              ),
              const SizedBox(height: 24),

              MyTextfield(
                controller: emailController,
                hintText: "Email",
                obscureText: false,
              ),
              const SizedBox(height: 10),
              MyTextfield(
                controller: passwordController,
                hintText: "Password",
                obscureText: true,
              ),
              const SizedBox(height: 14),

              MyButton(onTap: login, text: "Sign In"),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: continueAsGuest,
                child: const Text("Continue as guest"),
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member?",
                    style: TextStyle(color: cs.inversePrimary),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Register now",
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
