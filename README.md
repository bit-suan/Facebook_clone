# Facebook Clone

A Flutter application integrated with Firebase, featuring real-time interactions and a modular architecture.

## Features

### Authentication
- Email/Password and Google Sign-In support.
- Password visibility toggle on authentication forms.
- Automated Firestore profile initialization and recovery.

### Content & Feed
- Branded startup splash screen with animated transition.
- Real-time feed supporting image and video content.
- 24-hour status stories for user highlights.
- Interaction system for likes and comments.

### Networking & Navigation
- Real-time messaging service.
- Profile management with dynamic data fetching.
- Centralized navigation menu with application shortcuts and account management.

### Technical Architecture
- Modular feature-based directory structure for scalability.
- State management via Riverpod.
- Optimized performance using direct Firestore document snapshots.

## Setup

1. **Dependencies**: Run `flutter pub get`.
2. **Firebase**: Include `google-services.json` in `android/app/` and initialize via FlutterFire CLI.
3. **Run**: Use `flutter run`.

---
*Technical implementation focused on performance and modular design.*
