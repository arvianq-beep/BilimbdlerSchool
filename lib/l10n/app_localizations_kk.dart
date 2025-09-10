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
  String get password => 'Құпия сөз';

  @override
  String get signIn => 'Кіру';

  @override
  String get continueAsGuest => 'Қонақ ретінде жалғастыру';

  @override
  String get notMember => 'Тіркелмегенсіз бе?';

  @override
  String get registerNow => 'Қазір тіркелу';

  @override
  String get welcome => 'Қош келдіңіз!';

  @override
  String get signOut => 'Шығу';

  @override
  String get alreadyMember => 'Бұрын тіркелгенсіз бе?';

  @override
  String get loginNow => 'Кіру';

  @override
  String get confirmPassword => 'Құпия сөзді растау';

  @override
  String get weakPassword => 'Құпия сөз кемінде 6 таңба болуы керек';

  @override
  String get emailInUse => 'Бұл электрондық пошта бұрын қолданылған';

  @override
  String get emailAlreadyInUse => 'Бұл электрондық пошта бұрын қолданылған';

  @override
  String get invalidEmail => 'Жарамсыз электрондық пошта';

  @override
  String get userNotFound => 'Осы поштамен пайдаланушы табылмады';

  @override
  String get wrongPassword => 'Қате құпия сөз';

  @override
  String get badEmailOrPassword => 'Қате электрондық пошта не құпия сөз';

  @override
  String get tooManyRequests => 'Тым көп әрекет, кейінірек қайталап көріңіз';

  @override
  String get unknownError => 'Белгісіз қате орын алды';

  @override
  String get enterEmailPassword =>
      'Электрондық пошта мен құпия сөзді енгізіңіз';

  @override
  String get passwordsNotMatch => 'Құпия сөздер сәйкес келмейді';

  @override
  String verificationEmailSent(String email) {
    return 'Растау хаты $email поштасына жіберілді';
  }

  @override
  String get verifyYourEmail => 'Кіру алдында электрондық поштаңызды растаңыз';

  @override
  String get forgotPassword => 'Құпия сөзді ұмыттыңыз ба?';

  @override
  String get pleaseEnterEmail => 'Электрондық поштаңызды енгізіңіз';

  @override
  String resetEmailSent(String email) {
    return 'Құпия сөзді қалпына келтіру хаты $email поштасына жіберілді';
  }

  @override
  String get resendVerification => 'Растау хатын қайта жіберу';

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
      'Пайдаланушыларды аты/тегі бойынша іздей аласыз.';

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

  @override
  String get geography => 'География';

  @override
  String get physicalGeography => 'Физикалық география';

  @override
  String get economicGeography => 'Экономикалық география';

  @override
  String comingSoon(String title) {
    return 'Жақында: $title';
  }

  @override
  String get mountains => 'Таулар';

  @override
  String get lakes => 'Көлдер';

  @override
  String get deserts => 'Шөлдер';

  @override
  String get rivers => 'Өзендер';

  @override
  String get reserves => 'Қорықтар';

  @override
  String get testLabel => 'Тест';

  @override
  String get regions => 'Облыстар';

  @override
  String get cities => 'Қалалар';

  @override
  String get symbols => 'Шартты белгілер';

  @override
  String get factories => 'Зауыттар';

  @override
  String get symbolsTest => 'Шартты белгілер тест';
}
