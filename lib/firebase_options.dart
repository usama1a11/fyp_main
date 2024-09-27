// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyDpRXi1SeoN83DmcJ_nzjzcpu2SCB7LWas',
    appId: '1:367508075162:web:0709757897b8a919132523',
    messagingSenderId: '367508075162',
    projectId: 'fwag-b0538',
    authDomain: 'fwag-b0538.firebaseapp.com',
    storageBucket: 'fwag-b0538.appspot.com',
    measurementId: 'G-JFPTBWHR27',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC470MO_AiHqJATidQgnDgEVdrSjEBlopk',
    appId: '1:367508075162:android:76bebc0c7698c116132523',
    messagingSenderId: '367508075162',
    projectId: 'fwag-b0538',
    storageBucket: 'fwag-b0538.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBcG-qzFvi869DC9vmPkQeZC6gjxSFl1EM',
    appId: '1:367508075162:ios:649d23ecb313ab26132523',
    messagingSenderId: '367508075162',
    projectId: 'fwag-b0538',
    storageBucket: 'fwag-b0538.appspot.com',
    iosBundleId: 'com.example.furnitureworldapplication',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBcG-qzFvi869DC9vmPkQeZC6gjxSFl1EM',
    appId: '1:367508075162:ios:649d23ecb313ab26132523',
    messagingSenderId: '367508075162',
    projectId: 'fwag-b0538',
    storageBucket: 'fwag-b0538.appspot.com',
    iosBundleId: 'com.example.furnitureworldapplication',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDpRXi1SeoN83DmcJ_nzjzcpu2SCB7LWas',
    appId: '1:367508075162:web:019c8458a467621c132523',
    messagingSenderId: '367508075162',
    projectId: 'fwag-b0538',
    authDomain: 'fwag-b0538.firebaseapp.com',
    storageBucket: 'fwag-b0538.appspot.com',
    measurementId: 'G-DR7T7BFK1J',
  );

}