import 'package:flutter/material.dart';
import 'package:flutter_bilimdler/Components/My_Button.dart';
import 'package:flutter_bilimdler/Components/My_Textfield.dart';
import 'package:flutter_bilimdler/Pages/home_page.dart';
import 'package:flutter_bilimdler/l10n/app_localizations.dart';
import 'package:flutter_bilimdler/l10n/language_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.onTap});
  final void Function()? onTap;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() => Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const HomePage()),
  );

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
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: LanguageButton(), // 🌐 с иконкой планеты
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: isLandscape
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Левая часть с иконкой и брендом
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            t.brand,
                            style: TextStyle(
                              color: cs.inversePrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                    // Правая часть с формой
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                t.signIn,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: cs.inversePrimary,
                                ),
                              ),
                              const SizedBox(height: 20),
                              MyTextfield(
                                controller: emailController,
                                hintText: t.email,
                                obscureText: false,
                              ),
                              const SizedBox(height: 12),
                              MyTextfield(
                                controller: passwordController,
                                hintText: t.password,
                                obscureText: true,
                              ),
                              const SizedBox(height: 20),
                              MyButton(onTap: login, text: t.signIn),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    t.notMember,
                                    style: TextStyle(color: cs.inversePrimary),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: widget.onTap,
                                    child: Text(
                                      t.registerNow,
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
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.public, size: 80, color: cs.inversePrimary),
                    const SizedBox(height: 16),
                    Text(t.brand, style: TextStyle(color: cs.inversePrimary)),
                    const SizedBox(height: 24),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Column(
                        children: [
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
                          const SizedBox(height: 14),
                          MyButton(onTap: login, text: t.signIn),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          t.notMember,
                          style: TextStyle(color: cs.inversePrimary),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            t.registerNow,
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
