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
  String get brand => 'GEO 2026 · BILIM\"D\"LER';

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
  String get invalidEmail => 'Invalid email address';

  @override
  String get userNotFound => 'No user found with this email';

  @override
  String get wrongPassword => 'Wrong password';

  @override
  String get tooManyRequests => 'Too many attempts, try again later';

  @override
  String get unknownError => 'An unknown error occurred';

  @override
  String get enterEmailPassword => 'Enter email and password';

  @override
  String get passwordsNotMatch => 'Passwords do not match';

  @override
  String get verifyYourEmail => 'Please verify your email before logging in';

  @override
  String verificationEmailSent(Object email) {
    return 'Verification email sent to $email';
  }
}
