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
  String get brand => 'ГЕО 2026 · БІЛІМ\"D\"ЛЕР';

  @override
  String get email => 'Email';

  @override
  String get password => 'Құпиясөз';

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
  String get alreadyMember => 'Аккаунтыңыз бар ма?';

  @override
  String get loginNow => 'Кіру';

  @override
  String get confirmPassword => 'Құпиясөзді растаңыз';

  @override
  String get weakPassword => 'Құпиясөз кемінде 6 таңбадан тұруы керек';

  @override
  String get emailInUse => 'Бұл email бұрыннан қолданылуда';

  @override
  String get invalidEmail => 'Email дұрыс емес';

  @override
  String get userNotFound => 'Мұндай email табылмады';

  @override
  String get wrongPassword => 'Құпиясөз қате';

  @override
  String get tooManyRequests =>
      'Тым көп әрекет жасалды, кейінірек қайталап көріңіз';

  @override
  String get unknownError => 'Белгісіз қате орын алды';

  @override
  String get enterEmailPassword => 'Email мен құпиясөзді енгізіңіз';

  @override
  String get passwordsNotMatch => 'Құпиясөздер сәйкес келмейді';

  @override
  String verificationEmailSent(Object email) {
    return 'Растау хаты $email поштасына жіберілді';
  }

  @override
  String get verifyYourEmail => 'Жүйеге кірмес бұрын email-ді растаңыз';
}
