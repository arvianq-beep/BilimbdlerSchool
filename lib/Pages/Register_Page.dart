import 'package:flutter/material.dart';
import 'package:flutter_bilimdler/Components/My_Button.dart';
import 'package:flutter_bilimdler/Components/My_Textfield.dart';

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
              Icon(
                Icons.lock_open_outlined,
                size: 80,
                color: cs.inversePrimary,
              ),
              const SizedBox(height: 16),
              Text(
                "Let's create an account for you",
                style: TextStyle(color: cs.inversePrimary),
              ),
              const SizedBox(height: 16),

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
              const SizedBox(height: 10),
              MyTextfield(
                controller: confirmPasswordController,
                hintText: "Confirm password",
                obscureText: true,
              ),
              const SizedBox(height: 14),

              MyButton(
                onTap: () {
                  /* TODO: register */
                },
                text: "Sign Up",
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(color: cs.inversePrimary),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Login now",
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
