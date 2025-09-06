import 'package:flutter/material.dart';
import '../Auth/Login_or_Register.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _logoC;
  late final AnimationController _l1C;
  late final AnimationController _l2C;
  late final AnimationController _l3C;

  @override
  void initState() {
    super.initState();

    _logoC = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _l1C = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _l2C = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _l3C = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // запускаем последовательно
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) _l1C.forward();
    });
    _l1C.addStatusListener((s) {
      if (s == AnimationStatus.completed) _l2C.forward();
    });
    _l2C.addStatusListener((s) {
      if (s == AnimationStatus.completed) _l3C.forward();
    });
    _l3C.addStatusListener((s) async {
      if (s == AnimationStatus.completed && mounted) {
        await Future.delayed(const Duration(milliseconds: 400));
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginOrRegister()),
        );
      }
    });
  }

  @override
  void dispose() {
    _logoC.dispose();
    _l1C.dispose();
    _l2C.dispose();
    _l3C.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1A24),
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
            // всё по центру
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // логотип: fade + лёгкий scale
                FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _logoC,
                    curve: Curves.easeOut,
                  ),
                  child: ScaleTransition(
                    scale: Tween(begin: 0.92, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _logoC,
                        curve: Curves.easeOutBack,
                      ),
                    ),
                    child: Image.asset(
                      // укажи свой путь:
                      // 'lib/Images/Logo.png'
                      // или 'assets/images/Bilimdler_transparent.png'
                      'lib/Images/Logo.png',
                      width: 220,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // последовательное «написание» строк
                TypewriterText(
                  text: 'BILIM“D”LER',
                  controller: _l1C,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 6),
                TypewriterText(
                  text: 'MEKENI',
                  controller: _l2C,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    letterSpacing: 2.0,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 12),
                TypewriterText(
                  text: 'Қош келдіңіз!',
                  controller: _l3C,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Показывает строку посимвольно + лёгкое fade/slide
class TypewriterText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final AnimationController controller;
  final double slide; // пикселей сдвига при появлении
  final Curve curve;

  const TypewriterText({
    super.key,
    required this.text,
    required this.controller,
    required this.style,
    this.slide = 8,
    this.curve = Curves.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    final runes = text.runes.toList(); // корректно для кириллицы/кавычек
    final anim = CurvedAnimation(parent: controller, curve: curve);

    return AnimatedBuilder(
      animation: anim,
      builder: (_, __) {
        final t = anim.value;
        final count = (t * runes.length).clamp(0, runes.length).toInt();
        final visible = String.fromCharCodes(runes.take(count));
        final opacity = t;
        final dy = (1 - t) * slide;

        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, dy),
            child: Text(visible, textAlign: TextAlign.center, style: style),
          ),
        );
      },
    );
  }
}
