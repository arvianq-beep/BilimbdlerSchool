// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Bilimdler';

  @override
  String get brand => 'BILIM\"D\"LER';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get signIn => 'Sign in';

  @override
  String get continueAsGuest => 'Continue as guest';

  @override
  String get notMember => 'Not a member?';

  @override
  String get registerNow => 'Register now';

  @override
  String get welcome => 'Welcome!';

  @override
  String get signOut => 'Sign out';

  @override
  String get alreadyMember => 'Already have an account?';

  @override
  String get loginNow => 'Log in';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get weakPassword => 'Password must be at least 6 characters';

  @override
  String get emailInUse => 'This email is already in use';

  @override
  String get emailAlreadyInUse => 'This email is already in use';

  @override
  String get invalidEmail => 'Invalid email address';

  @override
  String get userNotFound => 'No user found with this email';

  @override
  String get wrongPassword => 'Wrong password';

  @override
  String get badEmailOrPassword => 'Wrong email or password';

  @override
  String get tooManyRequests => 'Too many attempts, try again later';

  @override
  String get unknownError => 'An unknown error occurred';

  @override
  String get enterEmailPassword => 'Enter email and password';

  @override
  String get passwordsNotMatch => 'Passwords do not match';

  @override
  String verificationEmailSent(String email) {
    return 'Verification email sent to $email';
  }

  @override
  String get verifyYourEmail => 'Please verify your email before logging in';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String resetEmailSent(String email) {
    return 'Password reset email sent to $email';
  }

  @override
  String get resendVerification => 'Resend verification email';

  @override
  String get verificationEmailResent => 'Verification email resent';

  @override
  String guestIdDisplay(String id) {
    return 'Guest ID: $id';
  }

  @override
  String userIdDisplay(String id) {
    return 'User ID: $id';
  }

  @override
  String get profileTitle => 'Profile';

  @override
  String get firstName => 'First name';

  @override
  String get lastName => 'Last name';

  @override
  String get save => 'Save';

  @override
  String get saved => 'Saved';

  @override
  String get enterNameOrSurname => 'Enter first or last name';

  @override
  String get youCanSearchByName => 'You can search users by first/last name.';

  @override
  String get startGame => 'Start game';

  @override
  String get subjects => 'Subjects';

  @override
  String get settings => 'Settings';

  @override
  String get sound => 'Sound';

  @override
  String get vibration => 'Vibration';

  @override
  String get theme => 'Theme';

  @override
  String get chooseSubject => 'Choose a subject';

  @override
  String get toggleTheme => 'Toggle theme';

  @override
  String get geography => 'Geography';

  @override
  String get physicalGeography => 'Physical geography';

  @override
  String get economicGeography => 'Economic geography';

  @override
  String comingSoon(String title) {
    return 'Coming soon: $title';
  }

  @override
  String get mountains => 'Mountains';

  @override
  String get lakes => 'Lakes';

  @override
  String get deserts => 'Deserts';

  @override
  String get rivers => 'Rivers';

  @override
  String get reserves => 'Reserves';

  @override
  String get testLabel => 'Test';

  @override
  String get regions => 'Regions';

  @override
  String get cities => 'Cities';

  @override
  String get symbols => 'Symbols';

  @override
  String get factories => 'Factories';

  @override
  String get symbolsTest => 'Symbols test';

  @override
  String get joinByCode => 'Join by code';

  @override
  String get enterCode => 'Enter code';

  @override
  String get enterCodeHint => 'ABC123';

  @override
  String get btnJoin => 'Join';

  @override
  String get btnCancel => 'Cancel';

  @override
  String get howToPlayTitle => 'How to play?';

  @override
  String get howToPlayBody =>
      'Solo — go straight to the subject.\nGroup — a room will be created and you’ll start together.';

  @override
  String get modeSolo => 'Solo';

  @override
  String get modeGroup => 'Group';

  @override
  String get chooseParticipantsTitle => 'How many participants?';

  @override
  String get btnOk => 'OK';

  @override
  String get waitingRoomTitle => 'Waiting room';

  @override
  String get roomDeleted => 'Room deleted';

  @override
  String get codeCopied => 'Code copied';

  @override
  String get roomOpen => 'Open';

  @override
  String get roomClosed => 'Closed';

  @override
  String membersCount(int count, int max) {
    return 'Members: $count / $max';
  }

  @override
  String get statusLabel => 'Status';

  @override
  String get statusWaiting => 'waiting';

  @override
  String get statusPlaying => 'playing';

  @override
  String get leave => 'Leave';

  @override
  String get chooseGame => 'Choose game';

  @override
  String get createRoomFailed => 'Couldn\'t create room';

  @override
  String get startGameFailed => 'Couldn\'t start the game';

  @override
  String get roomNotFound => 'Room not found';

  @override
  String get roomAlreadyStarted => 'The game has already started';

  @override
  String get roomIsClosed => 'Room is closed';

  @override
  String get roomIsFull => 'No seats left';

  @override
  String codeLabel(String code) {
    return 'Code: $code';
  }

  @override
  String get createRoomTitle => 'Create room';

  @override
  String get participantsLimit => 'Participants limit';

  @override
  String get btnCreate => 'Create';

  @override
  String get shareCodeHint =>
      'After creating, share the room code from the lobby.';

  @override
  String get owner => 'Owner';

  @override
  String get member => 'Member';

  @override
  String get noMembersYet => 'No one yet';

  @override
  String get joinFailed => 'Couldn\'t join';

  @override
  String get codeGenerationFailed => 'Couldn\'t generate a code';

  @override
  String gameTitle(String id) {
    return 'Game: $id';
  }

  @override
  String gameLaunched(String gameId, String subject) {
    return 'Started game \"$gameId\" for subject \"$subject\"';
  }

  @override
  String get markets => 'Markets';

  @override
  String get gdpQuiz => 'GDP quiz';

  @override
  String get tradeRoutes => 'Trade routes';

  @override
  String get industry => 'Industry';

  @override
  String get resources => 'Resources';

  @override
  String get population => 'Population';

  @override
  String get capitals => 'Capitals';

  @override
  String get flags => 'Flags';

  @override
  String get climate => 'Climate';

  @override
  String get citiesEgTitle => 'Economic geography: Cities';

  @override
  String get rules => 'Rules';

  @override
  String get findCityPrompt => 'Find the city:';

  @override
  String scoreDisplay(int score) {
    return 'Score: $score';
  }

  @override
  String get citiesEgFinishTitle => 'Done!';

  @override
  String resultDisplay(int score, int total) {
    return 'Your result: $score / $total';
  }

  @override
  String get playAgain => 'Play again';

  @override
  String get citiesEgRulesText =>
      'The screen shows a city name.\nTap the corresponding square on the map.\n\n+1 point for a correct answer.\nWrong taps highlight in red.\nGo through all cities and try again.';

  @override
  String get cityAstana => 'Astana';

  @override
  String get cityAlmaty => 'Almaty';

  @override
  String get cityShymkent => 'Shymkent';

  @override
  String get cityKaraganda => 'Karaganda';

  @override
  String get cityAktobe => 'Aktobe';

  @override
  String get cityTaraz => 'Taraz';

  @override
  String get cityPavlodar => 'Pavlodar';

  @override
  String get cityOskemen => 'Oskemen';

  @override
  String get citySemey => 'Semey';

  @override
  String get cityKostanay => 'Kostanay';

  @override
  String get cityAtyrau => 'Atyrau';

  @override
  String get cityKyzylorda => 'Kyzylorda';

  @override
  String get cityOral => 'Oral';

  @override
  String get cityPetropavl => 'Petropavl';

  @override
  String get cityEkibastuz => 'Ekibastuz';

  @override
  String get cityZhezkazgan => 'Zhezkazgan';

  @override
  String get cityTemirtau => 'Temirtau';

  @override
  String get cityKokshetau => 'Kokshetau';

  @override
  String get cityTurkistan => 'Turkistan';

  @override
  String get cityTaldykorgan => 'Taldykorgan';

  @override
  String get factoriesTestTitle => 'Test: Metallurgy';

  @override
  String get factoriesQ1 => 'Where is the Titanium–Magnesium Plant located?';

  @override
  String get factoriesQ1A1 => 'Pavlodar';

  @override
  String get factoriesQ1A2 => 'Oskemen';

  @override
  String get factoriesQ1A3 => 'Ridder';

  @override
  String get factoriesQ1A4 => 'Zhezkazgan';

  @override
  String get factoriesQ2 => 'Which plant is located in Pavlodar?';

  @override
  String get factoriesQ2A1 => 'Electrolysis plant';

  @override
  String get factoriesQ2A2 => 'Polymetal plant';

  @override
  String get factoriesQ2A3 => 'Copper smelter';

  @override
  String get factoriesQ2A4 => 'Lead–zinc plant';

  @override
  String get factoriesQ3 => 'Metallurgical giant in Temirtau?';

  @override
  String get factoriesQ3A1 => 'Balkhash copper plant';

  @override
  String get factoriesQ3A2 => 'Ispat-Karmet (ArcelorMittal)';

  @override
  String get factoriesQ3A3 => 'Alumina plant';

  @override
  String get factoriesQ3A4 => 'Aktobe ferroalloy plant';

  @override
  String questionOfTotal(String current, String total) {
    return 'Question $current of $total';
  }

  @override
  String get factoriesQ4 => 'Which city does NOT have a ferroalloy plant?';

  @override
  String get factoriesQ4A1 => 'Aktobe';

  @override
  String get factoriesQ4A2 => 'Aksu (Pavlodar)';

  @override
  String get factoriesQ4A3 => 'Taraz';

  @override
  String get factoriesQ4A4 => 'Zhezkazgan';

  @override
  String get factoriesQ5 => 'Where is a copper smelter located?';

  @override
  String get factoriesQ5A1 => 'Balkhash';

  @override
  String get factoriesQ5A2 => 'Aktobe';

  @override
  String get factoriesQ5A3 => 'Ridder';

  @override
  String get factoriesQ5A4 => 'Atyrau';

  @override
  String get factoriesQ6 => 'Lead–zinc combine is in which city?';

  @override
  String get factoriesQ6A1 => 'Oskemen';

  @override
  String get factoriesQ6A2 => 'Atyrau';

  @override
  String get factoriesQ6A3 => 'Taraz';

  @override
  String get factoriesQ6A4 => 'Almaty';

  @override
  String get factoriesQ7 => 'Polymetal plant is located in:';

  @override
  String get factoriesQ7A1 => 'Oskemen';

  @override
  String get factoriesQ7A2 => 'Pavlodar';

  @override
  String get factoriesQ7A3 => 'Ridder';

  @override
  String get factoriesQ7A4 => 'Aktobe';

  @override
  String get resultsTitle => 'Results';

  @override
  String get room => 'Room';

  @override
  String get finished => 'Finished';

  @override
  String get scoreShort => 'Score';

  @override
  String get back => 'Back';

  @override
  String get toMenu => 'Home';

  @override
  String get testFinished => 'Test finished';

  @override
  String get result => 'Result';

  @override
  String get nextGame => 'Next game';
}
