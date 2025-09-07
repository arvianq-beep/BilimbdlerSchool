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
  String get brand => 'GEO 2026 · BILIM\"D\"LER';

  @override
  String get email => 'Электрондық пошта';

  @override
  String get password => 'Құпиясөз';

  @override
  String get signIn => 'Кіру';

  @override
  String get continueAsGuest => 'Қонақ ретінде кіру';

  @override
  String get notMember => 'Әлі тіркелмегенсіз бе?';

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
  String get confirmPassword => 'Құпиясөзді растау';

  @override
  String get weakPassword => 'Құпиясөз кемінде 6 таңба болуы керек';

  @override
  String get emailInUse => 'Бұл e-mail бұрын тіркелген';

  @override
  String get emailAlreadyInUse => 'Бұл e-mail бұрын тіркелген';

  @override
  String get invalidEmail => 'Жарамсыз e-mail';

  @override
  String get userNotFound => 'Бұл e-mail бойынша пайдаланушы табылмады';

  @override
  String get wrongPassword => 'Қате құпиясөз';

  @override
  String get badEmailOrPassword => 'Жарамсыз e-mail немесе құпиясөз';

  @override
  String get tooManyRequests => 'Өте көп әрекет, кейінірек көріңіз';

  @override
  String get unknownError => 'Белгісіз қате орын алды';

  @override
  String get enterEmailPassword => 'E-mail мен құпиясөзді енгізіңіз';

  @override
  String get passwordsNotMatch => 'Құпиясөздер сәйкес келмейді';

  @override
  String verificationEmailSent(String email) {
    return 'Растау хаты $email мекенжайына жіберілді';
  }

  @override
  String get verifyYourEmail => 'Кіру үшін e-mail-ді растаңыз';

  @override
  String get forgotPassword => 'Құпиясөзді ұмыттыңыз ба?';

  @override
  String get pleaseEnterEmail => 'E-mail енгізіңіз';

  @override
  String resetEmailSent(String email) {
    return 'Құпиясөзді қалпына келтіру хаты $email адресіне жіберілді';
  }

  @override
  String get resendVerification => 'Растау хатын қайта жіберу';

  @override
  String get verificationEmailResent => 'Растау хаты қайта жіберілді';
}
