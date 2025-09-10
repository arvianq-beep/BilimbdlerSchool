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
  String get brand => 'BILIM\"D\"LER';

  @override
  String get email => 'Эл. почта';

  @override
  String get password => 'Пароль';

  @override
  String get signIn => 'Войти';

  @override
  String get continueAsGuest => 'Продолжить как гость';

  @override
  String get notMember => 'Ещё нет аккаунта?';

  @override
  String get registerNow => 'Зарегистрируйтесь';

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
  String get emailAlreadyInUse => 'Этот адрес уже используется';

  @override
  String get invalidEmail => 'Некорректный адрес эл. почты';

  @override
  String get userNotFound => 'Пользователь с таким адресом не найден';

  @override
  String get wrongPassword => 'Неверный пароль';

  @override
  String get badEmailOrPassword => 'Неверная почта или пароль';

  @override
  String get tooManyRequests => 'Слишком много попыток, попробуйте позже';

  @override
  String get unknownError => 'Произошла неизвестная ошибка';

  @override
  String get enterEmailPassword => 'Введите эл. почту и пароль';

  @override
  String get passwordsNotMatch => 'Пароли не совпадают';

  @override
  String verificationEmailSent(String email) {
    return 'Письмо с подтверждением отправлено на $email';
  }

  @override
  String get verifyYourEmail => 'Пожалуйста, подтвердите почту перед входом';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get pleaseEnterEmail => 'Введите адрес эл. почты';

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
      'Можно искать пользователей по имени/фамилии.';

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

  @override
  String get geography => 'География';

  @override
  String get physicalGeography => 'Физическая география';

  @override
  String get economicGeography => 'Экономическая география';

  @override
  String comingSoon(String title) {
    return 'Скоро будет: $title';
  }

  @override
  String get mountains => 'Горы';

  @override
  String get lakes => 'Озера';

  @override
  String get deserts => 'Пустыни';

  @override
  String get rivers => 'Реки';

  @override
  String get reserves => 'Заповедники';

  @override
  String get testLabel => 'Тест';

  @override
  String get regions => 'Области';

  @override
  String get cities => 'Города';

  @override
  String get symbols => 'Условные знаки';

  @override
  String get factories => 'Заводы';

  @override
  String get symbolsTest => 'Условные знаки тест';
}
