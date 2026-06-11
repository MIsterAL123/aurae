import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';

abstract final class FirebaseBootstrap {
  static bool initialized = false;
  static Object? initializationError;

  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      initialized = true;
    } catch (error) {
      initializationError = error;
      debugPrint('Firebase initialization failed: $error');
    }
  }
}
