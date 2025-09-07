import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bilimdler/l10n/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'Pages/splash_page.dart';
import 'Pages/home_page.dart';
import 'Themes/Themes_Provider.dart';
import 'l10n/app_localizations.dart';
import 'Auth/Login_or_Register.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Только альбомная ориентация
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemesProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemesProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bilimdler',
      theme: themeProvider.themeData,
      locale: localeProvider.locale,
      supportedLocales: const [Locale('en'), Locale('ru'), Locale('kk')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashPage();
          }

          if (snapshot.hasData) {
            final user = snapshot.data!;
            if (!user.emailVerified) {
              FirebaseAuth.instance.signOut();
              return const LoginOrRegister(); // ⚡️ сюда
            }
            return const HomePage();
          }

          return const LoginOrRegister(); // ⚡️ сюда
        },
      ),
    );
  }
}
