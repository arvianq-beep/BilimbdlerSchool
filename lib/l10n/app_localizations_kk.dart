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
  String get brand => 'BILIM\"D\"LER';

  @override
  String get email => 'Электрондық пошта';

  @override
  String get password => 'Құпиясөз';

  @override
  String get signIn => 'Кіру';

  @override
  String get continueAsGuest => 'Қонақ ретінде кіру';

  @override
  String get notMember => 'Тіркелмегенсіз бе?';

  @override
  String get registerNow => 'Тіркелу';

  @override
  String get welcome => 'Қош келдіңіз!';

  @override
  String get signOut => 'Шығу';

  @override
  String get alreadyMember => 'Тіркелгі бар ма?';

  @override
  String get loginNow => 'Кіру';

  @override
  String get confirmPassword => 'Құпиясөзді растау';

  @override
  String get weakPassword => 'Құпиясөз кемінде 6 таңба болуы тиіс';

  @override
  String get emailInUse => 'Бұл email бұрыннан тіркелген';

  @override
  String get emailAlreadyInUse => 'Бұл email бұрыннан тіркелген';

  @override
  String get invalidEmail => 'Жарамсыз email';

  @override
  String get userNotFound => 'Бұл email бойынша пайдаланушы табылмады';

  @override
  String get wrongPassword => 'Құпиясөз қате';

  @override
  String get badEmailOrPassword => 'Email немесе құпиясөз қате';

  @override
  String get tooManyRequests => 'Әрекет тым көп, кейінірек қайталап көріңіз';

  @override
  String get unknownError => 'Белгісіз қате орын алды';

  @override
  String get enterEmailPassword => 'Email мен құпиясөзді енгізіңіз';

  @override
  String get passwordsNotMatch => 'Құпиясөздер сәйкес келмейді';

  @override
  String verificationEmailSent(String email) {
    return 'Растау хаты $email адресіне жіберілді';
  }

  @override
  String get verifyYourEmail => 'Кіру алдында email-ді растаңыз';

  @override
  String get forgotPassword => 'Құпиясөзді ұмыттыңыз ба?';

  @override
  String get pleaseEnterEmail => 'Email енгізіңіз';

  @override
  String resetEmailSent(String email) {
    return 'Құпиясөзді қалпына келтіру хаты $email адресіне жіберілді';
  }

  @override
  String get resendVerification => 'Растауды қайта жіберу';

  @override
  String get verificationEmailResent => 'Растау хаты қайта жіберілді';

  @override
  String guestIdDisplay(String id) {
    return 'Қонақ ID: $id';
  }

  @override
  String userIdDisplay(String id) {
    return 'Пайдаланушы ID: $id';
  }

  @override
  String get profileTitle => 'Профиль';

  @override
  String get firstName => 'Аты';

  @override
  String get lastName => 'Тегі';

  @override
  String get save => 'Сақтау';

  @override
  String get saved => 'Сақталды';

  @override
  String get enterNameOrSurname => 'Аты немесе тегін енгізіңіз';

  @override
  String get youCanSearchByName =>
      'Пайдаланушыларды аты/тегі бойынша іздеуге болады.';

  @override
  String get startGame => 'Ойынды бастау';

  @override
  String get subjects => 'Пәндер';

  @override
  String get settings => 'Баптаулар';

  @override
  String get sound => 'Дыбыс';

  @override
  String get vibration => 'Діріл';

  @override
  String get theme => 'Тақырып';

  @override
  String get chooseSubject => 'Пәнді таңдаңыз';

  @override
  String get toggleTheme => 'Тақырыпты ауыстыру';
}
