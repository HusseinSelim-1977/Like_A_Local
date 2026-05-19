import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android: return android;
      case TargetPlatform.iOS: return ios;
      default: throw UnsupportedError('Platform not supported');
    }
  }

  // ⚠️ Dummy config for compilation - replace later with real values from Firebase Console
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDummyKeyForCompilationOnly',
    appId: '1:000000000000:web:0000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'like-a-local-2',
    authDomain: 'like-a-local-2.firebaseapp.com',
    storageBucket: 'like-a-local-2.appspot.com',
  );
  static const FirebaseOptions android = web;
  static const FirebaseOptions ios = web;
}