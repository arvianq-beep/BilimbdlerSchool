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
  String get mountains => 'Mountains';

  @override
  String get lakes => 'Lakes';

  @override
  String get deserts => 'Deserts';

  @override
  String get rivers => 'Rivers';

  @override
  String get reserves => 'Nature reserves';

  @override
  String get testLabel => 'Test';

  @override
  String get regions => 'Regions';

  @override
  String get cities => 'Cities';

  @override
  String get factories => 'Factories';

  @override
  String get legend => 'Map legend';

  @override
  String comingSoon(String title) {
    return 'Coming soon: $title';
  }
}
