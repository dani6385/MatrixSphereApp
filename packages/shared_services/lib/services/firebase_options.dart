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
          'DefaultFirebaseOptions have not been configured for windows - ',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - ',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCLNXG3wN-TBja2yldvwE_HKMVf-IC5i0I',
    appId: '1:113584843327:web:2a68364f1662c7dacfe68a',
    messagingSenderId: '113584843327',
    projectId: 'matrixsphere-project',
    authDomain: 'matrixsphere-project.firebaseapp.com',
    databaseURL: 'https://matrixsphere-project-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'matrixsphere-project.firebasestorage.app',
    measurementId: 'G-TTN6MCMND8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBOYpg1A3sIMXIWefYVQl18zswoA2ovTGc',
    appId: '1:113584843327:android:b70e92182020762fcfe68a',
    messagingSenderId: '113584843327',
    projectId: 'matrixsphere-project',
    databaseURL: 'https://matrixsphere-project-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'matrixsphere-project.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    databaseURL: 'YOUR_DATABASE_URL',
    storageBucket: 'YOUR_STORAGE_BUCKET',
    iosClientId: 'YOUR_IOS_CLIENT_ID',
    iosBundleId: 'YOUR_IOS_BUNDLE_ID',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    databaseURL: 'YOUR_DATABASE_URL',
    storageBucket: 'YOUR_STORAGE_BUCKET',
    iosClientId: 'YOUR_IOS_CLIENT_ID',
    iosBundleId: 'YOUR_IOS_BUNDLE_ID',
  );
}