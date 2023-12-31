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
    apiKey: 'AIzaSyBZ-YXuoY2eL-RZ4Crklrpfkx6RzboInuo',
    appId: '1:737050282418:web:2617ccaf7c4f9c056dbcab',
    messagingSenderId: '737050282418',
    projectId: 'earthgo-3aa75',
    authDomain: 'earthgo-3aa75.firebaseapp.com',
    databaseURL: 'https://earthgo-3aa75-default-rtdb.firebaseio.com',
    storageBucket: 'earthgo-3aa75.appspot.com',
    measurementId: 'G-HHE4TL9GTD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCO7weU3yWhq7nwAQ5-yGRY3r2JhEe02pc',
    appId: '1:737050282418:android:a8a9dd08f07db1226dbcab',
    messagingSenderId: '737050282418',
    projectId: 'earthgo-3aa75',
    databaseURL: 'https://earthgo-3aa75-default-rtdb.firebaseio.com',
    storageBucket: 'earthgo-3aa75.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBrt85Wfp-7wtiEzwuxTSKNxjCGY3tTLGs',
    appId: '1:737050282418:ios:a1e8c3b75ffecb2f6dbcab',
    messagingSenderId: '737050282418',
    projectId: 'earthgo-3aa75',
    databaseURL: 'https://earthgo-3aa75-default-rtdb.firebaseio.com',
    storageBucket: 'earthgo-3aa75.appspot.com',
    iosClientId: '737050282418-7poujcqusn6pklla0ig3d7mhjki977dh.apps.googleusercontent.com',
    iosBundleId: 'com.example.goe',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBrt85Wfp-7wtiEzwuxTSKNxjCGY3tTLGs',
    appId: '1:737050282418:ios:ff77f71cff0409076dbcab',
    messagingSenderId: '737050282418',
    projectId: 'earthgo-3aa75',
    databaseURL: 'https://earthgo-3aa75-default-rtdb.firebaseio.com',
    storageBucket: 'earthgo-3aa75.appspot.com',
    iosClientId: '737050282418-9elcq4736l69v6afphvgf39vdb0f8n1k.apps.googleusercontent.com',
    iosBundleId: 'com.example.goe.RunnerTests',
  );
}
