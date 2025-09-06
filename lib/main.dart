import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'Themes/Themes_Provider.dart';
import 'l10n/app_localizations.dart';
import 'l10n/locale_provider.dart';
import 'Pages/Splash_Page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // для SharedPreferences
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
    final theme = context.watch<ThemesProvider>().themeData;
    final localeProvider = context.watch<LocaleProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      locale: localeProvider.locale, // язык из провайдера
      supportedLocales: const [
        Locale('kk'), // ← казахский первым
        Locale('ru'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // fallback → всегда казахский, если ничего не выбрано
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        final current = localeProvider.locale;

        // если пользователь выбрал → используем
        if (supportedLocales.contains(current)) {
          return current;
        }

        // fallback → казахский
        return const Locale('kk');
      },

      home: const SplashPage(),
    );
  }
}
