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
  String get brand => 'ГЕО 2026 · БИЛИМ\"Д\"ЛЕР';

  @override
  String get email => 'Электронная почта';

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
  String get emailInUse => 'Этот адрес уже используется';

  @override
  String get invalidEmail => 'Некорректный адрес';

  @override
  String get userNotFound => 'Пользователь с таким email не найден';

  @override
  String get wrongPassword => 'Неверный пароль';

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
  String get verifyYourEmail =>
      'Пожалуйста, подтвердите вашу почту перед входом';
}
