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
  String get email => 'Email';

  @override
  String get password => 'Пароль';

  @override
  String get signIn => 'Войти';

  @override
  String get continueAsGuest => 'Продолжить как гость';

  @override
  String get notMember => 'Нет аккаунта?';

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
  String get weakPassword => 'Пароль должен быть не менее 6 символов';

  @override
  String get emailInUse => 'Этот email уже используется';

  @override
  String get emailAlreadyInUse => 'Этот email уже используется';

  @override
  String get invalidEmail => 'Некорректный email';

  @override
  String get userNotFound => 'Пользователь не найден';

  @override
  String get wrongPassword => 'Неверный пароль';

  @override
  String get badEmailOrPassword => 'Неверный email или пароль';

  @override
  String get tooManyRequests => 'Слишком много попыток, попробуйте позже';

  @override
  String get unknownError => 'Неизвестная ошибка';

  @override
  String get enterEmailPassword => 'Введите email и пароль';

  @override
  String get passwordsNotMatch => 'Пароли не совпадают';

  @override
  String verificationEmailSent(String email) {
    return 'Письмо для подтверждения отправлено на $email';
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
  String get verificationEmailResent => 'Письмо повторно отправлено';

  @override
  String guestIdDisplay(String id) {
    return 'Гостевой ID: $id';
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
    return 'Скоро: $title';
  }

  @override
  String get mountains => 'Горы';

  @override
  String get lakes => 'Озёра';

  @override
  String get deserts => 'Физ регоины';

  @override
  String get rivers => 'Реки';

  @override
  String get reserves => 'Заповедники';

  @override
  String get testLabel => 'Тест';

  @override
  String get regions => 'Регионы';

  @override
  String get cities => 'Города';

  @override
  String get symbols => 'Условные знаки';

  @override
  String get factories => 'Заводы';

  @override
  String get symbolsTest => 'Тест по знакам';

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
      'Соло — переходите сразу к предмету.\nГруппа — создаётся комната и вы стартуете вместе.';

  @override
  String get modeSolo => 'Соло';

  @override
  String get modeGroup => 'Группа';

  @override
  String get chooseParticipantsTitle => 'Сколько участников?';

  @override
  String get btnOk => 'ОК';

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
  String get statusPlaying => 'игра';

  @override
  String get leave => 'Выйти';

  @override
  String get chooseGame => 'Выберите игру';

  @override
  String get createRoomFailed => 'Не удалось создать комнату';

  @override
  String get startGameFailed => 'Не удалось запустить игру';

  @override
  String get roomNotFound => 'Комната не найдена';

  @override
  String get roomAlreadyStarted => 'Игра уже началась';

  @override
  String get roomIsClosed => 'Комната закрыта';

  @override
  String get roomIsFull => 'Свободных мест нет';

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
    return 'Запущена игра \"$gameId\" для предмета \"$subject\"';
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
  String get citiesEgTitle => 'Экономическая география: Города';

  @override
  String get rules => 'Правила';

  @override
  String get findCityPrompt => 'Найдите город:';

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
  String get playAgain => 'Играть ещё';

  @override
  String get citiesEgRulesText =>
      'На экране показано название города.\nНажмите соответствующий квадрат на карте.\n\n+1 балл за правильный ответ.\nОшибочные нажатия подсвечиваются красным.\nПройдите все города и попробуйте снова.';

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
  String get cityOral => 'Орал';

  @override
  String get cityPetropavl => 'Петропавл';

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

  @override
  String get factoriesTestTitle => 'Тест: Металлургия';

  @override
  String get factoriesQ1 => 'Где находится Титано-магниевый завод?';

  @override
  String get factoriesQ1A1 => 'Павлодар';

  @override
  String get factoriesQ1A2 => 'Усть-Каменогорск';

  @override
  String get factoriesQ1A3 => 'Риддер';

  @override
  String get factoriesQ1A4 => 'Жезказган';

  @override
  String get factoriesQ2 => 'Какой завод расположен в Павлодаре?';

  @override
  String get factoriesQ2A1 => 'Электролизный завод';

  @override
  String get factoriesQ2A2 => 'Полиметаллический завод';

  @override
  String get factoriesQ2A3 => 'Медеплавильный завод';

  @override
  String get factoriesQ2A4 => 'Свинцово-цинковый завод';

  @override
  String get factoriesQ3 => 'Металлургический гигант в Темиртау?';

  @override
  String get factoriesQ3A1 => 'Балхашский медеплавильный';

  @override
  String get factoriesQ3A2 => 'Ispat-Karmet (ArcelorMittal)';

  @override
  String get factoriesQ3A3 => 'Глинозёмный завод';

  @override
  String get factoriesQ3A4 => 'Актюбинский ферросплавный';

  @override
  String questionOfTotal(String current, String total) {
    return 'Вопрос $current из $total';
  }

  @override
  String get factoriesQ4 => 'В каком городе НЕТ ферросплавного завода?';

  @override
  String get factoriesQ4A1 => 'Актобе';

  @override
  String get factoriesQ4A2 => 'Аксу (Павлодар)';

  @override
  String get factoriesQ4A3 => 'Тараз';

  @override
  String get factoriesQ4A4 => 'Жезказган';

  @override
  String get factoriesQ5 => 'Где расположен медеплавильный завод?';

  @override
  String get factoriesQ5A1 => 'Балхаш';

  @override
  String get factoriesQ5A2 => 'Актобе';

  @override
  String get factoriesQ5A3 => 'Риддер';

  @override
  String get factoriesQ5A4 => 'Атырау';

  @override
  String get factoriesQ6 => 'Свинцово-цинковый комбинат — в каком городе?';

  @override
  String get factoriesQ6A1 => 'Усть-Каменогорск';

  @override
  String get factoriesQ6A2 => 'Атырау';

  @override
  String get factoriesQ6A3 => 'Тараз';

  @override
  String get factoriesQ6A4 => 'Алматы';

  @override
  String get factoriesQ7 => 'Полиметаллический завод расположен в:';

  @override
  String get factoriesQ7A1 => 'Усть-Каменогорск';

  @override
  String get factoriesQ7A2 => 'Павлодар';

  @override
  String get factoriesQ7A3 => 'Риддер';

  @override
  String get factoriesQ7A4 => 'Актобе';

  @override
  String get resultsTitle => 'Результат';

  @override
  String get room => 'Комната';

  @override
  String get finished => 'Завершено';

  @override
  String get scoreShort => 'Счёт';

  @override
  String get back => 'Назад';

  @override
  String get toMenu => 'Домой';

  @override
  String get testFinished => 'Тест завершён';

  @override
  String get result => 'Итог';

  @override
  String get nextGame => 'Следующая игра';

  @override
  String get symbolsQuizTitle => 'Тест по знакам';

  @override
  String get reset => 'Сбросить';

  @override
  String get restart => 'Заново';

  @override
  String get close => 'Закрыть';

  @override
  String get score => 'Счёт';

  @override
  String get next => 'Далее';

  @override
  String get showResult => 'Показать результат';

  @override
  String get symbolsResultTitle => 'Результат';

  @override
  String get correctAnswers => 'Верно';
}
