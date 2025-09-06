import 'package:flutter/material.dart';
import 'package:flutter_bilimdler/Auth/Login_or_Register.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginOrRegister()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // адаптивный размер логотипа
    final screenW = MediaQuery.of(context).size.width;
    final double logoSize = screenW * 0.5; // 50% ширины экрана
    final double clampedSize = logoSize.clamp(140.0, 220.0); // пределы 140..220

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF101012), Color(0xFF0F1A24)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // круглый логотип, изображение вписано без обрезки
                Container(
                  width: clampedSize,
                  height: clampedSize,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24, width: 2),
                    boxShadow: const [
                      BoxShadow(blurRadius: 16, color: Colors.black26),
                    ],
                  ),
                  child: Image.asset(
                    'lib/images/Bilimdler.png',
                    fit: BoxFit
                        .contain, // ничего не режем, вписываем внутрь круга
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Қош келдіңіз!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
