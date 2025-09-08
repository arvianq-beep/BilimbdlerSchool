// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Bilimdler';

  @override
  String get brand => 'БИЛИМ\"D\"ЛЕР';

  @override
  String get email => 'Email';

  @override
  String get password => 'Пароль';

  @override
  String get signIn => 'Войти';

  @override
  String get continueAsGuest => 'Войти как гость';

  @override
  String get notMember => 'Нет аккаунта?';

  @override
  String get registerNow => 'Зарегистрироваться';

  @override
  String get welcome => 'Добро пожаловать!';

  @override
  String get signOut => 'Выйти';

  @override
  String get alreadyMember => 'Уже есть аккаунт?';

  @override
  String get loginNow => 'Войти';

  @override
  String get confirmPassword => 'Повторите пароль';

  @override
  String get weakPassword => 'Пароль должен быть не короче 6 символов';

  @override
  String get emailInUse => 'Этот email уже используется';

  @override
  String get emailAlreadyInUse => 'Этот email уже используется';

  @override
  String get invalidEmail => 'Неверный адрес email';

  @override
  String get userNotFound => 'Пользователь с таким email не найден';

  @override
  String get wrongPassword => 'Неверный пароль';

  @override
  String get badEmailOrPassword => 'Неверный email или пароль';

  @override
  String get tooManyRequests => 'Слишком много попыток, попробуйте позже';

  @override
  String get unknownError => 'Произошла неизвестная ошибка';

  @override
  String get enterEmailPassword => 'Введите email и пароль';

  @override
  String get passwordsNotMatch => 'Пароли не совпадают';

  @override
  String verificationEmailSent(String email) {
    return 'Письмо с подтверждением отправлено на $email';
  }

  @override
  String get verifyYourEmail => 'Подтвердите email перед входом';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get pleaseEnterEmail => 'Введите email';

  @override
  String resetEmailSent(String email) {
    return 'Письмо для сброса пароля отправлено на $email';
  }

  @override
  String get resendVerification => 'Отправить письмо повторно';

  @override
  String get verificationEmailResent =>
      'Письмо подтверждения отправлено повторно';

  @override
  String guestIdDisplay(String id) {
    return 'ID гостя: $id';
  }

  @override
  String userIdDisplay(String id) {
    return 'ID пользователя: $id';
  }

  @override
  String get profileTitle => 'Профиль';

  @override
  String get firstName => 'Имя';

  @override
  String get lastName => 'Фамилия';

  @override
  String get save => 'Сохранить';

  @override
  String get saved => 'Сохранено';

  @override
  String get enterNameOrSurname => 'Введите имя или фамилию';

  @override
  String get youCanSearchByName =>
      'Вы можете искать пользователей по имени/фамилии.';

  @override
  String get startGame => 'Начать игру';

  @override
  String get subjects => 'Предметы';

  @override
  String get settings => 'Настройки';

  @override
  String get sound => 'Звук';

  @override
  String get vibration => 'Вибрация';

  @override
  String get theme => 'Тема';

  @override
  String get chooseSubject => 'Выберите предмет';

  @override
  String get toggleTheme => 'Переключить тему';
}
