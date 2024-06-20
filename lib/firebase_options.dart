// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAaVZwSR8y1BPGPGUhLmBUwJb7V31ZhkjA',
    appId: '1:383398987488:web:7d5809a5cc66fd5d1af285',
    messagingSenderId: '383398987488',
    projectId: 'projeto-agendeja',
    authDomain: 'projeto-agendeja.firebaseapp.com',
    storageBucket: 'projeto-agendeja.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAS1ecxU9H-BX928jly_iWyOPchc_W7wYI',
    appId: '1:383398987488:android:cad5183a959de90b1af285',
    messagingSenderId: '383398987488',
    projectId: 'projeto-agendeja',
    storageBucket: 'projeto-agendeja.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBJg60HgHynbAiVFWjPJlewysTkDLfxn1M',
    appId: '1:383398987488:ios:b9800fd9e772c6631af285',
    messagingSenderId: '383398987488',
    projectId: 'projeto-agendeja',
    storageBucket: 'projeto-agendeja.appspot.com',
    iosBundleId: 'com.example.agendeja',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBJg60HgHynbAiVFWjPJlewysTkDLfxn1M',
    appId: '1:383398987488:ios:a213e7aeef566ab41af285',
    messagingSenderId: '383398987488',
    projectId: 'projeto-agendeja',
    storageBucket: 'projeto-agendeja.appspot.com',
    iosBundleId: 'com.example.agendeja.RunnerTests',
  );
}