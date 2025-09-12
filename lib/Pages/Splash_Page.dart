import 'dart:async';
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

  bool _navigated = false;
  Timer? _fallbackTimer;

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
        _goNext();
      }
    });

    _fallbackTimer = Timer(const Duration(seconds: 5), _goNext);
  }

  void _goNext() {
    if (!mounted || _navigated) return;
    _navigated = true;
    _fallbackTimer?.cancel();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (_, __, ___) => const LoginOrRegister(),
        transitionsBuilder: (context, animation, __, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: Curves.easeOutCubic));
          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _fallbackTimer?.cancel();
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                      'lib/Images/Logo.png',
                      width: 220,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
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
                  text: 'MEKENINE',
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
                  text: 'Qosh keldiniz!',
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

class TypewriterText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final AnimationController controller;
  final double slide;
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
    final runes = text.runes.toList();
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
