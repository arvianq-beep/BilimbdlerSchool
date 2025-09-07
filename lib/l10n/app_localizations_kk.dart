// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kazakh (`kk`).
class AppLocalizationsKk extends AppLocalizations {
  AppLocalizationsKk([String locale = 'kk']) : super(locale);

  @override
  String get appTitle => 'Bilimdler';

  @override
  String get brand => 'GEO 2026 · BILIM\"D\"LER ';

  @override
  String get email => 'Электрондық пошта';

  @override
  String get password => 'Құпия сөз';

  @override
  String get signIn => 'Кіру';

  @override
  String get continueAsGuest => 'Қонақ ретінде кіру';

  @override
  String get notMember => 'Аккаунтыңыз жоқ па?';

  @override
  String get registerNow => 'Тіркелу';

  @override
  String get welcome => 'Қош келдіңіз!';

  @override
  String get signOut => 'Шығу';

  @override
  String get alreadyMember => 'Тіркелгіңіз бар ма?';

  @override
  String get loginNow => 'Кіру';

  @override
  String get confirmPassword => 'Құпия сөзді растаңыз';

  @override
  String get weakPassword => 'Password must be at least 6 characters';

  @override
  String get emailInUse => 'This email is already in use';

  @override
  String get invalidEmail => 'Invalid email address';

  @override
  String get userNotFound => 'No user found with this email';

  @override
  String get wrongPassword => 'Wrong password';

  @override
  String get tooManyRequests => 'Too many attempts, try again later';

  @override
  String get unknownError => 'An unknown error occurred';

  @override
  String get enterEmailPassword => 'Enter email and password';

  @override
  String get passwordsNotMatch => 'Passwords do not match';

  @override
  String verificationEmailSent(String email) {
    return 'Verification email sent to $email';
  }

  @override
  String get verifyYourEmail => 'Please verify your email before logging in';
}
