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
  String get brand => 'GEO 2026 · BILIM\"D\"LER';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Пароль';

  @override
  String get signIn => 'Войти';

  @override
  String get continueAsGuest => 'Продолжить как гость';

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
  String get confirmPassword => 'Подтвердите пароль';

  @override
  String get weakPassword => 'Пароль должен содержать не менее 6 символов';

  @override
  String get emailInUse => 'Этот e-mail уже используется';

  @override
  String get emailAlreadyInUse => 'Этот e-mail уже используется';

  @override
  String get invalidEmail => 'Некорректный e-mail';

  @override
  String get userNotFound => 'Пользователь с таким e-mail не найден';

  @override
  String get wrongPassword => 'Неверный пароль';

  @override
  String get badEmailOrPassword => 'Неверный e-mail или пароль';

  @override
  String get tooManyRequests => 'Слишком много попыток, попробуйте позже';

  @override
  String get unknownError => 'Произошла неизвестная ошибка';

  @override
  String get enterEmailPassword => 'Введите e-mail и пароль';

  @override
  String get passwordsNotMatch => 'Пароли не совпадают';

  @override
  String verificationEmailSent(String email) {
    return 'Письмо с подтверждением отправлено на $email';
  }

  @override
  String get verifyYourEmail => 'Пожалуйста, подтвердите e-mail перед входом';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get pleaseEnterEmail => 'Введите e-mail';

  @override
  String resetEmailSent(String email) {
    return 'Письмо для сброса пароля отправлено на $email';
  }

  @override
  String get resendVerification => 'Отправить письмо повторно';

  @override
  String get verificationEmailResent =>
      'Письмо с подтверждением отправлено повторно';

  @override
  String guestIdDisplay(String id) {
    return 'Гость ID: $id';
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
      'Можно искать пользователей по имени и фамилии.';
}
