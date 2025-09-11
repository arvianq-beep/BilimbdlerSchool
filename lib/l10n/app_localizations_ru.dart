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

  @override
  String get joinByCode => 'Войти по коду';

  @override
  String get enterCode => 'Введите код';

  @override
  String get enterCodeHint => 'ABC123';

  @override
  String get btnJoin => 'Войти';

  @override
  String get btnCancel => 'Отмена';

  @override
  String get howToPlayTitle => 'Как играть?';

  @override
  String get howToPlayBody =>
      'Один — сразу в предмет.\nГруппа — создастся комната и начнёте вместе.';

  @override
  String get modeSolo => 'Один';

  @override
  String get modeGroup => 'Группа';

  @override
  String get chooseParticipantsTitle => 'Сколько участников?';

  @override
  String get btnOk => 'Ок';

  @override
  String get waitingRoomTitle => 'Комната ожидания';

  @override
  String get roomDeleted => 'Комната удалена';

  @override
  String get codeCopied => 'Код скопирован';

  @override
  String get roomOpen => 'Открыта';

  @override
  String get roomClosed => 'Закрыта';

  @override
  String membersCount(int count, int max) {
    return 'Участники: $count / $max';
  }

  @override
  String get statusLabel => 'Статус';

  @override
  String get statusWaiting => 'ожидание';

  @override
  String get statusPlaying => 'в игре';

  @override
  String get leave => 'Выйти';

  @override
  String get chooseGame => 'Выбрать игру';

  @override
  String get createRoomFailed => 'Не удалось создать комнату';

  @override
  String get startGameFailed => 'Не удалось запустить игру';

  @override
  String get roomNotFound => 'Комната не найдена';

  @override
  String get roomAlreadyStarted => 'Игра уже начата';

  @override
  String get roomIsClosed => 'Комната закрыта';

  @override
  String get roomIsFull => 'Мест нет';

  @override
  String codeLabel(String code) {
    return 'Код: $code';
  }

  @override
  String get createRoomTitle => 'Создать комнату';

  @override
  String get participantsLimit => 'Лимит участников';

  @override
  String get btnCreate => 'Создать';

  @override
  String get shareCodeHint =>
      'После создания поделитесь кодом комнаты из лобби.';

  @override
  String get owner => 'Владелец';

  @override
  String get member => 'Участник';

  @override
  String get noMembersYet => 'Пока никого';

  @override
  String get joinFailed => 'Не удалось присоединиться';

  @override
  String get codeGenerationFailed => 'Не удалось сгенерировать код';

  @override
  String gameTitle(String id) {
    return 'Игра: $id';
  }

  @override
  String gameLaunched(String gameId, String subject) {
    return 'Запущена игра «$gameId» по предмету «$subject»';
  }

  @override
  String get markets => 'Рынки';

  @override
  String get gdpQuiz => 'Викторина по ВВП';

  @override
  String get tradeRoutes => 'Торговые пути';

  @override
  String get industry => 'Промышленность';

  @override
  String get resources => 'Ресурсы';

  @override
  String get population => 'Население';

  @override
  String get capitals => 'Столицы';

  @override
  String get flags => 'Флаги';

  @override
  String get climate => 'Климат';

  @override
  String get citiesEgTitle => 'Города Казахстана — мини-игра';

  @override
  String get rules => 'Правила';

  @override
  String get findCityPrompt => 'Найдите на карте город:';

  @override
  String scoreDisplay(int score) {
    return 'Счёт: $score';
  }

  @override
  String get citiesEgFinishTitle => 'Готово!';

  @override
  String resultDisplay(int score, int total) {
    return 'Ваш результат: $score / $total';
  }

  @override
  String get playAgain => 'Ещё раз';

  @override
  String get citiesEgRulesText =>
      'На экране показано название города.\nНажмите на соответствующий квадрат города на карте.\n\n+1 балл за правильный ответ.\nНеверные клики подсветятся красным.\nПройдите все города и начните заново.';

  @override
  String get cityAstana => 'Астана';

  @override
  String get cityAlmaty => 'Алматы';

  @override
  String get cityShymkent => 'Шымкент';

  @override
  String get cityKaraganda => 'Караганда';

  @override
  String get cityAktobe => 'Актобе';

  @override
  String get cityTaraz => 'Тараз';

  @override
  String get cityPavlodar => 'Павлодар';

  @override
  String get cityOskemen => 'Усть-Каменогорск';

  @override
  String get citySemey => 'Семей';

  @override
  String get cityKostanay => 'Костанай';

  @override
  String get cityAtyrau => 'Атырау';

  @override
  String get cityKyzylorda => 'Кызылорда';

  @override
  String get cityOral => 'Уральск';

  @override
  String get cityPetropavl => 'Петропавловск';

  @override
  String get cityEkibastuz => 'Экибастуз';

  @override
  String get cityZhezkazgan => 'Жезказган';

  @override
  String get cityTemirtau => 'Темиртау';

  @override
  String get cityKokshetau => 'Кокшетау';

  @override
  String get cityTurkistan => 'Туркестан';

  @override
  String get cityTaldykorgan => 'Талдыкорган';
}
