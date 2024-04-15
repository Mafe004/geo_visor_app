
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyDN28eEyViA2s9EGEoFCXgCqgktpYuNbj4',
    appId: '1:190836327076:web:28a2f09b7a08a0244c5c31',
    messagingSenderId: '190836327076',
    projectId: 'geovisor-88d44',
    authDomain: 'geovisor-88d44.firebaseapp.com',
    databaseURL: 'https://geovisor-88d44-default-rtdb.firebaseio.com',
    storageBucket: 'geovisor-88d44.appspot.com',
    measurementId: 'G-C4C0RKCRV1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAl1hp1AdOzZzI5HSigrJ3wceoe87_cAcw',
    appId: '1:190836327076:android:f1aa199ccd1e8e774c5c31',
    messagingSenderId: '190836327076',
    projectId: 'geovisor-88d44',
    databaseURL: 'https://geovisor-88d44-default-rtdb.firebaseio.com',
    storageBucket: 'geovisor-88d44.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDN28eEyViA2s9EGEoFCXgCqgktpYuNbj4',
    appId: '1:190836327076:web:3909b79ae29644ef4c5c31',
    messagingSenderId: '190836327076',
    projectId: 'geovisor-88d44',
    authDomain: 'geovisor-88d44.firebaseapp.com',
    databaseURL: 'https://geovisor-88d44-default-rtdb.firebaseio.com',
    storageBucket: 'geovisor-88d44.appspot.com',
    measurementId: 'G-59E814VVM9',
  );
}
