
// File generated manually for 복실이
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCb3h4GQnFely1mtvYs4-ey7Ypz3cRLyx8',
    authDomain: 'capstone-e91f5.firebaseapp.com',
    projectId: 'capstone-e91f5',
    storageBucket: 'capstone-e91f5.appspot.com',
    messagingSenderId: '1026309981901',
    appId: '1:1026309981901:web:exampleappid1234', // 예시 값 (appId 콘솔에서 꼭 확인)
  );
}
