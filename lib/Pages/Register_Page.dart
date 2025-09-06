import 'package:flutter/material.dart';
import 'package:flutter_bilimdler/Components/My_Button.dart';
import 'package:flutter_bilimdler/Components/My_Textfield.dart';
import 'package:flutter_bilimdler/l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void register() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Registered: ${emailController.text}")),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
        title: Text(t.registerNow, style: TextStyle(color: cs.inversePrimary)),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                t.registerNow,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: cs.inversePrimary,
                ),
              ),
              const SizedBox(height: 24),

              // Горизонтальная форма
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: MyTextfield(
                      controller: emailController,
                      hintText: t.email,
                      obscureText: false,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: MyTextfield(
                      controller: passwordController,
                      hintText: t.password,
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: MyButton(onTap: register, text: t.registerNow),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    t.alreadyMember,
                    style: TextStyle(color: cs.inversePrimary),
                  ),
                  const SizedBox(width: 8),
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
    );
  }
}
