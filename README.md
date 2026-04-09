# Bilimdler School

Bilimdler School is a Flutter educational app with quiz-based geography games, Firebase authentication, multiplayer rooms, and localization support.

The project currently focuses on geography content and includes both solo and group play flows.

## Features

- Email registration and login with email verification
- Guest login with automatic guest profile creation
- User profiles stored in Firebase Firestore
- Solo and multiplayer game modes
- Room creation and join-by-code flow
- Real-time room lobby and results screens
- Localization for Kazakh, Russian, and English
- Light and dark themes
- Geography game screens for:
  - physical geography
  - economic geography
  - cities
  - regions
  - symbols
  - factories
  - tests and result flow

## Tech Stack

- Flutter
- Dart
- Firebase Auth
- Cloud Firestore
- Firebase Storage
- Provider
- Flutter localization (`intl`, `flutter_localizations`)

## Project Structure

Main code lives in `lib/`:

```text
lib/
  auth/        authentication and profile logic
  components/  shared UI widgets
  images/      local assets
  l10n/        localization files
  pages/       screens and navigation entry pages
  rooms/       room-related UI helpers
  services/    app services
  subject/     subject/game implementations
  themes/      light/dark themes
```

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/arvianq-beep/BilimbdlerSchool.git
cd BilimbdlerSchool
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Firebase setup

This project uses Firebase on multiple platforms.

Make sure the following are configured correctly for your own Firebase project:

- `lib/firebase_options.dart`
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

If you use a different Firebase project, regenerate the FlutterFire config and replace the platform files.

### 4. Run the project

```bash
flutter run
```

## iOS Notes

If you run the app on iOS for the first time, install CocoaPods dependencies:

```bash
cd ios
pod install
cd ..
```

If Xcode cache causes plugin build issues, run:

```bash
flutter clean
flutter pub get
cd ios
pod install
cd ..
flutter run
```

## Current Status

- Geography is the most developed subject area
- Multiplayer room flow is already connected to Firestore
- Some lint warnings still remain and can be cleaned up later
- Parts of the app still need refactoring and polish

## Useful Commands

```bash
flutter pub get
flutter analyze
flutter run
```

## Branch

Work in progress is currently being updated in the `workapp12.2` branch.

## License

No license has been added yet. If you plan to publish or share the project publicly, add a license file first.
