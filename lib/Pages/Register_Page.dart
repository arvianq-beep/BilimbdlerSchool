import 'package:flutter/material.dart';
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

  void register() {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Пароли не совпадают!")));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Registered: ${emailController.text}")),
    );
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
          alignment: Alignment.topCenter, // 👈 форма прижата к верху
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 🔹 Заголовок сверху
                AuthHeader(title: t.registerNow),

                // 🔹 Сразу поля формы
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

                MyButton(onTap: register, text: t.registerNow),
                const SizedBox(height: 16),

                // 🔹 Внизу переключатель
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

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
