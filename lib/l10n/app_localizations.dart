import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_kk.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('kk'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Bilimdler'**
  String get appTitle;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'BILIM\"D\"LER'**
  String get brand;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as guest'**
  String get continueAsGuest;

  /// No description provided for @notMember.
  ///
  /// In en, this message translates to:
  /// **'Not a member?'**
  String get notMember;

  /// No description provided for @registerNow.
  ///
  /// In en, this message translates to:
  /// **'Register now'**
  String get registerNow;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @alreadyMember.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyMember;

  /// No description provided for @loginNow.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginNow;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get weakPassword;

  /// No description provided for @emailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already in use'**
  String get emailInUse;

  /// No description provided for @emailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already in use'**
  String get emailAlreadyInUse;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalidEmail;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'No user found with this email'**
  String get userNotFound;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password'**
  String get wrongPassword;

  /// No description provided for @badEmailOrPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong email or password'**
  String get badEmailOrPassword;

  /// No description provided for @tooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts, try again later'**
  String get tooManyRequests;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get unknownError;

  /// No description provided for @enterEmailPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter email and password'**
  String get enterEmailPassword;

  /// No description provided for @passwordsNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsNotMatch;

  /// No description provided for @verificationEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Verification email sent to {email}'**
  String verificationEmailSent(String email);

  /// No description provided for @verifyYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Please verify your email before logging in'**
  String get verifyYourEmail;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @resetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent to {email}'**
  String resetEmailSent(String email);

  /// No description provided for @resendVerification.
  ///
  /// In en, this message translates to:
  /// **'Resend verification email'**
  String get resendVerification;

  /// No description provided for @verificationEmailResent.
  ///
  /// In en, this message translates to:
  /// **'Verification email resent'**
  String get verificationEmailResent;

  /// No description provided for @guestIdDisplay.
  ///
  /// In en, this message translates to:
  /// **'Guest ID: {id}'**
  String guestIdDisplay(String id);

  /// No description provided for @userIdDisplay.
  ///
  /// In en, this message translates to:
  /// **'User ID: {id}'**
  String userIdDisplay(String id);

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @enterNameOrSurname.
  ///
  /// In en, this message translates to:
  /// **'Enter first or last name'**
  String get enterNameOrSurname;

  /// No description provided for @youCanSearchByName.
  ///
  /// In en, this message translates to:
  /// **'You can search users by first/last name.'**
  String get youCanSearchByName;

  /// No description provided for @startGame.
  ///
  /// In en, this message translates to:
  /// **'Start game'**
  String get startGame;

  /// No description provided for @subjects.
  ///
  /// In en, this message translates to:
  /// **'Subjects'**
  String get subjects;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// No description provided for @vibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibration;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @chooseSubject.
  ///
  /// In en, this message translates to:
  /// **'Choose a subject'**
  String get chooseSubject;

  /// No description provided for @toggleTheme.
  ///
  /// In en, this message translates to:
  /// **'Toggle theme'**
  String get toggleTheme;

  /// No description provided for @geography.
  ///
  /// In en, this message translates to:
  /// **'Geography'**
  String get geography;

  /// No description provided for @physicalGeography.
  ///
  /// In en, this message translates to:
  /// **'Physical geography'**
  String get physicalGeography;

  /// No description provided for @economicGeography.
  ///
  /// In en, this message translates to:
  /// **'Economic geography'**
  String get economicGeography;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon: {title}'**
  String comingSoon(String title);

  /// No description provided for @mountains.
  ///
  /// In en, this message translates to:
  /// **'Mountains'**
  String get mountains;

  /// No description provided for @lakes.
  ///
  /// In en, this message translates to:
  /// **'Lakes'**
  String get lakes;

  /// No description provided for @deserts.
  ///
  /// In en, this message translates to:
  /// **'Regions ph'**
  String get deserts;

  /// No description provided for @rivers.
  ///
  /// In en, this message translates to:
  /// **'Rivers'**
  String get rivers;

  /// No description provided for @reserves.
  ///
  /// In en, this message translates to:
  /// **'Reserves'**
  String get reserves;

  /// No description provided for @testLabel.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get testLabel;

  /// No description provided for @regions.
  ///
  /// In en, this message translates to:
  /// **'Regions'**
  String get regions;

  /// No description provided for @cities.
  ///
  /// In en, this message translates to:
  /// **'Cities'**
  String get cities;

  /// No description provided for @symbols.
  ///
  /// In en, this message translates to:
  /// **'Symbols'**
  String get symbols;

  /// No description provided for @factories.
  ///
  /// In en, this message translates to:
  /// **'Factories'**
  String get factories;

  /// No description provided for @symbolsTest.
  ///
  /// In en, this message translates to:
  /// **'Symbols test'**
  String get symbolsTest;

  /// No description provided for @joinByCode.
  ///
  /// In en, this message translates to:
  /// **'Join by code'**
  String get joinByCode;

  /// No description provided for @enterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter code'**
  String get enterCode;

  /// No description provided for @enterCodeHint.
  ///
  /// In en, this message translates to:
  /// **'ABC123'**
  String get enterCodeHint;

  /// No description provided for @btnJoin.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get btnJoin;

  /// No description provided for @btnCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get btnCancel;

  /// No description provided for @howToPlayTitle.
  ///
  /// In en, this message translates to:
  /// **'How to play?'**
  String get howToPlayTitle;

  /// No description provided for @howToPlayBody.
  ///
  /// In en, this message translates to:
  /// **'Solo — go straight to the subject.\nGroup — a room will be created and you’ll start together.'**
  String get howToPlayBody;

  /// No description provided for @modeSolo.
  ///
  /// In en, this message translates to:
  /// **'Solo'**
  String get modeSolo;

  /// No description provided for @modeGroup.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get modeGroup;

  /// No description provided for @chooseParticipantsTitle.
  ///
  /// In en, this message translates to:
  /// **'How many participants?'**
  String get chooseParticipantsTitle;

  /// No description provided for @btnOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get btnOk;

  /// No description provided for @waitingRoomTitle.
  ///
  /// In en, this message translates to:
  /// **'Waiting room'**
  String get waitingRoomTitle;

  /// No description provided for @roomDeleted.
  ///
  /// In en, this message translates to:
  /// **'Room deleted'**
  String get roomDeleted;

  /// No description provided for @codeCopied.
  ///
  /// In en, this message translates to:
  /// **'Code copied'**
  String get codeCopied;

  /// No description provided for @roomOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get roomOpen;

  /// No description provided for @roomClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get roomClosed;

  /// No description provided for @membersCount.
  ///
  /// In en, this message translates to:
  /// **'Members: {count} / {max}'**
  String membersCount(int count, int max);

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @statusWaiting.
  ///
  /// In en, this message translates to:
  /// **'waiting'**
  String get statusWaiting;

  /// No description provided for @statusPlaying.
  ///
  /// In en, this message translates to:
  /// **'playing'**
  String get statusPlaying;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @chooseGame.
  ///
  /// In en, this message translates to:
  /// **'Choose game'**
  String get chooseGame;

  /// No description provided for @createRoomFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create room'**
  String get createRoomFailed;

  /// No description provided for @startGameFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t start the game'**
  String get startGameFailed;

  /// No description provided for @roomNotFound.
  ///
  /// In en, this message translates to:
  /// **'Room not found'**
  String get roomNotFound;

  /// No description provided for @roomAlreadyStarted.
  ///
  /// In en, this message translates to:
  /// **'The game has already started'**
  String get roomAlreadyStarted;

  /// No description provided for @roomIsClosed.
  ///
  /// In en, this message translates to:
  /// **'Room is closed'**
  String get roomIsClosed;

  /// No description provided for @roomIsFull.
  ///
  /// In en, this message translates to:
  /// **'No seats left'**
  String get roomIsFull;

  /// No description provided for @codeLabel.
  ///
  /// In en, this message translates to:
  /// **'Code: {code}'**
  String codeLabel(String code);

  /// No description provided for @createRoomTitle.
  ///
  /// In en, this message translates to:
  /// **'Create room'**
  String get createRoomTitle;

  /// No description provided for @participantsLimit.
  ///
  /// In en, this message translates to:
  /// **'Participants limit'**
  String get participantsLimit;

  /// No description provided for @btnCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get btnCreate;

  /// No description provided for @shareCodeHint.
  ///
  /// In en, this message translates to:
  /// **'After creating, share the room code from the lobby.'**
  String get shareCodeHint;

  /// No description provided for @owner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get owner;

  /// No description provided for @member.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get member;

  /// No description provided for @noMembersYet.
  ///
  /// In en, this message translates to:
  /// **'No one yet'**
  String get noMembersYet;

  /// No description provided for @joinFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t join'**
  String get joinFailed;

  /// No description provided for @codeGenerationFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t generate a code'**
  String get codeGenerationFailed;

  /// No description provided for @gameTitle.
  ///
  /// In en, this message translates to:
  /// **'Game: {id}'**
  String gameTitle(String id);

  /// No description provided for @gameLaunched.
  ///
  /// In en, this message translates to:
  /// **'Started game \"{gameId}\" for subject \"{subject}\"'**
  String gameLaunched(String gameId, String subject);

  /// No description provided for @markets.
  ///
  /// In en, this message translates to:
  /// **'Markets'**
  String get markets;

  /// No description provided for @gdpQuiz.
  ///
  /// In en, this message translates to:
  /// **'GDP quiz'**
  String get gdpQuiz;

  /// No description provided for @tradeRoutes.
  ///
  /// In en, this message translates to:
  /// **'Trade routes'**
  String get tradeRoutes;

  /// No description provided for @industry.
  ///
  /// In en, this message translates to:
  /// **'Industry'**
  String get industry;

  /// No description provided for @resources.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get resources;

  /// No description provided for @population.
  ///
  /// In en, this message translates to:
  /// **'Population'**
  String get population;

  /// No description provided for @capitals.
  ///
  /// In en, this message translates to:
  /// **'Capitals'**
  String get capitals;

  /// No description provided for @flags.
  ///
  /// In en, this message translates to:
  /// **'Flags'**
  String get flags;

  /// No description provided for @climate.
  ///
  /// In en, this message translates to:
  /// **'Climate'**
  String get climate;

  /// No description provided for @citiesEgTitle.
  ///
  /// In en, this message translates to:
  /// **'Economic geography: Cities'**
  String get citiesEgTitle;

  /// No description provided for @rules.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get rules;

  /// No description provided for @findCityPrompt.
  ///
  /// In en, this message translates to:
  /// **'Find the city:'**
  String get findCityPrompt;

  /// No description provided for @scoreDisplay.
  ///
  /// In en, this message translates to:
  /// **'Score: {score}'**
  String scoreDisplay(int score);

  /// No description provided for @citiesEgFinishTitle.
  ///
  /// In en, this message translates to:
  /// **'Done!'**
  String get citiesEgFinishTitle;

  /// No description provided for @resultDisplay.
  ///
  /// In en, this message translates to:
  /// **'Your result: {score} / {total}'**
  String resultDisplay(int score, int total);

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play again'**
  String get playAgain;

  /// No description provided for @citiesEgRulesText.
  ///
  /// In en, this message translates to:
  /// **'The screen shows a city name.\nTap the corresponding square on the map.\n\n+1 point for a correct answer.\nWrong taps highlight in red.\nGo through all cities and try again.'**
  String get citiesEgRulesText;

  /// No description provided for @cityAstana.
  ///
  /// In en, this message translates to:
  /// **'Astana'**
  String get cityAstana;

  /// No description provided for @cityAlmaty.
  ///
  /// In en, this message translates to:
  /// **'Almaty'**
  String get cityAlmaty;

  /// No description provided for @cityShymkent.
  ///
  /// In en, this message translates to:
  /// **'Shymkent'**
  String get cityShymkent;

  /// No description provided for @cityKaraganda.
  ///
  /// In en, this message translates to:
  /// **'Karaganda'**
  String get cityKaraganda;

  /// No description provided for @cityAktobe.
  ///
  /// In en, this message translates to:
  /// **'Aktobe'**
  String get cityAktobe;

  /// No description provided for @cityTaraz.
  ///
  /// In en, this message translates to:
  /// **'Taraz'**
  String get cityTaraz;

  /// No description provided for @cityPavlodar.
  ///
  /// In en, this message translates to:
  /// **'Pavlodar'**
  String get cityPavlodar;

  /// No description provided for @cityOskemen.
  ///
  /// In en, this message translates to:
  /// **'Oskemen'**
  String get cityOskemen;

  /// No description provided for @citySemey.
  ///
  /// In en, this message translates to:
  /// **'Semey'**
  String get citySemey;

  /// No description provided for @cityKostanay.
  ///
  /// In en, this message translates to:
  /// **'Kostanay'**
  String get cityKostanay;

  /// No description provided for @cityAtyrau.
  ///
  /// In en, this message translates to:
  /// **'Atyrau'**
  String get cityAtyrau;

  /// No description provided for @cityKyzylorda.
  ///
  /// In en, this message translates to:
  /// **'Kyzylorda'**
  String get cityKyzylorda;

  /// No description provided for @cityOral.
  ///
  /// In en, this message translates to:
  /// **'Oral'**
  String get cityOral;

  /// No description provided for @cityPetropavl.
  ///
  /// In en, this message translates to:
  /// **'Petropavl'**
  String get cityPetropavl;

  /// No description provided for @cityEkibastuz.
  ///
  /// In en, this message translates to:
  /// **'Ekibastuz'**
  String get cityEkibastuz;

  /// No description provided for @cityZhezkazgan.
  ///
  /// In en, this message translates to:
  /// **'Zhezkazgan'**
  String get cityZhezkazgan;

  /// No description provided for @cityTemirtau.
  ///
  /// In en, this message translates to:
  /// **'Temirtau'**
  String get cityTemirtau;

  /// No description provided for @cityKokshetau.
  ///
  /// In en, this message translates to:
  /// **'Kokshetau'**
  String get cityKokshetau;

  /// No description provided for @cityTurkistan.
  ///
  /// In en, this message translates to:
  /// **'Turkistan'**
  String get cityTurkistan;

  /// No description provided for @cityTaldykorgan.
  ///
  /// In en, this message translates to:
  /// **'Taldykorgan'**
  String get cityTaldykorgan;

  /// No description provided for @factoriesTestTitle.
  ///
  /// In en, this message translates to:
  /// **'Test: Metallurgy'**
  String get factoriesTestTitle;

  /// No description provided for @factoriesQ1.
  ///
  /// In en, this message translates to:
  /// **'Where is the Titanium–Magnesium Plant located?'**
  String get factoriesQ1;

  /// No description provided for @factoriesQ1A1.
  ///
  /// In en, this message translates to:
  /// **'Pavlodar'**
  String get factoriesQ1A1;

  /// No description provided for @factoriesQ1A2.
  ///
  /// In en, this message translates to:
  /// **'Oskemen'**
  String get factoriesQ1A2;

  /// No description provided for @factoriesQ1A3.
  ///
  /// In en, this message translates to:
  /// **'Ridder'**
  String get factoriesQ1A3;

  /// No description provided for @factoriesQ1A4.
  ///
  /// In en, this message translates to:
  /// **'Zhezkazgan'**
  String get factoriesQ1A4;

  /// No description provided for @factoriesQ2.
  ///
  /// In en, this message translates to:
  /// **'Which plant is located in Pavlodar?'**
  String get factoriesQ2;

  /// No description provided for @factoriesQ2A1.
  ///
  /// In en, this message translates to:
  /// **'Electrolysis plant'**
  String get factoriesQ2A1;

  /// No description provided for @factoriesQ2A2.
  ///
  /// In en, this message translates to:
  /// **'Polymetal plant'**
  String get factoriesQ2A2;

  /// No description provided for @factoriesQ2A3.
  ///
  /// In en, this message translates to:
  /// **'Copper smelter'**
  String get factoriesQ2A3;

  /// No description provided for @factoriesQ2A4.
  ///
  /// In en, this message translates to:
  /// **'Lead–zinc plant'**
  String get factoriesQ2A4;

  /// No description provided for @factoriesQ3.
  ///
  /// In en, this message translates to:
  /// **'Metallurgical giant in Temirtau?'**
  String get factoriesQ3;

  /// No description provided for @factoriesQ3A1.
  ///
  /// In en, this message translates to:
  /// **'Balkhash copper plant'**
  String get factoriesQ3A1;

  /// No description provided for @factoriesQ3A2.
  ///
  /// In en, this message translates to:
  /// **'Ispat-Karmet (ArcelorMittal)'**
  String get factoriesQ3A2;

  /// No description provided for @factoriesQ3A3.
  ///
  /// In en, this message translates to:
  /// **'Alumina plant'**
  String get factoriesQ3A3;

  /// No description provided for @factoriesQ3A4.
  ///
  /// In en, this message translates to:
  /// **'Aktobe ferroalloy plant'**
  String get factoriesQ3A4;

  /// No description provided for @questionOfTotal.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String questionOfTotal(String current, String total);

  /// No description provided for @factoriesQ4.
  ///
  /// In en, this message translates to:
  /// **'Which city does NOT have a ferroalloy plant?'**
  String get factoriesQ4;

  /// No description provided for @factoriesQ4A1.
  ///
  /// In en, this message translates to:
  /// **'Aktobe'**
  String get factoriesQ4A1;

  /// No description provided for @factoriesQ4A2.
  ///
  /// In en, this message translates to:
  /// **'Aksu (Pavlodar)'**
  String get factoriesQ4A2;

  /// No description provided for @factoriesQ4A3.
  ///
  /// In en, this message translates to:
  /// **'Taraz'**
  String get factoriesQ4A3;

  /// No description provided for @factoriesQ4A4.
  ///
  /// In en, this message translates to:
  /// **'Zhezkazgan'**
  String get factoriesQ4A4;

  /// No description provided for @factoriesQ5.
  ///
  /// In en, this message translates to:
  /// **'Where is a copper smelter located?'**
  String get factoriesQ5;

  /// No description provided for @factoriesQ5A1.
  ///
  /// In en, this message translates to:
  /// **'Balkhash'**
  String get factoriesQ5A1;

  /// No description provided for @factoriesQ5A2.
  ///
  /// In en, this message translates to:
  /// **'Aktobe'**
  String get factoriesQ5A2;

  /// No description provided for @factoriesQ5A3.
  ///
  /// In en, this message translates to:
  /// **'Ridder'**
  String get factoriesQ5A3;

  /// No description provided for @factoriesQ5A4.
  ///
  /// In en, this message translates to:
  /// **'Atyrau'**
  String get factoriesQ5A4;

  /// No description provided for @factoriesQ6.
  ///
  /// In en, this message translates to:
  /// **'Lead–zinc combine is in which city?'**
  String get factoriesQ6;

  /// No description provided for @factoriesQ6A1.
  ///
  /// In en, this message translates to:
  /// **'Oskemen'**
  String get factoriesQ6A1;

  /// No description provided for @factoriesQ6A2.
  ///
  /// In en, this message translates to:
  /// **'Atyrau'**
  String get factoriesQ6A2;

  /// No description provided for @factoriesQ6A3.
  ///
  /// In en, this message translates to:
  /// **'Taraz'**
  String get factoriesQ6A3;

  /// No description provided for @factoriesQ6A4.
  ///
  /// In en, this message translates to:
  /// **'Almaty'**
  String get factoriesQ6A4;

  /// No description provided for @factoriesQ7.
  ///
  /// In en, this message translates to:
  /// **'Polymetal plant is located in:'**
  String get factoriesQ7;

  /// No description provided for @factoriesQ7A1.
  ///
  /// In en, this message translates to:
  /// **'Oskemen'**
  String get factoriesQ7A1;

  /// No description provided for @factoriesQ7A2.
  ///
  /// In en, this message translates to:
  /// **'Pavlodar'**
  String get factoriesQ7A2;

  /// No description provided for @factoriesQ7A3.
  ///
  /// In en, this message translates to:
  /// **'Ridder'**
  String get factoriesQ7A3;

  /// No description provided for @factoriesQ7A4.
  ///
  /// In en, this message translates to:
  /// **'Aktobe'**
  String get factoriesQ7A4;

  /// No description provided for @resultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get resultsTitle;

  /// No description provided for @room.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get room;

  /// No description provided for @finished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get finished;

  /// No description provided for @scoreShort.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get scoreShort;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @toMenu.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get toMenu;

  /// No description provided for @testFinished.
  ///
  /// In en, this message translates to:
  /// **'Test finished'**
  String get testFinished;

  /// No description provided for @result.
  ///
  /// In en, this message translates to:
  /// **'Result: {score} / {total}'**
  String result(Object score, Object total);

  /// No description provided for @nextGame.
  ///
  /// In en, this message translates to:
  /// **'Next game'**
  String get nextGame;

  /// No description provided for @symbolsQuizTitle.
  ///
  /// In en, this message translates to:
  /// **'Symbols quiz'**
  String get symbolsQuizTitle;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score: {value}'**
  String score(Object value);

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @showResult.
  ///
  /// In en, this message translates to:
  /// **'Show result'**
  String get showResult;

  /// No description provided for @symbolsResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get symbolsResultTitle;

  /// No description provided for @correctAnswers.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get correctAnswers;

  /// No description provided for @pgRegionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Physical-geographic regions'**
  String get pgRegionsTitle;

  /// No description provided for @pgFindPrefix.
  ///
  /// In en, this message translates to:
  /// **'Find:'**
  String get pgFindPrefix;

  /// No description provided for @pgRestart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get pgRestart;

  /// No description provided for @pgScore.
  ///
  /// In en, this message translates to:
  /// **'Score: {value}'**
  String pgScore(int value);

  /// No description provided for @pgMapNotFound.
  ///
  /// In en, this message translates to:
  /// **'Map not found'**
  String get pgMapNotFound;

  /// No description provided for @pgCalibrateOn.
  ///
  /// In en, this message translates to:
  /// **'Calibration: ON'**
  String get pgCalibrateOn;

  /// No description provided for @pgCalibrateOff.
  ///
  /// In en, this message translates to:
  /// **'Calibration: off'**
  String get pgCalibrateOff;

  /// No description provided for @pgNudgeSaved.
  ///
  /// In en, this message translates to:
  /// **'Adjustment for {name}: {delta}'**
  String pgNudgeSaved(Object name, Object delta);

  /// No description provided for @regEastEuropePlain.
  ///
  /// In en, this message translates to:
  /// **'East European Plain'**
  String get regEastEuropePlain;

  /// No description provided for @regNorthKazakhPlain.
  ///
  /// In en, this message translates to:
  /// **'North Kazakh Plain'**
  String get regNorthKazakhPlain;

  /// No description provided for @regTuranLowland.
  ///
  /// In en, this message translates to:
  /// **'Turan Lowland'**
  String get regTuranLowland;

  /// No description provided for @regUralMugalzhar.
  ///
  /// In en, this message translates to:
  /// **'Ural (Mugalzhar)'**
  String get regUralMugalzhar;

  /// No description provided for @regSaryarka.
  ///
  /// In en, this message translates to:
  /// **'Saryarka'**
  String get regSaryarka;

  /// No description provided for @regAltai.
  ///
  /// In en, this message translates to:
  /// **'Altai'**
  String get regAltai;

  /// No description provided for @regSaurTarbagatai.
  ///
  /// In en, this message translates to:
  /// **'Saur–Tarbagatai'**
  String get regSaurTarbagatai;

  /// No description provided for @regZhetysuAlatau.
  ///
  /// In en, this message translates to:
  /// **'Zhetysu Alatau'**
  String get regZhetysuAlatau;

  /// No description provided for @regTienShan.
  ///
  /// In en, this message translates to:
  /// **'Tian Shan'**
  String get regTienShan;

  /// No description provided for @mountainsTitle.
  ///
  /// In en, this message translates to:
  /// **'Mountains of Kazakhstan'**
  String get mountainsTitle;

  /// No description provided for @findRange.
  ///
  /// In en, this message translates to:
  /// **'Find the range:'**
  String get findRange;

  /// No description provided for @gameFinished.
  ///
  /// In en, this message translates to:
  /// **'Game finished'**
  String get gameFinished;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @mapNotFound.
  ///
  /// In en, this message translates to:
  /// **'Map not found'**
  String get mapNotFound;

  /// No description provided for @mountainIleAlatau.
  ///
  /// In en, this message translates to:
  /// **'Ile Alatau (Trans-Ili Alatau)'**
  String get mountainIleAlatau;

  /// No description provided for @mountainTienShan.
  ///
  /// In en, this message translates to:
  /// **'Tian Shan'**
  String get mountainTienShan;

  /// No description provided for @mountainZhetysuAlatau.
  ///
  /// In en, this message translates to:
  /// **'Zhetysu (Dzungarian) Alatau'**
  String get mountainZhetysuAlatau;

  /// No description provided for @mountainAltai.
  ///
  /// In en, this message translates to:
  /// **'Altai'**
  String get mountainAltai;

  /// No description provided for @mountainSauyrTarbagatai.
  ///
  /// In en, this message translates to:
  /// **'Sauyr–Tarbagatai'**
  String get mountainSauyrTarbagatai;

  /// No description provided for @mountainBayanaul.
  ///
  /// In en, this message translates to:
  /// **'Bayanaul'**
  String get mountainBayanaul;

  /// No description provided for @mountainKarkaraly.
  ///
  /// In en, this message translates to:
  /// **'Karkaraly'**
  String get mountainKarkaraly;

  /// No description provided for @mountainUlytau.
  ///
  /// In en, this message translates to:
  /// **'Ulytau'**
  String get mountainUlytau;

  /// No description provided for @mountainKokshetau.
  ///
  /// In en, this message translates to:
  /// **'Kokshetau Hills'**
  String get mountainKokshetau;

  /// No description provided for @mountainKaratau.
  ///
  /// In en, this message translates to:
  /// **'Karatau Range'**
  String get mountainKaratau;

  /// No description provided for @mountainMugodzhary.
  ///
  /// In en, this message translates to:
  /// **'Mugodzhary'**
  String get mountainMugodzhary;

  /// No description provided for @mountainMangystau.
  ///
  /// In en, this message translates to:
  /// **'Mangystau Mountains'**
  String get mountainMangystau;

  /// No description provided for @mountainKalba.
  ///
  /// In en, this message translates to:
  /// **'Kalba Range'**
  String get mountainKalba;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'kk', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'kk':
      return AppLocalizationsKk();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
